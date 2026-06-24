const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow } = require("./workflowEngine");

const documentStore = [];

const DOCUMENT_STATES = {
  UPLOADED: "UPLOADED",
  CLASSIFIED: "CLASSIFIED",
  ASSIGNED_TO_MATTER: "ASSIGNED_TO_MATTER",
  REVIEW: "REVIEW",
  APPROVED: "APPROVED",
  FILED: "FILED",
  ARCHIVED: "ARCHIVED",
  SUPERSEDED: "SUPERSEDED",
  REJECTED: "REJECTED"
};

const VALID_TRANSITIONS = {
  [DOCUMENT_STATES.UPLOADED]: [DOCUMENT_STATES.CLASSIFIED, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.CLASSIFIED]: [DOCUMENT_STATES.ASSIGNED_TO_MATTER, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.ASSIGNED_TO_MATTER]: [DOCUMENT_STATES.REVIEW, DOCUMENT_STATES.ARCHIVED],
  [DOCUMENT_STATES.REVIEW]: [DOCUMENT_STATES.APPROVED, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.APPROVED]: [DOCUMENT_STATES.FILED, DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.SUPERSEDED],
  [DOCUMENT_STATES.FILED]: [DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.SUPERSEDED],
  [DOCUMENT_STATES.ARCHIVED]: [],
  [DOCUMENT_STATES.SUPERSEDED]: [],
  [DOCUMENT_STATES.REJECTED]: [DOCUMENT_STATES.ARCHIVED]
};

const documentMetrics = {
  created: 0,
  uploaded: 0,
  classified: 0,
  assigned: 0,
  review: 0,
  approved: 0,
  filed: 0,
  archived: 0,
  superseded: 0,
  rejected: 0,
  invalidTransitions: 0,
  orphaned: 0
};

function createDocumentRecord({
  fileName,
  documentType = "UNKNOWN",
  matterId = null,
  uploadedBy = null,
  storagePath = null,
  payload = {}
} = {}) {
  if (!fileName) {
    throw new Error("fileName is required");
  }

  const document = {
    id: `DOC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    fileName,
    documentType,
    matterId,
    uploadedBy,
    storagePath,
    state: DOCUMENT_STATES.UPLOADED,
    payload,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    history: [
      {
        action: "CREATED",
        state: DOCUMENT_STATES.UPLOADED,
        timestamp: new Date().toISOString(),
        note: "Document record created"
      }
    ],
    reviewWorkflowId: null,
    error: null
  };

  documentStore.push(document);
  documentMetrics.created += 1;
  documentMetrics.uploaded += 1;

  emitEvent("DOCUMENT_UPLOADED", {
    documentId: document.id,
    fileName: document.fileName,
    documentType: document.documentType,
    matterId: document.matterId
  }, {
    module: "DocumentLifecycleEngine"
  });

  createNotification({
    title: `Document Uploaded: ${document.fileName}`,
    message: `Document ${document.fileName} entered lifecycle state UPLOADED.`,
    level: matterId ? "INFO" : "WARNING",
    source: "DOCUMENT_LIFECYCLE",
    eventType: "DOCUMENT_UPLOADED",
    matterId,
    payload: {
      documentId: document.id,
      state: document.state
    }
  });

  return document;
}

function transitionDocument(documentId, nextState, note = "State transition", actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (!DOCUMENT_STATES[nextState] && !Object.values(DOCUMENT_STATES).includes(nextState)) {
    return {
      ok: false,
      error: `Invalid document state: ${nextState}`
    };
  }

  const allowed = VALID_TRANSITIONS[document.state] || [];

  if (!allowed.includes(nextState)) {
    documentMetrics.invalidTransitions += 1;
    const error = `Invalid transition from ${document.state} to ${nextState}`;
    document.error = error;

    document.history.push({
      action: "INVALID_TRANSITION",
      from: document.state,
      to: nextState,
      actor,
      timestamp: new Date().toISOString(),
      error
    });

    createNotification({
      title: "Invalid Document Transition",
      message: error,
      level: "CRITICAL",
      source: "DOCUMENT_LIFECYCLE",
      eventType: "DOCUMENT_TRANSITION_INVALID",
      matterId: document.matterId,
      payload: {
        documentId: document.id,
        from: document.state,
        to: nextState
      }
    });

    return {
      ok: false,
      error,
      document
    };
  }

  const previousState = document.state;
  document.state = nextState;
  document.updatedAt = new Date().toISOString();
  document.error = null;

  document.history.push({
    action: "STATE_CHANGED",
    from: previousState,
    to: nextState,
    actor,
    timestamp: new Date().toISOString(),
    note
  });

  incrementStateMetric(nextState);

  emitEvent("DOCUMENT_UPLOADED", {
    documentId: document.id,
    fileName: document.fileName,
    from: previousState,
    to: nextState,
    matterId: document.matterId
  }, {
    module: "DocumentLifecycleEngine",
    action: "DOCUMENT_STATE_CHANGED"
  });

  createNotification({
    title: `Document State Updated: ${document.fileName}`,
    message: `Document moved from ${previousState} to ${nextState}.`,
    level: nextState === DOCUMENT_STATES.REJECTED ? "WARNING" : "INFO",
    source: "DOCUMENT_LIFECYCLE",
    eventType: "DOCUMENT_STATE_CHANGED",
    matterId: document.matterId,
    payload: {
      documentId: document.id,
      from: previousState,
      to: nextState
    }
  });

  return {
    ok: true,
    document
  };
}

async function startDocumentReview(documentId, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (document.state !== DOCUMENT_STATES.ASSIGNED_TO_MATTER) {
    return {
      ok: false,
      error: `Document must be ASSIGNED_TO_MATTER before review. Current state: ${document.state}`
    };
  }

  const transition = transitionDocument(documentId, DOCUMENT_STATES.REVIEW, "Document review started", actor);

  if (!transition.ok) {
    return transition;
  }

  const workflow = createWorkflow({
    workflowType: "DOCUMENT_REVIEW",
    title: `Document Review: ${document.fileName}`,
    payload: {
      documentId: document.id,
      fileName: document.fileName,
      matterId: document.matterId
    },
    context: {
      source: "DOCUMENT_LIFECYCLE",
      actor
    }
  });

  document.reviewWorkflowId = workflow.id;
  await startWorkflow(workflow.id);

  document.history.push({
    action: "REVIEW_WORKFLOW_STARTED",
    workflowId: workflow.id,
    actor,
    timestamp: new Date().toISOString()
  });

  return {
    ok: true,
    document,
    workflow
  };
}

function assignDocumentToMatter(documentId, matterId, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (!matterId) {
    return {
      ok: false,
      error: "matterId is required"
    };
  }

  document.matterId = matterId;
  document.history.push({
    action: "MATTER_LINKED",
    matterId,
    actor,
    timestamp: new Date().toISOString()
  });

  return transitionDocument(documentId, DOCUMENT_STATES.ASSIGNED_TO_MATTER, `Linked to matter ${matterId}`, actor);
}

function classifyDocument(documentId, documentType, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  document.documentType = documentType || document.documentType;
  document.history.push({
    action: "CLASSIFIED",
    documentType: document.documentType,
    actor,
    timestamp: new Date().toISOString()
  });

  return transitionDocument(documentId, DOCUMENT_STATES.CLASSIFIED, `Classified as ${document.documentType}`, actor);
}

function getDocumentById(documentId) {
  return documentStore.find(d => d.id === documentId) || null;
}

function getDocuments({ limit = 25, state = null, matterId = null, orphanedOnly = false } = {}) {
  let items = [...documentStore];

  if (state) {
    items = items.filter(d => d.state === state);
  }

  if (matterId) {
    items = items.filter(d => d.matterId === matterId);
  }

  if (orphanedOnly) {
    items = items.filter(d => !d.matterId);
  }

  return items.slice(-limit).reverse();
}

function getOrphanedDocuments() {
  return documentStore.filter(d => !d.matterId && ![DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.REJECTED].includes(d.state));
}

function getDocumentLifecycleMetrics() {
  const orphaned = getOrphanedDocuments().length;
  documentMetrics.orphaned = orphaned;

  return {
    ...documentMetrics,
    storedDocuments: documentStore.length,
    status: orphaned > 0 || documentMetrics.invalidTransitions > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getDocumentLifecycleHealth() {
  const metrics = getDocumentLifecycleMetrics();

  return {
    module: "Document Lifecycle Engine",
    status: metrics.status,
    created: metrics.created,
    uploaded: metrics.uploaded,
    classified: metrics.classified,
    assigned: metrics.assigned,
    review: metrics.review,
    approved: metrics.approved,
    filed: metrics.filed,
    archived: metrics.archived,
    superseded: metrics.superseded,
    rejected: metrics.rejected,
    orphaned: metrics.orphaned,
    invalidTransitions: metrics.invalidTransitions,
    storedDocuments: metrics.storedDocuments,
    timestamp: metrics.timestamp
  };
}

function incrementStateMetric(state) {
  if (state === DOCUMENT_STATES.CLASSIFIED) documentMetrics.classified += 1;
  if (state === DOCUMENT_STATES.ASSIGNED_TO_MATTER) documentMetrics.assigned += 1;
  if (state === DOCUMENT_STATES.REVIEW) documentMetrics.review += 1;
  if (state === DOCUMENT_STATES.APPROVED) documentMetrics.approved += 1;
  if (state === DOCUMENT_STATES.FILED) documentMetrics.filed += 1;
  if (state === DOCUMENT_STATES.ARCHIVED) documentMetrics.archived += 1;
  if (state === DOCUMENT_STATES.SUPERSEDED) documentMetrics.superseded += 1;
  if (state === DOCUMENT_STATES.REJECTED) documentMetrics.rejected += 1;
}

function resetDocumentLifecycleForTestOnly() {
  documentStore.length = 0;
  documentMetrics.created = 0;
  documentMetrics.uploaded = 0;
  documentMetrics.classified = 0;
  documentMetrics.assigned = 0;
  documentMetrics.review = 0;
  documentMetrics.approved = 0;
  documentMetrics.filed = 0;
  documentMetrics.archived = 0;
  documentMetrics.superseded = 0;
  documentMetrics.rejected = 0;
  documentMetrics.invalidTransitions = 0;
  documentMetrics.orphaned = 0;
}

module.exports = {
  DOCUMENT_STATES,
  createDocumentRecord,
  classifyDocument,
  assignDocumentToMatter,
  transitionDocument,
  startDocumentReview,
  getDocumentById,
  getDocuments,
  getOrphanedDocuments,
  getDocumentLifecycleMetrics,
  getDocumentLifecycleHealth,
  resetDocumentLifecycleForTestOnly
};

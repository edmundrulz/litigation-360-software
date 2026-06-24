const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");

const workflowStore = [];

const workflowMetrics = {
  created: 0,
  started: 0,
  completed: 0,
  failed: 0,
  active: 0
};

const WORKFLOW_TEMPLATES = {
  NEW_CLIENT_INTAKE: {
    name: "New Client Intake",
    steps: [
      "Capture client identity",
      "Run conflict check",
      "Open client profile",
      "Create initial matter",
      "Assign responsible user",
      "Create intake notification"
    ]
  },
  MATTER_OPENING: {
    name: "Matter Opening",
    steps: [
      "Create matter record",
      "Assign matter owner",
      "Create document folder",
      "Create opening task",
      "Notify responsible team"
    ]
  },
  COURT_DATE_PREPARATION: {
    name: "Court Date Preparation",
    steps: [
      "Record court date",
      "Calculate internal reminders",
      "Create court preparation task",
      "Notify assigned user",
      "Mark preparation workflow active"
    ]
  },
  DOCUMENT_REVIEW: {
    name: "Document Review",
    steps: [
      "Receive document",
      "Assign reviewer",
      "Review document",
      "Approve or reject document",
      "Archive review trail"
    ]
  }
};

function createWorkflow({ workflowType, title, payload = {}, context = {} } = {}) {
  const template = WORKFLOW_TEMPLATES[workflowType];

  if (!template) {
    throw new Error(`Unknown workflow type: ${workflowType}`);
  }

  const workflow = {
    id: `WF-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    workflowType,
    title: title || template.name,
    status: "CREATED",
    currentStepIndex: 0,
    steps: template.steps.map((step, index) => ({
      index,
      name: step,
      status: "PENDING",
      startedAt: null,
      completedAt: null,
      error: null
    })),
    payload,
    context,
    history: [
      {
        action: "CREATED",
        timestamp: new Date().toISOString(),
        note: "Workflow created"
      }
    ],
    createdAt: new Date().toISOString(),
    startedAt: null,
    completedAt: null,
    error: null
  };

  workflowStore.push(workflow);
  workflowMetrics.created += 1;

  return workflow;
}

async function startWorkflow(workflowId) {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  if (workflow.status !== "CREATED") {
    return { ok: false, error: `Workflow cannot be started from status ${workflow.status}` };
  }

  workflow.status = "ACTIVE";
  workflow.startedAt = new Date().toISOString();
  workflowMetrics.started += 1;
  workflowMetrics.active += 1;

  workflow.history.push({
    action: "STARTED",
    timestamp: new Date().toISOString(),
    note: "Workflow started"
  });

  if (workflow.steps[0]) {
    workflow.steps[0].status = "ACTIVE";
    workflow.steps[0].startedAt = new Date().toISOString();
  }

  await emitEvent("TASK_COMPLETED", {
    source: "workflowEngine",
    workflowId: workflow.id,
    workflowType: workflow.workflowType,
    action: "WORKFLOW_STARTED"
  }, {
    module: "WorkflowEngine"
  });

  createNotification({
    title: `Workflow Started: ${workflow.title}`,
    message: `${workflow.workflowType} workflow is now active.`,
    level: "INFO",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_STARTED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType
    }
  });

  return { ok: true, workflow };
}

async function completeCurrentStep(workflowId, note = "Step completed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  if (workflow.status !== "ACTIVE") {
    return { ok: false, error: `Workflow is not active. Current status: ${workflow.status}` };
  }

  const step = workflow.steps[workflow.currentStepIndex];

  if (!step) {
    return completeWorkflow(workflowId, "No remaining steps");
  }

  step.status = "COMPLETED";
  step.completedAt = new Date().toISOString();

  workflow.history.push({
    action: "STEP_COMPLETED",
    timestamp: new Date().toISOString(),
    stepIndex: step.index,
    stepName: step.name,
    note
  });

  workflow.currentStepIndex += 1;

  const nextStep = workflow.steps[workflow.currentStepIndex];

  if (nextStep) {
    nextStep.status = "ACTIVE";
    nextStep.startedAt = new Date().toISOString();

    workflow.history.push({
      action: "STEP_STARTED",
      timestamp: new Date().toISOString(),
      stepIndex: nextStep.index,
      stepName: nextStep.name
    });

    return { ok: true, status: "STEP_COMPLETED", workflow };
  }

  return completeWorkflow(workflowId, "All workflow steps completed");
}

function failWorkflow(workflowId, error = "Workflow failed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  workflow.status = "FAILED";
  workflow.error = error;
  workflow.completedAt = new Date().toISOString();

  workflowMetrics.failed += 1;
  workflowMetrics.active = Math.max(0, workflowMetrics.active - 1);

  workflow.history.push({
    action: "FAILED",
    timestamp: new Date().toISOString(),
    error
  });

  createNotification({
    title: `Workflow Failed: ${workflow.title}`,
    message: error,
    level: "CRITICAL",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_FAILED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType,
      error
    }
  });

  return { ok: true, workflow };
}

function completeWorkflow(workflowId, note = "Workflow completed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  workflow.status = "COMPLETED";
  workflow.completedAt = new Date().toISOString();

  workflowMetrics.completed += 1;
  workflowMetrics.active = Math.max(0, workflowMetrics.active - 1);

  workflow.history.push({
    action: "COMPLETED",
    timestamp: new Date().toISOString(),
    note
  });

  createNotification({
    title: `Workflow Completed: ${workflow.title}`,
    message: `${workflow.workflowType} workflow completed successfully.`,
    level: "INFO",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_COMPLETED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType
    }
  });

  return { ok: true, status: "COMPLETED", workflow };
}

function getWorkflowById(workflowId) {
  return workflowStore.find(w => w.id === workflowId) || null;
}

function getWorkflows({ limit = 25, status = null, workflowType = null } = {}) {
  let items = [...workflowStore];

  if (status) {
    items = items.filter(w => w.status === status);
  }

  if (workflowType) {
    items = items.filter(w => w.workflowType === workflowType);
  }

  return items.slice(-limit).reverse();
}

function getWorkflowMetrics() {
  return {
    ...workflowMetrics,
    storedWorkflows: workflowStore.length,
    status: workflowMetrics.failed > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getWorkflowHealth() {
  const metrics = getWorkflowMetrics();

  return {
    module: "Workflow Automation Engine",
    status: metrics.status,
    created: metrics.created,
    started: metrics.started,
    active: metrics.active,
    completed: metrics.completed,
    failed: metrics.failed,
    storedWorkflows: metrics.storedWorkflows,
    timestamp: metrics.timestamp
  };
}

function getWorkflowTemplates() {
  return WORKFLOW_TEMPLATES;
}

function resetWorkflowsForTestOnly() {
  workflowStore.length = 0;
  workflowMetrics.created = 0;
  workflowMetrics.started = 0;
  workflowMetrics.completed = 0;
  workflowMetrics.failed = 0;
  workflowMetrics.active = 0;
}

module.exports = {
  createWorkflow,
  startWorkflow,
  completeCurrentStep,
  completeWorkflow,
  failWorkflow,
  getWorkflowById,
  getWorkflows,
  getWorkflowMetrics,
  getWorkflowHealth,
  getWorkflowTemplates,
  resetWorkflowsForTestOnly
};

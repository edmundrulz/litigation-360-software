const { createNotification } = require("./notificationService");
const { getDocuments } = require("./documentLifecycleEngine");
const {
  getCourtEvents,
  getCourtTasks,
  getOverdueCourtDeadlines,
  getUpcomingCourtEvents
} = require("./courtOperationsEngine");
const { getWorkflows } = require("./workflowEngine");

const matterProfiles = new Map();

const matterIntelligenceMetrics = {
  profilesCreated: 0,
  profilesUpdated: 0,
  assessmentsGenerated: 0,
  highRiskMatters: 0,
  mediumRiskMatters: 0,
  healthyMatters: 0
};

function createOrUpdateMatterProfile({
  matterId,
  matterTitle = null,
  matterType = "GENERAL_LITIGATION",
  status = "ACTIVE",
  assignedLawyer = null,
  clientName = null,
  courtName = null,
  payload = {}
} = {}) {
  if (!matterId) {
    throw new Error("matterId is required");
  }

  const existing = matterProfiles.get(matterId);

  const profile = {
    matterId,
    matterTitle: matterTitle || existing?.matterTitle || matterId,
    matterType: matterType || existing?.matterType || "GENERAL_LITIGATION",
    status: status || existing?.status || "ACTIVE",
    assignedLawyer: assignedLawyer || existing?.assignedLawyer || null,
    clientName: clientName || existing?.clientName || null,
    courtName: courtName || existing?.courtName || null,
    payload: {
      ...(existing?.payload || {}),
      ...payload
    },
    createdAt: existing?.createdAt || new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    history: [
      ...(existing?.history || []),
      {
        action: existing ? "UPDATED" : "CREATED",
        timestamp: new Date().toISOString(),
        note: existing ? "Matter profile updated" : "Matter profile created"
      }
    ]
  };

  matterProfiles.set(matterId, profile);

  if (existing) {
    matterIntelligenceMetrics.profilesUpdated += 1;
  } else {
    matterIntelligenceMetrics.profilesCreated += 1;
  }

  return profile;
}

function getMatterProfile(matterId) {
  return matterProfiles.get(matterId) || createOrUpdateMatterProfile({ matterId });
}

function buildMatterTimeline(matterId) {
  const profile = getMatterProfile(matterId);
  const documents = getDocuments({ limit: 100, matterId });
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const workflows = getWorkflows({ limit: 100 });
  const courtTasks = getCourtTasks({ limit: 100, matterId });

  const timeline = [];

  timeline.push({
    type: "MATTER_PROFILE",
    title: "Matter profile available",
    timestamp: profile.createdAt,
    source: "MATTER_INTELLIGENCE"
  });

  for (const doc of documents) {
    timeline.push({
      type: "DOCUMENT",
      title: `Document ${doc.fileName} is ${doc.state}`,
      timestamp: doc.updatedAt || doc.createdAt,
      source: "DOCUMENT_LIFECYCLE",
      refId: doc.id
    });
  }

  for (const courtEvent of courtEvents) {
    timeline.push({
      type: "COURT_EVENT",
      title: `${courtEvent.eventType} at ${courtEvent.courtName}`,
      timestamp: courtEvent.eventDate,
      source: "COURT_OPERATIONS",
      refId: courtEvent.id
    });
  }

  for (const workflow of workflows) {
    if (workflow.payload?.matterId === matterId || workflow.context?.matterId === matterId) {
      timeline.push({
        type: "WORKFLOW",
        title: `${workflow.workflowType} workflow ${workflow.status}`,
        timestamp: workflow.updatedAt || workflow.createdAt,
        source: "WORKFLOW_ENGINE",
        refId: workflow.id
      });
    }
  }

  for (const task of courtTasks) {
    timeline.push({
      type: "COURT_TASK",
      title: `${task.name} - ${task.status}`,
      timestamp: task.createdAt,
      source: "COURT_OPERATIONS",
      refId: task.id
    });
  }

  return timeline
    .filter(item => item.timestamp)
    .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
}

function calculateMatterRiskFlags(matterId) {
  const documents = getDocuments({ limit: 100, matterId });
  const orphanedDocuments = getDocuments({ limit: 100, orphanedOnly: true }).filter(d => d.matterId === matterId);
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const courtTasks = getCourtTasks({ limit: 100, matterId });
  const overdueDeadlines = getOverdueCourtDeadlines().filter(d => d.matterId === matterId);
  const upcomingCourtEvents = getUpcomingCourtEvents(14).filter(c => c.matterId === matterId);

  const flags = [];

  if (documents.length === 0) {
    flags.push({
      code: "NO_DOCUMENTS",
      severity: "MEDIUM",
      message: "Matter has no linked documents."
    });
  }

  if (orphanedDocuments.length > 0) {
    flags.push({
      code: "ORPHANED_DOCUMENTS",
      severity: "HIGH",
      message: "Matter has orphaned documents requiring linkage or archive."
    });
  }

  if (courtEvents.length === 0) {
    flags.push({
      code: "NO_COURT_EVENTS",
      severity: "LOW",
      message: "Matter has no court events recorded."
    });
  }

  if (upcomingCourtEvents.length > 0) {
    flags.push({
      code: "UPCOMING_COURT_EVENT",
      severity: "MEDIUM",
      message: "Matter has a court event within 14 days."
    });
  }

  if (overdueDeadlines.length > 0) {
    flags.push({
      code: "OVERDUE_COURT_DEADLINES",
      severity: "HIGH",
      message: "Matter has overdue court deadlines."
    });
  }

  const openTasks = courtTasks.filter(t => t.status === "OPEN");
  if (openTasks.length > 0) {
    flags.push({
      code: "OPEN_COURT_TASKS",
      severity: "MEDIUM",
      message: `Matter has ${openTasks.length} open court tasks.`
    });
  }

  const reviewDocs = documents.filter(d => d.state === "REVIEW");
  if (reviewDocs.length > 0) {
    flags.push({
      code: "DOCUMENTS_UNDER_REVIEW",
      severity: "LOW",
      message: `Matter has ${reviewDocs.length} documents under review.`
    });
  }

  return flags;
}

function calculateMatterHealthScore(matterId) {
  const flags = calculateMatterRiskFlags(matterId);

  let score = 100;

  for (const flag of flags) {
    if (flag.severity === "HIGH") score -= 30;
    if (flag.severity === "MEDIUM") score -= 15;
    if (flag.severity === "LOW") score -= 5;
  }

  score = Math.max(0, score);

  let status = "HEALTHY";
  if (score < 80) status = "ATTENTION";
  if (score < 50) status = "HIGH_RISK";

  return {
    score,
    status,
    flagsCount: flags.length,
    highRiskFlags: flags.filter(f => f.severity === "HIGH").length,
    mediumRiskFlags: flags.filter(f => f.severity === "MEDIUM").length,
    lowRiskFlags: flags.filter(f => f.severity === "LOW").length
  };
}

function getMatterIntelligence(matterId) {
  const profile = getMatterProfile(matterId);
  const documents = getDocuments({ limit: 100, matterId });
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const courtTasks = getCourtTasks({ limit: 100, matterId });
  const workflows = getWorkflows({ limit: 100 }).filter(w => w.payload?.matterId === matterId || w.context?.matterId === matterId);
  const riskFlags = calculateMatterRiskFlags(matterId);
  const health = calculateMatterHealthScore(matterId);
  const timeline = buildMatterTimeline(matterId);

  matterIntelligenceMetrics.assessmentsGenerated += 1;

  if (health.status === "HIGH_RISK") {
    matterIntelligenceMetrics.highRiskMatters += 1;
    createNotification({
      title: `High Risk Matter: ${matterId}`,
      message: `Matter health score is ${health.score}. Immediate review recommended.`,
      level: "CRITICAL",
      source: "MATTER_INTELLIGENCE",
      eventType: "MATTER_HIGH_RISK",
      matterId,
      payload: {
        health,
        riskFlags
      }
    });
  } else if (health.status === "ATTENTION") {
    matterIntelligenceMetrics.mediumRiskMatters += 1;
  } else {
    matterIntelligenceMetrics.healthyMatters += 1;
  }

  return {
    matterProfile: profile,
    health,
    riskFlags,
    documents,
    courtEvents,
    courtTasks,
    workflows,
    timeline,
    generatedAt: new Date().toISOString()
  };
}

function getMatterIntelligenceSummary() {
  const profiles = Array.from(matterProfiles.values());

  return {
    totalProfiles: profiles.length,
    profiles,
    metrics: getMatterIntelligenceMetrics(),
    timestamp: new Date().toISOString()
  };
}

function getMatterIntelligenceMetrics() {
  return {
    ...matterIntelligenceMetrics,
    storedProfiles: matterProfiles.size,
    status: matterIntelligenceMetrics.highRiskMatters > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getMatterIntelligenceHealth() {
  const metrics = getMatterIntelligenceMetrics();

  return {
    module: "Matter Intelligence Engine",
    status: metrics.status,
    profilesCreated: metrics.profilesCreated,
    profilesUpdated: metrics.profilesUpdated,
    assessmentsGenerated: metrics.assessmentsGenerated,
    highRiskMatters: metrics.highRiskMatters,
    mediumRiskMatters: metrics.mediumRiskMatters,
    healthyMatters: metrics.healthyMatters,
    storedProfiles: metrics.storedProfiles,
    timestamp: metrics.timestamp
  };
}

function resetMatterIntelligenceForTestOnly() {
  matterProfiles.clear();
  matterIntelligenceMetrics.profilesCreated = 0;
  matterIntelligenceMetrics.profilesUpdated = 0;
  matterIntelligenceMetrics.assessmentsGenerated = 0;
  matterIntelligenceMetrics.highRiskMatters = 0;
  matterIntelligenceMetrics.mediumRiskMatters = 0;
  matterIntelligenceMetrics.healthyMatters = 0;
}

module.exports = {
  createOrUpdateMatterProfile,
  getMatterProfile,
  getMatterIntelligence,
  getMatterIntelligenceSummary,
  calculateMatterRiskFlags,
  calculateMatterHealthScore,
  buildMatterTimeline,
  getMatterIntelligenceMetrics,
  getMatterIntelligenceHealth,
  resetMatterIntelligenceForTestOnly
};

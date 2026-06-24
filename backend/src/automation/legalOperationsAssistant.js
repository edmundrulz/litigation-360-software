const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { getMatterIntelligence } = require("./matterIntelligenceEngine");
const { createNotification } = require("./notificationService");

const assistantMetrics = {
  briefingsGenerated: 0,
  matterBriefingsGenerated: 0,
  actionPlansGenerated: 0,
  lastGeneratedAt: null
};

function priorityFromSeverity(severity) {
  const s = String(severity || "").toUpperCase();
  if (s === "HIGH" || s === "CRITICAL") return 1;
  if (s === "MEDIUM") return 2;
  return 3;
}

function buildRecommendedActionsFromDashboard(dashboard) {
  const actions = [];

  for (const item of dashboard.riskItems || []) {
    if (item.code === "OVERDUE_COURT_DEADLINES") {
      actions.push({
        priority: "HIGH",
        action: "Review overdue court deadlines immediately.",
        reason: item.message,
        source: "COURT_OPERATIONS"
      });
    }

    if (item.code === "ORPHANED_DOCUMENTS") {
      actions.push({
        priority: "HIGH",
        action: "Review orphaned documents and link them to the correct matter or archive them.",
        reason: item.message,
        source: "DOCUMENT_LIFECYCLE"
      });
    }

    if (item.code === "FAILED_WORKFLOWS") {
      actions.push({
        priority: "HIGH",
        action: "Open failed workflows and decide whether to retry, repair, or close them.",
        reason: item.message,
        source: "WORKFLOW_ENGINE"
      });
    }

    if (item.code === "CRITICAL_NOTIFICATIONS") {
      actions.push({
        priority: "HIGH",
        action: "Clear critical notifications from the notification centre.",
        reason: item.message,
        source: "NOTIFICATION_FRAMEWORK"
      });
    }

    if (item.code === "UPCOMING_COURT_EVENTS") {
      actions.push({
        priority: "MEDIUM",
        action: "Review upcoming court events and confirm preparation workflows are active.",
        reason: item.message,
        source: "COURT_OPERATIONS"
      });
    }
  }

  if (actions.length === 0) {
    actions.push({
      priority: "LOW",
      action: "No urgent operational issue detected. Continue monitoring dashboard health.",
      reason: "Enterprise dashboard has no major risk item.",
      source: "EXECUTIVE_COMMAND_CENTRE"
    });
  }

  return actions.sort((a, b) => priorityFromSeverity(a.priority) - priorityFromSeverity(b.priority));
}

function generateDailyBriefing() {
  const dashboard = generateExecutiveDashboard();
  const actions = buildRecommendedActionsFromDashboard(dashboard);

  assistantMetrics.briefingsGenerated += 1;
  assistantMetrics.actionPlansGenerated += 1;
  assistantMetrics.lastGeneratedAt = new Date().toISOString();

  const briefing = {
    module: "Legal Operations Assistant",
    briefingType: "DAILY_OPERATIONS_BRIEFING",
    generatedAt: assistantMetrics.lastGeneratedAt,
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    summary: {
      courtEventsNext30Days: dashboard.executiveSummary.upcomingCourtEvents,
      overdueCourtDeadlines: dashboard.executiveSummary.overdueCourtDeadlines,
      orphanedDocuments: dashboard.executiveSummary.orphanedDocuments,
      activeWorkflows: dashboard.executiveSummary.activeWorkflows,
      failedWorkflows: dashboard.executiveSummary.failedWorkflows,
      unreadNotifications: dashboard.executiveSummary.unreadNotifications,
      criticalNotifications: dashboard.executiveSummary.criticalNotifications,
      matterProfiles: dashboard.executiveSummary.matterProfiles
    },
    riskItems: dashboard.riskItems,
    recommendedActions: actions,
    plainEnglishSummary: buildPlainEnglishSummary(dashboard, actions)
  };

  if (dashboard.enterpriseStatus === "CRITICAL") {
    createNotification({
      title: "Executive Assistant Critical Briefing",
      message: "Enterprise status is critical. Immediate leadership review recommended.",
      level: "CRITICAL",
      source: "LEGAL_OPERATIONS_ASSISTANT",
      eventType: "ASSISTANT_CRITICAL_BRIEFING",
      payload: {
        enterpriseStatus: dashboard.enterpriseStatus,
        enterpriseScore: dashboard.enterpriseScore
      }
    });
  }

  return briefing;
}

function buildPlainEnglishSummary(dashboard, actions) {
  const parts = [];
  parts.push(`Enterprise status is ${dashboard.enterpriseStatus} with score ${dashboard.enterpriseScore}.`);

  if (dashboard.riskItems.length === 0) {
    parts.push("No major risk items are currently visible.");
  } else {
    parts.push(`${dashboard.riskItems.length} risk item(s) require attention.`);
  }

  if (actions.length > 0) {
    parts.push(`Top action: ${actions[0].action}`);
  }

  return parts.join(" ");
}

function generateMatterBriefing(matterId) {
  const intelligence = getMatterIntelligence(matterId);
  const health = intelligence.health;
  const actions = [];

  for (const flag of intelligence.riskFlags || []) {
    if (flag.code === "NO_DOCUMENTS") {
      actions.push({ priority: "MEDIUM", action: "Upload or link key matter documents.", reason: flag.message });
    }
    if (flag.code === "UPCOMING_COURT_EVENT") {
      actions.push({ priority: "MEDIUM", action: "Confirm court preparation workflow, documents, and attendance.", reason: flag.message });
    }
    if (flag.code === "OVERDUE_COURT_DEADLINES") {
      actions.push({ priority: "HIGH", action: "Resolve overdue court deadlines immediately.", reason: flag.message });
    }
    if (flag.code === "OPEN_COURT_TASKS") {
      actions.push({ priority: "MEDIUM", action: "Review and close open court tasks.", reason: flag.message });
    }
  }

  if (actions.length === 0) {
    actions.push({ priority: "LOW", action: "Matter appears stable. Continue routine monitoring.", reason: "No major matter-specific risk flag." });
  }

  assistantMetrics.matterBriefingsGenerated += 1;
  assistantMetrics.actionPlansGenerated += 1;
  assistantMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Legal Operations Assistant",
    briefingType: "MATTER_BRIEFING",
    matterId,
    generatedAt: assistantMetrics.lastGeneratedAt,
    health,
    matterProfile: intelligence.matterProfile,
    riskFlags: intelligence.riskFlags,
    recommendedActions: actions.sort((a, b) => priorityFromSeverity(a.priority) - priorityFromSeverity(b.priority)),
    timelinePreview: intelligence.timeline.slice(-10),
    plainEnglishSummary: `Matter ${matterId} is ${health.status} with score ${health.score}. ${actions[0].action}`
  };
}

function answerOperationalQuestion(question = "") {
  const q = String(question || "").toLowerCase();
  const daily = generateDailyBriefing();

  if (q.includes("risk")) {
    return {
      question,
      answerType: "RISK_SUMMARY",
      answer: daily.riskItems.length
        ? "There are visible risk items requiring attention."
        : "No major risk items are currently visible.",
      riskItems: daily.riskItems,
      recommendedActions: daily.recommendedActions
    };
  }

  if (q.includes("court")) {
    return {
      question,
      answerType: "COURT_SUMMARY",
      answer: `There are ${daily.summary.courtEventsNext30Days} court event(s) in the next 30 days and ${daily.summary.overdueCourtDeadlines} overdue court deadline(s).`,
      recommendedActions: daily.recommendedActions.filter(a => a.source === "COURT_OPERATIONS")
    };
  }

  if (q.includes("document")) {
    return {
      question,
      answerType: "DOCUMENT_SUMMARY",
      answer: `There are ${daily.summary.orphanedDocuments} orphaned document(s).`,
      recommendedActions: daily.recommendedActions.filter(a => a.source === "DOCUMENT_LIFECYCLE")
    };
  }

  return {
    question,
    answerType: "GENERAL_OPERATIONS_SUMMARY",
    answer: daily.plainEnglishSummary,
    recommendedActions: daily.recommendedActions
  };
}

function getAssistantHealth() {
  return {
    module: "Legal Operations Assistant Core",
    status: "HEALTHY",
    briefingsGenerated: assistantMetrics.briefingsGenerated,
    matterBriefingsGenerated: assistantMetrics.matterBriefingsGenerated,
    actionPlansGenerated: assistantMetrics.actionPlansGenerated,
    lastGeneratedAt: assistantMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getAssistantMetrics() {
  return {
    ...assistantMetrics,
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  generateDailyBriefing,
  generateMatterBriefing,
  answerOperationalQuestion,
  getAssistantHealth,
  getAssistantMetrics
};

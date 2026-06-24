const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { generatePredictiveDashboard, forecastDeadlines, forecastWorkload, forecastCapacity, forecastMatter } = require("./predictiveAnalyticsEngine");
const { generateDailyBriefing } = require("./legalOperationsAssistant");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow, getWorkflows } = require("./workflowEngine");
const { getUpcomingCourtEvents, startCourtPreparationWorkflow } = require("./courtOperationsEngine");
const { getOrphanedDocuments } = require("./documentLifecycleEngine");
const { getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");

const autonomousActions = [];
const escalationQueue = [];
const decisionHistory = [];

const autonomousMetrics = {
  cyclesRun: 0,
  decisionsMade: 0,
  actionsCreated: 0,
  actionsExecuted: 0,
  escalationsCreated: 0,
  notificationsCreated: 0,
  workflowsTriggered: 0,
  skippedActions: 0,
  lastRunAt: null
};

const RULES = [
  {
    id: "AUTO-COURT-7D-PREP",
    name: "Court event within 7 days requires preparation",
    severity: "HIGH",
    enabled: true,
    description: "Detects upcoming court events and recommends/prepares workflow action."
  },
  {
    id: "AUTO-DEADLINE-RISK",
    name: "Deadline risk requires triage",
    severity: "HIGH",
    enabled: true,
    description: "Detects predicted deadline failure risk and creates escalation."
  },
  {
    id: "AUTO-CAPACITY-OVERLOAD",
    name: "Capacity overload requires leadership alert",
    severity: "HIGH",
    enabled: true,
    description: "Detects capacity pressure and escalates."
  },
  {
    id: "AUTO-ORPHAN-DOCUMENTS",
    name: "Orphan documents require review",
    severity: "MEDIUM",
    enabled: true,
    description: "Detects unlinked documents and creates corrective action."
  },
  {
    id: "AUTO-FAILED-WORKFLOWS",
    name: "Failed workflows require recovery review",
    severity: "HIGH",
    enabled: true,
    description: "Detects failed workflows and creates recovery escalation."
  },
  {
    id: "AUTO-MATTER-RISK",
    name: "High-risk matter requires review",
    severity: "HIGH",
    enabled: true,
    description: "Detects matter intelligence deterioration and recommends intervention."
  }
];

function now() {
  return new Date().toISOString();
}

function createDecision({ ruleId, ruleName, severity, reason, source, data = {} }) {
  const decision = {
    id: `DEC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    ruleId,
    ruleName,
    severity,
    reason,
    source,
    data,
    createdAt: now()
  };

  decisionHistory.push(decision);
  autonomousMetrics.decisionsMade += 1;
  return decision;
}

function createAutonomousAction({ decisionId, actionType, title, description, priority = "MEDIUM", source = "AUTONOMOUS_OPERATIONS", payload = {}, executable = false }) {
  const action = {
    id: `ACT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    decisionId,
    actionType,
    title,
    description,
    priority,
    source,
    payload,
    executable,
    status: "CREATED",
    createdAt: now(),
    executedAt: null,
    result: null
  };

  autonomousActions.push(action);
  autonomousMetrics.actionsCreated += 1;
  return action;
}

function createEscalation({ decisionId, title, message, severity = "HIGH", matterId = null, payload = {} }) {
  const escalation = {
    id: `ESC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    decisionId,
    title,
    message,
    severity,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  escalationQueue.push(escalation);
  autonomousMetrics.escalationsCreated += 1;

  createNotification({
    title,
    message,
    level: severity === "HIGH" ? "CRITICAL" : "WARNING",
    source: "AUTONOMOUS_OPERATIONS",
    eventType: "AUTONOMOUS_ESCALATION_CREATED",
    matterId,
    payload: escalation
  });

  autonomousMetrics.notificationsCreated += 1;
  return escalation;
}

async function runAutonomousCycle({ executeSafeActions = false } = {}) {
  const executive = generateExecutiveDashboard();
  const predictive = generatePredictiveDashboard();
  const briefing = generateDailyBriefing();

  const decisions = [];
  const actions = [];
  const escalations = [];

  autonomousMetrics.cyclesRun += 1;
  autonomousMetrics.lastRunAt = now();

  const upcoming7 = getUpcomingCourtEvents(7);

  if (upcoming7.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-COURT-7D-PREP");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${upcoming7.length} court event(s) within 7 days.`,
      source: "COURT_OPERATIONS",
      data: { count: upcoming7.length }
    });
    decisions.push(decision);

    for (const courtEvent of upcoming7.slice(0, 5)) {
      const action = createAutonomousAction({
        decisionId: decision.id,
        actionType: "COURT_PREPARATION_WORKFLOW",
        title: `Prepare for court event: ${courtEvent.courtName}`,
        description: "Start or verify court preparation workflow.",
        priority: "HIGH",
        payload: { courtEventId: courtEvent.id, matterId: courtEvent.matterId },
        executable: true
      });
      actions.push(action);

      if (executeSafeActions) {
        try {
          const result = await startCourtPreparationWorkflow(courtEvent.id, "AUTONOMOUS_OPERATIONS");
          action.status = result.ok ? "EXECUTED" : "FAILED";
          action.executedAt = now();
          action.result = result;
          if (result.ok) {
            autonomousMetrics.actionsExecuted += 1;
            autonomousMetrics.workflowsTriggered += 1;
          }
        } catch (err) {
          action.status = "FAILED";
          action.result = { error: err.message };
        }
      } else {
        autonomousMetrics.skippedActions += 1;
      }
    }
  }

  const deadlineForecast = forecastDeadlines();
  if (deadlineForecast.predictedDeadlineFailureRisk === "HIGH") {
    const rule = RULES.find(r => r.id === "AUTO-DEADLINE-RISK");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: deadlineForecast.recommendedAction,
      source: "PREDICTIVE_ANALYTICS",
      data: deadlineForecast
    });
    decisions.push(decision);

    const escalation = createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Deadline Risk",
      message: deadlineForecast.recommendedAction,
      severity: "HIGH",
      payload: deadlineForecast
    });
    escalations.push(escalation);
  }

  const capacityForecast = forecastCapacity();
  if (capacityForecast.predictedCapacityStatus === "OVERLOADED") {
    const rule = RULES.find(r => r.id === "AUTO-CAPACITY-OVERLOAD");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: capacityForecast.recommendedAction,
      source: "PREDICTIVE_ANALYTICS",
      data: capacityForecast
    });
    decisions.push(decision);

    escalations.push(createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Capacity Overload",
      message: capacityForecast.recommendedAction,
      severity: "HIGH",
      payload: capacityForecast
    }));
  }

  const orphaned = getOrphanedDocuments();
  if (orphaned.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-ORPHAN-DOCUMENTS");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${orphaned.length} orphan document(s) detected.`,
      source: "DOCUMENT_LIFECYCLE",
      data: { count: orphaned.length }
    });
    decisions.push(decision);

    actions.push(createAutonomousAction({
      decisionId: decision.id,
      actionType: "DOCUMENT_REVIEW_ACTION",
      title: "Review orphan documents",
      description: "Link orphan documents to correct matter, reject, or archive.",
      priority: "MEDIUM",
      payload: { orphanedCount: orphaned.length },
      executable: false
    }));
  }

  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  if (failedWorkflows.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-FAILED-WORKFLOWS");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${failedWorkflows.length} failed workflow(s) require recovery.`,
      source: "WORKFLOW_ENGINE",
      data: { count: failedWorkflows.length }
    });
    decisions.push(decision);

    escalations.push(createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Failed Workflows",
      message: "Failed workflows require recovery review.",
      severity: "HIGH",
      payload: { failedWorkflows: failedWorkflows.map(w => w.id) }
    }));
  }

  const matterSummary = getMatterIntelligenceSummary();
  for (const profile of (matterSummary.profiles || []).slice(0, 20)) {
    const forecast = forecastMatter(profile.matterId);
    if (forecast.predictedRisk === "HIGH" || forecast.predictedRisk === "CRITICAL") {
      const rule = RULES.find(r => r.id === "AUTO-MATTER-RISK");
      const decision = createDecision({
        ruleId: rule.id,
        ruleName: rule.name,
        severity: rule.severity,
        reason: `Matter ${profile.matterId} predicted risk is ${forecast.predictedRisk}.`,
        source: "MATTER_INTELLIGENCE",
        data: forecast
      });
      decisions.push(decision);

      escalations.push(createEscalation({
        decisionId: decision.id,
        title: `Autonomous Escalation: High Risk Matter ${profile.matterId}`,
        message: forecast.recommendedAction,
        severity: forecast.predictedRisk === "CRITICAL" ? "HIGH" : "MEDIUM",
        matterId: profile.matterId,
        payload: forecast
      }));
    }
  }

  return {
    module: "Autonomous Operations Engine",
    status: escalations.length > 0 ? "ATTENTION" : "HEALTHY",
    executeSafeActions,
    decisions,
    actions,
    escalations,
    summary: {
      decisions: decisions.length,
      actions: actions.length,
      escalations: escalations.length,
      executiveStatus: executive.enterpriseStatus,
      predictiveStatus: predictive.status,
      topAssistantAction: briefing.recommendedActions?.[0] || null
    },
    generatedAt: now()
  };
}

function getAutonomousDashboard() {
  return {
    module: "Autonomous Operations Engine",
    status: escalationQueue.filter(e => e.status === "OPEN").length > 0 ? "ATTENTION" : "HEALTHY",
    metrics: getAutonomousMetrics(),
    openEscalations: getEscalations({ status: "OPEN" }),
    recentActions: getActions({ limit: 25 }),
    recentDecisions: getDecisions({ limit: 25 }),
    rules: getRules(),
    generatedAt: now()
  };
}

function getRules() {
  return RULES;
}

function getActions({ limit = 25, status = null } = {}) {
  let items = [...autonomousActions];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getEscalations({ limit = 25, status = null } = {}) {
  let items = [...escalationQueue];
  if (status) items = items.filter(e => e.status === status);
  return items.slice(-limit).reverse();
}

function getDecisions({ limit = 25 } = {}) {
  return decisionHistory.slice(-limit).reverse();
}

function resolveEscalation(escalationId, note = "Resolved") {
  const escalation = escalationQueue.find(e => e.id === escalationId);
  if (!escalation) return { ok: false, error: "Escalation not found" };

  escalation.status = "RESOLVED";
  escalation.resolvedAt = now();
  escalation.resolutionNote = note;
  return { ok: true, escalation };
}

function getAutonomousHealth() {
  const openEscalations = escalationQueue.filter(e => e.status === "OPEN").length;

  return {
    module: "Autonomous Operations Engine",
    status: openEscalations > 0 ? "ATTENTION" : "HEALTHY",
    cyclesRun: autonomousMetrics.cyclesRun,
    decisionsMade: autonomousMetrics.decisionsMade,
    actionsCreated: autonomousMetrics.actionsCreated,
    actionsExecuted: autonomousMetrics.actionsExecuted,
    escalationsCreated: autonomousMetrics.escalationsCreated,
    openEscalations,
    workflowsTriggered: autonomousMetrics.workflowsTriggered,
    lastRunAt: autonomousMetrics.lastRunAt,
    timestamp: now()
  };
}

function getAutonomousMetrics() {
  return {
    ...autonomousMetrics,
    openEscalations: escalationQueue.filter(e => e.status === "OPEN").length,
    storedActions: autonomousActions.length,
    storedEscalations: escalationQueue.length,
    storedDecisions: decisionHistory.length,
    timestamp: now()
  };
}

function resetAutonomousForTestOnly() {
  autonomousActions.length = 0;
  escalationQueue.length = 0;
  decisionHistory.length = 0;
  autonomousMetrics.cyclesRun = 0;
  autonomousMetrics.decisionsMade = 0;
  autonomousMetrics.actionsCreated = 0;
  autonomousMetrics.actionsExecuted = 0;
  autonomousMetrics.escalationsCreated = 0;
  autonomousMetrics.notificationsCreated = 0;
  autonomousMetrics.workflowsTriggered = 0;
  autonomousMetrics.skippedActions = 0;
  autonomousMetrics.lastRunAt = null;
}

module.exports = {
  runAutonomousCycle,
  getAutonomousDashboard,
  getAutonomousHealth,
  getAutonomousMetrics,
  getRules,
  getActions,
  getEscalations,
  getDecisions,
  resolveEscalation,
  resetAutonomousForTestOnly
};

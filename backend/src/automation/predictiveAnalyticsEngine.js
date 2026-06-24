const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { getMatterIntelligence, calculateMatterHealthScore } = require("./matterIntelligenceEngine");
const { getCourtOperationsHealth, getUpcomingCourtEvents, getOverdueCourtDeadlines } = require("./courtOperationsEngine");
const { getWorkflowHealth, getWorkflows } = require("./workflowEngine");
const { getDocumentLifecycleHealth, getOrphanedDocuments } = require("./documentLifecycleEngine");
const { createNotification } = require("./notificationService");

const predictiveMetrics = {
  dashboardsGenerated: 0,
  matterForecastsGenerated: 0,
  workloadForecastsGenerated: 0,
  capacityForecastsGenerated: 0,
  deadlineForecastsGenerated: 0,
  highRiskPredictions: 0,
  lastGeneratedAt: null
};

function riskLabel(score) {
  if (score >= 85) return "LOW";
  if (score >= 65) return "MEDIUM";
  if (score >= 40) return "HIGH";
  return "CRITICAL";
}

function confidenceLabel(dataPoints) {
  if (dataPoints >= 8) return "HIGH";
  if (dataPoints >= 4) return "MEDIUM";
  return "LOW";
}

function forecastMatter(matterId) {
  const intelligence = getMatterIntelligence(matterId);
  const currentHealth = calculateMatterHealthScore(matterId);
  const riskFlags = intelligence.riskFlags || [];

  let predictedScore = currentHealth.score;
  let pressure = 0;

  for (const flag of riskFlags) {
    if (flag.severity === "HIGH") pressure += 18;
    if (flag.severity === "MEDIUM") pressure += 9;
    if (flag.severity === "LOW") pressure += 3;
  }

  const openCourtTasks = (intelligence.courtTasks || []).filter(t => t.status === "OPEN").length;
  const documentsUnderReview = (intelligence.documents || []).filter(d => d.state === "REVIEW").length;
  const upcomingCourtEvents = (intelligence.courtEvents || []).filter(c => {
    const d = new Date(c.eventDate);
    const now = new Date();
    const future = new Date();
    future.setDate(future.getDate() + 30);
    return d >= now && d <= future;
  }).length;

  pressure += openCourtTasks * 2;
  pressure += documentsUnderReview * 3;
  pressure += upcomingCourtEvents * 8;

  predictedScore = Math.max(0, predictedScore - Math.min(45, pressure));

  const trend =
    predictedScore < currentHealth.score - 15 ? "DECLINING" :
    predictedScore > currentHealth.score + 5 ? "IMPROVING" :
    "STABLE";

  const prediction = {
    matterId,
    currentScore: currentHealth.score,
    predicted30Days: predictedScore,
    currentStatus: currentHealth.status,
    predictedRisk: riskLabel(predictedScore),
    trend,
    confidence: confidenceLabel(riskFlags.length + openCourtTasks + documentsUnderReview + upcomingCourtEvents),
    drivers: {
      riskFlags: riskFlags.length,
      openCourtTasks,
      documentsUnderReview,
      upcomingCourtEvents
    },
    recommendedAction: buildMatterPredictionAction(predictedScore, trend, riskFlags),
    generatedAt: new Date().toISOString()
  };

  predictiveMetrics.matterForecastsGenerated += 1;
  if (prediction.predictedRisk === "HIGH" || prediction.predictedRisk === "CRITICAL") {
    predictiveMetrics.highRiskPredictions += 1;
    createNotification({
      title: `Predictive Risk Alert: ${matterId}`,
      message: `Matter predicted risk is ${prediction.predictedRisk} with 30-day score ${prediction.predicted30Days}.`,
      level: prediction.predictedRisk === "CRITICAL" ? "CRITICAL" : "WARNING",
      source: "PREDICTIVE_ANALYTICS",
      eventType: "MATTER_RISK_PREDICTED",
      matterId,
      payload: prediction
    });
  }

  return prediction;
}

function buildMatterPredictionAction(score, trend, flags) {
  if (score < 40) return "Immediate leadership review required. Assign owner and clear deadline/document/workflow risks.";
  if (score < 65) return "Review matter within 24 hours and reduce active risk drivers.";
  if (trend === "DECLINING") return "Monitor matter closely and complete pending preparation tasks.";
  if (flags.length > 0) return "Resolve open risk flags before next milestone.";
  return "No urgent predictive action required.";
}

function forecastDeadlines() {
  const overdue = getOverdueCourtDeadlines();
  const upcoming = getUpcomingCourtEvents(14);

  const riskScore = Math.min(100, overdue.length * 35 + upcoming.length * 8);
  const risk = riskLabel(100 - riskScore);

  predictiveMetrics.deadlineForecastsGenerated += 1;

  return {
    module: "Deadline Risk Predictor",
    overdueDeadlines: overdue.length,
    upcomingCourtEvents14Days: upcoming.length,
    predictedDeadlineFailureRisk: riskScore >= 70 ? "HIGH" : riskScore >= 35 ? "MEDIUM" : "LOW",
    scorePressure: riskScore,
    recommendedAction: riskScore >= 70
      ? "Immediate deadline triage required."
      : riskScore >= 35
        ? "Review upcoming deadlines and court events this week."
        : "Deadline risk appears controlled.",
    generatedAt: new Date().toISOString()
  };
}

function forecastWorkload() {
  const activeWorkflows = getWorkflows({ limit: 100, status: "ACTIVE" });
  const upcomingCourtEvents = getUpcomingCourtEvents(30);
  const overdue = getOverdueCourtDeadlines();
  const openPressure = activeWorkflows.length * 5 + upcomingCourtEvents.length * 8 + overdue.length * 25;

  const overloadRisk =
    openPressure >= 80 ? "HIGH" :
    openPressure >= 45 ? "MEDIUM" :
    "LOW";

  predictiveMetrics.workloadForecastsGenerated += 1;

  return {
    module: "Workload Predictor",
    activeWorkflows: activeWorkflows.length,
    upcomingCourtEvents30Days: upcomingCourtEvents.length,
    overdueCourtDeadlines: overdue.length,
    workloadPressureScore: openPressure,
    predictedOverloadRisk: overloadRisk,
    recommendedAction: overloadRisk === "HIGH"
      ? "Redistribute tasks and assign support immediately."
      : overloadRisk === "MEDIUM"
        ? "Monitor workload and prepare backup capacity."
        : "Workload appears manageable.",
    generatedAt: new Date().toISOString()
  };
}

function forecastCapacity() {
  const dashboard = generateExecutiveDashboard();
  const workload = forecastWorkload();
  const orphanedDocuments = getOrphanedDocuments();
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });

  const capacityPressure =
    (100 - dashboard.enterpriseScore) +
    workload.workloadPressureScore +
    orphanedDocuments.length * 10 +
    failedWorkflows.length * 20;

  const capacityStatus =
    capacityPressure >= 100 ? "OVERLOADED" :
    capacityPressure >= 60 ? "ATTENTION" :
    "CONTROLLED";

  predictiveMetrics.capacityForecastsGenerated += 1;

  return {
    module: "Capacity Predictor",
    enterpriseScore: dashboard.enterpriseScore,
    workloadPressureScore: workload.workloadPressureScore,
    orphanedDocuments: orphanedDocuments.length,
    failedWorkflows: failedWorkflows.length,
    capacityPressure,
    predictedCapacityStatus: capacityStatus,
    recommendedAction: capacityStatus === "OVERLOADED"
      ? "Leadership intervention required. Reduce operational backlog and reassign urgent work."
      : capacityStatus === "ATTENTION"
        ? "Capacity is tightening. Review workload distribution."
        : "Capacity appears controlled.",
    generatedAt: new Date().toISOString()
  };
}

function generatePredictiveDashboard() {
  const executive = generateExecutiveDashboard();
  const deadlineForecast = forecastDeadlines();
  const workloadForecast = forecastWorkload();
  const capacityForecast = forecastCapacity();

  const documentHealth = getDocumentLifecycleHealth();
  const courtHealth = getCourtOperationsHealth();
  const workflowHealth = getWorkflowHealth();

  const predictiveRiskItems = [];

  if (deadlineForecast.predictedDeadlineFailureRisk === "HIGH") {
    predictiveRiskItems.push({
      code: "PREDICTED_DEADLINE_FAILURE",
      severity: "HIGH",
      message: deadlineForecast.recommendedAction
    });
  }

  if (workloadForecast.predictedOverloadRisk === "HIGH") {
    predictiveRiskItems.push({
      code: "PREDICTED_WORKLOAD_OVERLOAD",
      severity: "HIGH",
      message: workloadForecast.recommendedAction
    });
  }

  if (capacityForecast.predictedCapacityStatus === "OVERLOADED") {
    predictiveRiskItems.push({
      code: "PREDICTED_CAPACITY_OVERLOAD",
      severity: "HIGH",
      message: capacityForecast.recommendedAction
    });
  }

  predictiveMetrics.dashboardsGenerated += 1;
  predictiveMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Predictive Litigation Analytics Engine",
    status: predictiveRiskItems.length > 0 ? "ATTENTION" : "HEALTHY",
    generatedAt: predictiveMetrics.lastGeneratedAt,
    enterpriseScore: executive.enterpriseScore,
    enterpriseStatus: executive.enterpriseStatus,
    forecasts: {
      deadlines: deadlineForecast,
      workload: workloadForecast,
      capacity: capacityForecast
    },
    moduleSignals: {
      documents: documentHealth,
      courtOperations: courtHealth,
      workflows: workflowHealth
    },
    predictiveRiskItems,
    recommendedExecutiveAction: predictiveRiskItems.length > 0
      ? "Review predictive risk panel and assign owners to high-risk areas."
      : "No immediate predictive escalation required."
  };
}

function getPredictiveHealth() {
  const dashboard = generatePredictiveDashboard();

  return {
    module: "Predictive Litigation Analytics Engine",
    status: dashboard.status,
    dashboardsGenerated: predictiveMetrics.dashboardsGenerated,
    matterForecastsGenerated: predictiveMetrics.matterForecastsGenerated,
    workloadForecastsGenerated: predictiveMetrics.workloadForecastsGenerated,
    capacityForecastsGenerated: predictiveMetrics.capacityForecastsGenerated,
    deadlineForecastsGenerated: predictiveMetrics.deadlineForecastsGenerated,
    highRiskPredictions: predictiveMetrics.highRiskPredictions,
    lastGeneratedAt: predictiveMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getPredictiveMetrics() {
  return { ...predictiveMetrics, timestamp: new Date().toISOString() };
}

module.exports = {
  forecastMatter,
  forecastDeadlines,
  forecastWorkload,
  forecastCapacity,
  generatePredictiveDashboard,
  getPredictiveHealth,
  getPredictiveMetrics
};

const { getRegistryHealth } = require("./handlerRegistry");
const { getEventBusHealth } = require("./eventBus");
const { getNotificationHealth, getNotifications } = require("./notificationService");
const { getWorkflowHealth, getWorkflows } = require("./workflowEngine");
const { getDocumentLifecycleHealth, getOrphanedDocuments } = require("./documentLifecycleEngine");
const { getCourtOperationsHealth, getUpcomingCourtEvents, getOverdueCourtDeadlines } = require("./courtOperationsEngine");
const { getMatterIntelligenceHealth, getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");

const metrics = { dashboardGenerated: 0, lastGeneratedAt: null };

function weight(status) {
  const s = String(status || "").toUpperCase();
  if (s === "HEALTHY" || s === "PASS") return 100;
  if (s === "WARNING" || s === "ATTENTION") return 70;
  if (s === "HIGH_RISK") return 40;
  if (s === "FAIL" || s === "ERROR" || s === "CRITICAL") return 0;
  return 60;
}

function statusFromScore(score) {
  if (score >= 90) return "HEALTHY";
  if (score >= 70) return "ATTENTION";
  if (score >= 50) return "WARNING";
  return "CRITICAL";
}

function avgScore(modules) {
  const total = modules.reduce((sum, m) => sum + weight(m.status), 0);
  return Math.round(total / Math.max(1, modules.length));
}

function generateExecutiveDashboard() {
  const handler = getRegistryHealth();
  const eventBus = getEventBusHealth();
  const notifications = getNotificationHealth();
  const workflows = getWorkflowHealth();
  const documents = getDocumentLifecycleHealth();
  const courts = getCourtOperationsHealth();
  const matters = getMatterIntelligenceHealth();

  const moduleHealth = [
    { module: "Handler Registry", status: handler.status, details: handler },
    { module: "Universal Event Bus", status: eventBus.status, details: eventBus },
    { module: "Notification Framework", status: notifications.status, details: notifications },
    { module: "Workflow Automation Engine", status: workflows.status, details: workflows },
    { module: "Document Lifecycle Engine", status: documents.status, details: documents },
    { module: "Court Operations Engine", status: courts.status, details: courts },
    { module: "Matter Intelligence Engine", status: matters.status, details: matters }
  ];

  const enterpriseScore = avgScore(moduleHealth);
  const enterpriseStatus = statusFromScore(enterpriseScore);

  const upcomingCourtEvents = getUpcomingCourtEvents(30);
  const overdueCourtDeadlines = getOverdueCourtDeadlines();
  const orphanedDocuments = getOrphanedDocuments();
  const activeWorkflows = getWorkflows({ limit: 100, status: "ACTIVE" });
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  const unreadNotifications = getNotifications({ limit: 100, unreadOnly: true });
  const criticalNotifications = getNotifications({ limit: 100, level: "CRITICAL" });
  const matterSummary = getMatterIntelligenceSummary();

  const riskItems = [];
  if (overdueCourtDeadlines.length) riskItems.push({ code: "OVERDUE_COURT_DEADLINES", severity: "HIGH", count: overdueCourtDeadlines.length, message: "Overdue court deadlines require action." });
  if (orphanedDocuments.length) riskItems.push({ code: "ORPHANED_DOCUMENTS", severity: "HIGH", count: orphanedDocuments.length, message: "Documents without matter linkage require action." });
  if (failedWorkflows.length) riskItems.push({ code: "FAILED_WORKFLOWS", severity: "HIGH", count: failedWorkflows.length, message: "Failed workflows require recovery." });
  if (criticalNotifications.length) riskItems.push({ code: "CRITICAL_NOTIFICATIONS", severity: "HIGH", count: criticalNotifications.length, message: "Critical notifications require action." });
  if (upcomingCourtEvents.length) riskItems.push({ code: "UPCOMING_COURT_EVENTS", severity: "MEDIUM", count: upcomingCourtEvents.length, message: "Court events exist within 30 days." });

  metrics.dashboardGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Executive Command Centre",
    enterpriseStatus,
    enterpriseScore,
    generatedAt: metrics.lastGeneratedAt,
    moduleHealth,
    executiveSummary: {
      upcomingCourtEvents: upcomingCourtEvents.length,
      overdueCourtDeadlines: overdueCourtDeadlines.length,
      orphanedDocuments: orphanedDocuments.length,
      activeWorkflows: activeWorkflows.length,
      failedWorkflows: failedWorkflows.length,
      unreadNotifications: unreadNotifications.length,
      criticalNotifications: criticalNotifications.length,
      matterProfiles: matterSummary.totalProfiles
    },
    riskItems,
    panels: {
      automation: { handlerRegistry: handler, eventBus },
      notifications: { health: notifications, unreadNotifications, criticalNotifications },
      workflows: { health: workflows, activeWorkflows, failedWorkflows },
      documentLifecycle: { health: documents, orphanedDocuments },
      courtOperations: { health: courts, upcomingCourtEvents, overdueCourtDeadlines },
      matters: { health: matters, summary: matterSummary }
    }
  };
}

function getExecutiveCommandHealth() {
  const dashboard = generateExecutiveDashboard();
  return {
    module: "Executive Command Centre",
    status: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    dashboardGenerated: metrics.dashboardGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    riskItems: dashboard.riskItems.length,
    timestamp: new Date().toISOString()
  };
}

function getExecutiveCommandMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = { generateExecutiveDashboard, getExecutiveCommandHealth, getExecutiveCommandMetrics };

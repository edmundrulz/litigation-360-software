const alerts = [];

const LEVELS = {
  INFO: "INFO",
  WARNING: "WARNING",
  CRITICAL: "CRITICAL",
  BLOCKER: "BLOCKER"
};

function createAlert({ level = "INFO", code, title, message, source = "MONITORING", payload = {} } = {}) {
  const alert = {
    id: `ALT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    level,
    code: code || "GENERAL_ALERT",
    title: title || "Monitoring Alert",
    message: message || "Monitoring alert generated.",
    source,
    payload,
    status: "OPEN",
    createdAt: new Date().toISOString(),
    resolvedAt: null
  };
  alerts.push(alert);
  return alert;
}

function resolveAlert(id, note = "Resolved") {
  const alert = alerts.find(a => a.id === id);
  if (!alert) return { ok: false, error: "Alert not found" };
  alert.status = "RESOLVED";
  alert.resolvedAt = new Date().toISOString();
  alert.resolutionNote = note;
  return { ok: true, alert };
}

function getAlerts({ status = null, level = null, limit = 50 } = {}) {
  let items = [...alerts];
  if (status) items = items.filter(a => a.status === status);
  if (level) items = items.filter(a => a.level === level);
  return items.slice(-limit).reverse();
}

function generateAlertsFromMetrics(metrics) {
  const generated = [];

  if (!metrics.database.exists) {
    generated.push(createAlert({
      level: LEVELS.BLOCKER,
      code: "DATABASE_MISSING",
      title: "Database Missing",
      message: "litigation360.db is missing.",
      source: "MONITORING"
    }));
  }

  if (metrics.process.memory.heapUsedMB > 512) {
    generated.push(createAlert({
      level: LEVELS.WARNING,
      code: "HIGH_MEMORY_USAGE",
      title: "High Memory Usage",
      message: `Heap used is ${metrics.process.memory.heapUsedMB} MB.`,
      source: "MONITORING",
      payload: metrics.process.memory
    }));
  }

  const moduleEntries = Object.entries(metrics.modules || {});
  for (const [name, data] of moduleEntries) {
    const status = String(data?.status || "").toUpperCase();
    if (["ERROR", "LOAD_ERROR", "BLOCKED", "FAIL", "CRITICAL"].includes(status)) {
      generated.push(createAlert({
        level: status === "BLOCKED" || status === "CRITICAL" ? LEVELS.BLOCKER : LEVELS.CRITICAL,
        code: `MODULE_${name.toUpperCase()}_${status}`,
        title: `Module ${name} status ${status}`,
        message: `Monitoring detected ${name} status: ${status}.`,
        source: "MONITORING",
        payload: data
      }));
    }
  }

  return generated;
}

function getAlertHealth() {
  const open = alerts.filter(a => a.status === "OPEN");
  const blockers = open.filter(a => a.level === "BLOCKER");
  const critical = open.filter(a => a.level === "CRITICAL");

  return {
    module: "Alert Manager",
    status: blockers.length > 0 ? "BLOCKER" : critical.length > 0 ? "CRITICAL" : "HEALTHY",
    openAlerts: open.length,
    blockerAlerts: blockers.length,
    criticalAlerts: critical.length,
    storedAlerts: alerts.length,
    timestamp: new Date().toISOString()
  };
}

function resetAlertsForTestOnly() {
  alerts.length = 0;
}

module.exports = {
  LEVELS,
  createAlert,
  resolveAlert,
  getAlerts,
  generateAlertsFromMetrics,
  getAlertHealth,
  resetAlertsForTestOnly
};

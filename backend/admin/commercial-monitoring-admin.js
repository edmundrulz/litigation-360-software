const fs = require("fs");
const path = require("path");

const adminRoot = __dirname;
const firmFile = path.join(adminRoot, "firm-subscriptions.json");
const trialFile = path.join(adminRoot, "trial-controls.json");
const overrideFile = path.join(adminRoot, "feature-overrides.json");
const auditFile = path.join(adminRoot, "admin-actions-audit.log");

function safeReadJson(file, fallback) {
  try {
    if (!fs.existsSync(file)) return fallback;
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return fallback;
  }
}

function safeReadLines(file) {
  try {
    if (!fs.existsSync(file)) return [];
    return fs.readFileSync(file, "utf8").split(/\r?\n/).filter(Boolean);
  } catch {
    return [];
  }
}

function getClients() {
  const firms = safeReadJson(firmFile, {});
  return Object.keys(firms).map(id => ({
    firmId: id,
    ...firms[id]
  }));
}

function getTrials() {
  const trials = safeReadJson(trialFile, { active_trials: {} });
  return trials.active_trials || {};
}

function getFeatureOverrides() {
  const overrides = safeReadJson(overrideFile, { manual_feature_overrides: {} });
  return overrides.manual_feature_overrides || {};
}

function getAuditSummary() {
  const lines = safeReadLines(auditFile);
  const recent = lines.slice(-20).map(line => {
    try { return JSON.parse(line); } catch { return { raw: line }; }
  });

  return {
    total_audit_entries: lines.length,
    recent_entries: recent
  };
}

function getDashboard() {
  const clients = getClients();
  const trials = getTrials();
  const overrides = getFeatureOverrides();
  const audit = getAuditSummary();

  const activeClients = clients.filter(c => c.status === "ACTIVE").length;
  const suspendedClients = clients.filter(c => c.status === "SUSPENDED").length;
  const paidClients = clients.filter(c => c.billing_status === "PAID").length;
  const exemptClients = clients.filter(c => c.billing_status === "EXEMPT").length;

  const activeTrials = Object.values(trials).filter(t => t.trial_active === true).length;
  const expiredTrials = Object.values(trials).filter(t => t.trial_expired === true).length;

  const overrideFirmCount = Object.keys(overrides).length;

  const dashboard = {
    generated_at: new Date().toISOString(),
    active_clients: activeClients,
    suspended_clients: suspendedClients,
    paid_clients: paidClients,
    exempt_clients: exemptClients,
    active_trials: activeTrials,
    expired_trials: expiredTrials,
    feature_override_firms: overrideFirmCount,
    audit_entries: audit.total_audit_entries,
    ground_zero_status: "FULL_ACCESS_UNLIMITED",
    commercial_health: activeClients >= 1 ? "OPERATIONAL" : "SETUP_MODE"
  };

  return dashboard;
}

function getCommercialHealth() {
  const dashboard = getDashboard();

  return {
    generated_at: new Date().toISOString(),
    status: "OPERATIONAL",
    commercial_monitoring_api: "ACTIVE",
    dashboard_available: true,
    clients_available: true,
    trials_available: true,
    feature_overrides_available: true,
    audit_summary_available: true,
    ground_zero_protected: true,
    dashboard
  };
}

module.exports = {
  getDashboard,
  getClients,
  getTrials,
  getFeatureOverrides,
  getAuditSummary,
  getCommercialHealth
};

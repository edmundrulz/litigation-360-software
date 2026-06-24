const fs = require("fs");
const path = require("path");

const adminPath = __dirname;
const firmFile = path.join(adminPath, "firm-subscriptions.json");
const overrideFile = path.join(adminPath, "feature-overrides.json");
const trialFile = path.join(adminPath, "trial-controls.json");
const auditFile = path.join(adminPath, "admin-actions-audit.log");

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

function audit(action, payload) {
  fs.appendFileSync(
    auditFile,
    JSON.stringify({
      timestamp: new Date().toISOString(),
      action,
      payload
    }) + "\n"
  );
}

function setFirmPlan(firmId, plan) {
  const firms = readJson(firmFile);

  if (!firms[firmId]) {
    throw new Error("Firm not found: " + firmId);
  }

  if (firms[firmId].license_type === "UNLIMITED_FOUNDING_CLIENT") {
    firms[firmId].subscription_plan = "GROUND_ZERO";
    firms[firmId].all_features_unlocked = true;
    writeJson(firmFile, firms);
    audit("GROUND_ZERO_PROTECTED_FROM_DOWNGRADE", { firmId });
    return firms[firmId];
  }

  firms[firmId].subscription_plan = plan;
  writeJson(firmFile, firms);
  audit("SET_FIRM_PLAN", { firmId, plan });

  return firms[firmId];
}

function suspendFirm(firmId) {
  const firms = readJson(firmFile);

  if (!firms[firmId]) {
    throw new Error("Firm not found: " + firmId);
  }

  if (firms[firmId].license_type === "UNLIMITED_FOUNDING_CLIENT") {
    audit("GROUND_ZERO_SUSPENSION_BLOCKED", { firmId });
    return firms[firmId];
  }

  firms[firmId].status = "SUSPENDED";
  writeJson(firmFile, firms);
  audit("SUSPEND_FIRM", { firmId });

  return firms[firmId];
}

function activateFirm(firmId) {
  const firms = readJson(firmFile);

  if (!firms[firmId]) {
    throw new Error("Firm not found: " + firmId);
  }

  firms[firmId].status = "ACTIVE";
  writeJson(firmFile, firms);
  audit("ACTIVATE_FIRM", { firmId });

  return firms[firmId];
}

function grantFeatureOverride(firmId, userId, featureKey) {
  const overrides = readJson(overrideFile);

  if (!overrides.manual_feature_overrides[firmId]) {
    overrides.manual_feature_overrides[firmId] = {};
  }

  if (!overrides.manual_feature_overrides[firmId][userId]) {
    overrides.manual_feature_overrides[firmId][userId] = [];
  }

  if (!overrides.manual_feature_overrides[firmId][userId].includes(featureKey)) {
    overrides.manual_feature_overrides[firmId][userId].push(featureKey);
  }

  writeJson(overrideFile, overrides);
  audit("GRANT_FEATURE_OVERRIDE", { firmId, userId, featureKey });

  return overrides.manual_feature_overrides[firmId][userId];
}

function startTrial(firmId, days = 30) {
  const trials = readJson(trialFile);

  const start = new Date();
  const end = new Date();
  end.setDate(start.getDate() + days);

  trials.active_trials[firmId] = {
    trial_active: true,
    trial_expired: false,
    trial_start: start.toISOString(),
    trial_end: end.toISOString(),
    trial_days: days
  };

  writeJson(trialFile, trials);
  audit("START_TRIAL", { firmId, days });

  return trials.active_trials[firmId];
}

module.exports = {
  setFirmPlan,
  suspendFirm,
  activateFirm,
  grantFeatureOverride,
  startTrial
};

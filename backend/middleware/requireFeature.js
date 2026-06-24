const fs = require("fs");
const path = require("path");

const plansPath = path.join(__dirname, "../licensing/plans.json");
const auditPath = path.join(__dirname, "../audit/feature-access-audit.log");

function loadPlans() {
  return JSON.parse(fs.readFileSync(plansPath, "utf8"));
}

function writeAuditLog(entry) {
  const line = JSON.stringify({
    timestamp: new Date().toISOString(),
    ...entry
  }) + "\n";

  fs.appendFileSync(auditPath, line);
}

function requireFeature(featureKey) {
  return function (req, res, next) {
    const plans = loadPlans();

    const user = req.user || {};
    const firm = req.firm || {};

    const isGroundZero =
      firm.license_type === "UNLIMITED_FOUNDING_CLIENT" &&
      firm.all_features_unlocked === true;

    const hasManualOverride =
      Array.isArray(user.feature_overrides) &&
      user.feature_overrides.includes(featureKey);

    const trialAllowed =
      firm.trial_active === true &&
      firm.trial_expired !== true;

    const plan = firm.subscription_plan;
    const planFeatures = plans[plan] || [];
    const subscriptionAllowed = planFeatures.includes(featureKey);

    const allowed =
      isGroundZero ||
      hasManualOverride ||
      trialAllowed ||
      subscriptionAllowed;

    writeAuditLog({
      user_id: user.id || "UNKNOWN_USER",
      firm_id: firm.id || "UNKNOWN_FIRM",
      firm_name: firm.name || "UNKNOWN_FIRM_NAME",
      feature: featureKey,
      plan: plan || "NO_PLAN",
      access_granted: allowed,
      reason: allowed
        ? isGroundZero
          ? "GROUND_ZERO_FULL_ACCESS"
          : hasManualOverride
          ? "MANUAL_USER_OVERRIDE"
          : trialAllowed
          ? "ACTIVE_TRIAL"
          : "SUBSCRIPTION_PLAN_ALLOWED"
        : "FEATURE_NOT_INCLUDED_IN_PLAN"
    });

    if (!allowed) {
      return res.status(403).json({
        success: false,
        error: "FEATURE_LOCKED",
        message: "This feature is not available under the current subscription.",
        feature: featureKey,
        upgrade_required: true
      });
    }

    next();
  };
}

module.exports = {
  requireFeature
};

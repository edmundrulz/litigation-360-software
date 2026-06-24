const express = require("express");
const router = express.Router();

const {
  setFirmPlan,
  suspendFirm,
  activateFirm
} = require("../admin/subscription-admin");

const {
  startTrial,
  endTrial,
  getTrialStatus,
  listTrials,
  refreshTrialExpiries
} = require("../admin/trial-admin");

const {
  grantFeatureOverride,
  revokeFeatureOverride,
  listFeatureOverrides,
  featureOverrideStatus
} = require("../admin/feature-override-admin");

const { requireAdmin } = require("../middleware/requireAdmin");
const { requireApproval } = require("../middleware/requireApproval");
const { safetyLock } = require("../middleware/safetyLock");
const { adminAudit } = require("../middleware/adminAudit");
const {
  validateRequired,
  validatePlan,
  validateTrialDays
} = require("../middleware/adminValidation");
const { validateFeatureKey } = require("../middleware/validateFeatureKey");

router.get("/health", requireAdmin, function (req, res) {
  res.json({
    success: true,
    module: "Admin Control API",
    hardening: "ACTIVE",
    trial_management_hardening: "ACTIVE",
    status: "OPERATIONAL"
  });
});

router.post(
  "/subscription/set-plan",
  requireApproval("SET_FIRM_PLAN"),
  safetyLock("SET_FIRM_PLAN"),
  validateRequired(["firmId", "plan"]),
  validatePlan,
  adminAudit("SET_FIRM_PLAN"),
  function (req, res) {
    try {
      const result = setFirmPlan(req.body.firmId, req.body.plan);
      res.json({ success: true, action: "SET_FIRM_PLAN", firm: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/subscription/downgrade",
  requireApproval("DOWNGRADE_PLAN"),
  safetyLock("DOWNGRADE_PLAN"),
  validateRequired(["firmId", "plan"]),
  validatePlan,
  adminAudit("DOWNGRADE_PLAN"),
  function (req, res) {
    try {
      const result = setFirmPlan(req.body.firmId, req.body.plan);
      res.json({ success: true, action: "DOWNGRADE_PLAN", firm: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/subscription/suspend",
  requireApproval("SUSPEND_FIRM"),
  safetyLock("SUSPEND_FIRM"),
  validateRequired(["firmId"]),
  adminAudit("SUSPEND_FIRM"),
  function (req, res) {
    try {
      const result = suspendFirm(req.body.firmId);
      res.json({ success: true, action: "SUSPEND_FIRM", firm: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/subscription/activate",
  requireApproval("ACTIVATE_FIRM"),
  safetyLock("ACTIVATE_FIRM"),
  validateRequired(["firmId"]),
  adminAudit("ACTIVATE_FIRM"),
  function (req, res) {
    try {
      const result = activateFirm(req.body.firmId);
      res.json({ success: true, action: "ACTIVATE_FIRM", firm: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/trial/start",
  requireApproval("START_TRIAL"),
  safetyLock("START_TRIAL"),
  validateRequired(["firmId"]),
  validateTrialDays,
  adminAudit("START_TRIAL"),
  function (req, res) {
    try {
      const result = startTrial(req.body.firmId, req.body.days);
      res.json({ success: true, action: "START_TRIAL", trial: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/trial/end",
  requireApproval("END_TRIAL"),
  safetyLock("END_TRIAL"),
  validateRequired(["firmId"]),
  adminAudit("END_TRIAL"),
  function (req, res) {
    try {
      const result = endTrial(req.body.firmId, req.body.reason || "ADMIN_ENDED");
      res.json({ success: true, action: "END_TRIAL", trial: result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.get(
  "/trial/status",
  requireAdmin,
  adminAudit("TRIAL_STATUS"),
  function (req, res) {
    try {
      if (!req.query.firmId) {
        return res.status(400).json({
          success: false,
          error: "MISSING_REQUIRED_PARAMETERS",
          missing: ["firmId"]
        });
      }

      const result = getTrialStatus(req.query.firmId);
      res.json({ success: true, action: "TRIAL_STATUS", result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.get(
  "/trial/list",
  requireAdmin,
  adminAudit("TRIAL_LIST"),
  function (req, res) {
    try {
      const result = listTrials();
      res.json({ success: true, action: "TRIAL_LIST", result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/trial/refresh-expiries",
  requireApproval("END_TRIAL"),
  adminAudit("TRIAL_REFRESH_EXPIRIES"),
  function (req, res) {
    try {
      const result = refreshTrialExpiries();
      res.json({ success: true, action: "TRIAL_REFRESH_EXPIRIES", result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/feature/grant",
  requireApproval("GRANT_FEATURE_OVERRIDE"),
  safetyLock("GRANT_FEATURE_OVERRIDE"),
  validateRequired(["firmId", "userId", "featureKey"]),
  validateFeatureKey,
  adminAudit("GRANT_FEATURE_OVERRIDE"),
  function (req, res) {
    try {
      const result = grantFeatureOverride(req.body.firmId, req.body.userId, req.body.featureKey);
      res.json({
        success: true,
        action: "GRANT_FEATURE_OVERRIDE",
        firmId: req.body.firmId,
        userId: req.body.userId,
        features: result
      });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.post(
  "/feature/revoke",
  requireApproval("REVOKE_FEATURE_OVERRIDE"),
  safetyLock("REVOKE_FEATURE_OVERRIDE"),
  validateRequired(["firmId", "userId", "featureKey"]),
  validateFeatureKey,
  adminAudit("REVOKE_FEATURE_OVERRIDE"),
  function (req, res) {
    try {
      const result = revokeFeatureOverride(req.body.firmId, req.body.userId, req.body.featureKey);
      res.json({
        success: true,
        action: "REVOKE_FEATURE_OVERRIDE",
        firmId: req.body.firmId,
        userId: req.body.userId,
        features: result
      });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.get(
  "/feature/list",
  requireAdmin,
  adminAudit("LIST_FEATURE_OVERRIDES"),
  function (req, res) {
    try {
      const result = listFeatureOverrides(req.query.firmId, req.query.userId);
      res.json({ success: true, action: "LIST_FEATURE_OVERRIDES", result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);

router.get(
  "/feature/status",
  requireAdmin,
  validateFeatureKey,
  adminAudit("FEATURE_OVERRIDE_STATUS"),
  function (req, res) {
    try {
      if (!req.query.firmId || !req.query.userId || !req.query.featureKey) {
        return res.status(400).json({
          success: false,
          error: "MISSING_REQUIRED_PARAMETERS",
          missing: ["firmId", "userId", "featureKey"]
        });
      }

      const result = featureOverrideStatus(
        req.query.firmId,
        req.query.userId,
        req.query.featureKey
      );

      res.json({ success: true, action: "FEATURE_OVERRIDE_STATUS", result });
    } catch (err) {
      res.status(500).json({ success: false, error: err.message });
    }
  }
);


const {
  getDashboard,
  getClients,
  getTrials,
  getFeatureOverrides,
  getAuditSummary,
  getCommercialHealth
} = require("../admin/commercial-monitoring-admin");

router.get(
  "/dashboard",
  requireAdmin,
  adminAudit("COMMERCIAL_DASHBOARD"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_DASHBOARD",
      result: getDashboard()
    });
  }
);

router.get(
  "/clients",
  requireAdmin,
  adminAudit("COMMERCIAL_CLIENTS"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_CLIENTS",
      result: getClients()
    });
  }
);

router.get(
  "/trials",
  requireAdmin,
  adminAudit("COMMERCIAL_TRIALS"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_TRIALS",
      result: getTrials()
    });
  }
);

router.get(
  "/feature-overrides",
  requireAdmin,
  adminAudit("COMMERCIAL_FEATURE_OVERRIDES"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_FEATURE_OVERRIDES",
      result: getFeatureOverrides()
    });
  }
);

router.get(
  "/audit-summary",
  requireAdmin,
  adminAudit("COMMERCIAL_AUDIT_SUMMARY"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_AUDIT_SUMMARY",
      result: getAuditSummary()
    });
  }
);

router.get(
  "/commercial-health",
  requireAdmin,
  adminAudit("COMMERCIAL_HEALTH"),
  function (req, res) {
    res.json({
      success: true,
      action: "COMMERCIAL_HEALTH",
      result: getCommercialHealth()
    });
  }
);

module.exports = router;


const express = require("express");
const router = express.Router();

const {
  getDashboard,
  getClients,
  getTrials,
  getFeatureOverrides,
  getAuditSummary,
  getCommercialHealth
} = require("../admin/commercial-monitoring-admin");

const { requireAdmin } = require("../middleware/requireAdmin");
const { adminAudit } = require("../middleware/adminAudit");

router.get("/dashboard", requireAdmin, adminAudit("COMMERCIAL_DASHBOARD"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_DASHBOARD", result: getDashboard() });
});

router.get("/clients", requireAdmin, adminAudit("COMMERCIAL_CLIENTS"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_CLIENTS", result: getClients() });
});

router.get("/trials", requireAdmin, adminAudit("COMMERCIAL_TRIALS"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_TRIALS", result: getTrials() });
});

router.get("/feature-overrides", requireAdmin, adminAudit("COMMERCIAL_FEATURE_OVERRIDES"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_FEATURE_OVERRIDES", result: getFeatureOverrides() });
});

router.get("/audit-summary", requireAdmin, adminAudit("COMMERCIAL_AUDIT_SUMMARY"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_AUDIT_SUMMARY", result: getAuditSummary() });
});

router.get("/commercial-health", requireAdmin, adminAudit("COMMERCIAL_HEALTH"), (req, res) => {
  res.json({ success: true, action: "COMMERCIAL_HEALTH", result: getCommercialHealth() });
});

module.exports = router;

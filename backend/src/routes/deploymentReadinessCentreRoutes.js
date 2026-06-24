const express = require("express");
const router = express.Router();

const {
  loadBaseline,
  calculateDeploymentReadiness,
  getDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getDeploymentCentreHealth,
  getDeploymentCentreMetrics
} = require("../automation/deploymentReadinessCentre");

router.get("/health", (req, res) => res.json(getDeploymentCentreHealth()));
router.get("/metrics", (req, res) => res.json(getDeploymentCentreMetrics()));
router.get("/baseline", (req, res) => res.json(loadBaseline()));
router.get("/readiness", (req, res) => res.json(calculateDeploymentReadiness()));
router.get("/dashboard", (req, res) => res.json(getDeploymentDashboard()));
router.get("/executive-summary", (req, res) => res.json(getExecutiveDeploymentSummary()));

module.exports = router;

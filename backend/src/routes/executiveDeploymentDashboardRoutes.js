const express = require("express");
const router = express.Router();

const {
  generateExecutiveDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getExecutiveDeploymentHealth,
  getExecutiveDeploymentMetrics
} = require("../automation/executiveDeploymentDashboardEngine");

router.get("/health", (req, res) => res.json(getExecutiveDeploymentHealth()));
router.get("/metrics", (req, res) => res.json(getExecutiveDeploymentMetrics()));
router.get("/dashboard", (req, res) => res.json(generateExecutiveDeploymentDashboard()));
router.get("/summary", (req, res) => res.json(getExecutiveDeploymentSummary()));

module.exports = router;

const express = require("express");
const router = express.Router();

const {
  generateOperationsDashboard,
  getOperationsAlerts,
  getSystemPanel,
  getDeploymentPanel,
  getWorkflowPanel,
  getCourtPanel,
  getIndustrialCourtPanel,
  getPerkesoPanel,
  getNavigationPanel,
  getOperationsHealth,
  getOperationsMetrics
} = require("../automation/enterpriseOperationsCommandCentre");

router.get("/health", (req, res) => res.json(getOperationsHealth()));
router.get("/metrics", (req, res) => res.json(getOperationsMetrics()));
router.get("/dashboard", (req, res) => res.json(generateOperationsDashboard()));
router.get("/alerts", (req, res) => res.json(getOperationsAlerts()));
router.get("/system", (req, res) => res.json(getSystemPanel()));
router.get("/deployment", (req, res) => res.json(getDeploymentPanel()));
router.get("/workflows", (req, res) => res.json(getWorkflowPanel()));
router.get("/courts", (req, res) => res.json(getCourtPanel()));
router.get("/industrial-court", (req, res) => res.json(getIndustrialCourtPanel()));
router.get("/perkeso", (req, res) => res.json(getPerkesoPanel()));
router.get("/navigation", (req, res) => res.json(getNavigationPanel()));

module.exports = router;

const express = require("express");
const router = express.Router();

const {
  validateConfiguration,
  validateDatabase,
  validateAutomation,
  validateRoutes,
  validateSecurity,
  validatePerformance,
  validateStartup,
  runFullValidation,
  getEnterpriseHardeningDashboard,
  getDeploymentReadiness,
  getEnterpriseHealthScore,
  getHardeningHealth,
  getHardeningMetrics
} = require("../automation/enterpriseHardeningEngine");

router.get("/health", (req, res) => res.json(getHardeningHealth()));
router.get("/metrics", (req, res) => res.json(getHardeningMetrics()));
router.get("/dashboard", (req, res) => res.json(getEnterpriseHardeningDashboard()));
router.get("/validate", (req, res) => res.json(runFullValidation()));
router.get("/healthscore", (req, res) => res.json(getEnterpriseHealthScore()));
router.get("/deployment/readiness", (req, res) => res.json(getDeploymentReadiness()));
router.get("/startup/validate", (req, res) => res.json(validateStartup()));
router.get("/configuration/validate", (req, res) => res.json(validateConfiguration()));
router.get("/database/validate", (req, res) => res.json(validateDatabase()));
router.get("/routes/validate", (req, res) => res.json(validateRoutes()));
router.get("/automation/validate", (req, res) => res.json(validateAutomation()));
router.get("/security/validate", (req, res) => res.json(validateSecurity()));
router.get("/performance/validate", (req, res) => res.json(validatePerformance()));

module.exports = router;

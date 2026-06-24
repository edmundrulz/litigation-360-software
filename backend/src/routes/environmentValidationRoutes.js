const express = require("express");
const router = express.Router();

const {
  generateEnvironmentReport,
  getEnvironmentSummary,
  getEnvironmentReadiness,
  getEnvironmentHealth,
  getEnvironmentMetrics,
  validateOperatingEnvironment,
  validateRuntime,
  validateBackend,
  validateFrontend,
  validateDatabase,
  validateNetwork,
  validateStorage,
  validateEnvFile
} = require("../automation/environmentValidationEngine");

router.get("/health", (req, res) => res.json(getEnvironmentHealth()));
router.get("/metrics", (req, res) => res.json(getEnvironmentMetrics()));
router.get("/report", (req, res) => res.json(generateEnvironmentReport()));
router.get("/summary", (req, res) => res.json(getEnvironmentSummary()));
router.get("/readiness", (req, res) => res.json(getEnvironmentReadiness()));
router.get("/operating-system", (req, res) => res.json(validateOperatingEnvironment()));
router.get("/runtime", (req, res) => res.json(validateRuntime()));
router.get("/backend", (req, res) => res.json(validateBackend()));
router.get("/frontend", (req, res) => res.json(validateFrontend()));
router.get("/database", (req, res) => res.json(validateDatabase()));
router.get("/network", (req, res) => res.json(validateNetwork()));
router.get("/storage", (req, res) => res.json(validateStorage()));
router.get("/env", (req, res) => res.json(validateEnvFile()));

module.exports = router;

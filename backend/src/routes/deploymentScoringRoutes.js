const express = require("express");
const router = express.Router();

const {
  generateScoringReport,
  getScoringDashboard,
  getScoringReadiness,
  getEnterpriseGrade,
  getTrends,
  getScoringHealth,
  getScoringMetrics
} = require("../automation/deploymentScoringEngine");

router.get("/health", (req, res) => res.json(getScoringHealth()));
router.get("/metrics", (req, res) => res.json(getScoringMetrics()));
router.get("/report", (req, res) => res.json(generateScoringReport()));
router.get("/dashboard", (req, res) => res.json(getScoringDashboard()));
router.get("/readiness", (req, res) => res.json(getScoringReadiness()));
router.get("/grade", (req, res) => res.json(getEnterpriseGrade()));
router.get("/trends", (req, res) => res.json(getTrends()));

module.exports = router;

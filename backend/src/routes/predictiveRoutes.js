const express = require("express");
const router = express.Router();

const predictive = require("../automation/predictiveIntelligenceEngine");
const risk = require("../automation/riskScoringEngine");
const trends = require("../automation/trendAnalysisEngine");
const forecast = require("../automation/forecastEngine");

router.get("/health", (req, res) => res.json(predictive.health()));
router.get("/metrics", (req, res) => res.json(predictive.metrics()));
router.get("/dashboard", (req, res) => res.json(predictive.dashboard()));
router.get("/risks", (req, res) => res.json(predictive.risks()));
router.get("/workload", (req, res) => res.json(forecast.forecastWorkload()));
router.get("/deadlines", (req, res) => res.json(predictive.deadlines()));
router.get("/deployments", (req, res) => res.json(predictive.deployments()));
router.get("/performance", (req, res) => res.json(predictive.performance()));
router.get("/trends", (req, res) => res.json(trends.analyseTrends()));
router.get("/compliance", (req, res) => res.json(predictive.compliance()));

router.post("/score", (req, res) => res.json(risk.scoreRisk(req.body || {})));
router.get("/courts", (req, res) => res.json(forecast.forecastCourtDeadlines()));

module.exports = router;

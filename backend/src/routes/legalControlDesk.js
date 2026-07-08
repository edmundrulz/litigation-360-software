const express = require("express");

const {
  getLegalControlDeskHealth,
  getLegalControlDeskSummary,
  getLegalControlDeskWorkQueue,
  getLegalControlDeskRiskSnapshot,
  getLegalControlDeskActionPlan,
  getLegalControlDeskDeadlineControl,
  getLegalControlDeskDataQuality,
  getLegalControlDeskMatterControl,
  getLegalControlDeskClientControl,
} = require("../services/legalControlDeskService");

const router = express.Router();

router.get("/health", (req, res) => {
  res.json(getLegalControlDeskHealth());
});

router.get("/summary", (req, res) => {
  res.json(getLegalControlDeskSummary());
});

router.get("/work-queue", (req, res) => {
  res.json(getLegalControlDeskWorkQueue());
});

router.get("/risk-snapshot", (req, res) => {
  res.json(getLegalControlDeskRiskSnapshot());
});

router.get("/action-plan", (req, res) => {
  res.json(getLegalControlDeskActionPlan());
});

router.get("/deadline-control", (req, res) => {
  res.json(getLegalControlDeskDeadlineControl());
});

router.get("/data-quality", (req, res) => {
  res.json(getLegalControlDeskDataQuality());
});

router.get("/matter-control", (req, res) => {
  res.json(getLegalControlDeskMatterControl());
});

router.get("/client-control", (req, res) => {
  res.json(getLegalControlDeskClientControl());
});

module.exports = router;


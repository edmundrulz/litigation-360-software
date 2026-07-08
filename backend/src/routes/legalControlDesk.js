const express = require("express");

const {
  getLegalControlDeskHealth,
  getLegalControlDeskSummary,
  getLegalControlDeskWorkQueue,
  getLegalControlDeskRiskSnapshot,
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

module.exports = router;

const express = require("express");

const router = express.Router();

const CONTROL_DESK_VERSION = "15A-F01";

const legalControlDeskSnapshot = {
  version: CONTROL_DESK_VERSION,
  module: "Legal Control Desk",
  mode: "read-only-functional-core",
  generatedAt: new Date().toISOString(),
  summary: {
    activeMatters: 12,
    urgentDeadlines: 4,
    upcomingCourtDates: 3,
    openTasks: 18,
    highRiskItems: 2,
    operationalReadiness: "FOUNDATION_READY",
  },
  workQueue: [
    {
      id: "LCD-WQ-001",
      type: "deadline",
      priority: "critical",
      title: "Review urgent filing deadline",
      status: "requires-review",
      owner: "Legal Operations",
    },
    {
      id: "LCD-WQ-002",
      type: "court-date",
      priority: "high",
      title: "Confirm upcoming court appearance bundle",
      status: "pending-confirmation",
      owner: "Case Handler",
    },
    {
      id: "LCD-WQ-003",
      type: "matter",
      priority: "medium",
      title: "Validate matter status and next action",
      status: "open",
      owner: "Matter Controller",
    },
  ],
  riskSnapshot: [
    {
      id: "LCD-RISK-001",
      level: "high",
      area: "deadline-control",
      message: "Urgent deadline queue requires same-day review.",
    },
    {
      id: "LCD-RISK-002",
      level: "medium",
      area: "court-readiness",
      message: "Court bundle readiness should be confirmed before hearing date.",
    },
  ],
  nextActions: [
    "Connect summary endpoint to real matters/deadlines data.",
    "Add backend aggregation service after route contract is verified.",
    "Expose read-only frontend integration only after protected visual approval.",
  ],
};

router.get("/health", (req, res) => {
  res.json({
    ok: true,
    module: "Legal Control Desk",
    version: CONTROL_DESK_VERSION,
    status: "online",
    mode: "read-only",
  });
});

router.get("/summary", (req, res) => {
  res.json({
    ok: true,
    ...legalControlDeskSnapshot,
  });
});

router.get("/work-queue", (req, res) => {
  res.json({
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: new Date().toISOString(),
    workQueue: legalControlDeskSnapshot.workQueue,
  });
});

router.get("/risk-snapshot", (req, res) => {
  res.json({
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: new Date().toISOString(),
    riskSnapshot: legalControlDeskSnapshot.riskSnapshot,
  });
});

module.exports = router;

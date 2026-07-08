const CONTROL_DESK_VERSION = "15A-F02";

const baseSummary = {
  activeMatters: 12,
  urgentDeadlines: 4,
  upcomingCourtDates: 3,
  openTasks: 18,
  highRiskItems: 2,
  operationalReadiness: "SERVICE_LAYER_READY",
};

const workQueue = [
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
];

const riskSnapshot = [
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
];

const nextActions = [
  "Connect summary endpoint to real matters/deadlines data.",
  "Add backend aggregation from existing route modules after service contract is verified.",
  "Expose read-only frontend integration only after protected visual approval.",
];

function getGeneratedAt() {
  return new Date().toISOString();
}

function getLegalControlDeskHealth() {
  return {
    ok: true,
    module: "Legal Control Desk",
    version: CONTROL_DESK_VERSION,
    status: "online",
    mode: "read-only-service-layer",
  };
}

function getLegalControlDeskSummary() {
  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    module: "Legal Control Desk",
    mode: "read-only-functional-core",
    generatedAt: getGeneratedAt(),
    summary: baseSummary,
    workQueue,
    riskSnapshot,
    nextActions,
  };
}

function getLegalControlDeskWorkQueue() {
  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    workQueue,
  };
}

function getLegalControlDeskRiskSnapshot() {
  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    riskSnapshot,
  };
}

module.exports = {
  CONTROL_DESK_VERSION,
  getLegalControlDeskHealth,
  getLegalControlDeskSummary,
  getLegalControlDeskWorkQueue,
  getLegalControlDeskRiskSnapshot,
};

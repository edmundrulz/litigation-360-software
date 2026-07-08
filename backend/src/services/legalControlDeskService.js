const db = require("../database");

const CONTROL_DESK_VERSION = "15A-F05";
const URGENT_DEADLINE_WINDOW_DAYS = 7;

function getGeneratedAt() {
  return new Date().toISOString();
}

function toDateOnly(value) {
  if (!value) return null;

  if (typeof value === "string") {
    const match = value.match(/^(\d{4})-(\d{2})-(\d{2})/);
    if (match) {
      return new Date(Number(match[1]), Number(match[2]) - 1, Number(match[3]));
    }
  }

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;

  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

function addDays(date, days) {
  const next = new Date(date);
  next.setDate(next.getDate() + days);
  return next;
}

function normaliseStatus(status) {
  return String(status || "").trim().toLowerCase();
}

function isClosedMatter(status) {
  return ["closed", "archived", "inactive"].includes(normaliseStatus(status));
}

function isDeadlineComplete(row) {
  return Number(row.is_complete || 0) === 1;
}

function getDeadlineStatus(deadlineDate, today, urgentCutoff) {
  const parsedDate = toDateOnly(deadlineDate);

  if (!parsedDate) {
    return {
      bucket: "undated",
      priority: "medium",
      isUrgent: false,
      isOverdue: false,
    };
  }

  if (parsedDate < today) {
    return {
      bucket: "overdue",
      priority: "critical",
      isUrgent: true,
      isOverdue: true,
    };
  }

  if (parsedDate <= urgentCutoff) {
    return {
      bucket: "urgent",
      priority: "high",
      isUrgent: true,
      isOverdue: false,
    };
  }

  return {
    bucket: "upcoming",
    priority: "medium",
    isUrgent: false,
    isOverdue: false,
  };
}

function readSqliteSnapshot() {
  const cases = db.prepare(`
    SELECT id, case_number, title, status, client_id, opened_date, created_at
    FROM cases
    ORDER BY created_at DESC
  `).all();

  const clients = db.prepare(`
    SELECT id, full_name, email, phone, created_at
    FROM clients
    ORDER BY created_at DESC
  `).all();

  const deadlines = db.prepare(`
    SELECT
      deadlines.id,
      deadlines.case_id,
      deadlines.title,
      deadlines.deadline_date,
      deadlines.reminder_days,
      deadlines.notes,
      deadlines.is_complete,
      deadlines.created_at,
      cases.case_number,
      cases.title AS case_title,
      cases.status AS case_status
    FROM deadlines
    LEFT JOIN cases ON cases.id = deadlines.case_id
    ORDER BY deadlines.deadline_date ASC
  `).all();

  return {
    cases,
    clients,
    deadlines,
  };
}

function buildWorkQueue(deadlines, today, urgentCutoff) {
  return deadlines
    .filter((row) => !isDeadlineComplete(row))
    .map((row) => {
      const status = getDeadlineStatus(row.deadline_date, today, urgentCutoff);

      return {
        id: `LCD-DL-${row.id}`,
        sourceId: row.id,
        type: "deadline",
        priority: status.priority,
        bucket: status.bucket,
        title: row.title || "Untitled deadline",
        status: status.isOverdue ? "overdue" : status.isUrgent ? "requires-review" : "open",
        owner: "Legal Operations",
        deadlineDate: row.deadline_date,
        matterId: row.case_id,
        matterNumber: row.case_number || null,
        matterTitle: row.case_title || null,
      };
    })
    .filter((item) => ["critical", "high"].includes(item.priority))
    .slice(0, 10);
}

function buildDeadlineControl(deadlines, today, urgentCutoff) {
  const buckets = {
    overdue: [],
    urgent: [],
    upcoming: [],
    undated: [],
    completed: [],
  };

  deadlines.forEach((row) => {
    if (isDeadlineComplete(row)) {
      buckets.completed.push(row);
      return;
    }

    const status = getDeadlineStatus(row.deadline_date, today, urgentCutoff);
    buckets[status.bucket].push(row);
  });

  return {
    windowDays: URGENT_DEADLINE_WINDOW_DAYS,
    counts: {
      overdue: buckets.overdue.length,
      urgent: buckets.urgent.length,
      upcoming: buckets.upcoming.length,
      undated: buckets.undated.length,
      completed: buckets.completed.length,
      total: deadlines.length,
    },
    status:
      buckets.overdue.length > 0
        ? "critical"
        : buckets.urgent.length > 0
          ? "attention-required"
          : "controlled",
    overdueItems: buckets.overdue.slice(0, 10).map((row) => ({
      id: row.id,
      title: row.title,
      deadlineDate: row.deadline_date,
      matterNumber: row.case_number || null,
      matterTitle: row.case_title || null,
    })),
    urgentItems: buckets.urgent.slice(0, 10).map((row) => ({
      id: row.id,
      title: row.title,
      deadlineDate: row.deadline_date,
      matterNumber: row.case_number || null,
      matterTitle: row.case_title || null,
    })),
  };
}

function buildRiskSnapshot(deadlines, today, urgentCutoff) {
  const activeDeadlines = deadlines.filter((row) => !isDeadlineComplete(row));

  const overdueDeadlines = activeDeadlines.filter((row) => {
    const status = getDeadlineStatus(row.deadline_date, today, urgentCutoff);
    return status.isOverdue;
  });

  const urgentDeadlines = activeDeadlines.filter((row) => {
    const status = getDeadlineStatus(row.deadline_date, today, urgentCutoff);
    return status.isUrgent && !status.isOverdue;
  });

  const risks = [];

  if (overdueDeadlines.length > 0) {
    risks.push({
      id: "LCD-RISK-OVERDUE-DEADLINES",
      level: "critical",
      area: "deadline-control",
      count: overdueDeadlines.length,
      message: `${overdueDeadlines.length} deadline item(s) are overdue and require immediate review.`,
    });
  }

  if (urgentDeadlines.length > 0) {
    risks.push({
      id: "LCD-RISK-URGENT-DEADLINES",
      level: "high",
      area: "deadline-control",
      count: urgentDeadlines.length,
      message: `${urgentDeadlines.length} deadline item(s) fall within the next ${URGENT_DEADLINE_WINDOW_DAYS} day(s).`,
    });
  }

  if (risks.length === 0) {
    risks.push({
      id: "LCD-RISK-NO-URGENT-DEADLINES",
      level: "low",
      area: "deadline-control",
      count: 0,
      message: "No overdue or urgent incomplete deadlines detected from the current SQLite data.",
    });
  }

  return risks;
}

function getTableQuality(tableName, rows, configured = true) {
  if (!configured) {
    return {
      table: tableName,
      configured: false,
      status: "not-configured",
      rowCount: 0,
    };
  }

  return {
    table: tableName,
    configured: true,
    status: rows.length > 0 ? "live" : "live-empty",
    rowCount: rows.length,
  };
}

function buildDataQuality(snapshot) {
  return {
    status: "read-only-check-complete",
    generatedAt: getGeneratedAt(),
    tables: [
      getTableQuality("cases", snapshot.cases),
      getTableQuality("clients", snapshot.clients),
      getTableQuality("deadlines", snapshot.deadlines),
      getTableQuality("tasks", [], false),
      getTableQuality("court_dates", [], false),
    ],
    warnings: [
      "Task storage is not configured for Legal Control Desk aggregation yet.",
      "Court date storage is not configured for Legal Control Desk aggregation yet.",
    ],
  };
}

function buildMatterControl(cases) {
  const statusCounts = cases.reduce((acc, row) => {
    const key = normaliseStatus(row.status) || "unknown";
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});

  const activeMatters = cases.filter((row) => !isClosedMatter(row.status));
  const closedMatters = cases.filter((row) => isClosedMatter(row.status));
  const mattersWithoutClients = cases.filter((row) => !row.client_id);

  return {
    status: mattersWithoutClients.length > 0 ? "attention-required" : "controlled",
    counts: {
      total: cases.length,
      active: activeMatters.length,
      closedOrInactive: closedMatters.length,
      withoutClient: mattersWithoutClients.length,
    },
    statusBreakdown: statusCounts,
    activeMatterItems: activeMatters.slice(0, 10).map((row) => ({
      id: row.id,
      matterNumber: row.case_number || null,
      title: row.title || "Untitled matter",
      status: row.status || null,
      clientId: row.client_id || null,
      openedDate: row.opened_date || null,
    })),
    mattersWithoutClients: mattersWithoutClients.slice(0, 10).map((row) => ({
      id: row.id,
      matterNumber: row.case_number || null,
      title: row.title || "Untitled matter",
      status: row.status || null,
      openedDate: row.opened_date || null,
    })),
  };
}

function buildClientControl(clients, cases) {
  const matterCountByClientId = cases.reduce((acc, row) => {
    if (!row.client_id) return acc;
    const key = String(row.client_id);
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});

  const clientsWithoutMatters = clients.filter((client) => {
    return !matterCountByClientId[String(client.id)];
  });

  const linkedClients = clients.filter((client) => {
    return matterCountByClientId[String(client.id)] > 0;
  });

  return {
    status: clientsWithoutMatters.length > 0 ? "review-required" : "controlled",
    counts: {
      total: clients.length,
      linkedToMatters: linkedClients.length,
      withoutMatters: clientsWithoutMatters.length,
    },
    clientsWithoutMatters: clientsWithoutMatters.slice(0, 10).map((client) => ({
      id: client.id,
      fullName: client.full_name || "Unnamed client",
      email: client.email || null,
      phone: client.phone || null,
      createdAt: client.created_at || null,
    })),
    clientMatterLinks: clients.slice(0, 10).map((client) => ({
      id: client.id,
      fullName: client.full_name || "Unnamed client",
      matterCount: matterCountByClientId[String(client.id)] || 0,
    })),
  };
}

function buildActionPlan(summary, deadlineControl, riskSnapshot, matterControl = null, clientControl = null) {
  const actions = [];

  if (deadlineControl.counts.overdue > 0) {
    actions.push({
      id: "LCD-ACTION-OVERDUE-DEADLINE-REVIEW",
      priority: "critical",
      type: "deadline-control",
      title: "Review overdue deadline queue immediately",
      reason: `${deadlineControl.counts.overdue} overdue deadline item(s) detected.`,
      recommendedOwner: "Legal Operations",
      recommendedTiming: "same-day",
      status: "open",
    });
  }

  if (deadlineControl.counts.urgent > 0) {
    actions.push({
      id: "LCD-ACTION-URGENT-DEADLINE-CHECK",
      priority: "high",
      type: "deadline-control",
      title: "Confirm urgent upcoming deadline readiness",
      reason: `${deadlineControl.counts.urgent} deadline item(s) fall within ${URGENT_DEADLINE_WINDOW_DAYS} day(s).`,
      recommendedOwner: "Matter Controller",
      recommendedTiming: "within-24-hours",
      status: "open",
    });
  }

  if (summary.activeMatters > 0) {
    actions.push({
      id: "LCD-ACTION-MATTER-STATUS-REVIEW",
      priority: "medium",
      type: "matter-control",
      title: "Review active matter status coverage",
      reason: `${summary.activeMatters} active matter(s) are currently visible to the Legal Control Desk.`,
      recommendedOwner: "Case Handler",
      recommendedTiming: "routine-review",
      status: "open",
    });
  }

  if (matterControl && matterControl.counts.withoutClient > 0) {
    actions.push({
      id: "LCD-ACTION-MATTER-CLIENT-LINK-REVIEW",
      priority: "high",
      type: "matter-control",
      title: "Resolve matters without linked clients",
      reason: `${matterControl.counts.withoutClient} matter(s) are missing a linked client.`,
      recommendedOwner: "Matter Controller",
      recommendedTiming: "within-24-hours",
      status: "open",
    });
  }

  if (clientControl && clientControl.counts.withoutMatters > 0) {
    actions.push({
      id: "LCD-ACTION-CLIENT-MATTER-LINK-REVIEW",
      priority: "medium",
      type: "client-control",
      title: "Review clients without linked matters",
      reason: `${clientControl.counts.withoutMatters} client(s) are not linked to any matter.`,
      recommendedOwner: "Client Intake",
      recommendedTiming: "routine-review",
      status: "open",
    });
  }

  if (riskSnapshot.some((risk) => risk.level === "critical")) {
    actions.push({
      id: "LCD-ACTION-RISK-ESCALATION",
      priority: "critical",
      type: "risk-control",
      title: "Escalate critical Legal Control Desk risk",
      reason: "One or more critical operational risks are currently active.",
      recommendedOwner: "Senior Legal Controller",
      recommendedTiming: "same-day",
      status: "open",
    });
  }

  if (actions.length === 0) {
    actions.push({
      id: "LCD-ACTION-NO-CRITICAL-ACTION",
      priority: "low",
      type: "control-status",
      title: "Maintain routine control desk monitoring",
      reason: "No urgent or critical Legal Control Desk action is currently detected.",
      recommendedOwner: "Legal Operations",
      recommendedTiming: "routine",
      status: "open",
    });
  }

  return {
    status: actions.some((action) => action.priority === "critical")
      ? "critical-action-required"
      : actions.some((action) => action.priority === "high")
        ? "action-required"
        : "routine-monitoring",
    actionCount: actions.length,
    actions,
  };
}

function buildAggregation() {
  const today = toDateOnly(new Date());
  const urgentCutoff = addDays(today, URGENT_DEADLINE_WINDOW_DAYS);

  try {
    const snapshot = readSqliteSnapshot();

    const activeMatters = snapshot.cases.filter((row) => !isClosedMatter(row.status));
    const incompleteDeadlines = snapshot.deadlines.filter((row) => !isDeadlineComplete(row));

    const urgentDeadlines = incompleteDeadlines.filter((row) => {
      const status = getDeadlineStatus(row.deadline_date, today, urgentCutoff);
      return status.isUrgent;
    });

    const workQueue = buildWorkQueue(snapshot.deadlines, today, urgentCutoff);
    const riskSnapshot = buildRiskSnapshot(snapshot.deadlines, today, urgentCutoff);
    const deadlineControl = buildDeadlineControl(snapshot.deadlines, today, urgentCutoff);
    const dataQuality = buildDataQuality(snapshot);
    const matterControl = buildMatterControl(snapshot.cases);
    const clientControl = buildClientControl(snapshot.clients, snapshot.cases);

    const summary = {
      activeMatters: activeMatters.length,
      totalMatters: snapshot.cases.length,
      totalClients: snapshot.clients.length,
      urgentDeadlines: urgentDeadlines.length,
      totalDeadlines: snapshot.deadlines.length,
      upcomingCourtDates: 0,
      openTasks: workQueue.length,
      highRiskItems: riskSnapshot.filter((risk) => ["critical", "high"].includes(risk.level)).length,
      operationalReadiness: "MATTER_CLIENT_CONTROL_READY",
    };

    const actionPlan = buildActionPlan(summary, deadlineControl, riskSnapshot, matterControl, clientControl);

    return {
      dataSource: {
        mode: "sqlite-live",
        database: "better-sqlite3",
        tables: {
          cases: "live",
          deadlines: "live",
          clients: "live",
          tasks: "not-configured",
          courtDates: "not-configured",
        },
        fallbackUsed: false,
      },
      summary,
      workQueue,
      riskSnapshot,
      deadlineControl,
      dataQuality,
      matterControl,
      clientControl,
      actionPlan,
      nextActions: [
        "Complete overdue deadline review workflow.",
        "Review matter-client linkage exceptions.",
        "Add a dedicated court dates table or mapping when the data model is approved.",
        "Add task table aggregation when the task storage layer is confirmed.",
        "Expose read-only frontend integration only after protected visual approval.",
      ],
    };
  } catch (error) {
    const fallbackRiskSnapshot = [
      {
        id: "LCD-RISK-DATA-AGGREGATION",
        level: "high",
        area: "data-access",
        count: 1,
        message: "Legal Control Desk could not read the SQLite aggregation source.",
      },
    ];

    const fallbackSummary = {
      activeMatters: 0,
      totalMatters: 0,
      totalClients: 0,
      urgentDeadlines: 0,
      totalDeadlines: 0,
      upcomingCourtDates: 0,
      openTasks: 0,
      highRiskItems: 1,
      operationalReadiness: "ACTION_PLAN_ERROR",
    };

    return {
      dataSource: {
        mode: "fallback-error",
        database: "better-sqlite3",
        fallbackUsed: true,
        error: error.message,
      },
      summary: fallbackSummary,
      workQueue: [],
      riskSnapshot: fallbackRiskSnapshot,
      deadlineControl: {
        windowDays: URGENT_DEADLINE_WINDOW_DAYS,
        counts: {
          overdue: 0,
          urgent: 0,
          upcoming: 0,
          undated: 0,
          completed: 0,
          total: 0,
        },
        status: "unknown",
        overdueItems: [],
        urgentItems: [],
      },
      dataQuality: {
        status: "read-only-check-failed",
        generatedAt: getGeneratedAt(),
        tables: [],
        warnings: [error.message],
      },
      matterControl: {
        status: "unknown",
        counts: {
          total: 0,
          active: 0,
          closedOrInactive: 0,
          withoutClient: 0,
        },
        statusBreakdown: {},
        activeMatterItems: [],
        mattersWithoutClients: [],
      },
      clientControl: {
        status: "unknown",
        counts: {
          total: 0,
          linkedToMatters: 0,
          withoutMatters: 0,
        },
        clientsWithoutMatters: [],
        clientMatterLinks: [],
      },
      actionPlan: buildActionPlan(fallbackSummary, {
        counts: {
          overdue: 0,
          urgent: 0,
        },
      }, fallbackRiskSnapshot),
      nextActions: [
        "Review backend SQLite database availability.",
        "Confirm cases, clients, and deadlines tables are readable.",
        "Do not connect frontend until backend aggregation is stable.",
      ],
    };
  }
}

function getLegalControlDeskHealth() {
  return {
    ok: true,
    module: "Legal Control Desk",
    version: CONTROL_DESK_VERSION,
    status: "online",
    mode: "read-only-matter-client-control",
  };
}

function getLegalControlDeskSummary() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    module: "Legal Control Desk",
    mode: "read-only-matter-client-control",
    generatedAt: getGeneratedAt(),
    ...aggregation,
  };
}

function getLegalControlDeskWorkQueue() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    workQueue: aggregation.workQueue,
  };
}

function getLegalControlDeskRiskSnapshot() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    riskSnapshot: aggregation.riskSnapshot,
  };
}

function getLegalControlDeskActionPlan() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    actionPlan: aggregation.actionPlan,
  };
}

function getLegalControlDeskDeadlineControl() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    deadlineControl: aggregation.deadlineControl,
  };
}

function getLegalControlDeskDataQuality() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    dataQuality: aggregation.dataQuality,
  };
}

function getLegalControlDeskMatterControl() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    matterControl: aggregation.matterControl,
  };
}

function getLegalControlDeskClientControl() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    generatedAt: getGeneratedAt(),
    dataSource: aggregation.dataSource,
    clientControl: aggregation.clientControl,
  };
}

module.exports = {
  CONTROL_DESK_VERSION,
  getLegalControlDeskHealth,
  getLegalControlDeskSummary,
  getLegalControlDeskWorkQueue,
  getLegalControlDeskRiskSnapshot,
  getLegalControlDeskActionPlan,
  getLegalControlDeskDeadlineControl,
  getLegalControlDeskDataQuality,
  getLegalControlDeskMatterControl,
  getLegalControlDeskClientControl,
};


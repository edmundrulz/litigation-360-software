const db = require("../database");

const CONTROL_DESK_VERSION = "15A-F03";
const URGENT_DEADLINE_WINDOW_DAYS = 7;

function getGeneratedAt() {
  return new Date().toISOString();
}

function toDateOnly(value) {
  if (!value) return null;

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
      summary: {
        activeMatters: activeMatters.length,
        totalMatters: snapshot.cases.length,
        totalClients: snapshot.clients.length,
        urgentDeadlines: urgentDeadlines.length,
        totalDeadlines: snapshot.deadlines.length,
        upcomingCourtDates: 0,
        openTasks: workQueue.length,
        highRiskItems: riskSnapshot.filter((risk) => ["critical", "high"].includes(risk.level)).length,
        operationalReadiness: "SQLITE_AGGREGATION_READY",
      },
      workQueue,
      riskSnapshot,
      nextActions: [
        "Add a dedicated court dates table or mapping when the data model is approved.",
        "Add task table aggregation when the task storage layer is confirmed.",
        "Expose read-only frontend integration only after protected visual approval.",
      ],
    };
  } catch (error) {
    return {
      dataSource: {
        mode: "fallback-error",
        database: "better-sqlite3",
        fallbackUsed: true,
        error: error.message,
      },
      summary: {
        activeMatters: 0,
        totalMatters: 0,
        totalClients: 0,
        urgentDeadlines: 0,
        totalDeadlines: 0,
        upcomingCourtDates: 0,
        openTasks: 0,
        highRiskItems: 1,
        operationalReadiness: "SQLITE_AGGREGATION_ERROR",
      },
      workQueue: [],
      riskSnapshot: [
        {
          id: "LCD-RISK-DATA-AGGREGATION",
          level: "high",
          area: "data-access",
          count: 1,
          message: "Legal Control Desk could not read the SQLite aggregation source.",
        },
      ],
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
    mode: "read-only-sqlite-aggregation",
  };
}

function getLegalControlDeskSummary() {
  const aggregation = buildAggregation();

  return {
    ok: true,
    version: CONTROL_DESK_VERSION,
    module: "Legal Control Desk",
    mode: "read-only-sqlite-aggregation",
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

module.exports = {
  CONTROL_DESK_VERSION,
  getLegalControlDeskHealth,
  getLegalControlDeskSummary,
  getLegalControlDeskWorkQueue,
  getLegalControlDeskRiskSnapshot,
};

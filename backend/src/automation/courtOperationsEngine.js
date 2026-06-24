const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow } = require("./workflowEngine");

const courtStore = [];
const courtTaskStore = [];

const COURT_EVENT_TYPES = {
  MENTION: "MENTION",
  HEARING: "HEARING",
  TRIAL: "TRIAL",
  CASE_MANAGEMENT: "CASE_MANAGEMENT",
  DECISION: "DECISION",
  FILING_DEADLINE: "FILING_DEADLINE",
  SUBMISSION: "SUBMISSION",
  OTHER: "OTHER"
};

const courtMetrics = {
  courtDatesCreated: 0,
  deadlinesGenerated: 0,
  remindersGenerated: 0,
  tasksGenerated: 0,
  workflowsStarted: 0,
  overdue: 0,
  upcoming: 0
};

function toDate(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    throw new Error(`Invalid date: ${value}`);
  }
  return date;
}

function addDays(date, days) {
  const next = new Date(date);
  next.setDate(next.getDate() + days);
  return next;
}

function subtractDays(date, days) {
  const next = new Date(date);
  next.setDate(next.getDate() - days);
  return next;
}

function createCourtDate({
  matterId,
  caseTitle = null,
  courtName,
  courtAddress = null,
  courtRoom = null,
  eventType = COURT_EVENT_TYPES.MENTION,
  eventDate,
  eventTime = null,
  assignedTo = null,
  notes = null,
  payload = {}
} = {}) {
  if (!matterId) throw new Error("matterId is required");
  if (!courtName) throw new Error("courtName is required");
  if (!eventDate) throw new Error("eventDate is required");

  const courtDate = toDate(eventDate);
  const normalizedEventType = Object.values(COURT_EVENT_TYPES).includes(eventType) ? eventType : COURT_EVENT_TYPES.OTHER;

  const courtEvent = {
    id: `CRT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    matterId,
    caseTitle,
    courtName,
    courtAddress,
    courtRoom,
    eventType: normalizedEventType,
    eventDate: courtDate.toISOString(),
    eventTime,
    assignedTo,
    notes,
    payload,
    status: "SCHEDULED",
    deadlines: [],
    reminders: [],
    tasks: [],
    workflowId: null,
    history: [
      {
        action: "CREATED",
        timestamp: new Date().toISOString(),
        note: "Court date created"
      }
    ],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  courtStore.push(courtEvent);
  courtMetrics.courtDatesCreated += 1;

  courtEvent.deadlines = generateDeadlines(courtEvent);
  courtEvent.reminders = generateReminders(courtEvent);
  courtEvent.tasks = generateCourtTasks(courtEvent);

  emitEvent("COURT_DATE_ADDED", {
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    eventType: courtEvent.eventType,
    eventDate: courtEvent.eventDate
  }, {
    module: "CourtOperationsEngine"
  });

  createNotification({
    title: `Court Date Added: ${courtEvent.courtName}`,
    message: `${courtEvent.eventType} scheduled for matter ${courtEvent.matterId}.`,
    level: "COURT",
    source: "COURT_OPERATIONS",
    eventType: "COURT_DATE_ADDED",
    matterId: courtEvent.matterId,
    payload: {
      courtEventId: courtEvent.id,
      eventDate: courtEvent.eventDate
    }
  });

  return courtEvent;
}

function generateDeadlines(courtEvent) {
  const eventDate = toDate(courtEvent.eventDate);
  const rules = [];

  if (courtEvent.eventType === COURT_EVENT_TYPES.HEARING || courtEvent.eventType === COURT_EVENT_TYPES.TRIAL) {
    rules.push({ name: "Prepare hearing bundle", daysBefore: 14 });
    rules.push({ name: "Internal review deadline", daysBefore: 7 });
    rules.push({ name: "Final preparation deadline", daysBefore: 1 });
  } else if (courtEvent.eventType === COURT_EVENT_TYPES.MENTION || courtEvent.eventType === COURT_EVENT_TYPES.CASE_MANAGEMENT) {
    rules.push({ name: "Prepare case update", daysBefore: 7 });
    rules.push({ name: "Confirm attendance and instructions", daysBefore: 1 });
  } else {
    rules.push({ name: "Prepare court event", daysBefore: 7 });
  }

  const deadlines = rules.map(rule => ({
    id: `DDL-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name: rule.name,
    dueDate: subtractDays(eventDate, rule.daysBefore).toISOString(),
    daysBefore: rule.daysBefore,
    status: "OPEN",
    createdAt: new Date().toISOString()
  }));

  courtMetrics.deadlinesGenerated += deadlines.length;
  return deadlines;
}

function generateReminders(courtEvent) {
  const eventDate = toDate(courtEvent.eventDate);
  const reminderDays = [14, 7, 3, 1];

  const reminders = reminderDays.map(daysBefore => ({
    id: `REM-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name: `${daysBefore} day court reminder`,
    reminderDate: subtractDays(eventDate, daysBefore).toISOString(),
    daysBefore,
    status: "PENDING",
    createdAt: new Date().toISOString()
  }));

  courtMetrics.remindersGenerated += reminders.length;
  return reminders;
}

function generateCourtTasks(courtEvent) {
  const tasks = [
    "Review court file",
    "Confirm client instructions",
    "Prepare attendance notes",
    "Prepare court bundle",
    "Update matter after court"
  ].map(name => ({
    id: `CTK-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name,
    assignedTo: courtEvent.assignedTo,
    status: "OPEN",
    createdAt: new Date().toISOString()
  }));

  courtTaskStore.push(...tasks);
  courtMetrics.tasksGenerated += tasks.length;
  return tasks;
}

async function startCourtPreparationWorkflow(courtEventId, actor = "SYSTEM") {
  const courtEvent = getCourtEventById(courtEventId);

  if (!courtEvent) {
    return { ok: false, error: "Court event not found" };
  }

  const workflow = createWorkflow({
    workflowType: "COURT_DATE_PREPARATION",
    title: `Court Preparation: ${courtEvent.courtName}`,
    payload: {
      courtEventId: courtEvent.id,
      matterId: courtEvent.matterId,
      eventType: courtEvent.eventType,
      eventDate: courtEvent.eventDate
    },
    context: {
      source: "COURT_OPERATIONS",
      actor
    }
  });

  courtEvent.workflowId = workflow.id;
  courtEvent.history.push({
    action: "COURT_PREPARATION_WORKFLOW_STARTED",
    workflowId: workflow.id,
    actor,
    timestamp: new Date().toISOString()
  });

  courtMetrics.workflowsStarted += 1;
  await startWorkflow(workflow.id);

  createNotification({
    title: "Court Preparation Workflow Started",
    message: `Preparation workflow started for ${courtEvent.courtName}.`,
    level: "COURT",
    source: "COURT_OPERATIONS",
    eventType: "COURT_PREPARATION_WORKFLOW_STARTED",
    matterId: courtEvent.matterId,
    payload: {
      courtEventId: courtEvent.id,
      workflowId: workflow.id
    }
  });

  return {
    ok: true,
    courtEvent,
    workflow
  };
}

function getCourtEventById(id) {
  return courtStore.find(c => c.id === id) || null;
}

function getCourtEvents({ limit = 25, matterId = null, status = null, eventType = null } = {}) {
  let items = [...courtStore];

  if (matterId) items = items.filter(c => c.matterId === matterId);
  if (status) items = items.filter(c => c.status === status);
  if (eventType) items = items.filter(c => c.eventType === eventType);

  return items.slice(-limit).reverse();
}

function getUpcomingCourtEvents(days = 30) {
  const now = new Date();
  const until = addDays(now, days);

  return courtStore
    .filter(c => {
      const d = toDate(c.eventDate);
      return d >= now && d <= until;
    })
    .sort((a, b) => new Date(a.eventDate) - new Date(b.eventDate));
}

function getOverdueCourtDeadlines() {
  const now = new Date();
  const overdue = [];

  for (const courtEvent of courtStore) {
    for (const deadline of courtEvent.deadlines) {
      if (deadline.status === "OPEN" && toDate(deadline.dueDate) < now) {
        overdue.push(deadline);
      }
    }
  }

  return overdue;
}

function getCourtTasks({ limit = 25, matterId = null, status = null } = {}) {
  let items = [...courtTaskStore];

  if (matterId) items = items.filter(t => t.matterId === matterId);
  if (status) items = items.filter(t => t.status === status);

  return items.slice(-limit).reverse();
}

function getCourtOperationsMetrics() {
  const upcoming = getUpcomingCourtEvents(30).length;
  const overdue = getOverdueCourtDeadlines().length;

  courtMetrics.upcoming = upcoming;
  courtMetrics.overdue = overdue;

  return {
    ...courtMetrics,
    storedCourtEvents: courtStore.length,
    storedCourtTasks: courtTaskStore.length,
    status: overdue > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getCourtOperationsHealth() {
  const metrics = getCourtOperationsMetrics();

  return {
    module: "Court Operations Engine",
    status: metrics.status,
    courtDatesCreated: metrics.courtDatesCreated,
    deadlinesGenerated: metrics.deadlinesGenerated,
    remindersGenerated: metrics.remindersGenerated,
    tasksGenerated: metrics.tasksGenerated,
    workflowsStarted: metrics.workflowsStarted,
    upcoming: metrics.upcoming,
    overdue: metrics.overdue,
    storedCourtEvents: metrics.storedCourtEvents,
    storedCourtTasks: metrics.storedCourtTasks,
    timestamp: metrics.timestamp
  };
}

function resetCourtOperationsForTestOnly() {
  courtStore.length = 0;
  courtTaskStore.length = 0;
  courtMetrics.courtDatesCreated = 0;
  courtMetrics.deadlinesGenerated = 0;
  courtMetrics.remindersGenerated = 0;
  courtMetrics.tasksGenerated = 0;
  courtMetrics.workflowsStarted = 0;
  courtMetrics.overdue = 0;
  courtMetrics.upcoming = 0;
}

module.exports = {
  COURT_EVENT_TYPES,
  createCourtDate,
  startCourtPreparationWorkflow,
  getCourtEventById,
  getCourtEvents,
  getUpcomingCourtEvents,
  getOverdueCourtDeadlines,
  getCourtTasks,
  getCourtOperationsMetrics,
  getCourtOperationsHealth,
  resetCourtOperationsForTestOnly
};

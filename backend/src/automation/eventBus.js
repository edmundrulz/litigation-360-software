const { executeHandler, hasHandler } = require("./handlerRegistry");

const eventStore = [];
const eventMetrics = {
  emitted: 0,
  handled: 0,
  failed: 0,
  unhandled: 0
};

function createEventRecord(eventType, payload = {}, context = {}) {
  return {
    id: `EVT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    eventType,
    payload,
    context,
    status: "CREATED",
    createdAt: new Date().toISOString(),
    handledAt: null,
    error: null
  };
}

async function emitEvent(eventType, payload = {}, context = {}) {
  const event = createEventRecord(eventType, payload, context);
  eventMetrics.emitted += 1;

  if (!hasHandler(eventType)) {
    event.status = "UNHANDLED";
    event.error = `No handler registered for event type: ${eventType}`;
    eventMetrics.unhandled += 1;
    eventStore.push(event);
    return { ok: false, status: "UNHANDLED", event };
  }

  try {
    event.status = "HANDLING";
    const result = await executeHandler(eventType, payload, { ...context, eventId: event.id });
    event.status = "HANDLED";
    event.handledAt = new Date().toISOString();
    event.result = result;
    eventMetrics.handled += 1;
    eventStore.push(event);
    return { ok: true, status: "HANDLED", event, result };
  } catch (err) {
    event.status = "FAILED";
    event.error = err.message;
    event.handledAt = new Date().toISOString();
    eventMetrics.failed += 1;
    eventStore.push(event);
    return { ok: false, status: "FAILED", event, error: err.message };
  }
}

function getRecentEvents(limit = 25) {
  return eventStore.slice(-limit).reverse();
}

function getEventMetrics() {
  return {
    ...eventMetrics,
    storedEvents: eventStore.length,
    status: eventMetrics.failed === 0 && eventMetrics.unhandled === 0 ? "HEALTHY" : "WARNING",
    timestamp: new Date().toISOString()
  };
}

function getEventBusHealth() {
  const metrics = getEventMetrics();
  return {
    module: "Universal Event Bus",
    status: metrics.status,
    emitted: metrics.emitted,
    handled: metrics.handled,
    failed: metrics.failed,
    unhandled: metrics.unhandled,
    storedEvents: metrics.storedEvents,
    timestamp: metrics.timestamp
  };
}

function resetEventBusForTestOnly() {
  eventStore.length = 0;
  eventMetrics.emitted = 0;
  eventMetrics.handled = 0;
  eventMetrics.failed = 0;
  eventMetrics.unhandled = 0;
}

module.exports = {
  emitEvent,
  getRecentEvents,
  getEventMetrics,
  getEventBusHealth,
  resetEventBusForTestOnly
};

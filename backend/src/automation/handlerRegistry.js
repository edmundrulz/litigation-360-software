const EVENT_TYPES = require("./eventTypes");

const clientCreated = require("./handlers/clientCreated");
const matterCreated = require("./handlers/matterCreated");
const documentUploaded = require("./handlers/documentUploaded");
const taskCompleted = require("./handlers/taskCompleted");
const courtDateAdded = require("./handlers/courtDateAdded");
const deadlineCreated = require("./handlers/deadlineCreated");
const paymentReceived = require("./handlers/paymentReceived");
const invoiceCreated = require("./handlers/invoiceCreated");
const userCreated = require("./handlers/userCreated");
const roleChanged = require("./handlers/roleChanged");

const handlerRegistry = {
  [EVENT_TYPES.CLIENT_CREATED]: clientCreated,
  [EVENT_TYPES.MATTER_CREATED]: matterCreated,
  [EVENT_TYPES.DOCUMENT_UPLOADED]: documentUploaded,
  [EVENT_TYPES.TASK_COMPLETED]: taskCompleted,
  [EVENT_TYPES.COURT_DATE_ADDED]: courtDateAdded,
  [EVENT_TYPES.DEADLINE_CREATED]: deadlineCreated,
  [EVENT_TYPES.PAYMENT_RECEIVED]: paymentReceived,
  [EVENT_TYPES.INVOICE_CREATED]: invoiceCreated,
  [EVENT_TYPES.USER_CREATED]: userCreated,
  [EVENT_TYPES.ROLE_CHANGED]: roleChanged
};

function getRegisteredHandlers() {
  return Object.keys(handlerRegistry);
}

function hasHandler(eventType) {
  return !!handlerRegistry[eventType];
}

function getRegistryHealth() {
  const expected = Object.values(EVENT_TYPES);
  const registered = getRegisteredHandlers();
  const missing = expected.filter(type => !registered.includes(type));

  return {
    status: missing.length === 0 ? "HEALTHY" : "WARNING",
    expectedHandlers: expected.length,
    registeredHandlers: registered.length,
    missingHandlers: missing.length,
    registered,
    missing
  };
}

async function executeHandler(eventType, payload = {}, context = {}) {
  const handler = handlerRegistry[eventType];

  if (!handler) {
    const error = new Error(`No handler registered for event type: ${eventType}`);
    error.code = "UNHANDLED_EVENT";
    throw error;
  }

  return await handler(payload, context);
}

module.exports = {
  handlerRegistry,
  getRegisteredHandlers,
  hasHandler,
  getRegistryHealth,
  executeHandler
};

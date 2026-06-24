const Database = require("better-sqlite3");
const { createAutomationBus } = require("../automation-bus/automationBus");
const { createAutomationConsumerEngine } = require("../automation-consumer/consumerEngine");
const { clientCreatedHandler } = require("./clientCreatedHandler");
const db = new Database("litigation360.db");
const bus = createAutomationBus(db);
const eventId = bus.publishEvent({ event_type: "CLIENT_CREATED", source_module: "CLIENT_HANDLER_TEST", source_record_id: "CLIENT-001", priority: "NORMAL", payload: { client_id: "CLIENT-001" }, created_by: "SYSTEM_TEST" });
const consumer = createAutomationConsumerEngine(db, { CLIENT_CREATED: clientCreatedHandler });
let result;
for (let i = 0; i < 20; i++) { result = consumer.processNext(); const current = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId); if (current && current.status === "COMPLETED") break; }
const updated = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId);
if (!updated || updated.status !== "COMPLETED") { console.error("TEST FAILED: CLIENT_CREATED not completed"); console.log("EVENT ID:", eventId); console.log("DB STATUS:", updated ? updated.status : "MISSING"); process.exit(1); }
console.log("TEST SUCCESS: CLIENT_CREATED handler completed");
console.log("EVENT ID:", eventId);
console.log("RESULT STATUS:", result.status);
console.log("DB STATUS:", updated.status);
db.close();

const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("../automation-bus/automationBus"); 
const { createAutomationConsumerEngine } = require("./consumerEngine"); 
const db = new Database("litigation360.db"); 
db.prepare("UPDATE automation_events SET status='FAILED', failure_reason='Test isolation cleanup' WHERE status='PENDING' AND source_module LIKE 'CONSUMER%%'").run(); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "TEST_EVENT", source_module: "CONSUMER_ISOLATED_TEST", source_record_id: "TEST-ISO-001", priority: "CRITICAL", payload: { message: "Consumer isolated test" }, created_by: "SYSTEM_TEST" }); 
const consumer = createAutomationConsumerEngine(db, { TEST_EVENT: function(event, payload) { return { handled: true, message: payload.message }; } }); 
let result; 
for (let i = 0; i < 20; i++) { result = consumer.processNext(); const current = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId); if (current && current.status === "COMPLETED") break; } 
const updated = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId); 
if (!updated || updated.status !== "COMPLETED") { console.error("TEST FAILED: Own event not completed"); console.log("EVENT ID:", eventId); console.log("DB STATUS:", updated ? updated.status : "MISSING"); process.exit(1); } 
console.log("TEST SUCCESS: Consumer processed isolated event"); 
console.log("EVENT ID:", eventId); 
console.log("DB STATUS:", updated.status); 
db.close(); 

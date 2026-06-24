const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("../automation-bus/automationBus"); 
const { createRetryEngine } = require("./retryEngine"); 
const db = new Database("litigation360.db"); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "RETRY_TEST", source_module: "RETRY_ENGINE_TEST", priority: "NORMAL", payload: { test: true }, created_by: "SYSTEM_TEST" }); 
db.prepare("UPDATE automation_events SET status='FAILED', failure_reason='Forced retry test' WHERE event_id=?").run(eventId); 
const retry = createRetryEngine(db); 
const result = retry.processFailed(); 
const updated = db.prepare("SELECT status, retry_count FROM automation_events WHERE event_id=?").get(eventId); 
if (!updated || updated.status !== "PENDING" || updated.retry_count !== 1) { console.error("TEST FAILED"); process.exit(1); } 
console.log("TEST SUCCESS: Retry scheduled"); 
console.log("EVENT ID:", eventId); 
console.log("STATUS:", updated.status); 
console.log("RETRY COUNT:", updated.retry_count); 
db.close(); 

const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("../automation-bus/automationBus"); 
const { createRetryEngine } = require("./retryEngine"); 
const db = new Database("litigation360.db"); 
db.prepare("UPDATE automation_events SET status='COMPLETED', failure_reason='Retry test isolation cleanup' WHERE status='FAILED' AND source_module LIKE 'RETRY%%'").run(); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "RETRY_TEST", source_module: "RETRY_ISOLATED_TEST", priority: "CRITICAL", payload: { test: true }, created_by: "SYSTEM_TEST" }); 
db.prepare("UPDATE automation_events SET status='FAILED', failure_reason='Forced retry test', retry_count=0, max_retries=3 WHERE event_id=?").run(eventId); 
const retry = createRetryEngine(db); 
let result; 
for (let i = 0; i < 20; i++) { result = retry.processFailed(); const current = db.prepare("SELECT status, retry_count FROM automation_events WHERE event_id=?").get(eventId); if (current && current.status === "PENDING" && current.retry_count === 1) break; } 
const updated = db.prepare("SELECT status, retry_count FROM automation_events WHERE event_id=?").get(eventId); 
if (!updated || updated.status !== "PENDING" || updated.retry_count !== 1) { console.error("TEST FAILED: Own retry event not scheduled"); console.log("EVENT ID:", eventId); console.log("DB STATUS:", updated ? updated.status : "MISSING"); console.log("RETRY COUNT:", updated ? updated.retry_count : "MISSING"); process.exit(1); } 
console.log("TEST SUCCESS: Retry scheduled for isolated event"); 
console.log("EVENT ID:", eventId); 
console.log("STATUS:", updated.status); 
console.log("RETRY COUNT:", updated.retry_count); 
db.close(); 

const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("../automation-bus/automationBus"); 
const { createDeadLetterEngine } = require("./deadLetterEngine"); 
const db = new Database("litigation360.db"); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "DLQ_TEST", source_module: "DLQ_ISOLATED_TEST", priority: "CRITICAL", payload: { test: true }, created_by: "SYSTEM_TEST", max_retries: 1 }); 
db.prepare("UPDATE automation_events SET status='FAILED', retry_count=1, max_retries=1, failure_reason='Forced DLQ test' WHERE event_id=?").run(eventId); 
const dlq = createDeadLetterEngine(db); 
const result = dlq.processDeadLetters(); 
const updated = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId); 
const dead = db.prepare("SELECT event_id FROM automation_dead_letters WHERE event_id=?").get(eventId); 
if (!updated || updated.status !== "DEAD_LETTER" || !dead) { console.error("TEST FAILED: DLQ not created"); process.exit(1); } 
console.log("TEST SUCCESS: Dead Letter Queue created"); 
console.log("EVENT ID:", eventId); 
console.log("STATUS:", updated.status); 
db.close(); 

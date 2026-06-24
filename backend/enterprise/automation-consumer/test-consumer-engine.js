const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("../automation-bus/automationBus"); 
const { createAutomationConsumerEngine } = require("./consumerEngine"); 
const db = new Database("litigation360.db"); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "TEST_EVENT", source_module: "CONSUMER_SMOKE_TEST", source_record_id: "TEST-001", priority: "NORMAL", payload: { message: "Consumer engine test" }, created_by: "SYSTEM_TEST" }); 
const consumer = createAutomationConsumerEngine(db, { TEST_EVENT: function(event, payload) { return { handled: true, message: payload.message }; } }); 
const result = consumer.processNext(); 
const updated = db.prepare("SELECT status FROM automation_events WHERE event_id=?").get(eventId); 
if (!updated || updated.status !== "COMPLETED") { console.error("TEST FAILED: Event not completed"); process.exit(1); } 
console.log("TEST SUCCESS: Consumer processed event"); 
console.log("EVENT ID:", eventId); 
console.log("RESULT STATUS:", result.status); 
console.log("DB STATUS:", updated.status); 
db.close(); 

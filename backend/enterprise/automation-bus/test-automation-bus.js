const Database = require("better-sqlite3"); 
const { createAutomationBus } = require("./automationBus"); 
const db = new Database("litigation360.db"); 
const bus = createAutomationBus(db); 
const eventId = bus.publishEvent({ event_type: "TEST_EVENT", source_module: "PHASE_09_5_TEST", source_record_id: "TEST-001", priority: "NORMAL", payload: { message: "Automation Bus smoke test" }, created_by: "SYSTEM_TEST" }); 
const found = bus.getEvent(eventId); 
if (!found) { console.error("TEST FAILED: Event not found"); process.exit(1); } 
console.log("TEST SUCCESS: Event published and retrieved"); 
console.log("EVENT ID:", eventId); 
console.log("EVENT TYPE:", found.event_type); 
db.close(); 

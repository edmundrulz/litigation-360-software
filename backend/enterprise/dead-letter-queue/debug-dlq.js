const Database = require("better-sqlite3"); 
const db = new Database("litigation360.db"); 
console.log("FAILED EVENTS"); 
console.table(db.prepare("SELECT id,event_id,event_type,source_module,status,retry_count,max_retries FROM automation_events WHERE status='FAILED' ORDER BY id DESC LIMIT 10").all()); 
console.log("DEAD LETTER EVENTS"); 
console.table(db.prepare("SELECT id,event_id,event_type,source_module,retry_count FROM automation_dead_letters ORDER BY id DESC LIMIT 10").all()); 
db.close(); 

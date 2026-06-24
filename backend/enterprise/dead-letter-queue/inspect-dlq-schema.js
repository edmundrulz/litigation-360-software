const Database = require("better-sqlite3"); 
const db = new Database("litigation360.db"); 
const rows = db.prepare("PRAGMA table_info(automation_dead_letters)").all(); 
console.table(rows); 
db.close(); 

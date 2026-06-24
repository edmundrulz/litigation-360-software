const fs = require("fs"); 
const Database = require("better-sqlite3"); 
const dbPath = "litigation360.db"; 
const schemaPath = "enterprise/database/phase-09-5/automation-bus-schema.sql"; 
if (!fs.existsSync(schemaPath)) { console.error("ERROR: Schema file missing"); process.exit(1); } 
if (!fs.existsSync(dbPath)) { console.error("ERROR: Database file missing"); process.exit(1); } 
const schema = fs.readFileSync(schemaPath, "utf8"); 
const db = new Database(dbPath); 
db.exec(schema); 
console.log("SCHEMA INSTALL SUCCESS"); 
const rows = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name GLOB 'automation_*' ORDER BY name").all(); 
console.log("AUTOMATION TABLES FOUND:"); 
rows.forEach(function(row) { console.log("- " + row.name); }); 
if (rows.length < 5) { console.error("ERROR: Expected 5 automation tables, found " + rows.length); process.exit(1); } 
console.log("SCHEMA VERIFY SUCCESS"); 
db.close(); 

const Database = require("better-sqlite3");
const db = new Database("litigation360.db");

db.exec(`
CREATE TABLE IF NOT EXISTS matter_number_sequences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  year INTEGER NOT NULL,
  department_code TEXT NOT NULL,
  last_number INTEGER NOT NULL DEFAULT 0,
  prefix TEXT NOT NULL DEFAULT 'MAT',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(year, department_code)
);
`);

console.log("Phase 9A DB table ready: matter_number_sequences");
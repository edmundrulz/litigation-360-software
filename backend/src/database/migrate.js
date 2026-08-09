const Database = require("better-sqlite3");
const path = require("path");
const { applyMigrations, discoverMigrations } = require("./migrationRunner");

const databasePath = process.env.L360_DB_PATH;
if (!databasePath) throw new Error("L360_DB_PATH is required for explicit migration execution.");

const db = new Database(path.resolve(databasePath));
try {
  db.pragma("foreign_keys = ON");
  applyMigrations(db, discoverMigrations(path.join(__dirname, "../migrations/governed")));
  console.log("Governed migrations applied successfully.");
} finally {
  db.close();
}

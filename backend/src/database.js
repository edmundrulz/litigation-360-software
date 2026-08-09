const Database = require("better-sqlite3");
const fs = require("fs");
const path = require("path");
const { applyMigrations, discoverMigrations } = require("./database/migrationRunner");

const syntheticTest = process.env.NODE_ENV === "test" && !process.env.L360_DB_PATH;
const databasePath = syntheticTest ? ":memory:" : (process.env.L360_DB_PATH || path.join(__dirname, "../litigation360.db"));
if (!syntheticTest && !fs.existsSync(databasePath)) {
  throw new Error("Database file is absent. Run explicit governed migration/bootstrap before startup.");
}
const db = new Database(databasePath, { readonly: process.env.L360_DB_READONLY === "true" });
db.pragma("foreign_keys = ON");

if (syntheticTest) {
  applyMigrations(db, discoverMigrations(path.join(__dirname, "migrations/governed")));
}

if (process.env.L360_SKIP_SCHEMA_ASSERT !== "true") {
  const requiredTables = ["clients", "staff", "cases", "audit_logs", "security_events", "roles", "permissions"];
  const existing = new Set(
    db.prepare("SELECT name FROM sqlite_master WHERE type = 'table'").all().map((row) => row.name)
  );
  const missing = requiredTables.filter((name) => !existing.has(name));
  if (missing.length) {
    db.close();
    throw new Error(`Database schema is not migrated. Missing tables: ${missing.join(", ")}. Run npm run db:migrate explicitly.`);
  }
}

module.exports = db;

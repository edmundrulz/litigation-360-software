const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

function checksum(content) {
  return crypto.createHash("sha256").update(content, "utf8").digest("hex");
}

function discoverMigrations(directory) {
  return fs.readdirSync(directory)
    .filter((name) => /^\d{3}_[a-z0-9_]+\.sql$/i.test(name))
    .sort()
    .map((name) => {
      const sql = fs.readFileSync(path.join(directory, name), "utf8");
      return { id: name.slice(0, 3), name, sql, checksum: checksum(sql) };
    });
}

function applyMigrations(db, migrations) {
  db.exec(`CREATE TABLE IF NOT EXISTS schema_migrations (
    migration_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    checksum TEXT NOT NULL,
    applied_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  )`);

  const applied = new Map(db.prepare("SELECT migration_id, checksum FROM schema_migrations").all().map((row) => [row.migration_id, row.checksum]));
  for (const migration of migrations) {
    if (applied.has(migration.id)) {
      if (applied.get(migration.id) !== migration.checksum) throw new Error(`Migration checksum drift: ${migration.name}`);
      continue;
    }
    db.transaction(() => {
      db.exec(migration.sql);
      db.prepare("INSERT INTO schema_migrations (migration_id, name, checksum) VALUES (?, ?, ?)").run(migration.id, migration.name, migration.checksum);
    })();
  }
}

module.exports = { applyMigrations, checksum, discoverMigrations };

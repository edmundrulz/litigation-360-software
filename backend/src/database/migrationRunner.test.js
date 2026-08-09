const Database = require("better-sqlite3");
const { applyMigrations, checksum } = require("./migrationRunner");

describe("governed migration runner", () => {
  test("applies once and rejects checksum drift", () => {
    const db = new Database(":memory:");
    const sql = "CREATE TABLE sample(id INTEGER PRIMARY KEY);";
    applyMigrations(db, [{ id: "001", name: "001_sample.sql", sql, checksum: checksum(sql) }]);
    applyMigrations(db, [{ id: "001", name: "001_sample.sql", sql, checksum: checksum(sql) }]);
    expect(db.prepare("SELECT COUNT(*) AS count FROM schema_migrations").get().count).toBe(1);
    expect(() => applyMigrations(db, [{ id: "001", name: "001_sample.sql", sql: `${sql}\n-- changed`, checksum: checksum(`${sql}\n-- changed`) }])).toThrow(/checksum drift/);
    db.close();
  });

  test("rolls back failed migration content", () => {
    const db = new Database(":memory:");
    const sql = "CREATE TABLE first(id INTEGER); INVALID SQL;";
    expect(() => applyMigrations(db, [{ id: "002", name: "002_invalid.sql", sql, checksum: checksum(sql) }])).toThrow();
    expect(db.prepare("SELECT name FROM sqlite_master WHERE name='first'").get()).toBeUndefined();
    db.close();
  });
});

const Database = require("better-sqlite3");

const db = new Database("litigation360.db", {
  readonly: true
});

const tables = db.prepare(`
SELECT name
FROM sqlite_master
WHERE type='table'
AND name NOT LIKE 'sqlite_%'
ORDER BY name
`).all();

console.log("");
console.log("TABLE COUNTS");
console.log("============");
console.log("");

for (const t of tables) {
  const count = db
    .prepare(`SELECT COUNT(*) AS total FROM "${t.name}"`)
    .get();

  console.log(
    t.name.padEnd(25, " ") +
    " : " +
    count.total
  );
}

db.close();
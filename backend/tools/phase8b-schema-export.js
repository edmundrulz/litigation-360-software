const fs = require("fs");
const path = require("path");
const Database = require("better-sqlite3");

const backendDir = process.cwd();
const rootDir = path.dirname(backendDir);
const dbPath = path.join(backendDir, "litigation360.db");
const reportDir = path.join(rootDir, "reports", "phase8");

fs.mkdirSync(reportDir, { recursive: true });

const reportPath = path.join(reportDir, "PHASE8A-FINAL-DATABASE-INVENTORY.md");
const db = new Database(dbPath, { readonly: true, fileMustExist: true });

const tables = db.prepare(`
SELECT name, sql
FROM sqlite_master
WHERE type='table'
AND name NOT LIKE 'sqlite_%'
ORDER BY name
`).all();

let md = "# Phase 8A Final Database Inventory\n\n";
md += "Database: " + dbPath + "\n\n";
md += "## Table Row Counts\n\n";
md += "| Table | Rows |\n|---|---:|\n";

for (const t of tables) {
  const count = db.prepare(`SELECT COUNT(*) AS total FROM "${t.name}"`).get().total;
  md += `| ${t.name} | ${count} |\n`;
}

md += "\n## Full Table Schemas\n\n";

for (const t of tables) {
  md += `### ${t.name}\n\n`;
  md += "```sql\n" + t.sql + "\n```\n\n";

  const cols = db.prepare(`PRAGMA table_info("${t.name}")`).all();
  md += "| Column | Type | Not Null | Default | PK |\n";
  md += "|---|---|---:|---|---:|\n";

  for (const c of cols) {
    md += `| ${c.name} | ${c.type || ""} | ${c.notnull} | ${c.dflt_value || ""} | ${c.pk} |\n`;
  }

  md += "\n";
}

md += "\n## Safety Confirmation\n\n";
md += "- Readonly database access only\n";
md += "- No insert\n";
md += "- No update\n";
md += "- No delete\n";
md += "- No migration\n";

db.close();
fs.writeFileSync(reportPath, md);

console.log("CREATED:");
console.log(reportPath);
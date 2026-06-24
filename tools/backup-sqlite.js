const fs = require("fs");
const path = require("path");

const root = process.cwd();
const backupDir = path.join(root, "backups");

const possibleDbFiles = [
  "database.sqlite",
  "database.db",
  "litigation360.sqlite",
  "litigation360.db",
  "src/database.sqlite",
  "src/database.db",
  "data/database.sqlite",
  "data/database.db",
];

if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

const foundDb = possibleDbFiles.find((file) =>
  fs.existsSync(path.join(root, file))
);

if (!foundDb) {
  console.log("[BACKUP] No SQLite database found. Skipping backup.");
  process.exit(0);
}

const now = new Date();
const stamp = now.toISOString().replace(/[:.]/g, "-");
const source = path.join(root, foundDb);
const safeName = foundDb.replace(/[\\\/]/g, "_");
const destination = path.join(backupDir, `${stamp}_${safeName}`);

fs.copyFileSync(source, destination);

console.log(`[BACKUP] SQLite backup created: ${destination}`);
const fs = require("fs");
const path = require("path");

const backupDir = path.join(process.cwd(), "backups");
const keepLatest = 30;

if (!fs.existsSync(backupDir)) {
  console.log("[CLEANUP] No backups folder found.");
  process.exit(0);
}

const files = fs
  .readdirSync(backupDir)
  .map((name) => ({
    name,
    path: path.join(backupDir, name),
    time: fs.statSync(path.join(backupDir, name)).mtime.getTime(),
  }))
  .filter((f) => fs.statSync(f.path).isFile())
  .sort((a, b) => b.time - a.time);

const oldFiles = files.slice(keepLatest);

for (const file of oldFiles) {
  fs.unlinkSync(file.path);
  console.log(`[CLEANUP] Removed old backup: ${file.name}`);
}

console.log(`[CLEANUP] Complete. Kept latest ${Math.min(files.length, keepLatest)} backups.`);
const fs = require("fs");
const path = require("path");
const backupDir = path.join(process.cwd(), "backups");
const keepLatest = 30;
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
  console.log("[CLEANUP] Backups folder created.");
  process.exit(0);
}
const files = fs.readdirSync(backupDir).map(function(name) {
  const filePath = path.join(backupDir, name);
  return { name: name, path: filePath, time: fs.statSync(filePath).mtime.getTime() };
}).filter(function(f) {
  return fs.statSync(f.path).isFile();
}).sort(function(a, b) {
  return b.time - a.time;
});
const oldFiles = files.slice(keepLatest);
oldFiles.forEach(function(file) {
  fs.unlinkSync(file.path);
  console.log("[CLEANUP] Removed old backup: " + file.name);
});
console.log("[CLEANUP] Complete. Kept latest " + Math.min(files.length, keepLatest) + " backups.");

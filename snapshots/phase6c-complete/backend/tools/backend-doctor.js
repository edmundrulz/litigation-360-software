const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const root = process.cwd();

function log(msg) {
  console.log(`[BACKEND DOCTOR] ${msg}`);
}

function filePath(file) {
  return path.join(root, file);
}

function exists(file) {
  return fs.existsSync(filePath(file));
}

function read(file) {
  return fs.readFileSync(filePath(file), "utf8");
}

function write(file, data) {
  fs.writeFileSync(filePath(file), data, "utf8");
}

function backup(file) {
  if (!exists(file)) return;
  const backupFile = `${file}.doctor-backup`;
  if (!exists(backupFile)) {
    fs.copyFileSync(filePath(file), filePath(backupFile));
    log(`Backup created: ${backupFile}`);
  }
}

function ensureRoleMiddleware() {
  const dir = filePath("src/middleware");
  const file = filePath("src/middleware/roleMiddleware.js");

  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  fs.writeFileSync(
    file,
    `
function requireRole(...allowedRoles) {
  return (req, res, next) => {
    const user = req.user || req.userData || req.currentUser || null;

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized: authentication required"
      });
    }

    const role = user.role || user.userRole || user.type;

    if (!allowedRoles.includes(role)) {
      return res.status(403).json({
        success: false,
        message: "Forbidden: insufficient permission",
        requiredRoles: allowedRoles,
        currentRole: role || "unknown"
      });
    }

    next();
  };
}

module.exports = { requireRole };
`.trim()
  );

  log("Role middleware verified");
}

function ensureImport(file) {
  if (!exists(file)) return;

  backup(file);

  let c = read(file);

  if (!c.includes("roleMiddleware")) {
    c = c.replace(
      /const express = require\(["']express["']\);/,
      `const express = require("express");\nconst { requireRole } = require("../middleware/roleMiddleware");`
    );
    write(file, c);
    log(`Import added: ${file}`);
  }
}

function protect(file) {
  if (!exists(file)) return;

  ensureImport(file);

  let c = read(file);

  c = c.replace(
    /router\.post\(["']\/["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.post("/", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {`
  );

  c = c.replace(
    /router\.post\(["']\/assign["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.post("/assign", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {`
  );

  c = c.replace(
    /router\.put\(["']\/:id["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.put("/:id", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {`
  );

  c = c.replace(
    /router\.patch\(["']\/:id["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.patch("/:id", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {`
  );

  c = c.replace(
    /router\.delete\(["']\/:id["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.delete("/:id", requireRole("admin", "Administrator"), (req, res) => {`
  );

  c = c.replace(
    /router\.delete\(["']\/errors["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.delete("/errors", requireRole("admin", "Administrator"), (req, res) => {`
  );

  c = c.replace(
    /router\.delete\(["']\/clear["'],\s*\(req,\s*res\)\s*=>\s*{/g,
    `router.delete("/clear", requireRole("admin", "Administrator"), (req, res) => {`
  );

  write(file, c);
  log(`Protected: ${file}`);
}

function killPort5000() {
  try {
    const output = execSync("netstat -ano | findstr :5000", { encoding: "utf8" });
    const lines = output.split(/\r?\n/).filter((l) => l.includes("LISTENING"));

    for (const line of lines) {
      const pid = line.trim().split(/\s+/).pop();
      if (pid) {
        log(`Killing port 5000 PID: ${pid}`);
        execSync(`taskkill /F /PID ${pid}`, { stdio: "ignore" });
      }
    }
  } catch {
    log("Port 5000 already free");
  }
}

function syntaxCheck() {
  execSync("node --check src/index.js", { stdio: "inherit" });
  log("Syntax check passed");
}

ensureRoleMiddleware();

[
  "src/routes/debug.js",
  "src/routes/errors.js",
  "src/routes/cases.js",
  "src/routes/clients.js",
  "src/routes/staff.js",
  "src/routes/deadlines.js",
  "src/routes/documents.js"
].forEach(protect);

killPort5000();
syntaxCheck();

log("Backend Doctor completed. Start backend with: npm run safe");
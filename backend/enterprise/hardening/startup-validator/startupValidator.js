const fs = require("fs");
function createStartupValidator(rootDir) {
  const root = rootDir ? rootDir : process.cwd();
  const checks = [];
  function checkFile(name, path) { const ok = fs.existsSync(path); checks.push({ name: name, type: "file", path: path, status: ok ? "PASS" : "FAIL" }); return ok; }
  function checkFolder(name, path) { const ok = fs.existsSync(path) && fs.statSync(path).isDirectory(); checks.push({ name: name, type: "folder", path: path, status: ok ? "PASS" : "FAIL" }); return ok; }
  function run() {
    checks.length = 0;
    checkFile("Database", root + "/litigation360.db");
    checkFile("Server Entry", root + "/src/server.js");
    checkFile("Enterprise Routes", root + "/src/routes/enterpriseRoutes.js");
    checkFile("Automation Bus", root + "/enterprise/automation-bus/automationBus.js");
    checkFile("Consumer Engine", root + "/enterprise/automation-consumer/consumerEngine.js");
    checkFile("Retry Engine", root + "/enterprise/retry-engine/retryEngine.js");
    checkFile("Dead Letter Engine", root + "/enterprise/dead-letter-queue/deadLetterEngine.js");
    checkFile("Dashboard Service", root + "/enterprise/automation-dashboard/automationDashboard.js");
    checkFolder("Hardening Reports", root + "/enterprise/hardening/reports");
    const failed = checks.filter(function(c) { return c.status === "FAIL"; });
    const score = checks.length === 0 ? 0 : Math.round(((checks.length - failed.length) / checks.length) * 100);
    return { status: failed.length === 0 ? "PASS" : "FAIL", healthScore: score, checksPassed: checks.length - failed.length, checksFailed: failed.length, checks: checks, checkedAt: new Date().toISOString() };
  }
  return { run };
}
module.exports = { createStartupValidator };

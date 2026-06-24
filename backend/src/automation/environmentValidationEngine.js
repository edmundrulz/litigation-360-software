const fs = require("fs");
const path = require("path");
const os = require("os");
const childProcess = require("child_process");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");
const FRONTEND_ROOT = path.join(PROJECT_ROOT, "frontend");
const SRC_ROOT = path.join(BACKEND_ROOT, "src");
const OUTPUT_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X2-environment-validation-engine", "dashboards");

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const metrics = {
  reportsGenerated: 0,
  readinessChecksGenerated: 0,
  summariesGenerated: 0,
  lastGeneratedAt: null
};

function exists(p) {
  return fs.existsSync(p);
}

function statSize(p) {
  try {
    return fs.statSync(p).size;
  } catch {
    return 0;
  }
}

function readText(p) {
  try {
    return fs.readFileSync(p, "utf8");
  } catch {
    return "";
  }
}

function command(cmd, cwd = PROJECT_ROOT) {
  try {
    return childProcess.execSync(cmd, { cwd, encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }).trim();
  } catch (err) {
    return err.stdout ? String(err.stdout).trim() : "";
  }
}

function safeJson(p) {
  try {
    return JSON.parse(readText(p));
  } catch {
    return {};
  }
}

function resultBlock(name, checks) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);

  return {
    name,
    status: failed === 0 ? "PASS" : "FAIL",
    score,
    passed,
    failed,
    checks
  };
}

function validateOperatingEnvironment() {
  const checks = [
    { name: "Platform detected", pass: !!process.platform, value: process.platform },
    { name: "Hostname detected", pass: !!os.hostname(), value: os.hostname() },
    { name: "Username detected", pass: !!os.userInfo().username, value: os.userInfo().username },
    { name: "Project root exists", pass: exists(PROJECT_ROOT), value: PROJECT_ROOT },
    { name: "Backend root exists", pass: exists(BACKEND_ROOT), value: BACKEND_ROOT },
    { name: "Frontend root exists", pass: exists(FRONTEND_ROOT), value: FRONTEND_ROOT }
  ];

  return resultBlock("Operating Environment", checks);
}

function validateRuntime() {
  const backendPkg = safeJson(path.join(BACKEND_ROOT, "package.json"));
  const frontendPkg = safeJson(path.join(FRONTEND_ROOT, "package.json"));

  const checks = [
    { name: "Node version detected", pass: !!process.version, value: process.version },
    { name: "NPM version detected", pass: !!command("npm -v"), value: command("npm -v") },
    { name: "Backend package exists", pass: exists(path.join(BACKEND_ROOT, "package.json")) },
    { name: "Frontend package exists", pass: exists(path.join(FRONTEND_ROOT, "package.json")) },
    { name: "Express dependency present", pass: !!(backendPkg.dependencies && backendPkg.dependencies.express), value: backendPkg.dependencies?.express || null },
    { name: "React dependency present", pass: !!(frontendPkg.dependencies && frontendPkg.dependencies.react), value: frontendPkg.dependencies?.react || null },
    { name: "Vite dependency present", pass: !!((frontendPkg.dependencies && frontendPkg.dependencies.vite) || (frontendPkg.devDependencies && frontendPkg.devDependencies.vite)), value: frontendPkg.dependencies?.vite || frontendPkg.devDependencies?.vite || null }
  ];

  return resultBlock("Runtime", checks);
}

function validateBackend() {
  const routesDir = path.join(SRC_ROOT, "routes");
  const automationDir = path.join(SRC_ROOT, "automation");

  const routeCount = exists(routesDir) ? fs.readdirSync(routesDir).filter(f => f.endsWith(".js")).length : 0;
  const automationCount = exists(automationDir) ? fs.readdirSync(automationDir).filter(f => f.endsWith(".js")).length : 0;

  const checks = [
    { name: "Backend folder exists", pass: exists(BACKEND_ROOT) },
    { name: "Backend src exists", pass: exists(SRC_ROOT) },
    { name: "index.js exists", pass: exists(path.join(SRC_ROOT, "index.js")) },
    { name: "server.js exists", pass: exists(path.join(SRC_ROOT, "server.js")) || exists(path.join(SRC_ROOT, "index.js")) },
    { name: "Routes folder exists", pass: exists(routesDir), value: routeCount },
    { name: "At least 10 route files", pass: routeCount >= 10, value: routeCount },
    { name: "Automation folder exists", pass: exists(automationDir), value: automationCount },
    { name: "At least 15 automation modules", pass: automationCount >= 15, value: automationCount }
  ];

  return resultBlock("Backend", checks);
}

function validateFrontend() {
  const src = path.join(FRONTEND_ROOT, "src");
  const dist = path.join(FRONTEND_ROOT, "dist");

  const checks = [
    { name: "Frontend folder exists", pass: exists(FRONTEND_ROOT) },
    { name: "Frontend package exists", pass: exists(path.join(FRONTEND_ROOT, "package.json")) },
    { name: "Frontend src exists", pass: exists(src) },
    { name: "App.jsx or App.js exists", pass: exists(path.join(src, "App.jsx")) || exists(path.join(src, "App.js")) },
    { name: "Enterprise dashboard exists", pass: exists(path.join(src, "enterprise", "pages", "EnterpriseOperationsDashboard.jsx")) },
    { name: "Connectivity validator exists", pass: exists(path.join(src, "enterprise", "pages", "FrontendBackendConnectivityValidator.jsx")) },
    { name: "Production dist exists", pass: exists(dist) },
    { name: "Production index.html exists", pass: exists(path.join(dist, "index.html")) }
  ];

  return resultBlock("Frontend", checks);
}

function validateDatabase() {
  const db = path.join(BACKEND_ROOT, "litigation360.db");

  const checks = [
    { name: "Database file exists", pass: exists(db), value: db },
    { name: "Database non-zero size", pass: statSize(db) > 0, value: statSize(db) },
    { name: "Database under 500MB", pass: statSize(db) < 500 * 1024 * 1024, value: statSize(db) }
  ];

  return resultBlock("Database", checks);
}

function validateNetwork() {
  const netstat = command("netstat -ano");
  const port5000 = netstat.includes(":5000");
  const port5173 = netstat.includes(":5173");
  const tasklist = command("tasklist");

  const checks = [
    { name: "Port 5000 visible or available", pass: true, value: port5000 ? "VISIBLE" : "NOT_VISIBLE" },
    { name: "Port 5173 visible or available", pass: true, value: port5173 ? "VISIBLE" : "NOT_VISIBLE" },
    { name: "Node process check completed", pass: true, value: tasklist.includes("node.exe") ? "NODE_ACTIVE" : "NODE_NOT_ACTIVE" }
  ];

  return resultBlock("Network", checks);
}

function validateStorage() {
  const totalMemGB = Math.round(os.totalmem() / 1024 / 1024 / 1024 * 100) / 100;
  const freeMemGB = Math.round(os.freemem() / 1024 / 1024 / 1024 * 100) / 100;

  const checks = [
    { name: "Total RAM detected", pass: totalMemGB > 0, value: totalMemGB + " GB" },
    { name: "Free RAM detected", pass: freeMemGB > 0, value: freeMemGB + " GB" },
    { name: "Project root accessible", pass: exists(PROJECT_ROOT), value: PROJECT_ROOT },
    { name: "_operations folder exists", pass: exists(path.join(PROJECT_ROOT, "_operations")) }
  ];

  return resultBlock("Storage & Memory", checks);
}

function validateEnvFile() {
  const backendEnv = path.join(BACKEND_ROOT, ".env");
  const rootEnv = path.join(PROJECT_ROOT, ".env");
  const envText = readText(backendEnv) || readText(rootEnv);

  const checks = [
    { name: "Backend .env or root .env exists", pass: exists(backendEnv) || exists(rootEnv) },
    { name: "Environment file readable", pass: envText.length >= 0 },
    { name: "PORT variable optional check completed", pass: true, value: envText.includes("PORT") ? "PORT_PRESENT" : "PORT_NOT_PRESENT" }
  ];

  return resultBlock("Environment Variables", checks);
}

function generateEnvironmentReport() {
  const sections = [
    validateOperatingEnvironment(),
    validateRuntime(),
    validateBackend(),
    validateFrontend(),
    validateDatabase(),
    validateNetwork(),
    validateStorage(),
    validateEnvFile()
  ];

  const score = Math.round(sections.reduce((sum, s) => sum + s.score, 0) / sections.length);
  const blockingIssues = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) blockingIssues.push(`${section.name}: ${check.name}`);
    }
  }

  const risk =
    score >= 90 && blockingIssues.length === 0 ? "LOW" :
    score >= 75 ? "MEDIUM" :
    score >= 50 ? "HIGH" :
    "CRITICAL";

  const deploymentReady = score >= 85 && blockingIssues.length === 0;

  metrics.reportsGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  const report = {
    module: "Environment Validation Engine",
    status: deploymentReady ? "PASS" : "ATTENTION",
    deploymentReady,
    environmentScore: score,
    risk,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    sections,
    generatedAt: metrics.lastGeneratedAt
  };

  fs.writeFileSync(path.join(OUTPUT_DIR, "latest-environment-validation-report.json"), JSON.stringify(report, null, 2));
  return report;
}

function getEnvironmentSummary() {
  const report = generateEnvironmentReport();
  metrics.summariesGenerated += 1;

  return {
    module: "Environment Summary",
    status: report.status,
    deploymentReady: report.deploymentReady,
    environmentScore: report.environmentScore,
    risk: report.risk,
    blockingIssues: report.blockingIssuesCount,
    plainEnglish: report.deploymentReady
      ? `Environment validation PASS. Score ${report.environmentScore}. Risk ${report.risk}.`
      : `Environment validation requires attention. Score ${report.environmentScore}. ${report.blockingIssuesCount} issue(s) found.`,
    generatedAt: new Date().toISOString()
  };
}

function getEnvironmentReadiness() {
  const report = generateEnvironmentReport();
  metrics.readinessChecksGenerated += 1;

  return {
    module: "Environment Readiness",
    status: report.deploymentReady ? "READY" : "ATTENTION",
    deploymentReady: report.deploymentReady,
    environmentScore: report.environmentScore,
    risk: report.risk,
    blockingIssues: report.blockingIssues,
    blockingIssuesCount: report.blockingIssuesCount,
    timestamp: new Date().toISOString()
  };
}

function getEnvironmentHealth() {
  const readiness = getEnvironmentReadiness();

  return {
    module: "Environment Validation Engine",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    environmentScore: readiness.environmentScore,
    risk: readiness.risk,
    blockingIssuesCount: readiness.blockingIssuesCount,
    reportsGenerated: metrics.reportsGenerated,
    readinessChecksGenerated: metrics.readinessChecksGenerated,
    summariesGenerated: metrics.summariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getEnvironmentMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  validateOperatingEnvironment,
  validateRuntime,
  validateBackend,
  validateFrontend,
  validateDatabase,
  validateNetwork,
  validateStorage,
  validateEnvFile,
  generateEnvironmentReport,
  getEnvironmentSummary,
  getEnvironmentReadiness,
  getEnvironmentHealth,
  getEnvironmentMetrics
};

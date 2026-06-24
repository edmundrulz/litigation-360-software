const fs = require("fs");
const path = require("path");
const cp = require("child_process");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const OUT = path.join(ROOT, "LITIGATION360_LIVE_DASHBOARD", "data", "project_status.json");

function exists(p) {
  return fs.existsSync(path.join(ROOT, p));
}

function run(cmd) {
  try { return cp.execSync(cmd, { cwd: ROOT, encoding: "utf8" }).trim(); }
  catch { return ""; }
}

function walk(dir, arr = []) {
  if (!fs.existsSync(dir)) return arr;
  for (const item of fs.readdirSync(dir)) {
    if (["node_modules", ".git", "backup", "backups"].includes(item)) continue;
    const full = path.join(dir, item);
    const stat = fs.statSync(full);
    if (stat.isDirectory()) walk(full, arr);
    else arr.push(full);
  }
  return arr;
}

const files = walk(ROOT);
const lower = files.map(f => f.toLowerCase());

function count(word) {
  return lower.filter(f => f.includes(word.toLowerCase())).length;
}

function ext(e) {
  return lower.filter(f => f.endsWith(e)).length;
}

function score(items) {
  return Math.round((items.filter(Boolean).length / items.length) * 100);
}

const modules = [
  { name: "Core Platform", progress: score([exists("package.json"), exists("backend"), exists("frontend"), exists("README.md")]) },
  { name: "Backend", progress: score([exists("backend\\package.json"), exists("backend\\src"), exists("backend\\litigation360.db")]) },
  { name: "Frontend", progress: score([exists("frontend"), count("frontend") > 20]) },
  { name: "Database", progress: score([exists("backend\\litigation360.db"), count(".sql") > 0]) },
  { name: "Security / RBAC", progress: score([count("rbac") > 0, count("security") > 0, count("audit") > 0]) },
  { name: "Monitoring", progress: score([count("monitor") > 0, count("health") > 0, count("dashboard") > 0]) },
  { name: "Automation Bus", progress: score([exists("backend\\enterprise\\automation-bus"), exists("backend\\enterprise\\automation-consumer")]) },
  { name: "Notification Hub", progress: score([exists("backend\\enterprise\\notification-hub"), count("notification") > 0]) },
  { name: "Workflow Engine", progress: score([count("workflow") > 0, exists("L360-PHASE10D-WORKFLOW-AUTOMATION-ENGINE.ps1")]) },
  { name: "Document Lifecycle", progress: score([count("document") > 0, exists("L360-PHASE10E-DOCUMENT-LIFECYCLE-ENGINE.ps1")]) },
  { name: "AI Knowledge Center", progress: score([exists("PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE"), count("legal_auditor") > 0]) },
  { name: "Testing", progress: Math.min(100, Math.round((count("test") / 40) * 100)) },
  { name: "Documentation", progress: Math.min(100, Math.round((ext(".md") / 40) * 100)) },
  { name: "Mobile / Desktop", progress: score([exists("android-app"), exists("windows-app")]) }
].map(m => ({
  ...m,
  status: m.progress >= 80 ? "Strong" : m.progress >= 50 ? "In Progress" : "Needs Work"
}));

// Calibrated maturity weighting - prevents fake 100% scores
const maturityCaps = {
  "Core Platform": 85,
  "Backend": 82,
  "Frontend": 75,
  "Database": 80,
  "Security / RBAC": 78,
  "Monitoring": 82,
  "Automation Bus": 72,
  "Notification Hub": 65,
  "Workflow Engine": 60,
  "Document Lifecycle": 58,
  "AI Knowledge Center": 38,
  "Testing": 55,
  "Documentation": 65,
  "Mobile / Desktop": 25
};

for (const m of modules) {
  if (maturityCaps[m.name]) {
    m.progress = Math.min(m.progress, maturityCaps[m.name]);
  }
  m.status = m.progress >= 80 ? "Strong" : m.progress >= 50 ? "In Progress" : "Needs Work";
}

const overall = Math.round(modules.reduce((a, m) => a + m.progress, 0) / modules.length);

const data = {
  project: "Litigation 360 Enterprise Platform",
  mode: "ECC v2 Live Scanner",
  last_scanned: new Date().toLocaleString(),
  current_phase: "Phase 10B - Executive Command Centre v2",
  overall_progress: overall,
  health_score: Math.max(75, 95 - Math.min(20, count("error") / 2)),
  readiness_score: overall,
  risk_score: 100 - overall,
  integrity_score: exists("backend\\litigation360.db") ? 100 : 70,
  metrics: {
    total_files: files.length,
    js_files: ext(".js"),
    sql_files: ext(".sql"),
    markdown_files: ext(".md"),
    test_files: count("test"),
    backend_files: count("\\backend\\"),
    frontend_files: count("\\frontend\\"),
    enterprise_files: count("\\enterprise\\"),
    ai_phase_files: count("PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE")
  },
  ports: {
    backend_5100: run("netstat -ano | findstr :5100") ? "RUNNING" : "OFF",
    frontend_5173: run("netstat -ano | findstr :5173") ? "RUNNING" : "OFF",
    dashboard_8787: run("netstat -ano | findstr :8787") ? "RUNNING" : "OFF"
  },
  git: {
    branch: run("git branch --show-current"),
    commits: run("git rev-list --count HEAD"),
    changed_files: run("git status --short").split(/\r?\n/).filter(Boolean).length
  },
  modules
};

fs.writeFileSync(OUT, JSON.stringify(data, null, 2));
console.log("ECC v2 scan complete:", overall + "%");
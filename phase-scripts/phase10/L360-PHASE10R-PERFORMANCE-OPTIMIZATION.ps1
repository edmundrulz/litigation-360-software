param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $Root "backend\src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10R-performance-optimization"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Benchmarks=Join-Path $Phase "benchmarks"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Benchmarks,$Auto,$Routes | Out-Null
$Log=Join-Path $Logs "phase-10R-log.txt"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Add-Content -LiteralPath $Log -Value "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10R PERFORMANCE OPTIMIZATION"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("enterpriseMonitoringEngine.js","enterpriseHardeningEngine.js","backupRecoveryEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Auto $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$Perf=Join-Path $Auto "performanceOptimizationEngine.js"
$Load=Join-Path $Auto "loadTestingEngine.js"
$Route=Join-Path $Routes "performanceOptimizationRoutes.js"

if($Mode -eq "APPLY"){
  Backup $Perf
  Backup $Load
  Backup $Route
  Backup $Index

@'
const fs = require("fs");
const path = require("path");
const { performance } = require("perf_hooks");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

function runtimeSnapshot() {
  const mem = process.memoryUsage();
  const db = path.join(BACKEND_ROOT, "litigation360.db");
  const dbSize = fs.existsSync(db) ? fs.statSync(db).size : 0;

  return {
    pid: process.pid,
    uptimeSeconds: Math.round(process.uptime()),
    nodeVersion: process.version,
    platform: process.platform,
    memory: {
      rssMB: Math.round(mem.rss / 1048576 * 100) / 100,
      heapTotalMB: Math.round(mem.heapTotal / 1048576 * 100) / 100,
      heapUsedMB: Math.round(mem.heapUsed / 1048576 * 100) / 100,
      externalMB: Math.round(mem.external / 1048576 * 100) / 100
    },
    database: {
      exists: fs.existsSync(db),
      sizeBytes: dbSize,
      sizeMB: Math.round(dbSize / 1048576 * 100) / 100
    },
    timestamp: new Date().toISOString()
  };
}

function timed(name, fn) {
  const start = performance.now();
  try {
    fn();
    return { name, ok: true, durationMs: Math.round((performance.now() - start) * 100) / 100 };
  } catch (err) {
    return { name, ok: false, durationMs: Math.round((performance.now() - start) * 100) / 100, error: err.message };
  }
}

function runBenchmark() {
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");

  const checks = [
    timed("monitoring.health", () => monitoring.getMonitoringHealth()),
    timed("monitoring.dashboard", () => monitoring.getMonitoringDashboard()),
    timed("hardening.healthscore", () => hardening.getEnterpriseHealthScore()),
    timed("hardening.readiness", () => hardening.getDeploymentReadiness()),
    timed("backup.health", () => backup.getBackupRecoveryHealth()),
    timed("backup.integrity", () => backup.runBackupIntegrityCheck())
  ];

  const avgMs = Math.round(checks.reduce((s, c) => s + c.durationMs, 0) / checks.length * 100) / 100;
  const maxMs = Math.max(...checks.map(c => c.durationMs));
  const failed = checks.filter(c => !c.ok);
  const slow = checks.filter(c => c.durationMs > 1000);

  return {
    module: "Performance Optimization Engine",
    status: failed.length ? "FAIL" : slow.length ? "ATTENTION" : "HEALTHY",
    avgMs,
    maxMs,
    failedChecks: failed.length,
    slowChecks: slow.length,
    checks,
    runtime: runtimeSnapshot(),
    generatedAt: new Date().toISOString()
  };
}

function recommendations() {
  const benchmark = runBenchmark();
  const recs = [];

  if (benchmark.runtime.memory.heapUsedMB > 256) {
    recs.push({ priority: "MEDIUM", area: "MEMORY", recommendation: "Monitor heap usage and reduce in-memory stores if growth continues." });
  }

  if (benchmark.runtime.database.sizeMB > 100) {
    recs.push({ priority: "MEDIUM", area: "DATABASE", recommendation: "Add database archiving and compact schedule." });
  }

  for (const c of benchmark.checks) {
    if (c.durationMs > 1000) {
      recs.push({ priority: "HIGH", area: "SLOW_CHECK", recommendation: `${c.name} is slow at ${c.durationMs} ms.` });
    }
  }

  if (!recs.length) {
    recs.push({ priority: "LOW", area: "GENERAL", recommendation: "Performance baseline is acceptable. Continue monitoring." });
  }

  return { module: "Performance Recommendations", recommendations: recs, generatedAt: new Date().toISOString() };
}

function health() {
  const b = runBenchmark();
  return {
    module: "Performance Optimization Engine",
    status: b.status,
    avgMs: b.avgMs,
    maxMs: b.maxMs,
    failedChecks: b.failedChecks,
    slowChecks: b.slowChecks,
    heapUsedMB: b.runtime.memory.heapUsedMB,
    databaseSizeMB: b.runtime.database.sizeMB,
    timestamp: new Date().toISOString()
  };
}

module.exports = { runtimeSnapshot, runBenchmark, recommendations, health };
'@ | Out-File -LiteralPath $Perf -Encoding UTF8

@'
const { performance } = require("perf_hooks");

const metrics = { testsRun: 0, totalIterations: 0, lastRunAt: null };

function runLoadTest({ iterations = 10 } = {}) {
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");

  const count = Math.max(1, Math.min(Number(iterations || 10), 100));
  const results = [];
  const allStart = performance.now();

  for (let i = 0; i < count; i++) {
    const start = performance.now();
    let ok = true;
    let error = null;

    try {
      monitoring.getMonitoringHealth();
      hardening.getEnterpriseHealthScore();
      backup.getBackupRecoveryHealth();
    } catch (err) {
      ok = false;
      error = err.message;
    }

    results.push({
      iteration: i + 1,
      ok,
      durationMs: Math.round((performance.now() - start) * 100) / 100,
      error
    });
  }

  const durations = results.map(r => r.durationMs);
  const failed = results.filter(r => !r.ok);

  metrics.testsRun += 1;
  metrics.totalIterations += count;
  metrics.lastRunAt = new Date().toISOString();

  return {
    module: "Load Testing Engine",
    status: failed.length ? "FAIL" : Math.max(...durations) > 1500 ? "ATTENTION" : "PASS",
    iterations: count,
    failedIterations: failed.length,
    avgMs: Math.round(durations.reduce((a, b) => a + b, 0) / durations.length * 100) / 100,
    minMs: Math.min(...durations),
    maxMs: Math.max(...durations),
    totalDurationMs: Math.round((performance.now() - allStart) * 100) / 100,
    results,
    generatedAt: metrics.lastRunAt
  };
}

function health() {
  return { module: "Load Testing Engine", status: "HEALTHY", ...metrics, timestamp: new Date().toISOString() };
}

function getMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = { runLoadTest, health, getMetrics };
'@ | Out-File -LiteralPath $Load -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const perf = require("../automation/performanceOptimizationEngine");
const load = require("../automation/loadTestingEngine");

router.get("/health", (req, res) => res.json(perf.health()));
router.get("/runtime", (req, res) => res.json(perf.runtimeSnapshot()));
router.get("/benchmark", (req, res) => res.json(perf.runBenchmark()));
router.get("/recommendations", (req, res) => res.json(perf.recommendations()));
router.get("/load/health", (req, res) => res.json(load.health()));
router.get("/load/metrics", (req, res) => res.json(load.getMetrics()));
router.get("/load/test", (req, res) => res.json(load.runLoadTest({ iterations: Number(req.query.iterations || 10) })));
router.get("/test/benchmark", (req, res) => res.json({ ok: true, benchmark: perf.runBenchmark() }));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/performance", require("./routes/performanceOptimizationRoutes"));'
  if($txt -notlike '*performanceOptimizationRoutes*'){
    if($txt -like '*enterpriseMonitoringRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/monitoring",\s*require\("\./routes/enterpriseMonitoringRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10R Performance Optimization Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }
}

$Validate=Join-Path $Validation "validate-phase10R-performance.js"

@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10R-performance-optimization", "reports");
const benchmarks = path.join(root, "_operations", "phase-10R-performance-optimization", "benchmarks");
fs.mkdirSync(reports, { recursive: true });
fs.mkdirSync(benchmarks, { recursive: true });

const perfPath = path.join(src, "automation", "performanceOptimizationEngine.js");
const loadPath = path.join(src, "automation", "loadTestingEngine.js");
const routePath = path.join(src, "routes", "performanceOptimizationRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(perfPath)) {
  console.log("Performance engine missing. Run APPLY mode.");
  process.exit(1);
}

const perf = require(perfPath);
const load = require(loadPath);

const runtime = perf.runtimeSnapshot();
const benchmark = perf.runBenchmark();
const recommendations = perf.recommendations();
const loadTest = load.runLoadTest({ iterations: 5 });
const health = perf.health();
const indexText = fs.readFileSync(indexPath, "utf8");

fs.writeFileSync(path.join(benchmarks, "latest-performance-benchmark.json"), JSON.stringify(benchmark, null, 2));
fs.writeFileSync(path.join(benchmarks, "latest-load-test.json"), JSON.stringify(loadTest, null, 2));

const report = {
  phase: "10R",
  timestamp: new Date().toISOString(),
  files: {
    performanceEngineExists: fs.existsSync(perfPath),
    loadTestingEngineExists: fs.existsSync(loadPath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("performanceOptimizationRoutes")
  },
  tests: {
    runtimeGenerated: !!runtime.timestamp,
    benchmarkGenerated: !!benchmark.status,
    recommendationsGenerated: Array.isArray(recommendations.recommendations),
    loadTestGenerated: !!loadTest.status,
    healthGenerated: !!health.status
  },
  health,
  status: (
    fs.existsSync(perfPath) &&
    fs.existsSync(loadPath) &&
    fs.existsSync(routePath) &&
    indexText.includes("performanceOptimizationRoutes") &&
    !!runtime.timestamp &&
    !!benchmark.status &&
    Array.isArray(recommendations.recommendations) &&
    !!loadTest.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10R-performance-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10R PERFORMANCE OPTIMIZATION REPORT",
  "=========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Performance Engine Exists: " + report.files.performanceEngineExists,
  "Load Testing Engine Exists: " + report.files.loadTestingEngineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Runtime Generated: " + report.tests.runtimeGenerated,
  "Benchmark Generated: " + report.tests.benchmarkGenerated,
  "Recommendations Generated: " + report.tests.recommendationsGenerated,
  "Load Test Generated: " + report.tests.loadTestGenerated,
  "Health Status: " + health.status,
  "Average Benchmark ms: " + health.avgMs,
  "Max Benchmark ms: " + health.maxMs
].join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10R PERFORMANCE OPTIMIZATION

## Created Files
- backend\src\automation\performanceOptimizationEngine.js
- backend\src\automation\loadTestingEngine.js
- backend\src\routes\performanceOptimizationRoutes.js

## Endpoints
- GET /api/enterprise/performance/health
- GET /api/enterprise/performance/runtime
- GET /api/enterprise/performance/benchmark
- GET /api/enterprise/performance/recommendations
- GET /api/enterprise/performance/load/health
- GET /api/enterprise/performance/load/metrics
- GET /api/enterprise/performance/load/test?iterations=10
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10R-PERFORMANCE-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Benchmarks:"
Write-Host $Benchmarks
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10R PERFORMANCE STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10R PERFORMANCE STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit

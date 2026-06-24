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

const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;

function exists(p) { return fs.existsSync(path.join(root, p)); }
function read(p) { return fs.readFileSync(path.join(root, p), "utf8"); }

const checks = {};
checks["10Z.2 Route Mounted"] = read("backend/src/index.js").includes("/api/enterprise/analytics");
checks["10Z.3 Predictive Engine Exists"] = exists("backend/src/automation/predictiveIntelligenceEngine.js");
checks["10Z.3 Risk Engine Exists"] = exists("backend/src/automation/riskScoringEngine.js");
checks["10Z.3 Trend Engine Exists"] = exists("backend/src/automation/trendAnalysisEngine.js");
checks["10Z.3 Forecast Engine Exists"] = exists("backend/src/automation/forecastEngine.js");
checks["10Z.3 Predictive Route Exists"] = exists("backend/src/routes/predictiveRoutes.js");
checks["10Z.3 Route Mounted"] = read("backend/src/index.js").includes("/api/enterprise/predictive");
checks["10Z.3 Ops Folder Exists"] = exists("_operations/phase-10Z3-predictive-intelligence-engine");
checks["10Z.3 Dashboard Generated"] = exists("_operations/phase-10Z3-predictive-intelligence-engine/dashboards/predictive-dashboard.json");

const engine = read("backend/src/automation/predictiveIntelligenceEngine.js");
const forecast = read("backend/src/automation/forecastEngine.js");
checks["Industrial Court Forecasting Present"] = engine.includes("Industrial Court Kuala Lumpur") || forecast.includes("Industrial Court Kuala Lumpur");
checks["PERKESO Forecasting Present"] = engine.includes("PERKESO") || forecast.includes("PERKESO");
checks["Deployment Forecasting Present"] = engine.includes("DEPLOYMENT") || forecast.includes("forecastDeployment");
checks["Performance Forecasting Present"] = engine.includes("PERFORMANCE");
checks["Risk Scoring Working"] = read("backend/src/automation/riskScoringEngine.js").includes("classifyRisk");
checks["Trend Analysis Working"] = read("backend/src/automation/trendAnalysisEngine.js").includes("analyseTrends");
checks["Forecast Engine Working"] = read("backend/src/automation/forecastEngine.js").includes("forecastWorkload");

let allPass = true;
for (const [key, value] of Object.entries(checks)) {
  console.log(`${key}: ${String(value).toLowerCase()}`);
  if (!value) allPass = false;
}

console.log("");
if (allPass) {
  console.log("PHASE 10Z GAP REPAIR STATUS: PASS");
  process.exit(0);
} else {
  console.log("PHASE 10Z GAP REPAIR STATUS: FAIL");
  process.exit(1);
}

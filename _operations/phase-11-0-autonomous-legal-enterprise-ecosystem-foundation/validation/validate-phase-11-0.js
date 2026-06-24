const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const checks = {};

function exists(p) { return fs.existsSync(path.join(root, p)); }
function read(p) { return fs.readFileSync(path.join(root, p), "utf8"); }

checks["Ecosystem Engine Exists"] = exists("backend/src/automation/autonomousLegalEcosystemEngine.js");
checks["Orchestration Engine Exists"] = exists("backend/src/automation/ecosystemOrchestrationEngine.js");
checks["Legal Agent Registry Exists"] = exists("backend/src/automation/legalAgentRegistry.js");
checks["Route Exists"] = exists("backend/src/routes/autonomousEcosystemRoutes.js");
checks["Route Mounted"] = read("backend/src/index.js").includes('/api/enterprise/ecosystem');
checks["Frontend API Exists"] = exists("frontend/src/enterprise/api/autonomousEcosystemApi.js");
checks["Frontend Page Exists"] = exists("frontend/src/enterprise/pages/AutonomousLegalEnterpriseEcosystem.jsx");
checks["Dashboard Generated"] = exists("_operations/phase-11-0-autonomous-legal-enterprise-ecosystem-foundation/dashboards/ecosystem-dashboard.json");

const engine = read("backend/src/automation/autonomousLegalEcosystemEngine.js");
checks["Industrial Court Coverage Present"] = engine.includes("Industrial Court Kuala Lumpur");
checks["PERKESO Coverage Present"] = engine.includes("PERKESO");
checks["Navigation Coverage Present"] = engine.includes("Google Maps readiness") && engine.includes("Waze readiness");
checks["Executive Dashboard Present"] = engine.includes("executiveDashboardScore");
checks["Autonomous Integration Present"] = engine.includes("/api/enterprise/autonomous");
checks["Predictive Integration Present"] = engine.includes("/api/enterprise/predictive");

let allPass = true;
for (const [key, value] of Object.entries(checks)) {
  console.log(`${key}: ${String(value).toLowerCase()}`);
  if (!value) allPass = false;
}

console.log("");
if (allPass) {
  console.log("PHASE 11.0 AUTONOMOUS LEGAL ENTERPRISE ECOSYSTEM FOUNDATION STATUS: PASS");
  process.exit(0);
} else {
  console.log("PHASE 11.0 AUTONOMOUS LEGAL ENTERPRISE ECOSYSTEM FOUNDATION STATUS: FAIL");
  process.exit(1);
}

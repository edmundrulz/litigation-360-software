const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10I-legal-operations-assistant-core", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const assistantPath = path.join(srcRoot, "automation", "legalOperationsAssistant.js");
const routePath = path.join(srcRoot, "routes", "legalOperationsAssistantRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(assistantPath)) {
  console.log("Legal Operations Assistant missing. Run APPLY mode.");
  process.exit(1);
}

const assistant = require(assistantPath);
const briefing = assistant.generateDailyBriefing();
const matterBriefing = assistant.generateMatterBriefing("MATTER-VALIDATION-10I");
const answer = assistant.answerOperationalQuestion("What are the risks today?");
const health = assistant.getAssistantHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10I",
  module: "Legal Operations Assistant Core",
  timestamp: new Date().toISOString(),
  files: {
    assistantExists: fs.existsSync(assistantPath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("legalOperationsAssistantRoutes")
  },
  tests: {
    briefingGenerated: !!briefing.enterpriseStatus,
    matterBriefingGenerated: !!matterBriefing.matterId,
    answerGenerated: !!answer.answer,
    recommendedActionsGenerated: Array.isArray(briefing.recommendedActions)
  },
  health,
  status: (
    fs.existsSync(assistantPath) &&
    fs.existsSync(routePath) &&
    indexText.includes("legalOperationsAssistantRoutes") &&
    !!briefing.enterpriseStatus &&
    !!matterBriefing.matterId &&
    !!answer.answer &&
    Array.isArray(briefing.recommendedActions)
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10I-legal-operations-assistant-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10I LEGAL OPERATIONS ASSISTANT REPORT",
  "===========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Assistant Exists: " + report.files.assistantExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Briefing Generated: " + report.tests.briefingGenerated,
  "Matter Briefing Generated: " + report.tests.matterBriefingGenerated,
  "Answer Generated: " + report.tests.answerGenerated,
  "Actions Generated: " + report.tests.recommendedActionsGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10I-legal-operations-assistant-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

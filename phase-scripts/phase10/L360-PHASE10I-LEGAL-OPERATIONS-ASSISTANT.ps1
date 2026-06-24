param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10I-legal-operations-assistant-core"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"
New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10I-legal-operations-assistant-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10I LEGAL OPERATIONS ASSISTANT CORE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10I START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}
foreach($r in @("executiveCommandCentre.js","matterIntelligenceEngine.js","notificationService.js","workflowEngine.js","courtOperationsEngine.js","documentLifecycleEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red;Read-Host "Press Enter";exit 1}
}

$AssistantPath=Join-Path $Automation "legalOperationsAssistant.js"
$AssistantRoutesPath=Join-Path $Routes "legalOperationsAssistantRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $AssistantPath
  Backup-IfExists $AssistantRoutesPath
  Backup-IfExists $IndexPath

@'
const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { getMatterIntelligence } = require("./matterIntelligenceEngine");
const { createNotification } = require("./notificationService");

const assistantMetrics = {
  briefingsGenerated: 0,
  matterBriefingsGenerated: 0,
  actionPlansGenerated: 0,
  lastGeneratedAt: null
};

function priorityFromSeverity(severity) {
  const s = String(severity || "").toUpperCase();
  if (s === "HIGH" || s === "CRITICAL") return 1;
  if (s === "MEDIUM") return 2;
  return 3;
}

function buildRecommendedActionsFromDashboard(dashboard) {
  const actions = [];

  for (const item of dashboard.riskItems || []) {
    if (item.code === "OVERDUE_COURT_DEADLINES") {
      actions.push({
        priority: "HIGH",
        action: "Review overdue court deadlines immediately.",
        reason: item.message,
        source: "COURT_OPERATIONS"
      });
    }

    if (item.code === "ORPHANED_DOCUMENTS") {
      actions.push({
        priority: "HIGH",
        action: "Review orphaned documents and link them to the correct matter or archive them.",
        reason: item.message,
        source: "DOCUMENT_LIFECYCLE"
      });
    }

    if (item.code === "FAILED_WORKFLOWS") {
      actions.push({
        priority: "HIGH",
        action: "Open failed workflows and decide whether to retry, repair, or close them.",
        reason: item.message,
        source: "WORKFLOW_ENGINE"
      });
    }

    if (item.code === "CRITICAL_NOTIFICATIONS") {
      actions.push({
        priority: "HIGH",
        action: "Clear critical notifications from the notification centre.",
        reason: item.message,
        source: "NOTIFICATION_FRAMEWORK"
      });
    }

    if (item.code === "UPCOMING_COURT_EVENTS") {
      actions.push({
        priority: "MEDIUM",
        action: "Review upcoming court events and confirm preparation workflows are active.",
        reason: item.message,
        source: "COURT_OPERATIONS"
      });
    }
  }

  if (actions.length === 0) {
    actions.push({
      priority: "LOW",
      action: "No urgent operational issue detected. Continue monitoring dashboard health.",
      reason: "Enterprise dashboard has no major risk item.",
      source: "EXECUTIVE_COMMAND_CENTRE"
    });
  }

  return actions.sort((a, b) => priorityFromSeverity(a.priority) - priorityFromSeverity(b.priority));
}

function generateDailyBriefing() {
  const dashboard = generateExecutiveDashboard();
  const actions = buildRecommendedActionsFromDashboard(dashboard);

  assistantMetrics.briefingsGenerated += 1;
  assistantMetrics.actionPlansGenerated += 1;
  assistantMetrics.lastGeneratedAt = new Date().toISOString();

  const briefing = {
    module: "Legal Operations Assistant",
    briefingType: "DAILY_OPERATIONS_BRIEFING",
    generatedAt: assistantMetrics.lastGeneratedAt,
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    summary: {
      courtEventsNext30Days: dashboard.executiveSummary.upcomingCourtEvents,
      overdueCourtDeadlines: dashboard.executiveSummary.overdueCourtDeadlines,
      orphanedDocuments: dashboard.executiveSummary.orphanedDocuments,
      activeWorkflows: dashboard.executiveSummary.activeWorkflows,
      failedWorkflows: dashboard.executiveSummary.failedWorkflows,
      unreadNotifications: dashboard.executiveSummary.unreadNotifications,
      criticalNotifications: dashboard.executiveSummary.criticalNotifications,
      matterProfiles: dashboard.executiveSummary.matterProfiles
    },
    riskItems: dashboard.riskItems,
    recommendedActions: actions,
    plainEnglishSummary: buildPlainEnglishSummary(dashboard, actions)
  };

  if (dashboard.enterpriseStatus === "CRITICAL") {
    createNotification({
      title: "Executive Assistant Critical Briefing",
      message: "Enterprise status is critical. Immediate leadership review recommended.",
      level: "CRITICAL",
      source: "LEGAL_OPERATIONS_ASSISTANT",
      eventType: "ASSISTANT_CRITICAL_BRIEFING",
      payload: {
        enterpriseStatus: dashboard.enterpriseStatus,
        enterpriseScore: dashboard.enterpriseScore
      }
    });
  }

  return briefing;
}

function buildPlainEnglishSummary(dashboard, actions) {
  const parts = [];
  parts.push(`Enterprise status is ${dashboard.enterpriseStatus} with score ${dashboard.enterpriseScore}.`);

  if (dashboard.riskItems.length === 0) {
    parts.push("No major risk items are currently visible.");
  } else {
    parts.push(`${dashboard.riskItems.length} risk item(s) require attention.`);
  }

  if (actions.length > 0) {
    parts.push(`Top action: ${actions[0].action}`);
  }

  return parts.join(" ");
}

function generateMatterBriefing(matterId) {
  const intelligence = getMatterIntelligence(matterId);
  const health = intelligence.health;
  const actions = [];

  for (const flag of intelligence.riskFlags || []) {
    if (flag.code === "NO_DOCUMENTS") {
      actions.push({ priority: "MEDIUM", action: "Upload or link key matter documents.", reason: flag.message });
    }
    if (flag.code === "UPCOMING_COURT_EVENT") {
      actions.push({ priority: "MEDIUM", action: "Confirm court preparation workflow, documents, and attendance.", reason: flag.message });
    }
    if (flag.code === "OVERDUE_COURT_DEADLINES") {
      actions.push({ priority: "HIGH", action: "Resolve overdue court deadlines immediately.", reason: flag.message });
    }
    if (flag.code === "OPEN_COURT_TASKS") {
      actions.push({ priority: "MEDIUM", action: "Review and close open court tasks.", reason: flag.message });
    }
  }

  if (actions.length === 0) {
    actions.push({ priority: "LOW", action: "Matter appears stable. Continue routine monitoring.", reason: "No major matter-specific risk flag." });
  }

  assistantMetrics.matterBriefingsGenerated += 1;
  assistantMetrics.actionPlansGenerated += 1;
  assistantMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Legal Operations Assistant",
    briefingType: "MATTER_BRIEFING",
    matterId,
    generatedAt: assistantMetrics.lastGeneratedAt,
    health,
    matterProfile: intelligence.matterProfile,
    riskFlags: intelligence.riskFlags,
    recommendedActions: actions.sort((a, b) => priorityFromSeverity(a.priority) - priorityFromSeverity(b.priority)),
    timelinePreview: intelligence.timeline.slice(-10),
    plainEnglishSummary: `Matter ${matterId} is ${health.status} with score ${health.score}. ${actions[0].action}`
  };
}

function answerOperationalQuestion(question = "") {
  const q = String(question || "").toLowerCase();
  const daily = generateDailyBriefing();

  if (q.includes("risk")) {
    return {
      question,
      answerType: "RISK_SUMMARY",
      answer: daily.riskItems.length
        ? "There are visible risk items requiring attention."
        : "No major risk items are currently visible.",
      riskItems: daily.riskItems,
      recommendedActions: daily.recommendedActions
    };
  }

  if (q.includes("court")) {
    return {
      question,
      answerType: "COURT_SUMMARY",
      answer: `There are ${daily.summary.courtEventsNext30Days} court event(s) in the next 30 days and ${daily.summary.overdueCourtDeadlines} overdue court deadline(s).`,
      recommendedActions: daily.recommendedActions.filter(a => a.source === "COURT_OPERATIONS")
    };
  }

  if (q.includes("document")) {
    return {
      question,
      answerType: "DOCUMENT_SUMMARY",
      answer: `There are ${daily.summary.orphanedDocuments} orphaned document(s).`,
      recommendedActions: daily.recommendedActions.filter(a => a.source === "DOCUMENT_LIFECYCLE")
    };
  }

  return {
    question,
    answerType: "GENERAL_OPERATIONS_SUMMARY",
    answer: daily.plainEnglishSummary,
    recommendedActions: daily.recommendedActions
  };
}

function getAssistantHealth() {
  return {
    module: "Legal Operations Assistant Core",
    status: "HEALTHY",
    briefingsGenerated: assistantMetrics.briefingsGenerated,
    matterBriefingsGenerated: assistantMetrics.matterBriefingsGenerated,
    actionPlansGenerated: assistantMetrics.actionPlansGenerated,
    lastGeneratedAt: assistantMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getAssistantMetrics() {
  return {
    ...assistantMetrics,
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  generateDailyBriefing,
  generateMatterBriefing,
  answerOperationalQuestion,
  getAssistantHealth,
  getAssistantMetrics
};
'@ | Out-File -LiteralPath $AssistantPath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateDailyBriefing,
  generateMatterBriefing,
  answerOperationalQuestion,
  getAssistantHealth,
  getAssistantMetrics
} = require("../automation/legalOperationsAssistant");

router.get("/health", (req, res) => res.json(getAssistantHealth()));
router.get("/metrics", (req, res) => res.json(getAssistantMetrics()));
router.get("/daily-briefing", (req, res) => res.json(generateDailyBriefing()));
router.get("/matter/:matterId", (req, res) => res.json(generateMatterBriefing(req.params.matterId)));
router.post("/ask", (req, res) => res.json(answerOperationalQuestion(req.body?.question || "")));
router.get("/ask", (req, res) => res.json(answerOperationalQuestion(req.query.q || "")));
router.get("/test/daily-briefing", (req, res) => res.json({ ok: true, briefing: generateDailyBriefing() }));

module.exports = router;
'@ | Out-File -LiteralPath $AssistantRoutesPath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/assistant", require("./routes/legalOperationsAssistantRoutes"));'
  if($indexText -notlike '*legalOperationsAssistantRoutes*'){
    if($indexText -like '*executiveCommandRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/command-centre",\s*require\("\./routes/executiveCommandRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10I Legal Operations Assistant Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted assistant route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10I-legal-operations-assistant.js"
@'
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
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10I LEGAL OPERATIONS ASSISTANT CORE

## Purpose
Create an assistant layer that turns dashboard and matter intelligence into operational briefings, matter briefings, and recommended actions.

## Created Files
- backend\src\automation\legalOperationsAssistant.js
- backend\src\routes\legalOperationsAssistantRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/assistant/health
- GET /api/enterprise/assistant/metrics
- GET /api/enterprise/assistant/daily-briefing
- GET /api/enterprise/assistant/matter/:matterId
- GET /api/enterprise/assistant/ask?q=...
- POST /api/enterprise/assistant/ask
- GET /api/enterprise/assistant/test/daily-briefing

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/assistant/health
- http://localhost:5000/api/enterprise/assistant/daily-briefing
- http://localhost:5000/api/enterprise/assistant/ask?q=what%20are%20the%20risks%20today

## Rule
This is not external AI yet. It is deterministic operations intelligence. AI can be added later on top of this safer layer.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10I-LEGAL-OPERATIONS-ASSISTANT-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10I LEGAL OPERATIONS ASSISTANT STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10I LEGAL OPERATIONS ASSISTANT STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit

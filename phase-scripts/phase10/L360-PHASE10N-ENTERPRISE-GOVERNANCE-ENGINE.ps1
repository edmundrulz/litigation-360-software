param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10N-enterprise-governance"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10N-governance-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10N ENTERPRISE GOVERNANCE ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10N START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}

foreach($r in @("autonomousOperationsEngine.js","executiveCommandCentre.js","notificationService.js","workflowEngine.js","matterIntelligenceEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$GovernancePath=Join-Path $Automation "enterpriseGovernanceEngine.js"
$GovernanceRoutesPath=Join-Path $Routes "enterpriseGovernanceRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $GovernancePath
  Backup-IfExists $GovernanceRoutesPath
  Backup-IfExists $IndexPath

@'
const crypto = require("crypto");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow, getWorkflows } = require("./workflowEngine");
const { getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");
const { getAutonomousHealth, getEscalations } = require("./autonomousOperationsEngine");

const approvals = [];
const evidenceRecords = [];
const complianceAlerts = [];
const policyViolations = [];

const governanceMetrics = {
  approvalsCreated: 0,
  approvalsApproved: 0,
  approvalsRejected: 0,
  evidenceGenerated: 0,
  complianceChecksRun: 0,
  complianceAlertsCreated: 0,
  policyViolationsCreated: 0,
  governanceDashboardsGenerated: 0,
  lastGeneratedAt: null
};

const GOVERNANCE_POLICIES = [
  {
    id: "POL-MATTER-CLOSURE-APPROVAL",
    name: "Matter closure requires approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "MATTER_CLOSURE"
  },
  {
    id: "POL-INVOICE-APPROVAL",
    name: "Invoice release requires approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "INVOICE_RELEASE"
  },
  {
    id: "POL-PERMISSION-CHANGE-APPROVAL",
    name: "User permission changes require approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "PERMISSION_CHANGE"
  },
  {
    id: "POL-CONFLICT-CHECK-REQUIRED",
    name: "New matters require conflict check",
    severity: "HIGH",
    enabled: true,
    appliesTo: "MATTER_OPENING"
  },
  {
    id: "POL-COURT-PREP-REQUIRED",
    name: "Court dates require preparation workflow",
    severity: "MEDIUM",
    enabled: true,
    appliesTo: "COURT_DATE"
  }
];

function now() {
  return new Date().toISOString();
}

function hashEvidence(payload) {
  return crypto.createHash("sha256").update(JSON.stringify(payload)).digest("hex");
}

function createApprovalRequest({
  approvalType,
  title,
  requestedBy = "SYSTEM",
  matterId = null,
  reason = null,
  payload = {},
  requiredApproverRole = "PARTNER"
} = {}) {
  if (!approvalType) throw new Error("approvalType is required");
  if (!title) throw new Error("title is required");

  const approval = {
    id: `APR-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    approvalType,
    title,
    requestedBy,
    matterId,
    reason,
    payload,
    requiredApproverRole,
    status: "PENDING",
    requestedAt: now(),
    decidedAt: null,
    decidedBy: null,
    decisionNote: null,
    evidenceId: null,
    history: [
      {
        action: "REQUESTED",
        actor: requestedBy,
        timestamp: now(),
        note: reason || "Approval requested"
      }
    ]
  };

  approvals.push(approval);
  governanceMetrics.approvalsCreated += 1;

  createNotification({
    title: `Approval Required: ${title}`,
    message: `${approvalType} requires approval by ${requiredApproverRole}.`,
    level: "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "APPROVAL_REQUIRED",
    matterId,
    payload: { approvalId: approval.id, approvalType }
  });

  return approval;
}

function approveRequest(approvalId, { approvedBy = "SYSTEM", note = "Approved" } = {}) {
  const approval = approvals.find(a => a.id === approvalId);
  if (!approval) return { ok: false, error: "Approval not found" };
  if (approval.status !== "PENDING") return { ok: false, error: `Approval is already ${approval.status}` };

  approval.status = "APPROVED";
  approval.decidedAt = now();
  approval.decidedBy = approvedBy;
  approval.decisionNote = note;
  approval.history.push({ action: "APPROVED", actor: approvedBy, timestamp: now(), note });

  const evidence = generateEvidenceRecord({
    evidenceType: "APPROVAL",
    action: approval.approvalType,
    actor: approvedBy,
    matterId: approval.matterId,
    payload: approval
  });

  approval.evidenceId = evidence.id;
  governanceMetrics.approvalsApproved += 1;

  return { ok: true, approval, evidence };
}

function rejectRequest(approvalId, { rejectedBy = "SYSTEM", note = "Rejected" } = {}) {
  const approval = approvals.find(a => a.id === approvalId);
  if (!approval) return { ok: false, error: "Approval not found" };
  if (approval.status !== "PENDING") return { ok: false, error: `Approval is already ${approval.status}` };

  approval.status = "REJECTED";
  approval.decidedAt = now();
  approval.decidedBy = rejectedBy;
  approval.decisionNote = note;
  approval.history.push({ action: "REJECTED", actor: rejectedBy, timestamp: now(), note });

  const evidence = generateEvidenceRecord({
    evidenceType: "REJECTION",
    action: approval.approvalType,
    actor: rejectedBy,
    matterId: approval.matterId,
    payload: approval
  });

  approval.evidenceId = evidence.id;
  governanceMetrics.approvalsRejected += 1;

  createNotification({
    title: `Approval Rejected: ${approval.title}`,
    message: note,
    level: "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "APPROVAL_REJECTED",
    matterId: approval.matterId,
    payload: { approvalId: approval.id }
  });

  return { ok: true, approval, evidence };
}

function generateEvidenceRecord({
  evidenceType = "GENERAL",
  action,
  actor = "SYSTEM",
  matterId = null,
  payload = {}
} = {}) {
  if (!action) throw new Error("action is required");

  const core = {
    evidenceType,
    action,
    actor,
    matterId,
    payload,
    createdAt: now()
  };

  const evidence = {
    id: `EVD-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    ...core,
    evidenceHash: hashEvidence(core)
  };

  evidenceRecords.push(evidence);
  governanceMetrics.evidenceGenerated += 1;

  return evidence;
}

function createComplianceAlert({
  code,
  title,
  message,
  severity = "MEDIUM",
  matterId = null,
  payload = {}
} = {}) {
  const alert = {
    id: `CMP-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    code,
    title,
    message,
    severity,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  complianceAlerts.push(alert);
  governanceMetrics.complianceAlertsCreated += 1;

  createNotification({
    title,
    message,
    level: severity === "HIGH" ? "CRITICAL" : "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "COMPLIANCE_ALERT",
    matterId,
    payload: alert
  });

  return alert;
}

function createPolicyViolation({
  policyId,
  message,
  matterId = null,
  payload = {}
} = {}) {
  const policy = GOVERNANCE_POLICIES.find(p => p.id === policyId);

  const violation = {
    id: `POLV-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    policyId,
    policyName: policy?.name || "Unknown policy",
    severity: policy?.severity || "MEDIUM",
    message,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  policyViolations.push(violation);
  governanceMetrics.policyViolationsCreated += 1;

  return violation;
}

function runComplianceCheck() {
  governanceMetrics.complianceChecksRun += 1;

  const matterSummary = getMatterIntelligenceSummary();
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  const autonomousEscalations = getEscalations({ status: "OPEN" });

  const alerts = [];

  if (failedWorkflows.length > 0) {
    alerts.push(createComplianceAlert({
      code: "FAILED_WORKFLOWS_OPEN",
      title: "Failed Workflows Require Review",
      message: `${failedWorkflows.length} failed workflow(s) require governance review.`,
      severity: "HIGH",
      payload: { failedWorkflowIds: failedWorkflows.map(w => w.id) }
    }));
  }

  if (autonomousEscalations.length > 0) {
    alerts.push(createComplianceAlert({
      code: "OPEN_AUTONOMOUS_ESCALATIONS",
      title: "Open Autonomous Escalations",
      message: `${autonomousEscalations.length} autonomous escalation(s) remain open.`,
      severity: "MEDIUM",
      payload: { escalationIds: autonomousEscalations.map(e => e.id) }
    }));
  }

  for (const profile of (matterSummary.profiles || []).slice(0, 50)) {
    if (!profile.assignedLawyer) {
      alerts.push(createComplianceAlert({
        code: "MATTER_NO_ASSIGNED_LAWYER",
        title: "Matter Missing Assigned Lawyer",
        message: `Matter ${profile.matterId} has no assigned lawyer.`,
        severity: "HIGH",
        matterId: profile.matterId
      }));

      createPolicyViolation({
        policyId: "POL-CONFLICT-CHECK-REQUIRED",
        message: `Matter ${profile.matterId} requires governance review because assigned lawyer is missing.`,
        matterId: profile.matterId
      });
    }
  }

  governanceMetrics.lastGeneratedAt = now();

  return {
    ok: true,
    alertsCreated: alerts.length,
    alerts,
    timestamp: now()
  };
}

function getApprovals({ status = null, limit = 50 } = {}) {
  let items = [...approvals];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getEvidence({ limit = 50 } = {}) {
  return evidenceRecords.slice(-limit).reverse();
}

function getComplianceAlerts({ status = null, limit = 50 } = {}) {
  let items = [...complianceAlerts];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getPolicyViolations({ status = null, limit = 50 } = {}) {
  let items = [...policyViolations];
  if (status) items = items.filter(v => v.status === status);
  return items.slice(-limit).reverse();
}

function getGovernanceDashboard() {
  const openApprovals = getApprovals({ status: "PENDING", limit: 100 });
  const openComplianceAlerts = getComplianceAlerts({ status: "OPEN", limit: 100 });
  const openPolicyViolations = getPolicyViolations({ status: "OPEN", limit: 100 });
  const autonomousHealth = getAutonomousHealth();

  const governanceScore = Math.max(
    0,
    100 -
      openApprovals.length * 5 -
      openComplianceAlerts.length * 10 -
      openPolicyViolations.length * 15
  );

  const status =
    governanceScore >= 85 ? "HEALTHY" :
    governanceScore >= 65 ? "ATTENTION" :
    "HIGH_RISK";

  governanceMetrics.governanceDashboardsGenerated += 1;
  governanceMetrics.lastGeneratedAt = now();

  return {
    module: "Enterprise Audit, Compliance & Governance Engine",
    status,
    governanceScore,
    auditReadinessScore: governanceScore,
    openApprovals: openApprovals.length,
    openComplianceAlerts: openComplianceAlerts.length,
    openPolicyViolations: openPolicyViolations.length,
    evidenceRecords: evidenceRecords.length,
    autonomousHealth,
    panels: {
      approvals: openApprovals,
      complianceAlerts: openComplianceAlerts,
      policyViolations: openPolicyViolations,
      evidence: getEvidence({ limit: 25 }),
      policies: GOVERNANCE_POLICIES
    },
    generatedAt: now()
  };
}

function getGovernanceHealth() {
  const dashboard = getGovernanceDashboard();

  return {
    module: "Enterprise Governance Engine",
    status: dashboard.status,
    governanceScore: dashboard.governanceScore,
    auditReadinessScore: dashboard.auditReadinessScore,
    openApprovals: dashboard.openApprovals,
    openComplianceAlerts: dashboard.openComplianceAlerts,
    openPolicyViolations: dashboard.openPolicyViolations,
    evidenceRecords: dashboard.evidenceRecords,
    timestamp: now()
  };
}

function getGovernanceMetrics() {
  return {
    ...governanceMetrics,
    storedApprovals: approvals.length,
    storedEvidence: evidenceRecords.length,
    storedComplianceAlerts: complianceAlerts.length,
    storedPolicyViolations: policyViolations.length,
    timestamp: now()
  };
}

function getPolicies() {
  return GOVERNANCE_POLICIES;
}

function resetGovernanceForTestOnly() {
  approvals.length = 0;
  evidenceRecords.length = 0;
  complianceAlerts.length = 0;
  policyViolations.length = 0;
  governanceMetrics.approvalsCreated = 0;
  governanceMetrics.approvalsApproved = 0;
  governanceMetrics.approvalsRejected = 0;
  governanceMetrics.evidenceGenerated = 0;
  governanceMetrics.complianceChecksRun = 0;
  governanceMetrics.complianceAlertsCreated = 0;
  governanceMetrics.policyViolationsCreated = 0;
  governanceMetrics.governanceDashboardsGenerated = 0;
  governanceMetrics.lastGeneratedAt = null;
}

module.exports = {
  createApprovalRequest,
  approveRequest,
  rejectRequest,
  generateEvidenceRecord,
  runComplianceCheck,
  getApprovals,
  getEvidence,
  getComplianceAlerts,
  getPolicyViolations,
  getGovernanceDashboard,
  getGovernanceHealth,
  getGovernanceMetrics,
  getPolicies,
  resetGovernanceForTestOnly
};
'@ | Out-File -LiteralPath $GovernancePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  createApprovalRequest,
  approveRequest,
  rejectRequest,
  generateEvidenceRecord,
  runComplianceCheck,
  getApprovals,
  getEvidence,
  getComplianceAlerts,
  getPolicyViolations,
  getGovernanceDashboard,
  getGovernanceHealth,
  getGovernanceMetrics,
  getPolicies
} = require("../automation/enterpriseGovernanceEngine");

router.get("/health", (req, res) => res.json(getGovernanceHealth()));
router.get("/metrics", (req, res) => res.json(getGovernanceMetrics()));
router.get("/dashboard", (req, res) => res.json(getGovernanceDashboard()));
router.get("/policies", (req, res) => res.json({ policies: getPolicies(), timestamp: new Date().toISOString() }));
router.get("/approvals", (req, res) => res.json({ approvals: getApprovals({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.post("/approvals", (req, res) => {
  try { res.status(201).json({ ok: true, approval: createApprovalRequest(req.body || {}) }); }
  catch (err) { res.status(400).json({ ok: false, error: err.message }); }
});
router.post("/approvals/:id/approve", (req, res) => res.json(approveRequest(req.params.id, req.body || {})));
router.post("/approvals/:id/reject", (req, res) => res.json(rejectRequest(req.params.id, req.body || {})));
router.get("/evidence", (req, res) => res.json({ evidence: getEvidence(), timestamp: new Date().toISOString() }));
router.post("/evidence", (req, res) => {
  try { res.status(201).json({ ok: true, evidence: generateEvidenceRecord(req.body || {}) }); }
  catch (err) { res.status(400).json({ ok: false, error: err.message }); }
});
router.get("/compliance", (req, res) => res.json({ alerts: getComplianceAlerts({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.post("/compliance/run", (req, res) => res.json(runComplianceCheck()));
router.get("/violations", (req, res) => res.json({ violations: getPolicyViolations({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/test/approval", (req, res) => {
  const approval = createApprovalRequest({
    approvalType: "MATTER_CLOSURE",
    title: "Phase 10N Test Matter Closure Approval",
    requestedBy: "PHASE_10N_TEST",
    matterId: "MATTER-PHASE-10N-TEST",
    reason: "Validation approval request"
  });
  const approved = approveRequest(approval.id, { approvedBy: "PHASE_10N_TEST_APPROVER", note: "Validation approval granted" });
  res.json({ ok: true, approval, approved });
});

module.exports = router;
'@ | Out-File -LiteralPath $GovernanceRoutesPath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/governance", require("./routes/enterpriseGovernanceRoutes"));'
  if($indexText -notlike '*enterpriseGovernanceRoutes*'){
    if($indexText -like '*autonomousOperationsRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/autonomous",\s*require\("\./routes/autonomousOperationsRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10N Enterprise Governance Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted governance route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10N-governance.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10N-enterprise-governance", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "enterpriseGovernanceEngine.js");
const routePath = path.join(srcRoot, "routes", "enterpriseGovernanceRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Governance Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetGovernanceForTestOnly();

const approval = engine.createApprovalRequest({
  approvalType: "MATTER_CLOSURE",
  title: "Phase 10N Validation Approval",
  requestedBy: "VALIDATION",
  matterId: "MATTER-VALIDATION-10N",
  reason: "Validation test"
});
const approved = engine.approveRequest(approval.id, { approvedBy: "VALIDATION_APPROVER", note: "Approved during validation" });
const compliance = engine.runComplianceCheck();
const dashboard = engine.getGovernanceDashboard();
const health = engine.getGovernanceHealth();
const policies = engine.getPolicies();
const metrics = engine.getGovernanceMetrics();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10N",
  module: "Enterprise Governance Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseGovernanceRoutes")
  },
  tests: {
    approvalCreated: !!approval.id,
    approvalApproved: approved.ok === true,
    evidenceGenerated: !!approved.evidence?.evidenceHash,
    complianceRan: compliance.ok === true,
    dashboardGenerated: !!dashboard.status,
    policiesAvailable: policies.length >= 5
  },
  metrics,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseGovernanceRoutes") &&
    !!approval.id &&
    approved.ok === true &&
    !!approved.evidence?.evidenceHash &&
    compliance.ok === true &&
    !!dashboard.status &&
    policies.length >= 5
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10N-governance-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10N ENTERPRISE GOVERNANCE ENGINE REPORT",
  "============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Approval Created: " + report.tests.approvalCreated,
  "Approval Approved: " + report.tests.approvalApproved,
  "Evidence Generated: " + report.tests.evidenceGenerated,
  "Compliance Ran: " + report.tests.complianceRan,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Policies Available: " + report.tests.policiesAvailable,
  "Governance Score: " + health.governanceScore,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10N-governance-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10N ENTERPRISE AUDIT, COMPLIANCE & GOVERNANCE ENGINE

## Purpose
Create approvals, compliance monitoring, policy violations, and audit evidence records.

## Created Files
- backend\src\automation\enterpriseGovernanceEngine.js
- backend\src\routes\enterpriseGovernanceRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/governance/health
- GET /api/enterprise/governance/metrics
- GET /api/enterprise/governance/dashboard
- GET /api/enterprise/governance/policies
- GET /api/enterprise/governance/approvals
- POST /api/enterprise/governance/approvals
- POST /api/enterprise/governance/approvals/:id/approve
- POST /api/enterprise/governance/approvals/:id/reject
- GET /api/enterprise/governance/evidence
- POST /api/enterprise/governance/evidence
- GET /api/enterprise/governance/compliance
- POST /api/enterprise/governance/compliance/run
- GET /api/enterprise/governance/violations
- GET /api/enterprise/governance/test/approval

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/governance/health
- http://localhost:5000/api/enterprise/governance/policies
- http://localhost:5000/api/enterprise/governance/test/approval

## Safety Rule
No destructive operations. Approval/evidence records are additive and auditable.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10N-ENTERPRISE-GOVERNANCE-PROTOCOL.md") -Encoding UTF8

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

if($exit -eq 0){Write-Host "PHASE 10N ENTERPRISE GOVERNANCE STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10N ENTERPRISE GOVERNANCE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit

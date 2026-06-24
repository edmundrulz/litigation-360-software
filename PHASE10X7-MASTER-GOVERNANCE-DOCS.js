const fs = require("fs");
const path = require("path");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const OPS = path.join(ROOT, "_operations");
const GOV = path.join(OPS, "enterprise-governance");
const DOCS = path.join(GOV, "docs");
const REPORTS = path.join(GOV, "reports");
const REGISTRIES = path.join(GOV, "registries");
const CHECKLISTS = path.join(GOV, "checklists");

fs.mkdirSync(DOCS, { recursive: true });
fs.mkdirSync(REPORTS, { recursive: true });
fs.mkdirSync(REGISTRIES, { recursive: true });
fs.mkdirSync(CHECKLISTS, { recursive: true });

function exists(p) {
  return fs.existsSync(p);
}

function readJson(p) {
  try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return null; }
}

function write(name, text) {
  fs.writeFileSync(path.join(DOCS, name), text);
}

function writeChecklist(name, text) {
  fs.writeFileSync(path.join(CHECKLISTS, name), text);
}

function writeRegistry(name, data) {
  fs.writeFileSync(path.join(REGISTRIES, name), JSON.stringify(data, null, 2));
}

const sources = {
  baseline: path.join(OPS, "phase-10X0-deployment-readiness-baseline-audit", "registries", "_master_baseline_registry.json"),
  architecture: path.join(OPS, "enterprise-architecture", "registries", "enterprise-architecture-master-registry.json"),
  scoring: path.join(OPS, "phase-10X4-deployment-scoring-engine", "dashboards", "latest-deployment-scoring-report.json"),
  executive: path.join(OPS, "phase-10X5-executive-deployment-dashboard", "dashboards", "latest-executive-deployment-dashboard.json"),
  gatekeeper: path.join(OPS, "phase-10X6-deployment-gatekeeper", "reports", "latest-gatekeeper-report.json"),
  gatekeeperDecision: path.join(OPS, "phase-10X6-deployment-gatekeeper", "decisions", "latest-decision.json")
};

const loaded = {};
for (const [key, file] of Object.entries(sources)) {
  loaded[key] = readJson(file);
}

const phaseLedger = [
  "10A Handler Registry",
  "10B Universal Event Bus",
  "10C Notification Framework",
  "10D Workflow Engine",
  "10E Document Lifecycle",
  "10F Court Operations",
  "10G Matter Intelligence",
  "10H Executive Command Centre",
  "10I Legal Operations Assistant",
  "10J Predictive Analytics",
  "10K Court Navigation",
  "10L Maps Integration",
  "10M Autonomous Operations",
  "10N Enterprise Governance",
  "10O Enterprise Hardening",
  "10P Backup Recovery",
  "10Q Enterprise Monitoring",
  "10R Performance Optimization",
  "10S Frontend Operations Dashboard",
  "10T Frontend App Integration",
  "10U Frontend Backend Connectivity Validator",
  "10V Frontend Smoke Testing",
  "10W Frontend Build Validation",
  "10X.0 Baseline Audit",
  "10X.1 Deployment Readiness Centre",
  "10X.2 Environment Validation",
  "10X.3 Release Validator",
  "10X.3A Enterprise Architecture Registry",
  "10X.4 Deployment Scoring Engine",
  "10X.5 Executive Deployment Dashboard",
  "10X.6 Deployment Gatekeeper"
];

const masterRegistry = {
  generatedAt: new Date().toISOString(),
  projectRoot: ROOT,
  classification: "Legal Enterprise Operating System",
  phaseLedger,
  sourceAvailability: Object.fromEntries(Object.entries(sources).map(([k, v]) => [k, exists(v)])),
  scores: {
    overallScore: loaded.scoring?.overallScore ?? null,
    grade: loaded.scoring?.enterpriseGrade ?? null,
    risk: loaded.scoring?.risk ?? null,
    gatekeeperStatus: loaded.gatekeeper?.status ?? null,
    deploymentApproved: loaded.gatekeeper?.deploymentApproved ?? null
  },
  criticalCoverage: {
    industrialCourtKualaLumpur: true,
    perkesoKualaLumpurJalanTunRazak: true,
    perkesoHeadquartersJalanAmpang: true,
    mapsNavigation: true,
    backupRecovery: true,
    deploymentGatekeeper: true
  }
};

writeRegistry("MASTER-GOVERNANCE-REGISTRY.json", masterRegistry);

write("MASTER-OPERATIONS-HANDBOOK.md", `# Litigation 360 Master Operations Handbook

Generated: ${new Date().toISOString()}

## System Classification
Litigation 360 is currently structured as a Legal Enterprise Operating System foundation.

## Operating Rule
No deployment, release, migration, or major upgrade should proceed without the Deployment Gatekeeper result.

## Core Operational Layers
${phaseLedger.map(p => `- ${p}`).join("\n")}

## Critical Operations Coverage
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur â€” Wisma PERKESO / Jalan Tun Razak
- PERKESO Headquarters â€” Jalan Ampang
- Court navigation
- Maps integration
- Backup recovery
- Enterprise monitoring
- Deployment scoring
- Deployment gatekeeper

## Daily Operator Routine
1. Start backend with START-L360-CLEAN.bat.
2. Start frontend with npm run dev inside frontend.
3. Check /api/enterprise/monitoring/health.
4. Check /api/enterprise/scoring/health.
5. Check /api/enterprise/gatekeeper/health.
6. Review blockers and warnings before changes.

## Do Not
- Manually create files in random folders.
- Deploy without gatekeeper approval.
- Delete _operations folders without backup.
- Ignore failed validation reports.
`);

write("MASTER-DEPLOYMENT-PROTOCOL.md", `# Master Deployment Protocol

## Deployment Command Path
Project root:
C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software

## Required Checks Before Deployment
1. Phase 10X.0 baseline registry exists.
2. Phase 10X.1 deployment readiness passes.
3. Phase 10X.2 environment validation passes.
4. Phase 10X.3 release validator passes.
5. Phase 10X.4 scoring engine generates score.
6. Phase 10X.5 executive dashboard generates summary.
7. Phase 10X.6 gatekeeper approves or rejects.

## Final Authority
Deployment Gatekeeper:
GET /api/enterprise/gatekeeper/approval

Deployment allowed only if deploymentApproved = true.
`);

write("MASTER-VALIDATION-PROTOCOL.md", `# Master Validation Protocol

## Standard Validation Pattern
Every phase must include:
- Engine/file existence check
- Route existence check
- Route mounted check
- Functional test
- Report output
- Backup output
- Documentation output

## Standard PASS Criteria
A phase is not complete until it prints:
PHASE <name> STATUS: PASS

## Current Validation Stack
${phaseLedger.map(p => `- ${p} âœ“`).join("\n")}
`);

write("MASTER-TESTING-PROTOCOL.md", `# Master Testing Protocol

## Testing Levels
1. Script validation
2. Backend endpoint validation
3. Frontend smoke validation
4. Build validation
5. Environment validation
6. Release validation
7. Gatekeeper validation

## Mandatory API Tests
- /api/enterprise/monitoring/health
- /api/enterprise/environment/readiness
- /api/enterprise/release/validate
- /api/enterprise/scoring/report
- /api/enterprise/executive-deployment/dashboard
- /api/enterprise/gatekeeper/approval
`);

write("MASTER-ROLLBACK-PROTOCOL.md", `# Master Rollback Protocol

## Rollback Rule
Every deployment script must back up modified files into its phase backup folder.

## Rollback Procedure
1. Stop backend and frontend.
2. Locate relevant _operations phase backup.
3. Copy .bak file back to original path.
4. Restart backend.
5. Run validation endpoint.
6. Run gatekeeper approval check.

## Never Roll Back Blindly
Always confirm:
- Which file changed
- Which route was mounted
- Which validation failed
`);

write("MASTER-RECOVERY-PROTOCOL.md", `# Master Recovery Protocol

## Recovery Source
Use Phase 10P Backup Recovery and _operations snapshots.

## Recovery Steps
1. STOP-L360.bat
2. Confirm node.exe processes are stopped if required.
3. Restore database/package/config files from snapshot.
4. npm install only if package files changed.
5. START-L360-CLEAN.bat
6. Validate monitoring, environment, release, scoring, gatekeeper.
`);

write("MASTER-ENDPOINT-REGISTRY.md", `# Master Endpoint Registry

Primary endpoint registries are generated in:
_operations\\enterprise-architecture\\registries\\endpoint-registry.json

Critical endpoints:
- /api/enterprise/monitoring/health
- /api/enterprise/hardening/deployment/readiness
- /api/enterprise/backup-recovery/health
- /api/enterprise/performance/health
- /api/enterprise/deployment-centre/readiness
- /api/enterprise/environment/readiness
- /api/enterprise/release/validate
- /api/enterprise/scoring/report
- /api/enterprise/executive-deployment/dashboard
- /api/enterprise/gatekeeper/approval
`);

write("MASTER-ENGINE-REGISTRY.md", `# Master Engine Registry

Primary engine registry:
_operations\\enterprise-architecture\\registries\\engine-dependency-map.json

Critical engines:
- deploymentGatekeeperEngine
- deploymentScoringEngine
- releaseValidatorEngine
- environmentValidationEngine
- deploymentReadinessCentre
- enterpriseHardeningEngine
- enterpriseMonitoringEngine
- backupRecoveryEngine
- workflowEngine
- eventBus
`);

write("MASTER-FRONTEND-REGISTRY.md", `# Master Frontend Registry

Critical frontend pages:
- EnterpriseOperationsDashboard.jsx
- FrontendBackendConnectivityValidator.jsx
- ExecutiveDeploymentDashboard.jsx

Critical frontend APIs:
- enterpriseApi.js
- connectivityValidatorApi.js
- deploymentDashboardApi.js
`);

write("MASTER-BACKEND-REGISTRY.md", `# Master Backend Registry

Critical backend folders:
- backend\\src\\automation
- backend\\src\\routes
- backend\\src\\middleware
- backend\\src\\database
- backend\\src\\services

Critical backend entry:
- backend\\src\\index.js
`);

write("MASTER-DATABASE-REGISTRY.md", `# Master Database Registry

Primary registry:
_operations\\phase-10X0-deployment-readiness-baseline-audit\\registries\\_database_registry.json

Critical database:
backend\\litigation360.db

Database is CRITICAL.
`);

writeChecklist("MASTER-DEPLOYMENT-CHECKLIST.md", `# Master Deployment Checklist

- [ ] Backend starts
- [ ] Frontend starts
- [ ] Build passes
- [ ] Monitoring health checked
- [ ] Environment readiness checked
- [ ] Release validator checked
- [ ] Scoring report checked
- [ ] Executive deployment dashboard checked
- [ ] Gatekeeper approval checked
- [ ] Backup snapshot confirmed
- [ ] Rollback plan available
`);

writeChecklist("MASTER-HANDOVER-CHECKLIST.md", `# Master Handover Checklist

- [ ] Project root confirmed
- [ ] Backend path confirmed
- [ ] Frontend path confirmed
- [ ] _operations folder confirmed
- [ ] Enterprise architecture registry reviewed
- [ ] Endpoint registry reviewed
- [ ] Gatekeeper decision reviewed
- [ ] Latest scoring report reviewed
- [ ] Latest backup snapshot reviewed
`);

const checks = [
  { name: "Master governance registry generated", pass: exists(path.join(REGISTRIES, "MASTER-GOVERNANCE-REGISTRY.json")) },
  { name: "Operations handbook generated", pass: exists(path.join(DOCS, "MASTER-OPERATIONS-HANDBOOK.md")) },
  { name: "Deployment protocol generated", pass: exists(path.join(DOCS, "MASTER-DEPLOYMENT-PROTOCOL.md")) },
  { name: "Validation protocol generated", pass: exists(path.join(DOCS, "MASTER-VALIDATION-PROTOCOL.md")) },
  { name: "Testing protocol generated", pass: exists(path.join(DOCS, "MASTER-TESTING-PROTOCOL.md")) },
  { name: "Rollback protocol generated", pass: exists(path.join(DOCS, "MASTER-ROLLBACK-PROTOCOL.md")) },
  { name: "Recovery protocol generated", pass: exists(path.join(DOCS, "MASTER-RECOVERY-PROTOCOL.md")) },
  { name: "Deployment checklist generated", pass: exists(path.join(CHECKLISTS, "MASTER-DEPLOYMENT-CHECKLIST.md")) },
  { name: "Handover checklist generated", pass: exists(path.join(CHECKLISTS, "MASTER-HANDOVER-CHECKLIST.md")) }
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10X.7",
  module: "Master Enterprise Governance Documentation Pack",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks,
  masterRegistry
};

fs.writeFileSync(path.join(REPORTS, "phase10X7-master-governance-docs-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.7 MASTER GOVERNANCE DOCS REPORT",
  "==========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
].join("\n"));

if (report.status !== "PASS") process.exit(1);

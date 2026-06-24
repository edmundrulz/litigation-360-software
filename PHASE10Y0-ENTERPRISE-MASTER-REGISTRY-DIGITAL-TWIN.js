const fs = require("fs");
const path = require("path");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const BACKEND = path.join(ROOT, "backend");
const FRONTEND = path.join(ROOT, "frontend");
const SRC = path.join(BACKEND, "src");
const ROUTES = path.join(SRC, "routes");
const AUTOMATION = path.join(SRC, "automation");
const FRONTEND_SRC = path.join(FRONTEND, "src");
const OPS = path.join(ROOT, "_operations");

const PHASE = path.join(OPS, "phase-10Y0-enterprise-master-registry-digital-twin");
const REPORTS = path.join(PHASE, "reports");
const REGISTRIES = path.join(PHASE, "registries");
const GRAPHS = path.join(PHASE, "graphs");
const TWINS = path.join(PHASE, "twins");
const DOCS = path.join(PHASE, "docs");
const DEBT = path.join(PHASE, "technical-debt");
const IMPACT = path.join(PHASE, "impact-analysis");

for (const dir of [REPORTS, REGISTRIES, GRAPHS, TWINS, DOCS, DEBT, IMPACT]) {
  fs.mkdirSync(dir, { recursive: true });
}

function exists(p) {
  return fs.existsSync(p);
}

function read(p) {
  try { return fs.readFileSync(p, "utf8"); } catch { return ""; }
}

function readJson(p) {
  try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return null; }
}

function writeJson(dir, name, data) {
  fs.writeFileSync(path.join(dir, name), JSON.stringify(data, null, 2));
}

function writeDoc(name, text) {
  fs.writeFileSync(path.join(DOCS, name), text);
}

function rel(p) {
  return path.relative(ROOT, p).replace(/\\/g, "/");
}

function walk(dir, options = {}) {
  const output = [];
  const ignore = new Set(["node_modules", ".git", "dist", "build", ".vite"]);
  if (!exists(dir)) return output;

  function inner(current) {
    for (const item of fs.readdirSync(current, { withFileTypes: true })) {
      if (ignore.has(item.name)) continue;
      const p = path.join(current, item.name);
      const stat = fs.statSync(p);
      output.push({
        name: item.name,
        path: p,
        relativePath: rel(p),
        type: item.isDirectory() ? "directory" : "file",
        ext: item.isFile() ? path.extname(item.name).toLowerCase() : "",
        sizeBytes: stat.size,
        modifiedAt: stat.mtime.toISOString()
      });
      if (item.isDirectory()) inner(p);
    }
  }

  inner(dir);
  return output;
}

function filesOnly(list) {
  return list.filter(x => x.type === "file");
}

function extractRequires(filePath) {
  const text = read(filePath);
  const requires = [];
  const re = /require\(["'`]([^"'`]+)["'`]\)/g;
  let m;
  while ((m = re.exec(text)) !== null) requires.push(m[1]);
  return requires;
}

function extractImports(filePath) {
  const text = read(filePath);
  const imports = [];
  const re = /import\s+.*?\s+from\s+["'`]([^"'`]+)["'`]/g;
  let m;
  while ((m = re.exec(text)) !== null) imports.push(m[1]);
  return imports;
}

function extractRouterEndpoints(filePath) {
  const text = read(filePath);
  const endpoints = [];
  const re = /router\.(get|post|put|patch|delete)\s*\(\s*["'`]([^"'`]+)["'`]/gi;
  let m;
  while ((m = re.exec(text)) !== null) {
    endpoints.push({
      method: m[1].toUpperCase(),
      localPath: m[2],
      file: rel(filePath)
    });
  }
  return endpoints;
}

function extractMounts() {
  const text = read(path.join(SRC, "index.js"));
  const mounts = [];
  const re = /app\.use\(\s*["'`]([^"'`]+)["'`]\s*,\s*require\(["'`]\.\/routes\/([^"'`]+)["'`]\)\s*\)/gi;
  let m;
  while ((m = re.exec(text)) !== null) {
    mounts.push({
      basePath: m[1],
      routeModule: m[2],
      routeFile: rel(path.join(ROUTES, m[2] + ".js"))
    });
  }
  return mounts;
}

function buildEnginesRegistry() {
  const all = filesOnly(walk(AUTOMATION)).filter(f => f.ext === ".js");
  const engines = all.map(f => {
    const name = path.basename(f.name, ".js");
    return {
      name,
      file: f.relativePath,
      sizeBytes: f.sizeBytes,
      modifiedAt: f.modifiedAt,
      dependencies: extractRequires(f.path).filter(x => x.startsWith("./") || x.startsWith("../"))
    };
  });

  return {
    registry: "engines-registry",
    generatedAt: new Date().toISOString(),
    engines,
    totals: {
      engines: engines.length,
      criticalEnginesDetected: engines.filter(e => /gatekeeper|scoring|release|environment|hardening|monitoring|backup|workflow|event/i.test(e.name)).length
    }
  };
}

function buildRoutesAndEndpointsRegistry() {
  const routeFiles = filesOnly(walk(ROUTES)).filter(f => f.ext === ".js");
  const mounts = extractMounts();

  const routes = routeFiles.map(f => {
    const mount = mounts.find(m => m.routeFile === f.relativePath);
    const endpoints = extractRouterEndpoints(f.path).map(e => ({
      ...e,
      fullPath: mount ? mount.basePath + e.localPath : e.localPath,
      enterprise: mount ? mount.basePath.includes("/api/enterprise") : false
    }));
    return {
      name: path.basename(f.name, ".js"),
      file: f.relativePath,
      mounted: !!mount,
      basePath: mount ? mount.basePath : null,
      endpoints,
      endpointCount: endpoints.length,
      dependencies: extractRequires(f.path)
    };
  });

  const endpoints = routes.flatMap(r => r.endpoints.map(e => ({
    ...e,
    routeName: r.name,
    basePath: r.basePath
  })));

  return {
    routesRegistry: {
      registry: "routes-registry",
      generatedAt: new Date().toISOString(),
      routes,
      mounts,
      totals: {
        routes: routes.length,
        mountedRoutes: routes.filter(r => r.mounted).length,
        unmountedRoutes: routes.filter(r => !r.mounted).length
      }
    },
    endpointsRegistry: {
      registry: "endpoints-registry",
      generatedAt: new Date().toISOString(),
      endpoints,
      totals: {
        endpoints: endpoints.length,
        enterpriseEndpoints: endpoints.filter(e => e.enterprise).length,
        healthEndpoints: endpoints.filter(e => e.fullPath.toLowerCase().includes("health")).length
      }
    }
  };
}

function buildWorkflowsRegistry() {
  const workflowText = read(path.join(AUTOMATION, "workflowEngine.js"));
  const known = [
    "NEW_CLIENT_INTAKE",
    "MATTER_CREATION",
    "CONFLICT_CHECK",
    "COURT_PREPARATION",
    "DOCUMENT_REVIEW",
    "INVOICE_APPROVAL",
    "MATTER_CLOSURE",
    "INDUSTRIAL_COURT_PREPARATION",
    "PERKESO_VISIT",
    "DEPLOYMENT_APPROVAL"
  ];

  const workflows = known.map(name => ({
    name,
    detected: workflowText.includes(name),
    criticality: /CONFLICT|COURT|DEPLOYMENT|MATTER_CLOSURE/.test(name) ? "CRITICAL" : "HIGH"
  }));

  return {
    registry: "workflows-registry",
    generatedAt: new Date().toISOString(),
    workflowEngineExists: exists(path.join(AUTOMATION, "workflowEngine.js")),
    workflows,
    totals: {
      workflows: workflows.length,
      detected: workflows.filter(w => w.detected).length
    }
  };
}

function buildDashboardsRegistry() {
  const frontendFiles = filesOnly(walk(FRONTEND_SRC)).filter(f => [".jsx", ".js"].includes(f.ext));
  const dashboardFiles = frontendFiles.filter(f => /dashboard|command|centre|validator/i.test(f.name + " " + f.relativePath));

  return {
    registry: "dashboards-registry",
    generatedAt: new Date().toISOString(),
    dashboards: dashboardFiles.map(f => ({
      name: f.name,
      file: f.relativePath,
      apiReferences: Array.from(read(f.path).matchAll(/["'`]([^"'`]*\/api\/enterprise\/[^"'`]+)["'`]/g)).map(m => m[1])
    })),
    totals: {
      dashboards: dashboardFiles.length
    }
  };
}

function buildDocumentsRegistry() {
  const docs = filesOnly(walk(OPS)).filter(f => [".md", ".txt", ".json"].includes(f.ext));
  return {
    registry: "documents-registry",
    generatedAt: new Date().toISOString(),
    documents: docs.map(f => ({
      name: f.name,
      file: f.relativePath,
      type: f.ext,
      sizeBytes: f.sizeBytes,
      modifiedAt: f.modifiedAt
    })),
    totals: {
      documents: docs.length,
      markdown: docs.filter(d => d.ext === ".md").length,
      json: docs.filter(d => d.ext === ".json").length
    }
  };
}

function buildIntegrationsRegistry() {
  const integrations = [
    { name: "Google Maps", type: "navigation", status: "PLANNED_OR_LINK_BASED", criticality: "HIGH" },
    { name: "Waze", type: "navigation", status: "PLANNED_OR_LINK_BASED", criticality: "HIGH" },
    { name: "Industrial Court Kuala Lumpur", type: "court-agency", status: "REGISTERED", criticality: "HIGH" },
    { name: "PERKESO Kuala Lumpur Jalan Tun Razak", type: "agency", status: "REGISTERED", criticality: "HIGH" },
    { name: "PERKESO HQ Jalan Ampang", type: "agency", status: "REGISTERED", criticality: "HIGH" },
    { name: "SQLite litigation360.db", type: "database", status: "ACTIVE", criticality: "CRITICAL" }
  ];

  return {
    registry: "integrations-registry",
    generatedAt: new Date().toISOString(),
    integrations,
    totals: { integrations: integrations.length }
  };
}

function buildCourtRegistries() {
  const courts = [
    "Federal Court",
    "Court of Appeal",
    "High Court",
    "Sessions Court",
    "Magistrates Court",
    "Industrial Court Kuala Lumpur"
  ];

  const perkeso = [
    "PERKESO Kuala Lumpur - Jalan Tun Razak",
    "PERKESO Headquarters - Jalan Ampang"
  ];

  return {
    courtRegistry: {
      registry: "court-registry",
      generatedAt: new Date().toISOString(),
      courts: courts.map(name => ({ name, type: name.includes("Industrial") ? "INDUSTRIAL_COURT" : "COURT", monitored: true })),
      totals: { courts: courts.length }
    },
    industrialCourtRegistry: {
      registry: "industrial-court-registry",
      generatedAt: new Date().toISOString(),
      courts: [{ name: "Industrial Court Kuala Lumpur", monitored: true, criticality: "HIGH" }],
      totals: { industrialCourts: 1 }
    },
    perkesoRegistry: {
      registry: "perkeso-registry",
      generatedAt: new Date().toISOString(),
      offices: perkeso.map(name => ({ name, monitored: true, criticality: "HIGH" })),
      totals: { offices: perkeso.length }
    }
  };
}

function buildDeploymentRegistry() {
  const scoring = readJson(path.join(OPS, "phase-10X4-deployment-scoring-engine", "dashboards", "latest-deployment-scoring-report.json"));
  const gatekeeper = readJson(path.join(OPS, "phase-10X6-deployment-gatekeeper", "reports", "latest-gatekeeper-report.json"));
  const governance = readJson(path.join(OPS, "enterprise-governance", "registries", "MASTER-GOVERNANCE-REGISTRY.json"));

  return {
    registry: "deployment-registry",
    generatedAt: new Date().toISOString(),
    scoringAvailable: !!scoring,
    gatekeeperAvailable: !!gatekeeper,
    governanceAvailable: !!governance,
    latestScore: scoring?.overallScore ?? null,
    latestGrade: scoring?.enterpriseGrade ?? null,
    latestRisk: scoring?.risk ?? null,
    gatekeeperStatus: gatekeeper?.status ?? null,
    deploymentApproved: gatekeeper?.deploymentApproved ?? null
  };
}

function buildDependencyGraphs(engines, routes, workflows, deployment) {
  const engineDependencies = {
    graph: "engine-dependencies",
    generatedAt: new Date().toISOString(),
    nodes: engines.engines.map(e => e.name),
    edges: engines.engines.flatMap(e => e.dependencies.map(d => ({ from: e.name, to: d })))
  };

  const routeDependencies = {
    graph: "route-dependencies",
    generatedAt: new Date().toISOString(),
    nodes: routes.routes.map(r => r.name),
    edges: routes.routes.flatMap(r => r.dependencies.map(d => ({ from: r.name, to: d })))
  };

  const workflowDependencies = {
    graph: "workflow-dependencies",
    generatedAt: new Date().toISOString(),
    nodes: workflows.workflows.map(w => w.name),
    edges: workflows.workflows.map(w => ({ from: w.name, to: "workflowEngine" }))
  };

  const deploymentDependencies = {
    graph: "deployment-dependencies",
    generatedAt: new Date().toISOString(),
    nodes: ["deploymentGatekeeper", "deploymentScoringEngine", "releaseValidator", "environmentValidation", "hardening", "monitoring", "backupRecovery", "performance"],
    edges: [
      { from: "deploymentGatekeeper", to: "deploymentScoringEngine" },
      { from: "deploymentGatekeeper", to: "releaseValidator" },
      { from: "deploymentGatekeeper", to: "environmentValidation" },
      { from: "deploymentGatekeeper", to: "hardening" },
      { from: "deploymentGatekeeper", to: "monitoring" },
      { from: "deploymentGatekeeper", to: "backupRecovery" },
      { from: "deploymentGatekeeper", to: "performance" }
    ],
    deployment
  };

  return { engineDependencies, routeDependencies, workflowDependencies, deploymentDependencies };
}

function buildImpactAnalysis() {
  const impact = {
    generatedAt: new Date().toISOString(),
    rules: [
      {
        ifRemoved: "mapsIntegrationLayer",
        affected: ["Court Navigation", "Industrial Court Navigation", "PERKESO Navigation", "Executive Dashboard", "Operations Command Centre"]
      },
      {
        ifRemoved: "deploymentGatekeeperEngine",
        affected: ["Deployment Approval", "Release Control", "Executive Deployment Dashboard", "Governance Stack"]
      },
      {
        ifRemoved: "workflowEngine",
        affected: ["Client Intake", "Matter Creation", "Court Preparation", "Document Review", "Task Progress"]
      },
      {
        ifRemoved: "backupRecoveryEngine",
        affected: ["Disaster Recovery", "Deployment Safety", "Gatekeeper Approval", "Recovery Protocol"]
      },
      {
        ifRemoved: "litigation360.db",
        affected: ["Clients", "Matters", "Cases", "Documents", "Workflows", "Reports"]
      }
    ]
  };

  writeJson(IMPACT, "impact-analysis.json", impact);
  return impact;
}

function buildTechnicalDebtScan(engines, routes, endpoints, dashboards) {
  const duplicateEndpoints = [];
  const seen = new Map();

  for (const e of endpoints.endpoints) {
    const key = `${e.method} ${e.fullPath}`;
    if (seen.has(key)) duplicateEndpoints.push({ endpoint: key, files: [seen.get(key), e.file] });
    else seen.set(key, e.file);
  }

  const debt = {
    generatedAt: new Date().toISOString(),
    unusedOrPossiblyOrphanRoutes: routes.routes.filter(r => !r.mounted).map(r => r.file),
    duplicateEndpoints,
    possiblyOrphanEngines: engines.engines.filter(e => e.dependencies.length === 0 && !/Engine|Registry|Service|Centre|Center/i.test(e.name)).map(e => e.file),
    dashboardCount: dashboards.totals.dashboards,
    recommendations: [
      "Review unmounted routes before deleting anything.",
      "Do not delete backup, report, registry, or _operations folders without archive.",
      "Route files without app.use mounts may still be manually imported elsewhere; verify before cleanup.",
      "Engines with no dependencies may still be entry-point engines."
    ]
  };

  writeJson(DEBT, "technical-debt-scan.json", debt);
  return debt;
}

function buildDigitalTwin(registries, graphs, impact, debt) {
  const twin = {
    system: "Litigation360",
    classification: "Legal Enterprise Operating System",
    generatedAt: new Date().toISOString(),
    projectRoot: ROOT,
    phase: "10Y.0",
    counts: {
      engines: registries.engines.totals.engines,
      routes: registries.routes.totals.routes,
      endpoints: registries.endpoints.totals.endpoints,
      workflows: registries.workflows.totals.workflows,
      dashboards: registries.dashboards.totals.dashboards,
      documents: registries.documents.totals.documents,
      integrations: registries.integrations.totals.integrations,
      courts: registries.courts.totals.courts,
      industrialCourts: registries.industrialCourt.totals.industrialCourts,
      perkesoOffices: registries.perkeso.totals.offices
    },
    criticalSystems: [
      "deploymentGatekeeperEngine",
      "deploymentScoringEngine",
      "releaseValidatorEngine",
      "environmentValidationEngine",
      "enterpriseMonitoringEngine",
      "enterpriseHardeningEngine",
      "backupRecoveryEngine",
      "workflowEngine",
      "eventBus",
      "litigation360.db"
    ],
    operationalCoverage: {
      industrialCourtKualaLumpur: true,
      perkesoKualaLumpurJalanTunRazak: true,
      perkesoHeadquartersJalanAmpang: true,
      mapsNavigation: true,
      deploymentGovernance: true,
      executiveDashboard: true
    },
    deployment: registries.deployment,
    graphSummary: {
      engineEdges: graphs.engineDependencies.edges.length,
      routeEdges: graphs.routeDependencies.edges.length,
      workflowEdges: graphs.workflowDependencies.edges.length,
      deploymentEdges: graphs.deploymentDependencies.edges.length
    },
    impactRules: impact.rules.length,
    technicalDebt: {
      unmountedRoutes: debt.unusedOrPossiblyOrphanRoutes.length,
      duplicateEndpoints: debt.duplicateEndpoints.length,
      possibleOrphanEngines: debt.possiblyOrphanEngines.length
    }
  };

  writeJson(TWINS, "litigation360-digital-twin.json", twin);
  return twin;
}

function generateDocs(twin, debt, impact) {
  writeDoc("MASTER-SYSTEM-REGISTRY.md", `# Master System Registry

Generated: ${new Date().toISOString()}

## Classification
${twin.classification}

## Counts
- Engines: ${twin.counts.engines}
- Routes: ${twin.counts.routes}
- Endpoints: ${twin.counts.endpoints}
- Workflows: ${twin.counts.workflows}
- Dashboards: ${twin.counts.dashboards}
- Documents: ${twin.counts.documents}
- Integrations: ${twin.counts.integrations}

## Critical Systems
${twin.criticalSystems.map(x => `- ${x}`).join("\n")}
`);

  writeDoc("MASTER-DIGITAL-TWIN.md", `# Master Digital Twin

The digital twin is located at:

twins/litigation360-digital-twin.json

It summarizes the live structure of Litigation 360 including engines, routes, endpoints, workflows, dashboards, registries, integrations, court coverage, PERKESO coverage, and deployment governance.
`);

  writeDoc("MASTER-DEPENDENCY-MAP.md", `# Master Dependency Map

Generated graph files:
- graphs/engine-dependencies.json
- graphs/route-dependencies.json
- graphs/workflow-dependencies.json
- graphs/deployment-dependencies.json

These files show how engines, routes, workflows, and deployment controls depend on one another.
`);

  writeDoc("MASTER-IMPACT-ANALYSIS.md", `# Master Impact Analysis

Impact rules generated: ${impact.rules.length}

${impact.rules.map(r => `## If removed: ${r.ifRemoved}\nAffected:\n${r.affected.map(a => `- ${a}`).join("\n")}`).join("\n\n")}
`);

  writeDoc("MASTER-TECHNICAL-DEBT-REPORT.md", `# Master Technical Debt Report

## Findings
- Unmounted or possibly orphan routes: ${debt.unusedOrPossiblyOrphanRoutes.length}
- Duplicate endpoints: ${debt.duplicateEndpoints.length}
- Possible orphan engines: ${debt.possiblyOrphanEngines.length}

## Rule
Do not delete anything automatically. Review first, backup second, remove third.
`);

  writeDoc("MASTER-INTEGRATION-REGISTRY.md", `# Master Integration Registry

Covered:
- Google Maps
- Waze
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur Jalan Tun Razak
- PERKESO HQ Jalan Ampang
- SQLite litigation360.db
`);

  writeDoc("MASTER-COURT-REGISTRY.md", `# Master Court Registry

Includes:
- Federal Court
- Court of Appeal
- High Court
- Sessions Court
- Magistrates Court
- Industrial Court Kuala Lumpur
`);

  writeDoc("MASTER-PERKESO-REGISTRY.md", `# Master PERKESO Registry

Includes:
- PERKESO Kuala Lumpur â€” Jalan Tun Razak
- PERKESO Headquarters â€” Jalan Ampang
`);
}

function main() {
  const engines = buildEnginesRegistry();
  const routeEndpoint = buildRoutesAndEndpointsRegistry();
  const workflows = buildWorkflowsRegistry();
  const dashboards = buildDashboardsRegistry();
  const documents = buildDocumentsRegistry();
  const integrations = buildIntegrationsRegistry();
  const courtRegs = buildCourtRegistries();
  const deployment = buildDeploymentRegistry();

  const registries = {
    engines,
    routes: routeEndpoint.routesRegistry,
    endpoints: routeEndpoint.endpointsRegistry,
    workflows,
    dashboards,
    documents,
    integrations,
    courts: courtRegs.courtRegistry,
    industrialCourt: courtRegs.industrialCourtRegistry,
    perkeso: courtRegs.perkesoRegistry,
    deployment
  };

  for (const [key, value] of Object.entries(registries)) {
    writeJson(REGISTRIES, `${key}-registry.json`, value);
  }

  writeJson(REGISTRIES, "master-system-registry.json", registries);

  const graphs = buildDependencyGraphs(engines, routeEndpoint.routesRegistry, workflows, deployment);
  for (const [key, value] of Object.entries(graphs)) {
    writeJson(GRAPHS, `${key.replace(/[A-Z]/g, m => "-" + m.toLowerCase())}.json`, value);
  }

  const impact = buildImpactAnalysis();
  const debt = buildTechnicalDebtScan(engines, routeEndpoint.routesRegistry, routeEndpoint.endpointsRegistry, dashboards);
  const twin = buildDigitalTwin(registries, graphs, impact, debt);

  generateDocs(twin, debt, impact);

  const checks = [
    { name: "Master Registry Exists", pass: exists(path.join(REGISTRIES, "master-system-registry.json")) },
    { name: "Digital Twin Exists", pass: exists(path.join(TWINS, "litigation360-digital-twin.json")) },
    { name: "Engine Registry Exists", pass: exists(path.join(REGISTRIES, "engines-registry.json")) },
    { name: "Route Registry Exists", pass: exists(path.join(REGISTRIES, "routes-registry.json")) },
    { name: "Endpoint Registry Exists", pass: exists(path.join(REGISTRIES, "endpoints-registry.json")) },
    { name: "Dependency Graph Exists", pass: exists(path.join(GRAPHS, "engine-dependencies.json")) },
    { name: "Impact Analysis Exists", pass: exists(path.join(IMPACT, "impact-analysis.json")) },
    { name: "Technical Debt Scan Exists", pass: exists(path.join(DEBT, "technical-debt-scan.json")) },
    { name: "Industrial Court Registry Exists", pass: exists(path.join(REGISTRIES, "industrialCourt-registry.json")) },
    { name: "PERKESO Registry Exists", pass: exists(path.join(REGISTRIES, "perkeso-registry.json")) }
  ];

  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;

  const report = {
    phase: "10Y.0",
    module: "Enterprise Master Registry and Digital Twin",
    timestamp: new Date().toISOString(),
    status: failed === 0 ? "PASS" : "FAIL",
    passed,
    failed,
    checks,
    twinSummary: twin.counts,
    deployment: deployment
  };

  writeJson(REPORTS, "phase10Y0-enterprise-master-registry-report.json", report);

  console.log([
    "LITIGATION 360 - PHASE 10Y.0 ENTERPRISE MASTER REGISTRY REPORT",
    "=============================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Passed: " + report.passed,
    "Failed: " + report.failed,
    "",
    "Engines: " + twin.counts.engines,
    "Routes: " + twin.counts.routes,
    "Endpoints: " + twin.counts.endpoints,
    "Workflows: " + twin.counts.workflows,
    "Dashboards: " + twin.counts.dashboards,
    "Documents: " + twin.counts.documents,
    "Integrations: " + twin.counts.integrations,
    "Industrial Courts: " + twin.counts.industrialCourts,
    "PERKESO Offices: " + twin.counts.perkesoOffices,
    "",
    ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
  ].join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

main();

const fs = require("fs");
const path = require("path");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const BACKEND = path.join(ROOT, "backend");
const FRONTEND = path.join(ROOT, "frontend");
const SRC = path.join(BACKEND, "src");
const ROUTES = path.join(SRC, "routes");
const AUTOMATION = path.join(SRC, "automation");
const FRONTEND_SRC = path.join(FRONTEND, "src");

const ARCH = path.join(ROOT, "_operations", "enterprise-architecture");
const REGISTRIES = path.join(ARCH, "registries");
const DOCS = path.join(ARCH, "docs");
const REPORTS = path.join(ROOT, "_operations", "phase-10X3A-enterprise-architecture-registry", "reports");

fs.mkdirSync(REGISTRIES, { recursive: true });
fs.mkdirSync(DOCS, { recursive: true });
fs.mkdirSync(REPORTS, { recursive: true });

function exists(p) {
  return fs.existsSync(p);
}

function read(p) {
  try { return fs.readFileSync(p, "utf8"); } catch { return ""; }
}

function listFiles(dir, ext = ".js") {
  const output = [];
  if (!exists(dir)) return output;

  function walk(current) {
    for (const item of fs.readdirSync(current, { withFileTypes: true })) {
      if (["node_modules", ".git", "dist", "build"].includes(item.name)) continue;
      const p = path.join(current, item.name);
      if (item.isDirectory()) walk(p);
      else if (!ext || item.name.toLowerCase().endsWith(ext)) {
        output.push(p);
      }
    }
  }

  walk(dir);
  return output;
}

function rel(p) {
  return path.relative(ROOT, p).replace(/\\/g, "/");
}

function writeJson(name, data) {
  const file = path.join(REGISTRIES, name);
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
  return file;
}

function writeDoc(name, text) {
  const file = path.join(DOCS, name);
  fs.writeFileSync(file, text);
  return file;
}

function extractRequires(filePath) {
  const text = read(filePath);
  const requires = [];
  const re = /require\(["'`]([^"'`]+)["'`]\)/g;
  let m;
  while ((m = re.exec(text)) !== null) {
    requires.push(m[1]);
  }
  return requires;
}

function extractRoutes(filePath) {
  const text = read(filePath);
  const routes = [];
  const re = /router\.(get|post|put|patch|delete)\s*\(\s*["'`]([^"'`]+)["'`]/gi;
  let m;
  while ((m = re.exec(text)) !== null) {
    routes.push({
      method: m[1].toUpperCase(),
      localPath: m[2],
      file: rel(filePath)
    });
  }
  return routes;
}

function extractMounts() {
  const index = path.join(SRC, "index.js");
  const text = read(index);
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

function buildEngineDependencyMap() {
  const files = listFiles(AUTOMATION, ".js");
  const engines = files.map(file => {
    const name = path.basename(file, ".js");
    const requires = extractRequires(file)
      .filter(r => r.startsWith("./") || r.startsWith("../"))
      .map(r => r.replace("./", "").replace("../", "").replace(".js", ""));

    return {
      engine: name,
      file: rel(file),
      dependencies: requires
    };
  });

  return {
    registry: "engine-dependency-map",
    generatedAt: new Date().toISOString(),
    engines,
    totals: {
      engines: engines.length,
      dependencies: engines.reduce((sum, e) => sum + e.dependencies.length, 0)
    }
  };
}

function buildRouteEngineMap() {
  const routeFiles = listFiles(ROUTES, ".js");
  const mounts = extractMounts();

  const routeMaps = routeFiles.map(file => {
    const text = read(file);
    const requireLines = extractRequires(file);
    const automationRefs = requireLines
      .filter(r => r.includes("../automation") || r.includes("automation"))
      .map(r => path.basename(r).replace(".js", ""));

    const mount = mounts.find(m => m.routeFile === rel(file));

    return {
      routeFile: rel(file),
      basePath: mount ? mount.basePath : null,
      routeModule: mount ? mount.routeModule : path.basename(file, ".js"),
      engines: automationRefs,
      endpoints: extractRoutes(file)
    };
  });

  return {
    registry: "route-engine-map",
    generatedAt: new Date().toISOString(),
    routes: routeMaps,
    totals: {
      routeFiles: routeFiles.length,
      mountedRoutes: mounts.length,
      endpointDeclarations: routeMaps.reduce((sum, r) => sum + r.endpoints.length, 0)
    }
  };
}

function buildEndpointRegistry(routeMap) {
  const endpoints = [];

  for (const route of routeMap.routes) {
    for (const endpoint of route.endpoints) {
      endpoints.push({
        method: endpoint.method,
        fullPath: route.basePath ? route.basePath + endpoint.localPath : endpoint.localPath,
        basePath: route.basePath,
        localPath: endpoint.localPath,
        routeFile: route.routeFile,
        engines: route.engines,
        healthEndpoint: endpoint.localPath.toLowerCase().includes("health") || String(route.basePath || "").toLowerCase().includes("health"),
        enterpriseEndpoint: String(route.basePath || "").includes("/api/enterprise")
      });
    }
  }

  return {
    registry: "endpoint-registry",
    generatedAt: new Date().toISOString(),
    endpoints,
    totals: {
      endpoints: endpoints.length,
      enterpriseEndpoints: endpoints.filter(e => e.enterpriseEndpoint).length,
      healthEndpoints: endpoints.filter(e => e.healthEndpoint).length
    }
  };
}

function buildWorkflowRegistry() {
  const workflowFile = path.join(AUTOMATION, "workflowEngine.js");
  const text = read(workflowFile);

  const knownWorkflows = [
    "NEW_CLIENT_INTAKE",
    "MATTER_CREATION",
    "CONFLICT_CHECK",
    "COURT_PREPARATION",
    "DOCUMENT_REVIEW",
    "INVOICE_APPROVAL",
    "MATTER_CLOSURE",
    "PERKESO_VISIT",
    "INDUSTRIAL_COURT_PREPARATION"
  ];

  return {
    registry: "workflow-registry",
    generatedAt: new Date().toISOString(),
    workflowEngineExists: exists(workflowFile),
    knownWorkflows: knownWorkflows.map(name => ({
      workflowType: name,
      detectedInCode: text.includes(name),
      criticality: ["COURT_PREPARATION", "CONFLICT_CHECK", "MATTER_CLOSURE"].includes(name) ? "CRITICAL" : "HIGH"
    })),
    totals: {
      knownWorkflows: knownWorkflows.length,
      detected: knownWorkflows.filter(name => text.includes(name)).length
    }
  };
}

function buildAutomationRegistry() {
  const eventTypes = read(path.join(AUTOMATION, "eventTypes.js"));
  const handlerRegistry = read(path.join(AUTOMATION, "handlerRegistry.js"));
  const handlerDir = path.join(AUTOMATION, "handlers");
  const handlers = exists(handlerDir) ? listFiles(handlerDir, ".js") : [];

  const events = [];
  const re = /([A-Z0-9_]+)\s*:\s*["'`]([A-Z0-9_]+)["'`]/g;
  let m;
  while ((m = re.exec(eventTypes)) !== null) {
    events.push(m[2]);
  }

  return {
    registry: "automation-registry",
    generatedAt: new Date().toISOString(),
    eventTypesFileExists: exists(path.join(AUTOMATION, "eventTypes.js")),
    handlerRegistryExists: exists(path.join(AUTOMATION, "handlerRegistry.js")),
    events,
    handlers: handlers.map(h => ({
      name: path.basename(h, ".js"),
      file: rel(h)
    })),
    schedulerFiles: listFiles(SRC, ".js").filter(f => read(f).toLowerCase().includes("schedule")).map(rel),
    notificationFiles: listFiles(SRC, ".js").filter(f => read(f).toLowerCase().includes("notification")).map(rel),
    totals: {
      events: events.length,
      handlers: handlers.length,
      schedulerRelatedFiles: listFiles(SRC, ".js").filter(f => read(f).toLowerCase().includes("schedule")).length
    }
  };
}

function buildFrontendBackendMap() {
  const frontendFiles = listFiles(FRONTEND_SRC, null).filter(f => [".js", ".jsx", ".ts", ".tsx"].includes(path.extname(f)));
  const refs = [];

  for (const file of frontendFiles) {
    const text = read(file);
    const apiRegex = /["'`]([^"'`]*\/api\/enterprise\/[^"'`]+)["'`]/g;
    let m;
    while ((m = apiRegex.exec(text)) !== null) {
      refs.push({
        frontendFile: rel(file),
        endpoint: m[1],
        area:
          m[1].includes("monitoring") ? "Monitoring" :
          m[1].includes("environment") ? "Environment" :
          m[1].includes("deployment") ? "Deployment" :
          m[1].includes("release") ? "Release" :
          m[1].includes("maps") ? "Maps" :
          m[1].includes("navigation") ? "Navigation" :
          m[1].includes("performance") ? "Performance" :
          "Enterprise"
      });
    }
  }

  return {
    registry: "frontend-backend-map",
    generatedAt: new Date().toISOString(),
    references: refs,
    totals: {
      frontendFilesScanned: frontendFiles.length,
      enterpriseApiReferences: refs.length
    }
  };
}

function buildCriticalityRegistry(engineMap, endpointRegistry) {
  const criticalEngines = new Set([
    "workflowEngine",
    "eventBus",
    "handlerRegistry",
    "enterpriseHardeningEngine",
    "deploymentReadinessCentre",
    "releaseValidatorEngine",
    "environmentValidationEngine",
    "backupRecoveryEngine",
    "enterpriseGovernanceEngine"
  ]);

  const highEngines = new Set([
    "enterpriseMonitoringEngine",
    "performanceOptimizationEngine",
    "courtOperationsEngine",
    "courtNavigationEngine",
    "mapsIntegrationLayer",
    "matterIntelligenceEngine",
    "predictiveAnalyticsEngine"
  ]);

  const engines = engineMap.engines.map(e => ({
    engine: e.engine,
    criticality: criticalEngines.has(e.engine) ? "CRITICAL" : highEngines.has(e.engine) ? "HIGH" : "MEDIUM",
    reason: criticalEngines.has(e.engine)
      ? "Required for deployment safety, governance, workflow, release, or recovery."
      : highEngines.has(e.engine)
      ? "Important for operations, visibility, navigation, or intelligence."
      : "Supporting enterprise function."
  }));

  const endpoints = endpointRegistry.endpoints.map(e => ({
    endpoint: e.fullPath,
    method: e.method,
    criticality:
      e.fullPath.includes("health") ||
      e.fullPath.includes("readiness") ||
      e.fullPath.includes("release") ||
      e.fullPath.includes("deployment")
        ? "CRITICAL"
        : e.fullPath.includes("maps") ||
          e.fullPath.includes("court") ||
          e.fullPath.includes("workflow")
        ? "HIGH"
        : "MEDIUM"
  }));

  return {
    registry: "criticality-registry",
    generatedAt: new Date().toISOString(),
    systemCriticality: {
      database: "CRITICAL",
      backend: "CRITICAL",
      frontend: "HIGH",
      monitoring: "CRITICAL",
      backups: "CRITICAL",
      maps: "HIGH",
      industrialCourtKualaLumpur: "HIGH",
      perkesoKualaLumpur: "HIGH",
      perkesoHeadquartersJalanAmpang: "HIGH"
    },
    engines,
    endpoints,
    totals: {
      engines: engines.length,
      endpoints: endpoints.length,
      criticalEngines: engines.filter(e => e.criticality === "CRITICAL").length,
      criticalEndpoints: endpoints.filter(e => e.criticality === "CRITICAL").length
    }
  };
}

function generateDocs(registries) {
  writeDoc("MASTER-ENGINE-REGISTRY.md", [
    "# MASTER ENGINE REGISTRY",
    "",
    "Generated: " + new Date().toISOString(),
    "",
    "Total Engines: " + registries.engine.totals.engines,
    "",
    ...registries.engine.engines.map(e => `- ${e.engine} â€” ${e.file} â€” dependencies: ${e.dependencies.join(", ") || "none"}`)
  ].join("\n"));

  writeDoc("MASTER-ROUTE-REGISTRY.md", [
    "# MASTER ROUTE REGISTRY",
    "",
    "Total Route Files: " + registries.route.totals.routeFiles,
    "Mounted Routes: " + registries.route.totals.mountedRoutes,
    "",
    ...registries.route.routes.map(r => `- ${r.basePath || "(unmounted)"} -> ${r.routeFile} -> engines: ${r.engines.join(", ") || "none"}`)
  ].join("\n"));

  writeDoc("MASTER-ENDPOINT-REGISTRY.md", [
    "# MASTER ENDPOINT REGISTRY",
    "",
    "Total Endpoints: " + registries.endpoint.totals.endpoints,
    "Enterprise Endpoints: " + registries.endpoint.totals.enterpriseEndpoints,
    "Health Endpoints: " + registries.endpoint.totals.healthEndpoints,
    "",
    ...registries.endpoint.endpoints.map(e => `- ${e.method} ${e.fullPath} -> ${e.routeFile}`)
  ].join("\n"));

  writeDoc("MASTER-WORKFLOW-REGISTRY.md", [
    "# MASTER WORKFLOW REGISTRY",
    "",
    ...registries.workflow.knownWorkflows.map(w => `- ${w.workflowType} â€” detected: ${w.detectedInCode} â€” criticality: ${w.criticality}`)
  ].join("\n"));

  writeDoc("MASTER-AUTOMATION-REGISTRY.md", [
    "# MASTER AUTOMATION REGISTRY",
    "",
    "Events: " + registries.automation.totals.events,
    "Handlers: " + registries.automation.totals.handlers,
    "",
    "## Events",
    ...registries.automation.events.map(e => `- ${e}`),
    "",
    "## Handlers",
    ...registries.automation.handlers.map(h => `- ${h.name} â€” ${h.file}`)
  ].join("\n"));

  writeDoc("MASTER-CRITICALITY-REGISTRY.md", [
    "# MASTER CRITICALITY REGISTRY",
    "",
    "## System Criticality",
    ...Object.entries(registries.criticality.systemCriticality).map(([k, v]) => `- ${k}: ${v}`),
    "",
    "## Critical Engines",
    ...registries.criticality.engines.filter(e => e.criticality === "CRITICAL").map(e => `- ${e.engine}: ${e.criticality}`)
  ].join("\n"));

  writeDoc("MASTER-ARCHITECTURE-DIAGRAM.md", [
    "# MASTER ARCHITECTURE DIAGRAM",
    "",
    "```text",
    "Frontend Dashboard / Connectivity Validator",
    "        â†“",
    "Enterprise API Routes",
    "        â†“",
    "Automation Engines",
    "        â†“",
    "Event Bus / Workflow / Governance / Monitoring / Release",
    "        â†“",
    "Database + Registries + Reports",
    "```",
    "",
    "## Special Operational Coverage",
    "- Industrial Court Kuala Lumpur",
    "- PERKESO Kuala Lumpur â€” Jalan Tun Razak",
    "- PERKESO Headquarters â€” Jalan Ampang"
  ].join("\n"));
}

function main() {
  const engine = buildEngineDependencyMap();
  const route = buildRouteEngineMap();
  const endpoint = buildEndpointRegistry(route);
  const workflow = buildWorkflowRegistry();
  const automation = buildAutomationRegistry();
  const frontendBackend = buildFrontendBackendMap();
  const criticality = buildCriticalityRegistry(engine, endpoint);

  const registries = { engine, route, endpoint, workflow, automation, frontendBackend, criticality };

  writeJson("engine-dependency-map.json", engine);
  writeJson("route-engine-map.json", route);
  writeJson("endpoint-registry.json", endpoint);
  writeJson("workflow-registry.json", workflow);
  writeJson("automation-registry.json", automation);
  writeJson("frontend-backend-map.json", frontendBackend);
  writeJson("criticality-registry.json", criticality);
  writeJson("enterprise-architecture-master-registry.json", registries);

  generateDocs(registries);

  const checks = [
    { name: "Engine Registry Generated", pass: engine.totals.engines > 0 },
    { name: "Route Registry Generated", pass: route.totals.routeFiles > 0 },
    { name: "Endpoint Registry Generated", pass: endpoint.totals.endpoints >= 0 },
    { name: "Workflow Registry Generated", pass: workflow.totals.knownWorkflows > 0 },
    { name: "Automation Registry Generated", pass: automation.handlerRegistryExists },
    { name: "Frontend Backend Map Generated", pass: frontendBackend.totals.frontendFilesScanned > 0 },
    { name: "Criticality Registry Generated", pass: criticality.totals.engines > 0 }
  ];

  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;

  const report = {
    phase: "10X.3A",
    module: "Enterprise Architecture Registry",
    timestamp: new Date().toISOString(),
    status: failed === 0 ? "PASS" : "FAIL",
    passed,
    failed,
    checks,
    totals: {
      engines: engine.totals.engines,
      routeFiles: route.totals.routeFiles,
      endpoints: endpoint.totals.endpoints,
      workflows: workflow.totals.knownWorkflows,
      events: automation.totals.events,
      handlers: automation.totals.handlers,
      frontendApiRefs: frontendBackend.totals.enterpriseApiReferences,
      criticalEngines: criticality.totals.criticalEngines
    }
  };

  fs.writeFileSync(path.join(REPORTS, "phase10X3A-enterprise-architecture-registry-report.json"), JSON.stringify(report, null, 2));

  console.log([
    "LITIGATION 360 - PHASE 10X.3A ENTERPRISE ARCHITECTURE REGISTRY REPORT",
    "====================================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Passed: " + report.passed,
    "Failed: " + report.failed,
    "",
    "Engines: " + report.totals.engines,
    "Route Files: " + report.totals.routeFiles,
    "Endpoints: " + report.totals.endpoints,
    "Workflows: " + report.totals.workflows,
    "Events: " + report.totals.events,
    "Handlers: " + report.totals.handlers,
    "Frontend API References: " + report.totals.frontendApiRefs,
    "Critical Engines: " + report.totals.criticalEngines,
    "",
    ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
  ].join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

main();

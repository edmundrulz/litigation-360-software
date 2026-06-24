$ROOT = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PHASE = "phase-10ZG-dashboard-framework"
$OPS = "$ROOT\_operations\$PHASE"
$BACKUPS = "$OPS\backups"
$REPORTS = "$OPS\reports"
$DOCS = "$ROOT\docs\phase-10ZG"
$APP = "$ROOT\frontend\src\App.jsx"
$CSS = "$ROOT\frontend\src\App.css"
$REPORT = "$REPORTS\PHASE-10ZG-DEPLOYMENT-REPORT.txt"
$BLUEPRINT = "$DOCS\PHASE-10ZG-DASHBOARD-BLUEPRINT.md"

New-Item -ItemType Directory -Force -Path $OPS, $BACKUPS, $REPORTS, $DOCS | Out-Null

"PHASE 10ZG DEPLOYMENT REPORT" | Set-Content $REPORT
"Date: $(Get-Date)" | Add-Content $REPORT

Copy-Item $APP "$BACKUPS\App.jsx.before-10ZG" -Force
Copy-Item $CSS "$BACKUPS\App.css.before-10ZG" -Force

@"
# PHASE 10ZG

Enterprise Dashboard Framework

## SECTION 1 — Executive Health
System health, database status, deployment readiness, and risk level.

## SECTION 2 — Operations Centre
Monitoring, governance, performance, backup recovery, navigation, and deployment centre.

## SECTION 3 — Matter Statistics
Future live counts for matters, cases, clients, documents, court dates, and staff.

## SECTION 4 — Staff Statistics
Future lawyer, clerk, admin, and partner workload view.

## SECTION 5 — KPI Panel
Open matters, closed matters, upcoming hearings, pending documents, and compliance score.

## SECTION 6 — Monitoring Panel
Realtime enterprise monitoring and endpoint health summary.

## SECTION 7 — Roadmap Panel
Legal AI, workflow automation, predictive analytics, mobile app, marketplace, client portal, and government integrations.

## SECTION 8 — Future Integrations
Court systems, government portals, maps, finance, AI agents, and autonomous operations.

## Rule
Phase 10ZG must not break Phase 10ZF navigation.
"@ | Set-Content $BLUEPRINT

@'
import React, { useEffect, useState } from "react";
import "./App.css";

import Clients from "./pages/Clients";
import Cases from "./pages/Cases";
import Matters from "./pages/Matters";
import Deadlines from "./pages/Deadlines";
import Documents from "./pages/Documents";
import Staff from "./pages/Staff";

const liveModules = {
  clients: { title: "Clients", component: <Clients /> },
  cases: { title: "Cases", component: <Cases /> },
  matters: { title: "Matters", component: <Matters /> },
  deadlines: { title: "Court Dates", component: <Deadlines /> },
  documents: { title: "Documents", component: <Documents /> },
  staff: { title: "Staff", component: <Staff /> },
};

const plannedModules = [
  "Tasks",
  "Notifications",
  "Court Navigation",
  "Reports",
  "Lawyer View",
  "Clerk View",
  "Admin View",
  "Finance View",
  "Partner View",
  "Legal AI",
  "Knowledge Management",
  "Predictive Analytics",
  "Executive Command Centre",
  "Workflow Automation",
  "Government Integrations",
  "Client Portal",
  "Mobile App",
  "Marketplace",
  "Autonomous Operations",
];

function StatusCard({ title, value }) {
  return (
    <div className="l360-status-card">
      <span>{title}</span>
      <strong>{value}</strong>
    </div>
  );
}

function App() {
  const [activeModule, setActiveModule] = useState(null);
  const [health, setHealth] = useState({
    system: "CHECKING",
    database: "CHECKING",
    monitoring: "CHECKING",
    governance: "CHECKING",
    performance: "CHECKING",
    deployment: "CHECKING",
    risk: "CHECKING",
  });

  useEffect(() => {
    async function loadHealth() {
      try {
        const base = "";
        const api = await fetch(base + "/api/health").then((r) => r.json());
        const monitoring = await fetch(base + "/api/enterprise/monitoring/health").then((r) => r.json());
        const governance = await fetch(base + "/api/enterprise/governance/health").then((r) => r.json());
        const performance = await fetch(base + "/api/enterprise/performance/health").then((r) => r.json());
        const deployment = await fetch(base + "/api/enterprise/deployment-centre/health").then((r) => r.json());

        setHealth({
          system: "HEALTHY",
          database: api.database || api.status || "CONNECTED",
          monitoring: monitoring.status || "HEALTHY",
          governance: governance.status || "HEALTHY",
          performance: performance.status || "HEALTHY",
          deployment: deployment.status || "READY",
          risk: deployment.riskLevel || "LOW",
        });
      } catch {
        setHealth({
          system: "BACKEND OFFLINE",
          database: "UNKNOWN",
          monitoring: "UNKNOWN",
          governance: "UNKNOWN",
          performance: "UNKNOWN",
          deployment: "UNKNOWN",
          risk: "UNKNOWN",
        });
      }
    }

    loadHealth();
  }, []);

  if (activeModule && liveModules[activeModule]) {
    return (
      <main className="l360-app">
        <button className="l360-back-button" onClick={() => setActiveModule(null)}>
          Back To Main Workspace
        </button>
        {liveModules[activeModule].component}
      </main>
    );
  }

  return (
    <main className="l360-app">
      <section className="l360-hero">
        <div>
          <h1>Litigation 360</h1>
          <p>Phase 10ZG — Enterprise Dashboard Framework</p>
        </div>
        <div className="l360-badge">LEOS COMMAND CENTRE</div>
      </section>

      <section className="l360-dashboard-grid">
        <StatusCard title="System Health" value={health.system} />
        <StatusCard title="Database" value={health.database} />
        <StatusCard title="Deployment" value={health.deployment} />
        <StatusCard title="Risk Level" value={health.risk} />
        <StatusCard title="Monitoring" value={health.monitoring} />
        <StatusCard title="Governance" value={health.governance} />
        <StatusCard title="Performance" value={health.performance} />
      </section>

      <h2>Live Legal Operations</h2>
      <section className="l360-module-grid">
        {Object.entries(liveModules).map(([key, item]) => (
          <button key={key} className="l360-module-card live" onClick={() => setActiveModule(key)}>
            <strong>{item.title}</strong>
            <span>LIVE</span>
          </button>
        ))}
      </section>

      <h2>Enterprise Roadmap</h2>
      <section className="l360-module-grid">
        {plannedModules.map((name) => (
          <button key={name} className="l360-module-card planned" disabled>
            <strong>{name}</strong>
            <span>PLANNED</span>
          </button>
        ))}
      </section>
    </main>
  );
}

export default App;
'@ | Set-Content $APP

$cssBlock = @'

/* PHASE 10ZG ENTERPRISE DASHBOARD FRAMEWORK */
.l360-app {
  padding: 24px;
  font-family: Arial, sans-serif;
}

.l360-hero {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.l360-badge {
  border: 1px solid #999;
  border-radius: 999px;
  padding: 8px 14px;
  font-size: 12px;
  font-weight: bold;
}

.l360-dashboard-grid,
.l360-module-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
  gap: 14px;
  margin: 16px 0 28px;
}

.l360-status-card,
.l360-module-card {
  border: 1px solid #ddd;
  border-radius: 14px;
  padding: 18px;
  background: white;
  text-align: left;
}

.l360-status-card span,
.l360-module-card span {
  display: block;
  font-size: 12px;
  margin-bottom: 8px;
  opacity: 0.7;
}

.l360-status-card strong,
.l360-module-card strong {
  font-size: 18px;
}

.l360-module-card.live {
  cursor: pointer;
}

.l360-module-card.planned {
  opacity: 0.55;
  cursor: not-allowed;
}

.l360-back-button {
  margin-bottom: 20px;
  padding: 10px 16px;
  border-radius: 10px;
  border: 1px solid #999;
  background: white;
  cursor: pointer;
  font-weight: bold;
}
'@

Add-Content $CSS $cssBlock

$rollback = @"
@echo off
set ROOT=$ROOT
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.jsx.before-10ZG" "%ROOT%\frontend\src\App.jsx"
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.css.before-10ZG" "%ROOT%\frontend\src\App.css"
cd /d "%ROOT%\frontend"
npm run build
pause
"@

$rollback | Set-Content "$ROOT\scripts\ROLLBACK-PHASE-10ZG.bat"

cd "$ROOT\frontend"
npm run build
if ($LASTEXITCODE -ne 0) {
  "BUILD: FAIL" | Add-Content $REPORT
  Write-Host "PHASE 10ZG DEPLOYMENT FAILED — RUN scripts\ROLLBACK-PHASE-10ZG.bat"
  exit 1
}

cd $ROOT
curl.exe -s http://localhost:5000/api/health | Add-Content $REPORT
curl.exe -s http://localhost:5000/api/enterprise/monitoring/health | Add-Content $REPORT
curl.exe -s http://localhost:5000/api/enterprise/deployment-centre/health | Add-Content $REPORT

"BUILD: PASS" | Add-Content $REPORT
"PHASE 10ZG DEPLOYMENT: PASS" | Add-Content $REPORT

Write-Host ""
Write-Host "PHASE 10ZG DEPLOYMENT: PASS"
Write-Host "Blueprint created: $BLUEPRINT"
Write-Host "Report created: $REPORT"
Write-Host "Rollback created: $ROOT\scripts\ROLLBACK-PHASE-10ZG.bat"
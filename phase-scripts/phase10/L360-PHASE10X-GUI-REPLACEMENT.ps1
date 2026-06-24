$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend = "$Root\frontend"
$Src = "$Frontend\src"
$Ops = "$Root\_operations\phase-10X-gui-replacement"
$Backup = "$Ops\backups\src_" + (Get-Date -Format "yyyyMMdd_HHmmss")

New-Item -ItemType Directory -Force -Path $Ops, "$Ops\backups", "$Ops\reports" | Out-Null
Copy-Item $Src $Backup -Recurse -Force

@'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      "/api": {
        target: "http://localhost:5100",
        changeOrigin: true,
        secure: false
      }
    }
  }
});
'@ | Set-Content -Encoding UTF8 "$Frontend\vite.config.js"

@'
import React, { useEffect, useState } from "react";
import "./App.css";

const endpoints = [
  ["Monitoring", "/api/enterprise/monitoring/health"],
  ["Readiness", "/api/enterprise/hardening/deployment/readiness"],
  ["Backup Recovery", "/api/enterprise/backup-recovery/health"],
  ["Performance", "/api/enterprise/performance/health"],
  ["Governance", "/api/enterprise/governance/health"],
  ["Maps", "/api/enterprise/maps/health"],
  ["Navigation", "/api/enterprise/navigation/health"]
];

export default function App() {
  const [view, setView] = useState("workspace");
  const [results, setResults] = useState([]);
  const [updated, setUpdated] = useState("Pending");

  async function runChecks() {
    const out = [];
    for (const [name, path] of endpoints) {
      const start = performance.now();
      try {
        const res = await fetch(path);
        out.push({
          name,
          path,
          ok: res.ok,
          http: res.status,
          ms: Math.round((performance.now() - start) * 10) / 10
        });
      } catch {
        out.push({
          name,
          path,
          ok: false,
          http: "NETWORK_ERROR",
          ms: Math.round((performance.now() - start) * 10) / 10
        });
      }
    }
    setResults(out);
    setUpdated(new Date().toLocaleString());
  }

  useEffect(() => {
    runChecks();
    const timer = setInterval(runChecks, 30000);
    return () => clearInterval(timer);
  }, []);

  const passed = results.filter(r => r.ok).length;
  const failed = results.length - passed;

  return (
    <div className="shell">
      <aside className="sidebar">
        <div className="brand">Litigation 360</div>
        <button className={view === "workspace" ? "active" : ""} onClick={() => setView("workspace")}>End User Workspace</button>
        <button className={view === "operations" ? "active" : ""} onClick={() => setView("operations")}>Operations Centre</button>
        <button className={view === "admin" ? "active" : ""} onClick={() => setView("admin")}>Admin Centre</button>
        <button className={view === "developer" ? "active" : ""} onClick={() => setView("developer")}>Developer Centre</button>
      </aside>

      <main className="main">
        <header className="topbar">
          <div>
            <h1>{viewTitle(view)}</h1>
            <p>Realtime legal operations interface. Last update: {updated}</p>
          </div>
          <span className={failed ? "pill bad" : "pill good"}>{failed ? "BACKEND CHECK REQUIRED" : "SYSTEM HEALTHY"}</span>
        </header>

        {view === "workspace" && <Workspace />}
        {view === "operations" && <Operations results={results} run={runChecks} passed={passed} failed={failed} />}
        {view === "admin" && <Admin />}
        {view === "developer" && <Developer results={results} />}
      </main>
    </div>
  );
}

function viewTitle(view) {
  return {
    workspace: "End User Legal Workspace",
    operations: "Operations Centre",
    admin: "Admin Centre",
    developer: "Developer Centre"
  }[view];
}

function Workspace() {
  const cards = [
    ["Clients", "Client records, contacts, onboarding and profile management."],
    ["Matters", "Active case files, parties, progress and status tracking."],
    ["Court Dates", "Hearings, mentions, deadlines and reminders."],
    ["Tasks", "Daily assignments, follow-ups and pending actions."],
    ["Documents", "Drafts, filings, templates, evidence and archives."],
    ["Notifications", "Alerts, reminders, escalations and updates."],
    ["Court Navigation", "Industrial Court Kuala Lumpur, PERKESO Kuala Lumpur — Wisma PERKESO, PERKESO Headquarters — Jalan Ampang."],
    ["Reports", "Matter summaries, workload reports and executive overview."]
  ];

  return (
    <>
      <section className="hero">
        <h2>Welcome Back</h2>
        <p>This is the normal user workspace. No raw JSON. No developer diagnostics. No merged headings.</p>
        <div className="actions">
          <button>New Client</button>
          <button>New Matter</button>
          <button>Upload Document</button>
          <button>Add Court Date</button>
        </div>
      </section>

      <section className="grid">
        {cards.map(([title, text]) => <Card key={title} title={title} status="Ready" text={text} />)}
      </section>
    </>
  );
}

function Operations({ results, run, passed, failed }) {
  return (
    <>
      <section className="summary">
        <Metric label="Modules Online" value={`${passed}/${results.length}`} />
        <Metric label="Modules Failed" value={failed} />
        <button onClick={run}>Refresh Now</button>
      </section>
      <section className="grid">
        {results.map(r => <Card key={r.name} title={r.name} status={r.ok ? "Healthy" : "Network Error"} text={`HTTP: ${r.http} | ${r.ms} ms`} bad={!r.ok} />)}
      </section>
    </>
  );
}

function Admin() {
  return (
    <section className="grid">
      <Card title="Governance" status="Ready" text="Compliance, approvals, policies and audit readiness." />
      <Card title="Backup Recovery" status="Ready" text="Backup status, restore planning and disaster readiness." />
      <Card title="Deployment Readiness" status="Ready" text="Production readiness, blockers and release checks." />
      <Card title="Audit Trail" status="Ready" text="System evidence and operational traceability." />
    </section>
  );
}

function Developer({ results }) {
  return (
    <>
      <section className="grid">
        {results.map(r => <Card key={r.name} title={r.name} status={r.ok ? "PASS" : "FAIL"} text={r.path} bad={!r.ok} />)}
      </section>
      <details className="jsonbox">
        <summary>Developer Raw JSON Diagnostics</summary>
        <pre>{JSON.stringify(results, null, 2)}</pre>
      </details>
    </>
  );
}

function Card({ title, status, text, bad }) {
  return (
    <article className={bad ? "card badcard" : "card"}>
      <h3>{title}</h3>
      <strong>{status}</strong>
      <p>{text}</p>
    </article>
  );
}

function Metric({ label, value }) {
  return (
    <div className="metric">
      <span>{label}</span>
      <strong>{value}</strong>
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 "$Src\App.jsx"

@'
* { box-sizing: border-box; }

html, body, #root {
  margin: 0;
  min-height: 100%;
  font-family: Arial, Helvetica, sans-serif;
  background: #f4f6fa;
  color: #1f2937;
}

.shell {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 255px;
  background: #111827;
  color: white;
  padding: 20px;
  flex-shrink: 0;
}

.brand {
  font-size: 24px;
  font-weight: 800;
  margin-bottom: 24px;
}

.sidebar button {
  display: block;
  width: 100%;
  margin-bottom: 10px;
  padding: 12px;
  border: 0;
  border-radius: 10px;
  text-align: left;
  background: #1f2937;
  color: #e5e7eb;
  cursor: pointer;
  font-weight: 700;
}

.sidebar button.active {
  background: white;
  color: #111827;
}

.main {
  flex: 1;
  padding: 28px;
  overflow-x: hidden;
}

.topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 22px;
  background: white;
  border: 1px solid #d9dee8;
  border-radius: 18px;
  padding: 22px 24px;
  margin-bottom: 24px;
}

.topbar h1 {
  margin: 0;
  font-size: clamp(28px, 3vw, 42px);
  line-height: 1.15;
}

.topbar p {
  margin: 8px 0 0;
  color: #64748b;
}

.pill {
  padding: 12px 16px;
  border-radius: 999px;
  font-weight: 800;
  white-space: nowrap;
}

.good {
  background: #dcfce7;
  color: #166534;
}

.bad {
  background: #fee2e2;
  color: #991b1b;
}

.hero, .card, .metric, .jsonbox {
  background: white;
  border: 1px solid #d9dee8;
  border-radius: 18px;
  padding: 22px;
}

.hero {
  margin-bottom: 24px;
}

.hero h2 {
  margin: 0 0 10px;
  font-size: 30px;
}

.hero p, .card p {
  color: #64748b;
  line-height: 1.45;
}

.actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.actions button, .summary button {
  padding: 12px 16px;
  border-radius: 10px;
  border: 0;
  background: #111827;
  color: white;
  font-weight: 800;
  cursor: pointer;
}

.grid, .summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 18px;
}

.card h3 {
  margin: 0 0 10px;
  font-size: 20px;
}

.card strong {
  display: inline-block;
  margin-bottom: 10px;
  color: #047857;
}

.badcard {
  background: #fff1f2;
  border-color: #fecdd3;
}

.badcard strong {
  color: #be123c;
}

.metric span {
  display: block;
  color: #64748b;
  margin-bottom: 8px;
}

.metric strong {
  font-size: 24px;
}

.jsonbox {
  margin-top: 24px;
}

.jsonbox pre {
  background: #0f172a;
  color: #e5e7eb;
  padding: 18px;
  border-radius: 12px;
  overflow: auto;
  max-height: 520px;
}

@media (max-width: 850px) {
  .shell { flex-direction: column; }
  .sidebar { width: 100%; }
  .topbar { flex-direction: column; align-items: flex-start; }
}
'@ | Set-Content -Encoding UTF8 "$Src\App.css"

@'
# Phase 10X GUI Replacement Report

Status: Completed

Files replaced:
- frontend/src/App.jsx
- frontend/src/App.css
- frontend/vite.config.js

Backup created before replacement.
Default screen is End User Workspace.
Developer diagnostics moved to Developer Centre.
'@ | Set-Content -Encoding UTF8 "$Ops\reports\PHASE10X_GUI_REPLACEMENT_REPORT.md"

Set-Location $Frontend
npm run build

Write-Host ""
Write-Host "PHASE 10X GUI REPLACEMENT COMPLETE"
Write-Host "Backup created at: $Backup"
Write-Host "Now run: npm run dev"
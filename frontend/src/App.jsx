import MatterIntakeWizard from './pages/MatterIntakeWizard.jsx';
import React, { useEffect, useState } from "react";
import "./App.css";
import { MenuPlatform } from "./features/menu-platform";

import Clients from "./pages/Clients";
import Cases from "./pages/Cases";
import Matters from "./pages/Matters";
import Deadlines from "./pages/Deadlines";
import Documents from "./pages/Documents";
import Staff from "./pages/Staff";

const endpoints = [
  ["Monitoring", "/api/enterprise/monitoring/health"],
  ["Deployment Readiness", "/api/enterprise/deployment-centre/health"],
  ["Backup Recovery", "/api/enterprise/backup-recovery/health"],
  ["Performance", "/api/enterprise/performance/health"],
  ["Governance", "/api/enterprise/governance/health"],
  ["Maps", "/api/enterprise/maps/health"],
  ["Navigation", "/api/enterprise/navigation/health"]
];

const workspaceSections = [
  {
    id: "start-here",
    label: "Start Here",
    title: "Start Here",
    description: "Begin a new legal workflow or open client details.",
    items: [
      {
        module: "Matter Intake",
        title: "Matter Intake",
        status: "OPEN",
        sequence: "1",
        text: "Guided starting point for new matter intake and workflow preparation.",
      },
      {
        module: "Clients",
        title: "Client Details",
        status: "OPEN",
        sequence: "2",
        text: "Client records, contacts, onboarding and profile management.",
      },
    ],
  },
  {
    id: "active-legal-work",
    label: "Active Work",
    title: "Active Legal Work",
    description: "Manage active case, matter, court, and document work.",
    items: [
      {
        module: "Cases",
        title: "Case / Matter Details",
        status: "OPEN",
        sequence: "3",
        text: "Case files, parties, progress and litigation status.",
      },
      {
        module: "Matters",
        title: "Matter Workspace",
        status: "OPEN",
        sequence: "4",
        text: "Matter workspace and legal file tracking.",
      },
      {
        module: "Court Dates",
        title: "Court Dates",
        status: "OPEN",
        sequence: "5",
        text: "Hearings, mentions, deadlines and reminders.",
      },
      {
        module: "Documents",
        title: "Documents",
        status: "OPEN",
        sequence: "6",
        text: "Drafts, filings, templates, evidence and archives.",
      },
    ],
  },
  {
    id: "review-completion",
    label: "Completion",
    title: "Review And Completion",
    description: "Review the prepared workflow before save or submission.",
    items: [
      {
        module: "Review Submit",
        title: "Review / Save & Submit",
        status: "OPEN",
        sequence: "7",
        text: "Final review point before saving, submission, or future workflow handoff.",
      },
    ],
  },
  {
    id: "office-admin",
    label: "Admin",
    title: "Office Administration",
    description: "Internal administration tools for firm operations.",
    items: [
      {
        module: "Staff",
        title: "Staff",
        status: "OPEN",
        sequence: "A",
        text: "Staff records and internal team administration.",
      },
    ],
  },
  {
    id: "planned-platform",
    label: "Future",
    title: "Planned Platform Modules",
    description: "Roadmap modules are visible for planning but not active yet.",
    items: [
      { module: "Tasks", title: "Tasks", status: "PLANNED", sequence: "P1", text: "Daily assignments, follow-ups and pending actions." },
      { module: "Notifications", title: "Notifications", status: "PLANNED", sequence: "P2", text: "Alerts, reminders, escalations and updates." },
      { module: "Court Navigation", title: "Court Navigation", status: "PLANNED", sequence: "P3", text: "Court location intelligence, travel planning and readiness." },
      { module: "Reports", title: "Reports", status: "PLANNED", sequence: "P4", text: "Matter summaries, workload reports and executive overview." },
      { module: "Lawyer View", title: "Lawyer View", status: "PLANNED", sequence: "P5", text: "Hearings, active matters, pleadings, deadlines and court preparation." },
      { module: "Clerk View", title: "Clerk View", status: "PLANNED", sequence: "P6", text: "Filing tasks, service tracking, bundles and registry follow-ups." },
      { module: "Admin View", title: "Admin View", status: "PLANNED", sequence: "P7", text: "Client intake, scheduling, reminders and office coordination." },
      { module: "Finance View", title: "Finance View", status: "PLANNED", sequence: "P8", text: "Invoices, payments, disbursements and billing status." },
      { module: "Partner View", title: "Partner View", status: "PLANNED", sequence: "P9", text: "Firm-wide performance, risk view and supervision." },
      { module: "Legal AI", title: "Legal AI", status: "PLANNED", sequence: "P10", text: "AI drafting, review, research and legal operations support." },
      { module: "Knowledge Management", title: "Knowledge Management", status: "PLANNED", sequence: "P11", text: "Precedents, templates, research notes and internal knowledge." },
      { module: "Predictive Analytics", title: "Predictive Analytics", status: "PLANNED", sequence: "P12", text: "Matter risk, workload trend and outcome intelligence." },
      { module: "Executive Command Centre", title: "Executive Command Centre", status: "PLANNED", sequence: "P13", text: "Leadership cockpit for firm-wide legal operations." },
      { module: "Workflow Automation", title: "Workflow Automation", status: "PLANNED", sequence: "P14", text: "Automated routing, reminders, escalation and process control." },
      { module: "Government Integrations", title: "Government Integrations", status: "PLANNED", sequence: "P15", text: "Court, PERKESO, government and external registry integration layer." },
      { module: "Client Portal", title: "Client Portal", status: "PLANNED", sequence: "P16", text: "Client-facing secure matter, document and update portal." },
      { module: "Mobile App", title: "Mobile App", status: "PLANNED", sequence: "P17", text: "Mobile-ready legal operations access." },
      { module: "Autonomous Operations", title: "Autonomous Operations", status: "PLANNED", sequence: "P18", text: "Self-monitoring, recovery, alerts and operational automation." },
      { module: "Marketplace", title: "Marketplace", status: "PLANNED", sequence: "P19", text: "Future ecosystem marketplace and API extension layer." },
    ],
  },
];

const moduleFrameDetails = {
  "Matter Intake": {
    displayTitle: "Matter Intake",
    group: "Start Here",
    description: "Guided starting point for new matter intake and workflow preparation.",
    position: "Step 1 of 6",
    nextModule: "Clients",
    nextLabel: "Client Details",
  },
  Clients: {
    displayTitle: "Client Details",
    group: "Start Here",
    description: "Client records, contact information, onboarding, and profile management.",
    position: "Step 2 of 6",
    nextModule: "Cases",
    nextLabel: "Case / Matter Details",
  },
  Cases: {
    displayTitle: "Case / Matter Details",
    group: "Active Legal Work",
    description: "Case files, parties, progress, and litigation status.",
    position: "Step 3 of 6",
    nextModule: "Court Dates",
    nextLabel: "Court Dates",
  },
  Matters: {
    displayTitle: "Matter Workspace",
    group: "Active Legal Work",
    description: "Matter workspace and legal file tracking.",
    position: "Reference Module",
    nextModule: "Court Dates",
    nextLabel: "Court Dates",
  },
  "Court Dates": {
    displayTitle: "Court Dates",
    group: "Active Legal Work",
    description: "Hearings, mentions, deadlines, reminders, and court date tracking.",
    position: "Step 4 of 6",
    nextModule: "Documents",
    nextLabel: "Documents",
  },
  Documents: {
    displayTitle: "Documents",
    group: "Active Legal Work",
    description: "Drafts, filings, templates, evidence, and document management.",
    position: "Step 5 of 6",
    nextModule: "Review Submit",
    nextLabel: "Review / Save & Submit",
  },
  "Review / Save & Submit": {
    displayTitle: "Review / Save & Submit",
    group: "Review And Completion",
    description: "Final review point before saving, submission, or future workflow handoff.",
    position: "Step 6 of 6",
  },
  Staff: {
    displayTitle: "Staff",
    group: "Office Administration",
    description: "Staff records and internal team administration.",
    position: "Administration",
  },
};

function getModuleFrameDetails(title) {
  return moduleFrameDetails[title] || {
    displayTitle: title,
    group: "Workspace Module",
    description: "Workspace module.",
    position: "",
  };
}

export default function App() {
  const [view, setView] = useState("workspace");
  const [module, setModule] = useState("home");
  const [moduleHistory, setModuleHistory] = useState([]);
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

  function goToModule(nextModule) {
    if (nextModule === module) return;

    if (nextModule === "home") {
      setModuleHistory([]);
      setModule("home");
      return;
    }

    setModuleHistory((previousHistory) => [...previousHistory, module]);
    setModule(nextModule);
  }

  function backToPreviousModule() {
    setModuleHistory((previousHistory) => {
      if (previousHistory.length === 0) {
        setModule("home");
        return previousHistory;
      }

      const previousModule = previousHistory[previousHistory.length - 1];
      setModule(previousModule);

      return previousHistory.slice(0, -1);
    });
  }

  function openWorkspace() {
    setView("workspace");
    setModuleHistory([]);
    setModule("home");
  }

  return (
    <div className="shell">
      <aside className="sidebar">
        <div className="brand">Litigation 360</div>

        <div className="sidebar-menu-platform" aria-label="Application menu hub">
          <MenuPlatform
            context="sidebar"
            triggerLabel="App Menu"
            triggerVariant="sidebar"
            appVersion="0.0.0"
            onNavigate={(target) => {
              if (target === "home") {
                openWorkspace();
              }
            }}
            onAction={(item) => {
              if (item.id === "home") {
                openWorkspace();
              }
            }}
          />
        </div>

        <button className={view === "workspace" ? "active" : ""} onClick={openWorkspace}>
          End User Workspace
        </button>

        <button className={view === "operations" ? "active" : ""} onClick={() => setView("operations")}>
          Operations Centre
        </button>

        <button className={view === "admin" ? "active" : ""} onClick={() => setView("admin")}>
          Admin Centre
        </button>

        <button className={view === "developer" ? "active" : ""} onClick={() => setView("developer")}>
          Developer Centre
        </button>
      </aside>

      <main className="main">
        <header className="topbar">
          <div>
            <h1>{viewTitle(view, module)}</h1>
            <p>Realtime legal operations interface. Last update: {updated}</p>
          </div>

          <span className={failed ? "pill bad" : "pill good"}>
            {failed ? "BACKEND CHECK REQUIRED" : "SYSTEM HEALTHY"}
          </span>
        </header>

        {view === "workspace" && (
          <Workspace
            module={module}
            setModule={goToModule}
            previous={backToPreviousModule}
            canGoBack={moduleHistory.length > 0}
            results={results}
            runChecks={runChecks}
            passed={passed}
            failed={failed}
            updated={updated}
          />
        )}

        {view === "operations" && <Operations results={results} run={runChecks} passed={passed} failed={failed} />}
        {view === "admin" && <Admin />}
        {view === "developer" && <Developer results={results} />}
      </main>
    </div>
  );
}

function viewTitle(view, module) {
  if (view === "workspace" && module !== "home") return "Workspace - " + module;

  return {
    workspace: "End User Legal Workspace - LEOS Module Command Grid",
    operations: "Operations Centre",
    admin: "Admin Centre",
    developer: "Developer Centre"
  }[view];
}

function Workspace({ setModule, goToModule }) {
  const navigateToModule = goToModule || setModule;
  const sections = workspaceSections || [];

  const plannedSections = sections.filter((section) =>
    String(section.title || "").toLowerCase().includes("planned")
  );

  const liveSections = sections.filter((section) =>
    !String(section.title || "").toLowerCase().includes("planned")
  );

  const liveModuleCount = liveSections.reduce((total, section) => {
    const cards = section.modules || section.items || section.cards || [];
    return total + cards.filter((card) => !card.disabled).length;
  }, 0);

  const workflowSectionCount = liveSections.length;

  const plannedModuleCount = plannedSections.reduce((total, section) => {
    const cards = section.modules || section.items || section.cards || [];
    return total + cards.length;
  }, 0);

  const dashboardMetrics = [
    {
      label: "Live Workspace Modules",
      value: liveModuleCount,
      text: "Active modules ready for intake, legal work, review, and administration.",
    },
    {
      label: "Workflow Sections",
      value: workflowSectionCount,
      text: "Grouped areas for starting, continuing, reviewing, and administering work.",
    },
    {
      label: "Planned Modules",
      value: plannedModuleCount,
      text: "Roadmap modules remain visible but disabled until future implementation.",
    },
    {
      label: "Safety Gate",
      value: "Build",
      text: "Frontend production build remains the required verification gate.",
    },
  ];

  function openModule(moduleName) {
    if (typeof navigateToModule === "function") {
      navigateToModule(moduleName);
    }
  }

  function renderWorkspaceCard(card, sectionTitle) {
    const isPlannedSection = String(sectionTitle || "").toLowerCase().includes("planned");
    const isDisabled = Boolean(card.disabled || isPlannedSection);
    const moduleLabel = card.title || card.label || card.name || card.module || "Workspace Module";
    const moduleDescription = card.description || card.summary || "Open this workspace module.";
    const moduleTarget = card.module || card.target || card.key || moduleLabel;
    const badge = card.badge || (isDisabled ? "Roadmap" : sectionTitle);

    return (
      <button
        key={`${sectionTitle}-${moduleLabel}`}
        type="button"
        className={`card workflow-card ${isDisabled ? "planned-card" : "clickable-card"}`}
        onClick={() => {
          if (!isDisabled) {
            openModule(moduleTarget);
          }
        }}
        disabled={isDisabled}
        aria-label={isDisabled ? `${moduleLabel} is planned` : `Open ${moduleLabel}`}
      >
        <span className="workflow-badge">{badge}</span>
        <h3>{moduleLabel}</h3>
        <p>{moduleDescription}</p>
        <span className="card-meta">
          {isDisabled ? "Planned module - disabled" : "Open workspace module"}
        </span>
      </button>
    );
  }

  return (
    <div className="workspace-dashboard-shell">
      <section className="hero workspace-hero-polished">
        <div className="workspace-hero-copy">
          <span className="workspace-eyebrow">Guided legal workflow command centre</span>
          <h1>End User Workspace</h1>
          <p>
            Start intake, continue legal work, manage documents, and complete review steps
            from one guided workspace.
          </p>
        </div>

        <div className="actions workspace-action-panel">
          <button
            type="button"
            className="primary-action"
            onClick={() => openModule("Matter Intake")}
          >
            Start Matter Intake
          </button>

          <button type="button" onClick={() => openModule("Clients")}>
            Open Client Details
          </button>

          <button type="button" onClick={() => openModule("Cases")}>
            Continue Legal Work
          </button>

          <button type="button" onClick={() => openModule("Review Submit")}>
            Review / Save & Submit
          </button>
        </div>
      </section>

      <section className="summary dashboard-summary-grid" aria-label="Workspace summary">
        {dashboardMetrics.map((metric) => (
          <article className="dashboard-metric-card" key={metric.label}>
            <span>{metric.label}</span>
            <strong>{metric.value}</strong>
            <p>{metric.text}</p>
          </article>
        ))}
      </section>

      <section className="workspace-section-list" aria-label="Workspace module sections">
        {sections.map((section) => {
          const cards = section.modules || section.items || section.cards || [];
          const isPlannedSection = String(section.title || "").toLowerCase().includes("planned");

          return (
            <article
              className={`workspace-module-section ${
                isPlannedSection ? "planned-module-section" : "live-module-section"
              }`}
              key={section.title}
            >
              <header className="workspace-section-header">
                <div>
                  <span className="workspace-section-kicker">
                    {isPlannedSection ? "Future roadmap" : "Live workflow"}
                  </span>
                  <h2>{section.title}</h2>
                  {section.description ? <p>{section.description}</p> : null}
                </div>
              </header>

              <div className="grid workspace-card-grid">
                {cards.map((card) => renderWorkspaceCard(card, section.title))}
              </div>
            </article>
          );
        })}
      </section>
    </div>
  );
}


function ModuleFrame({
  title,
  setModule,
  previous,
  canGoBack,
  children
}) {
  const details = getModuleFrameDetails(title);
  const hasNextStep = Boolean(details.nextModule);

  function returnToWorkspace() {
    setModule("home");
  }

  function goToNextStep() {
    if (details.nextModule) {
      setModule(details.nextModule);
    }
  }

  return (
    <section className="module-frame">
      <header className="module-frame-header">
        <div className="module-frame-copy">
          <span className="module-context">{details.group}</span>
          <h2>{details.displayTitle}</h2>
          <p className="module-description">{details.description}</p>
          {details.position ? (
            <span className="module-position">{details.position}</span>
          ) : null}
        </div>

        <div className="module-frame-actions">
          <button
            type="button"
            className="module-secondary-button"
            onClick={canGoBack ? previous : returnToWorkspace}
          >
            {canGoBack ? "Back" : "Return to Workspace"}
          </button>

          <button
            type="button"
            className="module-secondary-button"
            onClick={returnToWorkspace}
          >
            Return to Workspace
          </button>

          {hasNextStep ? (
            <button
              type="button"
              className="module-next-button"
              onClick={goToNextStep}
            >
              Next: {details.nextLabel}
            </button>
          ) : null}
        </div>
      </header>

      <div className="module-frame-body">
        {children}
      </div>
    </section>
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
        {results.map(r => (
          <Card
            key={r.name}
            title={r.name}
            status={r.ok ? "Healthy" : "Network Error"}
            text={`HTTP: ${r.http} | ${r.ms} ms`}
            bad={!r.ok}
          />
        ))}
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
        {results.map(r => (
          <Card
            key={r.name}
            title={r.name}
            status={r.ok ? "PASS" : "FAIL"}
            text={r.path}
            bad={!r.ok}
          />
        ))}
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


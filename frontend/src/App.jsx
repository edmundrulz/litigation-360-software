import MatterIntakeWizard from './pages/MatterIntakeWizard.jsx';
import React, { useEffect, useState } from "react";
import "./App.css";
import { MenuPlatform } from "./features/menu-platform";
import KeyboardShortcutsHelp from "./components/KeyboardShortcutsHelp";

import Clients from "./pages/Clients";
import Cases from "./pages/Cases";
import Matters from "./pages/Matters";
import Deadlines from "./pages/Deadlines";
import Documents from "./pages/Documents";
import Staff from "./pages/Staff";
import ClientIntakeDiscovery from "./pages/ClientIntakeDiscovery";

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
    label: "START WORKFLOW",
    title: "Begin Guided Workflow",
    description: "Begin the guided legal workflow from preliminary triage through engagement preview.",
    items: [
      {
        module: "Client Intake Discovery",
        title: "Preliminary Assessment & Triage",
        status: "OPEN",
        sequence: "1",
        text: "Stage 1 triage for client instructions, urgency, risk, documents, objectives, and engagement readiness.",
      },
      {
        module: "Matter Intake",
        title: "Matter Opening & Client Gate",
        status: "OPEN",
        sequence: "2",
        text: "Stage 2 workspace for client search, duplicate prevention, client linking, new-client preparation, and matter-opening progression.",
      },
      {
        module: "Clients",
        title: "Client Details / Authority & Conflict",
        status: "OPEN",
        sequence: "3",
        text: "Client records, contacts, onboarding and profile management.",
      },
    ],
  },
  {
    id: "active-legal-work",
    label: "ACTIVE WORK",
    title: "Active Legal Work",
    description: "Manage active case, matter, court, and document work.",
    items: [
      {
        module: "Cases",
        title: "Case / Matter Details",
        status: "OPEN",
        sequence: "4",
        text: "Case files, parties, progress and litigation status.",
      },
      {
        module: "Matters",
        title: "Matter Workspace",
        status: "OPEN",
        sequence: "5",
        text: "Matter workspace and legal file tracking.",
      },
      {
        module: "Court Dates",
        title: "Court Dates",
        status: "OPEN",
        sequence: "6",
        text: "Hearings, mentions, deadlines and reminders.",
      },
      {
        module: "Documents",
        title: "Documents & Evidence Readiness",
        status: "OPEN",
        sequence: "7",
        text: "Drafts, filings, templates, evidence and archives.",
      },
    ],
  },
  {
    id: "review-completion",
    label: "COMPLETION",
    title: "Review And Completion",
    description: "Review the prepared workflow before save or submission.",
    items: [
      {
        module: "Review Submit",
        title: "Draft Engagement Preview",
        status: "OPEN",
        sequence: "8",
        text: "Final review point before saving, submission, or future workflow handoff.",
      },
    ],
  },
  {
    id: "office-admin",
    label: "ADMIN",
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
    label: "FUTURE",
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
    description: "Guided Stage 2 workspace for duplicate prevention, client linking, new-client preparation, and matter-opening readiness.",
    position: "Stage 2 · Client Gate",
    nextModule: "Clients",
    nextLabel: "Client Details / Authority & Conflict",
  },
  "Client Intake Discovery": {
    displayTitle: "Preliminary Assessment & Triage",
    group: "Start Here",
    description: "Guided preliminary intake review before conflict clearance, engagement approval, and matter opening.",
    position: "Preliminary Assessment",
    nextModule: "Clients",
    nextLabel: "Client Details / Authority & Conflict",
  },
  Clients: {
    displayTitle: "Client Details / Authority & Conflict",
    group: "Start Here",
    description: "Client records, contact information, onboarding, and profile management.",
    position: "Workflow Node: Client Details / Authority & Conflict · OPEN",
    nextModule: "Cases",
    nextLabel: "Case / Matter Details",
  },
  Cases: {
    displayTitle: "Case / Matter Details",
    group: "Active Legal Work",
    description: "Case files, parties, progress, and litigation status.",
    position: "Workflow Node: Case / Matter Details · OPEN",
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
    position: "Workflow Node: Court Dates · OPEN",
    nextModule: "Documents",
    nextLabel: "Documents & Evidence Readiness",
  },
  Documents: {
    displayTitle: "Documents & Evidence Readiness",
    group: "Active Legal Work",
    description: "Drafts, filings, templates, evidence, and document management.",
    position: "Workflow Node: Documents & Evidence Readiness · OPEN",
    nextModule: "Review Submit",
    nextLabel: "Draft Engagement Preview",
  },
  "Draft Engagement Preview": {
    displayTitle: "Draft Engagement Preview",
    group: "Review And Completion",
    description: "Final review point before saving, submission, or future workflow handoff.",
    position: "Workflow Node: Draft Engagement Preview · OPEN",
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

const moduleRouteAliases = {
  "Client Details / Authority & Conflict": "Clients",
  "Case / Matter Details": "Cases",
  "Matter Workspace": "Matters",
  "Documents & Evidence Readiness": "Documents",
  "Draft Engagement Preview": "Review Submit",
  "Review And Completion": "Review Submit",
  "Completion Review And Completion": "Review Submit",
};


function computeRequiredProgress(items) {
  const safeItems = Array.isArray(items) ? items : [];
  const requiredItems = safeItems.filter((item) => item.required !== false);
  const totalRequired = requiredItems.length;
  const completedRequired = requiredItems.filter((item) => Boolean(item.complete)).length;
  const missingRequired = Math.max(totalRequired - completedRequired, 0);
  const percentage = totalRequired > 0 ? Math.round((completedRequired / totalRequired) * 100) : 0;

  let label = "No required items";
  if (totalRequired > 0 && percentage === 100) label = "Complete";
  else if (totalRequired > 0 && percentage > 0) label = "In progress";
  else if (totalRequired > 0) label = "Not started";

  return {
    totalRequired,
    completedRequired,
    missingRequired,
    percentage,
    label,
  };
}

function PageRequiredProgressCard({ title, items, note }) {
  const progress = computeRequiredProgress(items);

  return (
    <section className="workflow-progress-dashboard" aria-label={`${title} progress`}>
      <div className="workflow-progress-dashboard-header">
        <div>
          <p className="workflow-progress-dashboard-kicker">Required Completion</p>
          <h3>{title}</h3>
          <p>{note || "Real required-item progress for this page."}</p>
        </div>
        <div className="workflow-progress-dashboard-total">
          <strong>{progress.percentage}%</strong>
          <span>{progress.label}</span>
        </div>
      </div>

      <div className="workflow-progress-dashboard-metrics">
        <div>
          <strong>{progress.totalRequired}</strong>
          <span>Required</span>
          <small>Total required items</small>
        </div>
        <div>
          <strong>{progress.completedRequired}</strong>
          <span>Complete</span>
          <small>Required items completed</small>
        </div>
        <div>
          <strong>{progress.missingRequired}</strong>
          <span>Missing</span>
          <small>Required items still pending</small>
        </div>
      </div>
    </section>
  );
}
function isEditableKeyboardTarget(target) {
  if (!target || typeof target.closest !== "function") return false;

  return Boolean(
    target.closest(
      "input, textarea, select, [contenteditable='true'], [role='textbox']"
    )
  );
}

function isSaveShortcut(event) {
  return (
    (event.ctrlKey || event.metaKey) &&
    !event.altKey &&
    !event.shiftKey &&
    event.key.toLowerCase() === "s"
  );
}

function isQuestionShortcut(event) {
  return (
    event.key === "?" &&
    !event.ctrlKey &&
    !event.metaKey &&
    !event.altKey
  );
}
function normalizeWorkspaceModule(moduleName) {
  return moduleRouteAliases[moduleName] || moduleName;
}

export default function App() {
  const [view, setView] = useState("workspace");
  const [module, setModule] = useState("home");
  const [moduleHistory, setModuleHistory] = useState([]);
  const [results, setResults] = useState([]);
  const [updated, setUpdated] = useState("Pending");
  const [keyboardHelpOpen, setKeyboardHelpOpen] = useState(false);

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
    const resolvedModule = normalizeWorkspaceModule(nextModule);

    if (resolvedModule === module) return;

    if (resolvedModule === "home") {
      setModuleHistory([]);
      setModule("home");
      return;
    }

    setModuleHistory((previousHistory) => [...previousHistory, module]);
    setModule(resolvedModule);
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

  function handleMenuTarget(rawTarget) {
    const normalizedTarget = String(rawTarget || "").toLowerCase();

    if (normalizedTarget === "home") {
      openWorkspace();
    }
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
            onNavigate={handleMenuTarget}
            onAction={(item) => {
              handleMenuTarget(item?.id || item?.target || item?.route);
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

      <KeyboardShortcutsHelp open={keyboardHelpOpen} onClose={() => setKeyboardHelpOpen(false)} />

      <main className="main">
        <header className="topbar">
          <div>
            <h1>{viewTitle(view, module)}</h1>
            <p className="topbar-status-line">
              <span className="topbar-updated-prefix">Real-time legal operations workspace. Last updated:</span>
              <span className="topbar-updated-value">{updated}</span>
            </p>
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
    workspace: "LEOS Legal Workspace Command Hub",
    operations: "Operations Centre",
    admin: "Admin Centre",
    developer: "Developer Centre"
  }[view];
}

function Workspace({ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated }) {
  if (module === "Client Intake Discovery") {
    return (
      <ModuleFrame title="Preliminary Assessment & Triage" setModule={setModule} previous={previous} canGoBack={canGoBack}>
        <ClientIntakeDiscovery />
      </ModuleFrame>
    );
  }
  if (module === "Clients") return <ModuleFrame title="Clients" setModule={setModule} previous={previous} canGoBack={canGoBack}><Clients setModule={setModule} /></ModuleFrame>;
  if (module === "Cases") return <ModuleFrame title="Cases" setModule={setModule} previous={previous} canGoBack={canGoBack}><Cases /></ModuleFrame>;
  if (module === "Matters") return <ModuleFrame title="Matters" setModule={setModule} previous={previous} canGoBack={canGoBack}><Matters /></ModuleFrame>;
  if (module === "Court Dates") return <ModuleFrame title="Court Dates" setModule={setModule} previous={previous} canGoBack={canGoBack}><Deadlines /></ModuleFrame>;
  if (module === "Documents" || module === "Documents & Evidence Readiness") return <ModuleFrame title="Documents & Evidence Readiness" setModule={setModule} previous={previous} canGoBack={canGoBack}><Documents /></ModuleFrame>;
  if (module === "Staff") return <ModuleFrame title="Staff" setModule={setModule} previous={previous} canGoBack={canGoBack}><Staff /></ModuleFrame>;
  if (module === "Review Submit" || module === "Draft Engagement Preview" || module === "Review And Completion" || module === "Completion Review And Completion") {
    return (
      <ModuleFrame title="Draft Engagement Preview" setModule={setModule} previous={previous} canGoBack={canGoBack}>
        <ReviewSubmit setModule={setModule} />
      </ModuleFrame>
    );
  }
  if (module === "Matter Intake") {
    return (
      <ModuleFrame
        title="Matter Intake"
        setModule={setModule}
        previous={previous}
        canGoBack={canGoBack}
        showActions={false}
      >
        <MatterIntakeWizard setModule={setModule} />
      </ModuleFrame>
    );
  }

  return (
    <>
      <section className="hero">
        <h2>Litigation 360 LEOS Workspace</h2>
        <p>Level 10/11 enterprise legal operating system command grid. Open modules are live. Planned modules are visible roadmap placeholders.</p>
        <section
          aria-label="Legal Operations Command Centre"
          style={{
            marginTop: 16,
            background: "#fff",
            border: "1px solid #EAECF0",
            borderRadius: 16,
            boxShadow: "0 2px 8px rgba(16,24,40,0.06)",
            padding: 16,
          }}
        >
          <h3 style={{ margin: 0, fontSize: 18, color: "#101828", fontWeight: 700 }}>
            Legal Operations Command Centre
          </h3>
          <p style={{ margin: "6px 0 14px", color: "#475467", fontSize: 13 }}>
            Priority-driven legal operations overview, today’s tasks, alerts, and quick controls.
          </p>

          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(250px, 1fr))", gap: 12 }}>
            <article style={{ border: "1px solid #EAECF0", borderRadius: 12, padding: 12 }}>
              <strong>Priority Actions</strong>
              <div style={{ display: "grid", gap: 8, marginTop: 10 }}>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #FDA29B", background: "#FEF3F2", color: "#B42318", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Urgent court deadlines</span><span>3</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #FEC84B", background: "#FFFAEB", color: "#B54708", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Client approvals pending</span><span>2</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #C3B5FD", background: "#F9F5FF", color: "#6941C6", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Filing blocked</span><span>1</span>
                </div>
              </div>
            </article>

            <article style={{ border: "1px solid #EAECF0", borderRadius: 12, padding: 12 }}>
              <strong>Today’s Tasks</strong>
              <ul style={{ margin: "10px 0 0", paddingLeft: 18, display: "grid", gap: 8, color: "#175CD3", fontWeight: 600 }}>
                <li>Review witness bundle</li>
                <li>Approve draft affidavit</li>
                <li>Confirm client meeting</li>
                <li>File amended pleadings</li>
              </ul>
            </article>

            <article style={{ border: "1px solid #EAECF0", borderRadius: 12, padding: 12 }}>
              <strong>Notifications & Alerts</strong>
              <div style={{ display: "grid", gap: 8, marginTop: 10 }}>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #FDA29B", background: "#FEF3F2", color: "#B42318", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Overdue</span><span>2</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #FEC84B", background: "#FFFAEB", color: "#B54708", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Due today</span><span>4</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #84CAFF", background: "#EFF8FF", color: "#175CD3", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Unread alerts</span><span>5</span>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", border: "1px solid #C3B5FD", background: "#F9F5FF", color: "#6941C6", borderRadius: 8, padding: "8px 10px", fontWeight: 600 }}>
                  <span>Blocked items</span><span>1</span>
                </div>
              </div>
            </article>
          </div>

          <div style={{ borderTop: "1px solid #EAECF0", marginTop: 12, paddingTop: 12, display: "flex", gap: 8, flexWrap: "wrap" }}>
            <button type="button" onClick={() => window.alert("Open is a frontend placeholder for now.")}>Open</button>
            <button type="button" onClick={() => window.alert("Assign is a frontend placeholder for now.")}>Assign</button>
            <button type="button" onClick={() => window.alert("Snooze is a frontend placeholder for now.")}>Snooze</button>
            <button type="button" onClick={() => window.alert("Move to KIV is a frontend placeholder for now.")}>Move to KIV</button>
          </div>
        </section>
      </section>

      <section className="summary">
        <Metric label="Modules Online" value={`${passed}/${results.length}`} />
        <Metric label="Modules Failed" value={failed} />
        <Metric label="Last Refresh" value={updated} />
        <button onClick={runChecks}>Refresh Now</button>
      </section>
      <section className="workspace-section-list" aria-label="Workspace module groups">
        {workspaceSections.map((section) => (
          <section className="workspace-module-section" key={section.id}>
            <div className="workspace-section-header">
              <div className="workspace-section-heading">
                <span className="workflow-badge">{section.label}</span>
                <h3>{section.title}</h3>
                <p>{section.description}</p>
              </div>
            </div>

            <div className="grid">
              {section.items.map((item) => {
                const isOpen = item.status === "OPEN";

                return (
                  <button
                    key={`${section.id}-${item.module}`}
                    type="button"
                    className={isOpen ? "card clickable-card workflow-card" : "card planned-card workflow-card"}
                    onClick={() => isOpen && setModule(item.module)}
                    disabled={!isOpen}
                  >
                    <span className="card-meta">{item.sequence}</span>
                    <div className="workflow-card-header">
                      <h3 className="workflow-card-title">{item.title}</h3>
                      <strong className={`workflow-status-badge ${isOpen ? "is-open" : "is-planned"}`}>
                        {item.status}
                      </strong>
                    </div>
                    <p>{item.text}</p>
                  </button>
                );
              })}
            </div>
          </section>
        ))}
      </section>
    </>
  );
}

function ReviewSubmit({ setModule }) {
  return (
    <section className="card review-submit-screen">
      <div className="module-step-header">
        <span className="pill">Workflow Node</span>
        <span className="pill good">OPEN</span>
      </div>

      <p className="eyebrow">Completion Review And Completion</p>

      <h2>Draft Engagement Preview</h2>

      <p>
        Review the prepared workflow before save or submission.
      </p>

      <div className="summary">
        <Metric label="Workflow Node" value="Draft Engagement Preview · OPEN" />
        <Metric label="Status" value="OPEN" />
        <Metric label="Workflow Context" value="Final Review Node" />
      </div>

      <article className="card">
        <h3>Final review point before saving, submission, or future workflow handoff.</h3>
        <p>
          This screen confirms that the workflow has reached the final review stage.
          Future save, submission, approval, handoff, audit, and backend persistence workflows
          can be connected here.
        </p>
      </article>

      <div className="actions">
        <button type="button" onClick={() => setModule("Documents")}>
          Back to Document Details
        </button>

        <button type="button" onClick={() => setModule("home")}>
          Return to Main Workspace
        </button>

        <button type="button" disabled>
          Save & Submit - Future Backend Action
        </button>
      </div>
    </section>
  );
}

function ModuleFrame({
  title,
  setModule,
  previous,
  canGoBack,
  showActions = true,
  children
}) {
  const previousMap = {
    "Clients": "home",
    "Cases": "Clients",
    "Matters": "Clients",
    "Court Dates": "Cases",
    "Documents": "Court Dates",
    "Documents & Evidence Readiness": "Court Dates",
    "Draft Engagement Preview": "Documents",
    "Review Submit": "Documents",
    "Staff": "home",
    "Matter Intake": "Client Intake Discovery",
    "Client Intake Discovery": "home",
    "Preliminary Assessment & Triage": "home",
    "Client Intake & Preliminary Assessment": "home",
    "Client Intake & Preliminary Matter Assessment": "home",
};

  const nextMap = {
    "Clients": "Cases",
    "Cases": "Court Dates",
    "Matters": "Court Dates",
    "Court Dates": "Documents",
    "Documents": "Review Submit",
    "Documents & Evidence Readiness": "Review Submit",
    "Client Intake Discovery": "Matter Intake",
    "Preliminary Assessment & Triage": "Matter Intake",
    "Matter Intake": "Clients",
    "Client Intake & Preliminary Assessment": "Matter Intake",
    "Client Intake & Preliminary Matter Assessment": "Matter Intake",
};

  const previousTarget = previousMap[title] || "home";
  const isPostPage3Module = [
    "Cases",
    "Court Dates",
    "Documents",
    "Documents & Evidence Readiness",
    "Draft Engagement Preview",
    "Review Submit",
  ].includes(title);

  const hasRenderableChildren = Boolean(children);

  const pageProgressItems = (() => {
    if (title === "Cases") {
      return [
        { label: "Case / Matter details section available", required: true, complete: hasRenderableChildren },
      ];
    }

    if (title === "Court Dates") {
      return [
        { label: "Court Dates section available", required: true, complete: hasRenderableChildren },
      ];
    }

    if (title === "Documents" || title === "Documents & Evidence Readiness") {
      return [
        { label: "Documents / Evidence section available", required: true, complete: hasRenderableChildren },
      ];
    }

    if (title === "Draft Engagement Preview" || title === "Review Submit") {
      return [
        { label: "Final review section available", required: true, complete: hasRenderableChildren },
      ];
    }

    return [];
  })();

  const pageProgressNote = "Current App.jsx exposes module-level completion only. Field-level required items can be expanded when page-specific field models are available.";

  const nextTarget = nextMap[title] || "";

  function goPrevious() {
    if (typeof previous === "function" && canGoBack) {
      previous();
      return;
    }

    setModule(previousTarget || "home");
  }

  function goHome() {
    setModule("home");
  }

  function goNext() {
    if (!nextTarget) {
      setModule("home");
      return;
    }

    setModule(nextTarget);
  }

  function goToPageStart() {
    if (typeof window !== "undefined") {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  function goToPageBottom() {
    if (typeof window !== "undefined") {
      window.scrollTo({
        top: Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
        behavior: "smooth"
      });
    }
  }

  function renderNavigation(position) {
    const isBottom = position === "bottom";

    function jumpToPageEnd() {
      if (typeof window !== "undefined") {
        window.scrollTo({
          top: Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
          behavior: "smooth"
        });
      }
    }

    function jumpToPageStart() {
      if (typeof window !== "undefined") {
        window.scrollTo({ top: 0, behavior: "smooth" });
      }
    }

    return (
      <nav
        className={"module-page-nav module-page-nav-" + position}
        aria-label={position + " workflow page navigation"}
      >
        <button
          type="button"
          className="module-page-nav-button module-page-nav-previous"
          onClick={goPrevious}
          title="Previous Step / Page"
        >← Previous Step / Page</button>

        <button
          type="button"
          className="module-page-nav-button module-page-nav-home"
          onClick={goHome}
          title="Home Main Page"
        >Home Main Page</button>

        <button
          type="button"
          className="module-page-nav-button module-page-nav-next"
          onClick={goNext}
          title="Continue to Next Step / Page"
        >Continue to Next Step / Page →</button>

        <button
          type="button"
          className="module-page-nav-button module-page-nav-jump"
          onClick={isBottom ? jumpToPageStart : jumpToPageEnd}
          title={isBottom ? "Go to Top of Page" : "Go to Bottom/End of Page"}
        >
          {isBottom ? "Go to Top of Page ↑" : "Go to Bottom/End of Page ↓"}
        </button>
      </nav>
    );
  }

  return (
    <section className="module-frame">
      {showActions && renderNavigation("top")}

      {title === "Matter Intake" ? null : (
        <div className="module-frame-header">
          <div>
            <p className="eyebrow">Workflow module</p>
            <h2>{title}</h2>
            <p className="workflow-node-label">Current Node: {title} · OPEN</p>
          </div>
        </div>
      )}

      <div className="module-frame-body">
        {isPostPage3Module ? (
          <PageRequiredProgressCard title={title} items={pageProgressItems} note={pageProgressNote} />
        ) : null}
        {children}
      </div>

      {showActions && renderNavigation("bottom")}
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

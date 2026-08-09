import MatterIntakeWizard from './pages/MatterIntakeWizard.jsx';
import React, { lazy, Suspense, useEffect, useRef, useState } from "react";
import "./App.css";
import { MenuPlatform } from "./features/menu-platform";
import WorkflowPageNavigation from "./features/menu-platform/WorkflowPageNavigation";
import KeyboardShortcutsHelp from "./components/KeyboardShortcutsHelp";

import Clients from "./pages/Clients";
import Cases from "./pages/Cases";
import Matters from "./pages/Matters";
import Deadlines from "./pages/Deadlines";
import Documents from "./pages/Documents";
import Staff from "./pages/Staff";
import ClientIntakeDiscovery from "./pages/ClientIntakeDiscovery";
import SecurityAccessConsole from "./pages/SecurityAccessConsole";
const LegalReferenceWorkspace = lazy(() => import("./features/legal-reference/LegalReferenceWorkspace"));
const LegalAuthoritiesModule = lazy(() => import("./features/legal-authorities/LegalAuthoritiesModule"));

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
      {
        module: "Security Access",
        title: "Login, Lockout & Access Monitoring",
        status: "OPEN",
        sequence: "B",
        text: "Adaptive sign-in, step-up verification, session monitoring and forced logout control.",
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
  "Security Access": {
    displayTitle: "Login, Lockout & Access Monitoring",
    group: "Office Administration",
    description: "Adaptive sign-in, step-up verification, session monitoring and forced logout control.",
    position: "Administration Security",
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

const legalSidebarTools = [
  { id: "legal-links", label: "Legal Web Links", icon: "link", roles: ["staff", "administrator", "system"] },
  { id: "apps-docs", label: "Launch Apps / Docs", icon: "briefcase", roles: ["staff", "administrator", "system"] },
  { id: "search-repository", label: "Search Repository", icon: "folder", roles: ["staff", "administrator", "system"] },
  { id: "instructions", label: "Instructions / Guides", icon: "book", roles: ["staff", "administrator", "system"] },
  { id: "glossary", label: "Legal Glossary", icon: "scales", roles: ["staff", "administrator", "system"] },
  { id: "legal-news", label: "MY / SG Legal News", icon: "news", roles: ["staff", "administrator", "system"] },
  { id: "settings", label: "Settings", icon: "gear", roles: ["administrator", "system"] }
];

const iconPaths = {
  workspace: ["M3 3h7v7H3z", "M14 3h7v7h-7z", "M3 14h7v7H3z", "M14 14h7v7h-7z"],
  operations: ["M4 19V9", "M10 19V5", "M16 19v-7", "M22 19V3"],
  admin: ["M12 3l8 4v5c0 5-3.4 8-8 9-4.6-1-8-4-8-9V7z", "M9 12l2 2 4-5"],
  developer: ["M8 9l-4 3 4 3", "M16 9l4 3-4 3", "M14 5l-4 14"],
  legal: ["M12 3v18", "M7 6h10", "M5 6l-3 6h6z", "M19 6l-3 6h6z", "M8 21h8"],
  link: ["M10 13a5 5 0 0 0 7.1.1l2-2a5 5 0 0 0-7.1-7.1l-1.1 1.1", "M14 11a5 5 0 0 0-7.1-.1l-2 2A5 5 0 0 0 12 20l1.1-1.1"],
  briefcase: ["M4 7h16v13H4z", "M9 7V4h6v3", "M4 12h16"],
  folder: ["M3 6h7l2 2h9v11H3z"],
  book: ["M4 5a4 4 0 0 1 4-1h4v16H8a4 4 0 0 0-4 1z", "M20 5a4 4 0 0 0-4-1h-4v16h4a4 4 0 0 1 4 1z"],
  scales: ["M12 3v18", "M6 6h12", "M6 6l-3 6h6z", "M18 6l-3 6h6z", "M8 21h8"],
  news: ["M4 5h13v15H4z", "M17 8h3v12h-3", "M7 9h7", "M7 13h7", "M7 17h4"],
  gear: ["M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8z", "M12 3v2", "M12 19v2", "M3 12h2", "M19 12h2", "M5.6 5.6 7 7", "M17 17l1.4 1.4", "M18.4 5.6 17 7", "M7 17l-1.4 1.4"],
  external: ["M14 4h6v6", "M20 4l-9 9", "M18 13v7H4V6h7"],
  file: ["M6 3h8l4 4v14H6z", "M14 3v5h5"],
  template: ["M4 4h16v16H4z", "M8 4v16", "M8 9h12"],
  court: ["M3 9h18", "M5 9v9", "M10 9v9", "M14 9v9", "M19 9v9", "M2 21h20", "M12 3l9 6H3z"],
  guide: ["M5 3h14v18H5z", "M9 7h6", "M9 11h6", "M9 15h4"],
  client: ["M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8z", "M4 21a8 8 0 0 1 16 0"],
  calendar: ["M4 5h16v16H4z", "M8 3v4", "M16 3v4", "M4 10h16"],
  research: ["M4 4h12v16H4z", "M8 8h4", "M8 12h4", "M18 15l3 3", "M17 12a4 4 0 1 0 0 8 4 4 0 0 0 0-8z"],
  finance: ["M12 3v18", "M16 7.5c0-1.4-1.8-2.5-4-2.5S8 6.1 8 7.5 9.8 10 12 10s4 1.1 4 2.5S14.2 15 12 15s-4-1.1-4-2.5"],
  shield: ["M12 3l8 4v5c0 5-3.4 8-8 9-4.6-1-8-4-8-9V7z"],
  menu: ["M4 7h16", "M4 12h16", "M4 17h16"],
  close: ["M6 6l12 12", "M18 6L6 18"],
};

function UiIcon({ name, size = 20, className = "" }) {
  const paths = iconPaths[name] || iconPaths.workspace;
  return (
    <svg className={`ui-icon ${className}`} width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" focusable="false">
      {paths.map((path, index) => <path key={`${name}-${index}`} d={path} />)}
    </svg>
  );
}

const SESSION_TOKEN_KEY = "l360_adaptive_auth_token";
const SESSION_USER_KEY = "l360_adaptive_auth_user";
const SESSION_STARTED_KEY = "l360_session_started_at";
const FAST_ACCESS_KEY = "l360_fast_access_profile";
const INACTIVITY_TIMEOUT_MS = 30 * 60 * 1000;
const INACTIVITY_WARNING_MS = 60 * 1000;

function getSessionUser() {
  try {
    return JSON.parse(window.sessionStorage.getItem(SESSION_USER_KEY) || "null");
  } catch {
    return null;
  }
}

function getSessionDurationMs() {
  const startedAt = window.sessionStorage.getItem(SESSION_STARTED_KEY);
  if (!startedAt) return 0;
  return Math.max(Date.now() - new Date(startedAt).getTime(), 0);
}

function getAutoLockReason(date = new Date()) {
  void date;
  return "";
}

function clearCurrentSession() {
  window.sessionStorage.removeItem(SESSION_TOKEN_KEY);
  window.sessionStorage.removeItem(SESSION_USER_KEY);
  window.sessionStorage.removeItem(SESSION_STARTED_KEY);
}

function clearFastAccess() {
  window.localStorage.removeItem(FAST_ACCESS_KEY);
}

function saveAuthenticatedSession(data) {
  if (!data?.token) return;
  window.sessionStorage.setItem(SESSION_TOKEN_KEY, data.token);
  window.sessionStorage.setItem(SESSION_USER_KEY, JSON.stringify(data.user || {}));
  window.sessionStorage.setItem(SESSION_STARTED_KEY, new Date().toISOString());
}

function getDisplayUser(user) {
  const safeUser = user || {};
  return {
    name: safeUser.full_name || safeUser.username || safeUser.email || "Signed-in user",
    role: safeUser.role || safeUser.role_id || "Administrator",
    identity: safeUser.username || safeUser.email || ""
  };
}

function normalizeRole(user) {
  const rawRole = String(user?.role || user?.role_id || "").trim().toLowerCase();
  if (["system", "system_admin", "developer", "owner", "super_admin"].includes(rawRole)) return "system";
  if (["administrator", "admin", "firm_admin"].includes(rawRole)) return "administrator";
  return "staff";
}

function canAccessAdmin(user) {
  return ["administrator", "system"].includes(normalizeRole(user));
}

function canAccessDeveloper(user) {
  return normalizeRole(user) === "system";
}

function getVisibleLegalTools(user) {
  const role = normalizeRole(user);
  return legalSidebarTools.filter((tool) => tool.roles.includes(role));
}

function decodeTokenPayload(token) {
  try {
    const payload = token.split(".")[1];
    const normalized = payload.replace(/-/g, "+").replace(/_/g, "/");
    return JSON.parse(window.atob(normalized));
  } catch {
    return {};
  }
}

function describeUiTarget(target) {
  if (!target || typeof target.closest !== "function") return "Unknown control";

  const control = target.closest("button, a, input, select, textarea, [role='button']");
  if (!control) return "Page";

  const label = control.getAttribute("aria-label") ||
    control.getAttribute("title") ||
    control.innerText ||
    control.name ||
    control.id ||
    control.placeholder ||
    control.tagName;

  return String(label || "Control").trim().slice(0, 120);
}

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
  const [authenticated, setAuthenticated] = useState(() => Boolean(window.sessionStorage.getItem(SESSION_TOKEN_KEY)));
  const [lockReason, setLockReason] = useState("");
  const [authScreen, setAuthScreen] = useState(() => Boolean(window.sessionStorage.getItem(SESSION_TOKEN_KEY)) ? "app" : "login");
  const [lockedUser, setLockedUser] = useState(() => getSessionUser());
  const [sessionUser, setSessionUser] = useState(() => getSessionUser());
  const [inactivityWarningOpen, setInactivityWarningOpen] = useState(false);
  const [warningRemaining, setWarningRemaining] = useState(Math.ceil(INACTIVITY_WARNING_MS / 1000));
  const [view, setView] = useState("workspace");
  const [module, setModule] = useState("home");
  const [moduleHistory, setModuleHistory] = useState([]);
  const [activeLegalTool, setActiveLegalTool] = useState("legal-links");
  const [results, setResults] = useState([]);
  const [updated, setUpdated] = useState("Pending");
  const [keyboardHelpOpen, setKeyboardHelpOpen] = useState(false);
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  useEffect(() => {
    if (!mobileNavOpen) return undefined;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const closeOnEscape = (event) => {
      if (event.key === "Escape") setMobileNavOpen(false);
    };
    document.addEventListener("keydown", closeOnEscape);
    return () => {
      document.body.style.overflow = previousOverflow;
      document.removeEventListener("keydown", closeOnEscape);
    };
  }, [mobileNavOpen]);
  const inactivityWarningTimerRef = useRef(null);
  const inactivityLockTimerRef = useRef(null);
  const inactivityCountdownRef = useRef(null);

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

  async function recordActivity(eventType, details = {}) {
    const token = window.sessionStorage.getItem(SESSION_TOKEN_KEY);
    const payload = token ? decodeTokenPayload(token) : {};
    const user = getSessionUser();

    try {
      await fetch("/api/adaptive-auth/audit-event", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          eventType,
          userId: user?.id || payload.userId || null,
          details: {
            ...details,
            sessionId: payload.sessionId || null,
            view,
            module,
            durationMs: getSessionDurationMs(),
            occurredAt: new Date().toISOString()
          }
        })
      });
    } catch {
      // Audit delivery should never block the user's local workflow.
    }
  }

  function lockSystem(reason = "The workspace has been locked.", options = {}) {
    const userBeforeLock = getSessionUser();
    recordActivity(options.eventType || "APP_LOCKED", { reason });
    setLockedUser(userBeforeLock);
    clearCurrentSession();
    setLockReason(reason);
    setAuthScreen("locked");
    setSessionUser(null);
    setInactivityWarningOpen(false);
    setAuthenticated(false);
  }

  function logoutSystem(options = {}) {
    if (!options.skipConfirm) {
      const confirmed = window.confirm("Logout will fully end this authenticated session. Unsaved work may be lost if it has not been saved. Continue?");
      if (!confirmed) return;
    }

    recordActivity("APP_LOGGED_OUT", { reason: options.reason || "User selected logout." });
    clearCurrentSession();
    clearFastAccess();
    setLockedUser(null);
    setSessionUser(null);
    setLockReason("You have logged out. Full sign-in is required for the next entry.");
    setAuthScreen("login");
    setInactivityWarningOpen(false);
    setAuthenticated(false);
  }

  function exitSystem() {
    const confirmed = window.confirm("Exit Application will securely log you out. Unsaved work may be lost if it has not been saved. Continue?");
    if (!confirmed) return;

    recordActivity("APP_EXIT_REQUESTED", { reason: "User selected exit." });
    clearCurrentSession();
    clearFastAccess();
    setLockedUser(null);
    setSessionUser(null);
    setLockReason("The system has been locked for exit. You may now close this browser tab.");
    setAuthScreen("login");
    setInactivityWarningOpen(false);
    setAuthenticated(false);
    window.setTimeout(() => window.close(), 100);
  }

  function handleAuthenticated(data) {
    const user = data?.user || getSessionUser();
    setLockReason("");
    setAuthScreen("app");
    setLockedUser(user);
    setSessionUser(user);
    setAuthenticated(true);
    recordActivity("APP_SESSION_STARTED", { reason: "Gateway approved access." });
  }

  function clearInactivityTimers() {
    window.clearTimeout(inactivityWarningTimerRef.current);
    window.clearTimeout(inactivityLockTimerRef.current);
    window.clearInterval(inactivityCountdownRef.current);
  }

  function resetInactivityTimer() {
    if (!authenticated) return;

    clearInactivityTimers();
    setInactivityWarningOpen(false);
    setWarningRemaining(Math.ceil(INACTIVITY_WARNING_MS / 1000));

    inactivityWarningTimerRef.current = window.setTimeout(() => {
      setInactivityWarningOpen(true);
      setWarningRemaining(Math.ceil(INACTIVITY_WARNING_MS / 1000));
      recordActivity("APP_INACTIVITY_WARNING", {
        warningSeconds: Math.ceil(INACTIVITY_WARNING_MS / 1000)
      });

      inactivityCountdownRef.current = window.setInterval(() => {
        setWarningRemaining((current) => Math.max(current - 1, 0));
      }, 1000);
    }, Math.max(INACTIVITY_TIMEOUT_MS - INACTIVITY_WARNING_MS, 0));

    inactivityLockTimerRef.current = window.setTimeout(() => {
      lockSystem("Your LEOS 360 session was locked because of inactivity.", {
        eventType: "APP_AUTO_LOCKED"
      });
    }, INACTIVITY_TIMEOUT_MS);
  }

  async function unlockWithCredential(password) {
    const user = lockedUser || getSessionUser();
    const displayUser = getDisplayUser(user);

    if (!displayUser.identity || !password) {
      return { ok: false, error: "Enter your password, PIN or approved credential to unlock." };
    }

    try {
      const response = await fetch("/api/adaptive-auth/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          identity: displayUser.identity,
          password,
          requestedModule: "session_unlock"
        })
      });

      const data = await response.json();
      if (!response.ok || !data.token) {
        recordActivity("APP_UNLOCK_FAILED", { reason: data.error || "Unlock failed" });
        return { ok: false, error: data.error || "Unlock failed." };
      }

      saveAuthenticatedSession(data);
      setLockedUser(data.user || user);
      setSessionUser(data.user || user);
      setLockReason("");
      setAuthScreen("app");
      setAuthenticated(true);
      recordActivity("APP_UNLOCKED", { reason: "User re-authenticated from lock screen." });
      return { ok: true };
    } catch {
      return { ok: false, error: "Unlock service is not reachable." };
    }
  }

  useEffect(() => {
    if (!authenticated) return undefined;

    recordActivity("APP_VIEW_ACCESSED", { view, module });
    const interval = window.setInterval(() => {
      recordActivity("APP_HEARTBEAT", { view, module });
      const reason = getAutoLockReason();
      if (reason) lockSystem(reason, { eventType: "APP_AUTO_LOCKED" });
    }, 60000);

    const reason = getAutoLockReason();
    if (reason) {
      window.setTimeout(() => lockSystem(reason, { eventType: "APP_AUTO_LOCKED" }), 0);
    }

    return () => window.clearInterval(interval);
  }, [authenticated, view, module]);

  useEffect(() => {
    if (!authenticated) {
      clearInactivityTimers();
      return undefined;
    }

    const userActivityEvents = ["mousemove", "mousedown", "keydown", "touchstart", "click", "input", "change"];
    resetInactivityTimer();

    function handleUserActivity() {
      resetInactivityTimer();
    }

    userActivityEvents.forEach((eventName) => {
      document.addEventListener(eventName, handleUserActivity, true);
    });

    return () => {
      userActivityEvents.forEach((eventName) => {
        document.removeEventListener(eventName, handleUserActivity, true);
      });
      clearInactivityTimers();
    };
  }, [authenticated, view, module]);

  useEffect(() => {
    if (!authenticated) return undefined;

    function handleClick(event) {
      recordActivity("APP_UI_ACTION", {
        action: "click",
        target: describeUiTarget(event.target)
      });
    }

    function handleSubmit(event) {
      recordActivity("APP_FORM_SUBMITTED", {
        form: describeUiTarget(event.target)
      });
    }

    function handleChange(event) {
      const field = event.target?.name || event.target?.id || event.target?.placeholder || event.target?.tagName || "field";
      recordActivity("APP_FIELD_CHANGED", {
        field: String(field).slice(0, 80),
        inputType: event.target?.type || event.target?.tagName || "unknown"
      });
    }

    function handleCopy() {
      recordActivity("APP_COPY_EVENT", {
        action: "copy"
      });
    }

    document.addEventListener("click", handleClick, true);
    document.addEventListener("submit", handleSubmit, true);
    document.addEventListener("change", handleChange, true);
    document.addEventListener("copy", handleCopy, true);

    return () => {
      document.removeEventListener("click", handleClick, true);
      document.removeEventListener("submit", handleSubmit, true);
      document.removeEventListener("change", handleChange, true);
      document.removeEventListener("copy", handleCopy, true);
    };
  }, [authenticated, view, module]);

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

  function openLegalTool(toolId) {
    setActiveLegalTool(toolId);
    setView("legal-tools");
    setModuleHistory([]);
    setModule("home");
    setMobileNavOpen(false);
  }

  function openPrimaryView(nextView) {
    setView(nextView);
    setMobileNavOpen(false);
  }

  if (!authenticated && authScreen === "locked") {
    return (
      <LockedSessionScreen
        user={lockedUser}
        reason={lockReason}
        onUnlock={unlockWithCredential}
        onLogout={() => logoutSystem({ skipConfirm: true, reason: "User selected logout from locked screen." })}
      />
    );
  }

  if (!authenticated) {
    return <SecurityAccessConsole mode="gateway" lockedReason={lockReason} onAuthenticated={handleAuthenticated} />;
  }

  const currentUser = getDisplayUser(sessionUser);
  const visibleLegalTools = getVisibleLegalTools(sessionUser);
  const userCanAccessAdmin = canAccessAdmin(sessionUser);
  const userCanAccessDeveloper = canAccessDeveloper(sessionUser);

  return (
    <div className="shell">
      <button className="mobile-nav-trigger" type="button" aria-label="Open navigation" aria-expanded={mobileNavOpen} aria-controls="primary-navigation" onClick={() => setMobileNavOpen(true)}>
        <UiIcon name="menu" size={24} />
        <span>Menu</span>
      </button>
      {mobileNavOpen && <button className="mobile-nav-backdrop" type="button" aria-label="Close navigation" onClick={() => setMobileNavOpen(false)} />}
      <aside id="primary-navigation" className={`sidebar ${mobileNavOpen ? "is-open" : ""}`} aria-label="Primary navigation">
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

        <button className={view === "workspace" ? "active primary-nav-button" : "primary-nav-button"} onClick={() => { openWorkspace(); setMobileNavOpen(false); }}>
          <UiIcon name="workspace" /><span>End User Workspace</span>
        </button>

        <button className={view === "operations" ? "active primary-nav-button" : "primary-nav-button"} onClick={() => openPrimaryView("operations")}>
          <UiIcon name="operations" /><span>Operations Centre</span>
        </button>

        {userCanAccessAdmin && (
          <button className={view === "admin" ? "active primary-nav-button" : "primary-nav-button"} onClick={() => openPrimaryView("admin")}>
            <UiIcon name="admin" /><span>Admin Centre</span>
          </button>
        )}

        {userCanAccessDeveloper && (
          <button className={view === "developer" ? "active primary-nav-button" : "primary-nav-button"} onClick={() => openPrimaryView("developer")}>
            <UiIcon name="developer" /><span>Developer Centre</span>
          </button>
        )}

        <button className={view === "legal-authorities" ? "active primary-nav-button" : "primary-nav-button"} onClick={() => openPrimaryView("legal-authorities")}>
          <UiIcon name="legal" /><span>Legal Authorities</span>
        </button>

        <div className="sidebar-section" aria-label="Legal tools">
          <div className="sidebar-section-title">
            <span className="sidebar-section-icon"><UiIcon name="legal" size={18} /></span>
            <span>LEGAL TOOLS</span>
          </div>

          <div className="sidebar-tool-list">
            {visibleLegalTools.map((tool) => (
              <button
                key={tool.id}
                type="button"
                className={view === "legal-tools" && activeLegalTool === tool.id ? "sidebar-tool-button active" : "sidebar-tool-button"}
                onClick={() => openLegalTool(tool.id)}
              >
                <span className="sidebar-tool-icon" aria-hidden="true"><UiIcon name={tool.icon} size={18} /></span>
                <span>{tool.label}</span>
              </button>
            ))}
          </div>
        </div>

        <div className="sidebar-session-area" aria-label="Session menu">
          <div className="sidebar-user-card">
            <div className="sidebar-user-avatar" aria-hidden="true">
              {currentUser.name.slice(0, 1).toUpperCase()}
            </div>
            <div>
              <strong>{currentUser.name}</strong>
              <span>{currentUser.role}</span>
              <small>Session active</small>
            </div>
          </div>

          <details className="sidebar-session-menu">
            <summary>Session Controls</summary>
            <div className="sidebar-session-options">
              <button type="button" onClick={() => lockSystem("Locked by user. Fast access remains available today.")}>
                Lock Screen
              </button>
              <button type="button" onClick={logoutSystem}>
                Logout
              </button>
              <button type="button" onClick={exitSystem}>
                Exit Application
              </button>
            </div>
          </details>
        </div>
      </aside>

      <KeyboardShortcutsHelp open={keyboardHelpOpen} onClose={() => setKeyboardHelpOpen(false)} />

      <main className="main">
        <header className="topbar">
          <div>
            <h1 className="page-title"><span className="page-title-icon"><UiIcon name={viewIcon(view)} size={24} /></span><span>{viewTitle(view, module)}</span></h1>
            <p className="topbar-status-line">
              <span className="topbar-updated-prefix">Real-time legal operations workspace. Last updated:</span>
              <span className="topbar-updated-value">{updated}</span>
            </p>
          </div>

          <span className={failed ? "pill bad" : "pill good"}>
            {failed ? "BACKEND CHECK REQUIRED" : `${passed}/${results.length || passed} SERVICES HEALTHY`}
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
            user={sessionUser}
          />
        )}

        {view === "operations" && <Operations results={results} run={runChecks} passed={passed} failed={failed} />}
        {view === "admin" && (userCanAccessAdmin ? <Admin user={sessionUser} /> : <AccessDenied />)}
        {view === "developer" && (userCanAccessDeveloper ? <Developer results={results} /> : <AccessDenied />)}
        {view === "legal-authorities" && <Suspense fallback={<div className="legal-reference-loading" role="status"><UiIcon name="legal" /><span>Loading Legal Authorities…</span></div>}><LegalAuthoritiesModule user={sessionUser} /></Suspense>}
        {view === "legal-tools" && <LegalToolPanel activeTool={activeLegalTool} setActiveTool={setActiveLegalTool} />}

        {inactivityWarningOpen && (
          <SessionWarningDialog
            seconds={warningRemaining}
            onStayLoggedIn={resetInactivityTimer}
            onLockNow={() => lockSystem("Locked by user from inactivity warning. Fast access remains available today.")}
          />
        )}

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
    developer: "Developer Centre",
    "legal-tools": "Legal Tools",
    "legal-authorities": "Legal Authorities & Knowledge"
  }[view];
}

function viewIcon(view) {
  return {
    workspace: "workspace",
    operations: "operations",
    admin: "admin",
    developer: "developer",
    "legal-tools": "legal",
    "legal-authorities": "legal",
  }[view] || "workspace";
}

function SessionWarningDialog({ seconds, onStayLoggedIn, onLockNow }) {
  useEffect(() => {
    function handleKeyDown(event) {
      if (event.key === "Enter" || event.key === "Escape") {
        onStayLoggedIn();
      }
    }

    document.addEventListener("keydown", handleKeyDown);
    return () => document.removeEventListener("keydown", handleKeyDown);
  }, [onStayLoggedIn]);

  return (
    <div className="session-warning-backdrop" role="presentation">
      <section className="session-warning-dialog" role="dialog" aria-modal="true" aria-labelledby="sessionWarningTitle">
        <p className="eyebrow">Session security</p>
        <h2 id="sessionWarningTitle">Your session is about to be locked due to inactivity.</h2>
        <p>For your security, the application will lock in <strong>{seconds}</strong> seconds.</p>
        <div className="session-warning-actions">
          <button type="button" onClick={onStayLoggedIn}>Stay Logged In</button>
          <button type="button" className="secondary" onClick={onLockNow}>Lock Now</button>
        </div>
      </section>
    </div>
  );
}

function LockedSessionScreen({ user, reason, onUnlock, onLogout }) {
  const displayUser = getDisplayUser(user);
  const [credential, setCredential] = useState("");
  const [message, setMessage] = useState(reason || "Your LEOS 360 session is locked.");
  const [busy, setBusy] = useState(false);

  async function handleUnlock(event) {
    event.preventDefault();
    setBusy(true);
    setMessage("Checking your credential...");

    const result = await onUnlock(credential);
    setBusy(false);

    if (!result.ok) {
      setMessage(result.error || "Unlock failed.");
      setCredential("");
    }
  }

  return (
    <main className="locked-session-screen">
      <section className="locked-session-card" aria-labelledby="lockedSessionTitle">
        <div className="locked-session-brand">
          <div className="locked-session-logo">L360</div>
          <div>
            <strong>LEOS 360</strong>
            <span>Secure workspace lock</span>
          </div>
        </div>

        <h1 id="lockedSessionTitle">Session Locked</h1>
        <p>{message}</p>

        <div className="locked-session-user">
          <div className="sidebar-user-avatar" aria-hidden="true">
            {displayUser.name.slice(0, 1).toUpperCase()}
          </div>
          <div>
            <strong>{displayUser.name}</strong>
            <span>{displayUser.role}</span>
          </div>
        </div>

        <form onSubmit={handleUnlock}>
          <label>
            <span>Password, PIN or approved credential</span>
            <input
              value={credential}
              onChange={(event) => setCredential(event.target.value)}
              type="password"
              autoComplete="current-password"
              placeholder="Enter credential to continue"
              required
            />
          </label>

          <button type="submit" disabled={busy}>
            {busy ? "Unlocking..." : "Unlock"}
          </button>
        </form>

        <button className="locked-session-logout" type="button" onClick={onLogout}>
          Logout Instead
        </button>
      </section>
    </main>
  );
}

function LegalToolPanel({ activeTool, setActiveTool }) {
  void setActiveTool;
  const active = legalSidebarTools.find((tool) => tool.id === activeTool) || legalSidebarTools[0];

  const panelMap = {
    "legal-links": (
      <div className="legal-tool-grid">
        <a href="https://www.kehakiman.gov.my/" target="_blank" rel="noreferrer"><UiIcon name="court" />Malaysian Judiciary<UiIcon name="external" size={16} /></a>
        <a href="https://efs.kehakiman.gov.my/" target="_blank" rel="noreferrer"><UiIcon name="file" />Court E-Filing<UiIcon name="external" size={16} /></a>
        <a href="https://lom.agc.gov.my/" target="_blank" rel="noreferrer"><UiIcon name="legal" />Laws of Malaysia<UiIcon name="external" size={16} /></a>
        <a href="https://www.elitigation.sg/" target="_blank" rel="noreferrer"><UiIcon name="court" />Singapore eLitigation<UiIcon name="external" size={16} /></a>
      </div>
    ),
    "apps-docs": (
      <div className="legal-tool-grid">
        <button type="button"><UiIcon name="client" />Open client document folder</button>
        <button type="button"><UiIcon name="template" />Open matter templates</button>
        <button type="button"><UiIcon name="court" />Open court forms</button>
        <button type="button"><UiIcon name="guide" />Open internal SOP library</button>
      </div>
    ),
    "search-repository": (
      <div className="legal-tool-search">
        <input placeholder="Search clients, matters, documents, deadlines, folders..." />
        <div className="legal-tool-grid">
          <button type="button"><UiIcon name="client" />Client Files</button>
          <button type="button"><UiIcon name="folder" />Matter Folders</button>
          <button type="button"><UiIcon name="file" />Documents</button>
          <button type="button"><UiIcon name="calendar" />Deadlines</button>
          <button type="button"><UiIcon name="research" />Legal Research</button>
          <button type="button"><UiIcon name="finance" />Billing / Finance</button>
        </div>
      </div>
    ),
    instructions: (
      <div className="legal-tool-list">
        <button type="button"><UiIcon name="guide" />Getting Started Guide</button>
        <button type="button"><UiIcon name="client" />Client Intake Workflow</button>
        <button type="button"><UiIcon name="briefcase" />Matter Opening SOP</button>
        <button type="button"><UiIcon name="file" />Document Upload & Review Guide</button>
        <button type="button"><UiIcon name="calendar" />Deadline Monitoring Guide</button>
        <button type="button"><UiIcon name="shield" />Security, RBAC & Audit SOP</button>
      </div>
    ),
    glossary: <Suspense fallback={<div className="legal-reference-loading" role="status"><UiIcon name="glossary" size={20} /><span>Loading complete legal dictionary…</span></div>}><LegalReferenceWorkspace /></Suspense>,
    "legal-news": (
      <div className="legal-tool-grid">
        <a href="https://www.malaysianbar.org.my/" target="_blank" rel="noreferrer"><UiIcon name="news" />Malaysian Bar<UiIcon name="external" size={16} /></a>
        <a href="https://www.agc.gov.my/" target="_blank" rel="noreferrer"><UiIcon name="legal" />Attorney General's Chambers Malaysia<UiIcon name="external" size={16} /></a>
        <a href="https://www.lawsociety.org.sg/" target="_blank" rel="noreferrer"><UiIcon name="news" />Law Society of Singapore<UiIcon name="external" size={16} /></a>
        <a href="https://www.judiciary.gov.sg/" target="_blank" rel="noreferrer"><UiIcon name="court" />Singapore Courts<UiIcon name="external" size={16} /></a>
      </div>
    ),
    settings: (
      <div className="legal-tool-grid">
        <article><strong>User Preferences</strong><span>Language, default dashboard and quick links.</span></article>
        <article><strong>Display Settings</strong><span>Theme, density, font size and layout mode.</span></article>
        <article><strong>Notifications</strong><span>Email, in-app alerts and deadline reminders.</span></article>
        <article><strong>Access Controls</strong><span>Roles, permissions, module visibility and audit controls.</span></article>
      </div>
    )
  };

  return (
    <section className="legal-tool-panel">
      <article className="legal-tool-card">
        <p className="eyebrow">Legal Tools</p>
        <h2><UiIcon name={active.icon} size={24} /><span>{active.label}</span></h2>
        {panelMap[active.id]}
      </article>
    </section>
  );
}

function Workspace({ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated, user }) {
  const userCanAccessAdmin = canAccessAdmin(user);

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
  if (module === "Security Access") {
    return userCanAccessAdmin ? <ModuleFrame title="Login, Lockout & Access Monitoring" setModule={setModule} previous={previous} canGoBack={canGoBack}><SecurityOperationsPanel /></ModuleFrame> : <AccessDenied />;
  }
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
        showActions
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
        {workspaceSections
          .map((section) => {
            if (section.id !== "office-admin") return section;
            return {
              ...section,
              items: section.items.filter((item) => item.module !== "Security Access" || userCanAccessAdmin)
            };
          })
          .filter((section) => section.items.length > 0)
          .map((section) => (
          <section className="workspace-module-section" data-section={section.id} key={section.id}>
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

        <button type="button" disabled title="Saving and submission are not connected yet">
          Save & Submit (not available yet)
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

  return (
    <section className="module-frame">
      {showActions && (
        <WorkflowPageNavigation
          position="top"
          currentPageId={title}
          onNavigate={setModule}
          onPrevious={goPrevious}
          onHome={goHome}
          onContinue={goNext}
          onGoToTop={goToPageStart}
          onGoToBottom={goToPageBottom}
        />
      )}

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

      {showActions && (
        <WorkflowPageNavigation
          position="bottom"
          currentPageId={title}
          onNavigate={setModule}
          onPrevious={goPrevious}
          onHome={goHome}
          onContinue={goNext}
          onGoToTop={goToPageStart}
          onGoToBottom={goToPageBottom}
        />
      )}
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

function AccessDenied() {
  return (
    <section className="card access-denied-panel">
      <h2>Access restricted</h2>
      <p>This area is available only to authorized administrator or system-level accounts.</p>
    </section>
  );
}

function SecurityOperationsPanel() {
  return (
    <section className="admin-management-panel">
      <article>
        <h3>Session Security</h3>
        <p>Lock, logout, session expiry, forced logout and audit controls are integrated through the sidebar session control and security audit log.</p>
      </article>
      <article>
        <h3>Authentication Methods</h3>
        <p>Password, PIN, passcode, OTP, QR, phrase, colour and numeric challenge settings are managed in Admin Centre user management.</p>
      </article>
      <article>
        <h3>Live Monitoring</h3>
        <p>Administrators can grant or revoke live monitoring access for users and security-sensitive roles.</p>
      </article>
    </section>
  );
}

function Admin({ user }) {
  return (
    <>
      <section className="grid">
        <Card title="Governance" status="Ready" text="Compliance, approvals, policies and audit readiness." />
        <Card title="Backup Recovery" status="Ready" text="Backup status, restore planning and disaster readiness." />
        <Card title="Deployment Readiness" status="Ready" text="Production readiness, blockers and release checks." />
        <Card title="Audit Trail" status="Ready" text="System evidence and operational traceability." />
      </section>

      <AdminUserManagement user={user} />
    </>
  );
}

function AdminUserManagement({ user }) {
  const [users, setUsers] = useState([]);
  const [status, setStatus] = useState("Ready to manage users.");
  const [authenticatorSetup, setAuthenticatorSetup] = useState(null);
  const [authenticatorCode, setAuthenticatorCode] = useState("");
  const [form, setForm] = useState({
    full_name: "",
    username: "",
    email: "",
    role: "staff",
    phone_number: "",
    initials: "",
    nric_last4: "",
    password: "",
    passcodes: "",
    enabled_factors: "password,otp",
    security_phrase: "",
    security_colour: "",
    security_number_code: "",
    live_monitoring_access: false,
    protected_account: false,
    break_glass_account: false
  });

  const token = window.sessionStorage.getItem(SESSION_TOKEN_KEY);

  function headers() {
    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`
    };
  }

  async function loadUsers() {
    try {
      const response = await fetch("/api/adaptive-auth/admin/users", { headers: headers() });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Could not load users.");
      setUsers(data.users || []);
    } catch (error) {
      setStatus(error.message);
    }
  }

  useEffect(() => {
    loadUsers();
  }, []);

  function updateForm(key, value) {
    setForm((current) => ({ ...current, [key]: value }));
  }

  async function saveUser(event) {
    event.preventDefault();
    setStatus("Saving user account...");

    try {
      const payload = {
        ...form,
        passcodes: form.passcodes.split(",").map((item) => item.trim()).filter(Boolean),
        enabled_factors: form.enabled_factors.split(",").map((item) => item.trim()).filter(Boolean)
      };

      const response = await fetch("/api/adaptive-auth/admin/users", {
        method: "POST",
        headers: headers(),
        body: JSON.stringify(payload)
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Could not save user.");

      setStatus("User account saved.");
      setForm((current) => ({ ...current, full_name: "", username: "", email: "", phone_number: "", initials: "", nric_last4: "", password: "", passcodes: "", protected_account: false, break_glass_account: false }));
      loadUsers();
    } catch (error) {
      setStatus(error.message);
    }
  }

  async function updateUser(userId, patch) {
    setStatus("Updating user...");

    try {
      const response = await fetch(`/api/adaptive-auth/admin/users/${userId}`, {
        method: "PATCH",
        headers: headers(),
        body: JSON.stringify(patch)
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Could not update user.");

      setStatus("User updated.");
      loadUsers();
    } catch (error) {
      setStatus(error.message);
    }
  }

  async function setupAuthenticator(userId) {
    setStatus("Generating authenticator QR code...");

    try {
      const response = await fetch(`/api/adaptive-auth/admin/users/${userId}/authenticator/setup`, {
        method: "POST",
        headers: headers()
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Could not generate authenticator QR.");

      setAuthenticatorSetup(data);
      setAuthenticatorCode("");
      setStatus("Scan the QR code with Google Authenticator or Microsoft Authenticator, then enter the 6-digit code.");
    } catch (error) {
      setStatus(error.message);
    }
  }

  async function verifyAuthenticator() {
    if (!authenticatorSetup?.userId) return;
    setStatus("Verifying authenticator app code...");

    try {
      const response = await fetch(`/api/adaptive-auth/admin/users/${authenticatorSetup.userId}/authenticator/verify`, {
        method: "POST",
        headers: headers(),
        body: JSON.stringify({ code: authenticatorCode })
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Authenticator code could not be verified.");

      setStatus("Authenticator app enabled for this user.");
      setAuthenticatorSetup(null);
      setAuthenticatorCode("");
      loadUsers();
    } catch (error) {
      setStatus(error.message);
    }
  }

  async function emergencyAction(userId, action, extra = {}) {
    const reason = window.prompt("Enter the emergency/change reason for audit:");
    if (!reason || reason.trim().length < 8) {
      setStatus("Emergency/change reason must be at least 8 characters.");
      return;
    }

    setStatus("Submitting emergency action...");
    try {
      const response = await fetch(`/api/adaptive-auth/admin/users/${userId}/${action}`, {
        method: "POST",
        headers: headers(),
        body: JSON.stringify({ reason, ...extra })
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Emergency action failed.");

      setStatus("Emergency action recorded.");
      loadUsers();
    } catch (error) {
      setStatus(error.message);
    }
  }

  return (
    <section className="admin-user-management">
      <div className="admin-user-heading">
        <div>
          <p className="eyebrow">Administrator user management</p>
          <h2>Users, Roles & Authentication</h2>
          <p>Signed in as {getDisplayUser(user).name}. Changes are role-gated and audited server-side.</p>
        </div>
        <strong>{status}</strong>
      </div>

      <form className="admin-user-form" onSubmit={saveUser}>
        <label><span>Full legal name</span><input value={form.full_name} onChange={(event) => updateForm("full_name", event.target.value)} required /></label>
        <label><span>Username</span><input value={form.username} onChange={(event) => updateForm("username", event.target.value)} required /></label>
        <label><span>Email</span><input type="email" value={form.email} onChange={(event) => updateForm("email", event.target.value)} required /></label>
        <label><span>Role</span><select value={form.role} onChange={(event) => updateForm("role", event.target.value)}><option value="staff">Staff</option><option value="administrator">Administrator</option><option value="system_admin">System Administrator / Developer</option></select></label>
        <label><span>Phone for MFA</span><input value={form.phone_number} onChange={(event) => updateForm("phone_number", event.target.value)} /></label>
        <label><span>Initials</span><input value={form.initials} onChange={(event) => updateForm("initials", event.target.value)} /></label>
        <label><span>NRIC last 4</span><input value={form.nric_last4} onChange={(event) => updateForm("nric_last4", event.target.value)} maxLength={4} /></label>
        <label><span>Temporary password</span><input type="password" value={form.password} onChange={(event) => updateForm("password", event.target.value)} required /></label>
        <label><span>PIN / passcodes</span><input value={form.passcodes} onChange={(event) => updateForm("passcodes", event.target.value)} placeholder="5135,1985" /></label>
        <label><span>Authentication methods</span><input value={form.enabled_factors} onChange={(event) => updateForm("enabled_factors", event.target.value)} placeholder="password,otp,qr_approval,pin" /></label>
        <label><span>Security phrase / keyword</span><input value={form.security_phrase} onChange={(event) => updateForm("security_phrase", event.target.value)} /></label>
        <label><span>Security colour</span><input value={form.security_colour} onChange={(event) => updateForm("security_colour", event.target.value)} /></label>
        <label><span>Numeric challenge</span><input value={form.security_number_code} onChange={(event) => updateForm("security_number_code", event.target.value)} /></label>
        <label className="admin-checkbox"><input type="checkbox" checked={form.live_monitoring_access} onChange={(event) => updateForm("live_monitoring_access", event.target.checked)} /><span>Grant live monitoring access</span></label>
        <label className="admin-checkbox"><input type="checkbox" checked={form.protected_account} onChange={(event) => updateForm("protected_account", event.target.checked)} /><span>Protected account</span></label>
        <label className="admin-checkbox"><input type="checkbox" checked={form.break_glass_account} onChange={(event) => updateForm("break_glass_account", event.target.checked)} /><span>Break-glass authority</span></label>
        <button type="submit">Create User Account</button>
      </form>

      {authenticatorSetup && (
        <section className="admin-authenticator-setup" aria-label="Authenticator app setup">
          <div>
            <p className="eyebrow">Authenticator app setup</p>
            <h3>Scan QR for {authenticatorSetup.label}</h3>
            <p>Use Google Authenticator or Microsoft Authenticator. After scanning, enter the current 6-digit code to activate this login method.</p>
          </div>
          <img src={authenticatorSetup.qrDataUrl} alt={`Authenticator QR setup for ${authenticatorSetup.label}`} />
          <label>
            <span>Manual setup key</span>
            <input value={authenticatorSetup.manualKey || ""} readOnly />
          </label>
          <label>
            <span>6-digit authenticator code</span>
            <input value={authenticatorCode} onChange={(event) => setAuthenticatorCode(event.target.value)} inputMode="numeric" maxLength={6} />
          </label>
          <div className="admin-authenticator-actions">
            <button type="button" onClick={verifyAuthenticator}>Verify & Enable</button>
            <button type="button" onClick={() => setAuthenticatorSetup(null)}>Cancel</button>
          </div>
        </section>
      )}

      <div className="admin-user-table">
        <div className="admin-user-row admin-user-head">
          <span>User</span><span>Role</span><span>Phone</span><span>Factors</span><span>Status</span><span>Monitoring</span><span>Authenticator</span><span>Emergency</span>
        </div>
        {users.map((account) => (
          <div className="admin-user-row" key={account.id}>
            <span>
              <strong>{account.full_name || account.username}</strong>
              <small>{account.email}</small>
              {account.protected_system && <small className="admin-protected-label">Protected System Administrator / Developer</small>}
            </span>
            <span>{account.protected_system ? "system_admin" : account.role || "staff"}</span>
            <span>{account.phone_number || "-"}</span>
            <span>{Array.isArray(account.enabled_factors) ? account.enabled_factors.join(", ") : account.enabled_factors || "-"}</span>
            <button
              type="button"
              disabled={account.protected_system}
              title={account.protected_system ? "Protected System Administrator / Developer access cannot be revoked." : ""}
              onClick={() => updateUser(account.id, { access_status: account.access_status === "revoked" ? "active" : "revoked" })}
            >
              {account.protected_system ? "Protected" : account.access_status === "revoked" ? "Restore" : "Revoke"}
            </button>
            <button
              type="button"
              disabled={account.protected_system}
              title={account.protected_system ? "Protected System Administrator / Developer monitoring access is always enabled." : ""}
              onClick={() => updateUser(account.id, { live_monitoring_access: account.live_monitoring_access ? 0 : 1 })}
            >
              {account.protected_system ? "Always On" : account.live_monitoring_access ? "Enabled" : "Disabled"}
            </button>
            <button type="button" onClick={() => setupAuthenticator(account.id)}>
              {account.authenticator_enabled ? "Reset QR" : "Setup QR"}
            </button>
            <span className="admin-emergency-actions">
              <button type="button" onClick={() => emergencyAction(account.id, account.emergency_suspended ? "emergency-restore" : "emergency-suspend")}>
                {account.emergency_suspended ? "Restore" : "Suspend"}
              </button>
              <button type="button" onClick={() => emergencyAction(account.id, "revoke-sessions")}>Sessions</button>
              <button type="button" onClick={() => emergencyAction(account.id, "mfa-reset")}>MFA Reset</button>
            </span>
          </div>
        ))}
      </div>
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


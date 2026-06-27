# Litigation 360 / LEOS 360
# Phase 13F.1 Keyboard Accessibility Read-Only Inspection

Date: 2026-06-27
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: cad8272 docs(phase-13): record no-match full profile redirect QA pass

## Purpose

Read-only inspection before implementing keyboard accessibility and shortcut support.

## Recent Commit Chain

```text
cad8272 docs(phase-13): record no-match full profile redirect QA pass
1a7ecc8 docs(phase-13): plan keyboard accessibility framework
1503467 docs(phase-13): record no-match full-profile redirect gap map
d8edcb2 fix(matter): redirect no-match client creation to full profile
122a928 feat(clients): connect profile summary section jump links
19de958 docs(phase-13): record static client summary rail QA pass
321d54c chore(clients): clean summary rail whitespace
cfeb45f feat(clients): add static profile summary rail shell
3d0dab8 docs(phase-13): record explicit client section wrapper QA pass
1ca1487 style(clients): add explicit profile section heading wrappers
d387e81 docs(phase-13): blueprint explicit client profile section wrappers
3d99b99 docs(phase-13): record client profile shell QA pass
```

## Keyboard / Focus / Accessibility Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:34: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:46: place-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:87: .side-nav button:focus {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:118: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:163: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:181: place-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:211: place-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:219: text-align: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:232: justify-content: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:68: aria-label="Search legal repository"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:190: <aside className="legal-sidebar" aria-label="Legal management navigation">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:191: <div className="legal-sidebar-menu-platform" aria-label="Application menu hub">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:97: function handleKeyDown(event) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:99: if (event.key === "Escape") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:120: if (event.key === "Enter") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:125: if (event.key === "Escape") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:135: {required ? <span aria-hidden="true"> *</span> : null}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:150: onKeyDown={handleKeyDown}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:151: aria-autocomplete="list"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:152: aria-expanded={isOpen}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:156: <ul className="email-autocomplete-suggestions" role="listbox">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\alertEscalationApi.js:1: const BASE_URL = "/api/enterprise/alerts";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\autonomousEcosystemApi.js:1: const BASE = "/api/enterprise/ecosystem";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\autonomousOperationsApi.js:1: const BASE_URL = '/api/enterprise/autonomous';
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:3: const ENTERPRISE_ENDPOINTS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:4: { key: "monitoring", label: "Monitoring", path: "/api/enterprise/monitoring/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:5: { key: "hardening", label: "Hardening Readiness", path: "/api/enterprise/hardening/deployment/readiness" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:6: { key: "backupRecovery", label: "Backup Recovery", path: "/api/enterprise/backup-recovery/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:7: { key: "performance", label: "Performance", path: "/api/enterprise/performance/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:8: { key: "governance", label: "Governance", path: "/api/enterprise/governance/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:9: { key: "autonomous", label: "Autonomous Operations", path: "/api/enterprise/autonomous/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:10: { key: "maps", label: "Maps Integration", path: "/api/enterprise/maps/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:11: { key: "navigation", label: "Court Navigation", path: "/api/enterprise/navigation/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:12: { key: "predictive", label: "Predictive Analytics", path: "/api/enterprise/predictive/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:13: { key: "assistant", label: "Legal Assistant", path: "/api/enterprise/assistant/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:14: { key: "commandCentre", label: "Command Centre", path: "/api/enterprise/command-centre/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:15: { key: "documents", label: "Document Lifecycle", path: "/api/enterprise/documents/lifecycle/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:16: { key: "courtOperations", label: "Court Operations", path: "/api/enterprise/court-operations/health" },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:17: { key: "matterIntelligence", label: "Matter Intelligence", path: "/api/enterprise/matters/intelligence/health" }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:58: for (const endpoint of ENTERPRISE_ENDPOINTS) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\connectivityValidatorApi.js:79: export { ENTERPRISE_ENDPOINTS };
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\deploymentDashboardApi.js:14: return await getJson("/api/enterprise/executive-deployment/dashboard");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\deploymentDashboardApi.js:18: return await getJson("/api/enterprise/executive-deployment/summary");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\deploymentDashboardApi.js:22: return await getJson("/api/enterprise/executive-deployment/health");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:13: export async function getEnterpriseHealthBundle() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:15: monitoring: "/api/enterprise/monitoring/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:16: monitoringDashboard: "/api/enterprise/monitoring/dashboard",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:17: hardening: "/api/enterprise/hardening/deployment/readiness",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:18: backupRecovery: "/api/enterprise/backup-recovery/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:19: performance: "/api/enterprise/performance/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:20: governance: "/api/enterprise/governance/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:21: autonomous: "/api/enterprise/autonomous/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:22: maps: "/api/enterprise/maps/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:23: navigation: "/api/enterprise/navigation/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:24: predictive: "/api/enterprise/predictive/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:25: assistant: "/api/enterprise/assistant/health",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:26: commandCentre: "/api/enterprise/command-centre/health"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:33: export async function getEnterpriseDashboard() { return await getJson("/api/enterprise/monitoring/dashboard"); }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:34: export async function getPerformanceBenchmark() { return await getJson("/api/enterprise/performance/benchmark"); }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseApi.js:35: export async function getDeploymentReadiness() { return await getJson("/api/enterprise/hardening/deployment/readiness"); }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:13: export async function getEnterpriseOperationsDashboard() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:14: return await getJson("/api/enterprise/operations/dashboard");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:17: export async function getEnterpriseOperationsHealth() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:18: return await getJson("/api/enterprise/operations/health");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:21: export async function getEnterpriseOperationsAlerts() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\enterpriseOperationsApi.js:22: return await getJson("/api/enterprise/operations/alerts");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\operationsAnalyticsApi.js:1: const BASE_URL = "/api/enterprise/operations-analytics";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\api\predictiveIntelligenceApi.js:1: const BASE = "/api/enterprise/predictive";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\components\EnterpriseStatusCard.jsx:3: export default function EnterpriseStatusCard({ title, status, value }) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\AutonomousLegalEnterpriseEcosystem.jsx:8: export default function AutonomousLegalEnterpriseEcosystem() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\AutonomousLegalEnterpriseEcosystem.jsx:21: <h1>Phase 11.0 Autonomous Legal Enterprise Ecosystem</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\AutonomousLegalEnterpriseEcosystem.jsx:22: <p>Foundation layer for autonomous legal enterprise orchestration.</p>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseAlertEscalationCentre.jsx:9: export default function EnterpriseAlertEscalationCentre() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseAlertEscalationCentre.jsx:51: notes: "Resolved from Enterprise Alert & Escalation Centre",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseAlertEscalationCentre.jsx:65: <h1>Enterprise Alert & Escalation Centre</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseAutonomousOperationsSupervisor.jsx:4: export default function EnterpriseAutonomousOperationsSupervisor() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseAutonomousOperationsSupervisor.jsx:19: <h1>Enterprise Autonomous Operations Supervisor</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsAnalyticsCentre.jsx:4: export default function EnterpriseOperationsAnalyticsCentre() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsAnalyticsCentre.jsx:34: <h1>Enterprise Operations Analytics Centre</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsCommandCentre.jsx:2: import { getEnterpriseOperationsDashboard } from "../api/enterpriseOperationsApi";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsCommandCentre.jsx:4: export default function EnterpriseOperationsCommandCentre() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsCommandCentre.jsx:11: setDashboard(await getEnterpriseOperationsDashboard());
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsCommandCentre.jsx:27: <h1>Enterprise Operations Command Centre</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:2: import EnterpriseStatusCard from "../components/EnterpriseStatusCard";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:3: import { getEnterpriseHealthBundle, getEnterpriseDashboard, getDeploymentReadiness, getPerformanceBenchmark } from "../api/enterpriseApi";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:5: export default function EnterpriseOperationsDashboard() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:16: getEnterpriseHealthBundle(),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:17: getEnterpriseDashboard(),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:40: <h1>Litigation 360 Enterprise Operations Dashboard</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:46: <EnterpriseStatusCard title="Monitoring" status={result.monitoring?.status} value={`Score: ${result.monitoring?.healthScore ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:47: <EnterpriseStatusCard title="Deployment Readiness" status={readiness?.status} value={`Ready: ${String(readiness?.deploymentReady ?? false)}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:48: <EnterpriseStatusCard title="Performance" status={result.performance?.status} value={`Avg: ${result.performance?.avgMs ?? "N/A"} ms`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:49: <EnterpriseStatusCard title="Backup Recovery" status={result.backupRecovery?.status} value={`Snapshots: ${result.backupRecovery?.snapshotsCreated ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:50: <EnterpriseStatusCard title="Governance" status={result.governance?.status} value={`Score: ${result.governance?.governanceScore ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:51: <EnterpriseStatusCard title="Autonomous Ops" status={result.autonomous?.status} value={`Escalations: ${result.autonomous?.openEscalations ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:52: <EnterpriseStatusCard title="Maps" status={result.maps?.status} value={`Courts: ${result.maps?.registeredCourts ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx:53: <EnterpriseStatusCard title="Navigation" status={result.navigation?.status} value={`Courts: ${result.navigation?.courtsRegistered ?? "N/A"}`} />
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\ExecutiveDeploymentDashboard.jsx:43: <h3>Enterprise Grade</h3>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\pages\ExecutiveDeploymentDashboard.jsx:44: <strong>{summary.enterpriseGrade || "N/A"}</strong>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\FaqPanel.jsx:30: "Yes. Use Arrow Up and Arrow Down to move, Enter or Space to select, Escape to close, and Tab to exit.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\FaqPanel.jsx:58: <section className="mp-panel" aria-labelledby="mp-panel-faq-title">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\FaqPanel.jsx:84: aria-expanded={isOpen}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\FaqPanel.jsx:91: <span aria-hidden="true">{isOpen ? "−" : "+"}</span>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\SupportRequestPanel.jsx:147: <div className="mp-error-box" role="alert">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:27: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:28: justify-content: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:46: .mp-trigger:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:47: .mp-menu-item:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:48: .mp-faq-question:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:49: .mp-primary-button:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:50: .mp-action-grid button:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:51: .mp-simple-list button:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:52: .mp-attachment-list button:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:53: .mp-field input:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:54: .mp-field select:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:55: .mp-field textarea:focus-visible,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:56: .mp-search input:focus-visible {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:150: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.css:178: justify-content: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:61: <span className="mp-item-icon" aria-hidden="true">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:101: return <div className="mp-separator" role="separator" />;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:110: aria-label={item.ariaLabel || item.label}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:111: aria-disabled={disabled ? "true" : undefined}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:112: aria-haspopup={isSubmenu ? "menu" : undefined}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:113: aria-expanded={isSubmenu ? expanded : undefined}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:133: <span className="mp-expand-indicator" aria-hidden="true">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:159: <div className="mp-menu-tree" role={depth === 0 ? undefined : "group"}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:322: function handleKeyDown(event) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:324: case "Escape":
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:336: case "Enter":
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:355: aria-label="Close application menu"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:357: tabIndex={-1}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:364: role="dialog"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:365: aria-modal="true"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:366: aria-label="Application menu"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:367: onKeyDown={handleKeyDown}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:377: aria-label="Search menu, settings, FAQ, and support topics"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:419: <div className="mp-live-region" aria-live="polite">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:434: aria-haspopup="dialog"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:435: aria-expanded={open}
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:436: aria-controls="mp-dropdown-shell"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\MenuPlatform.jsx:439: <span aria-hidden="true">☰</span>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\layout\layout.jsx:18: <nav className="sidebar-nav" aria-label="Main navigation">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1740: : "Enter the Email Address above; duplicate entry is not required here.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2105: nextErrors.phoneNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2110: nextErrors.backupPhoneNumber = "Secondary / Backup Phone Number is enabled. Enter at least " + MINIMUM_CONTACT_DIGITS + " digits or untick the backup number option.";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2112: nextErrors.backupPhoneNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2117: nextErrors.whatsappNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2121: nextErrors.whatsapp2Number = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2299: setGoogleContactStatus("Enter a name, phone, or email before searching Google Contacts.");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2470: [field]: hadInvalidCharacters ? "Only numeric characters are allowed. Please enter a valid phone number." : ""
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2816: errors.push("Secondary / Backup Phone Number is enabled. Enter at least " + MINIMUM_CONTACT_DIGITS + " digits or untick the backup number option.");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3026: : "Client profile successfully entered, received, verified and saved.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3315: justify-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3323: justify-content: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3342: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3430: text-align: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3452: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3453: justify-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3458: justify-content: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3459: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3478: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3492: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3532: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3551: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3614: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3624: <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3759: <div className="client-alphabet-filter two-rows" aria-label="Client alphabet filter">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3955: <div className="client-form-progress-track" aria-label="Client form completion progress">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4078: placeholder="Enter NRIC or Passport No."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4516: <span className="muted-box">Enter WhatsApp number first</span>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4531: <div className="contact-choice-guard-panel full" role="status" aria-live="polite">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4673: placeholder="Enter reason"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4710: Open entered address in Google Maps
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4791: <div className="address-sync-panel full" role="status" aria-live="polite">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:4920: <strong>Location / Administrative Classification — Combined:</strong> Select the administrative category/type, then enter the actual area, authority or locality details. Use this for postcode area, town, state, municipality, council, borough, district, county, parish, shire, mukim or other local authority structures.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5041: placeholder="Enter administrative area/name/details"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5077: placeholder="Enter administrative area/name/details"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5123: placeholder="Enter administrative area/name/details"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5169: placeholder="Enter administrative area/name/details"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5215: placeholder="Enter administrative area/name/details or notes"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:1665: setGoogleContactStatus("Enter a name, phone, or email before searching Google Contacts.");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:1726: [field]: hadInvalidCharacters ? "Only numeric characters are allowed. Please enter a valid phone number." : ""
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2166: : "Client profile successfully entered, received, verified and saved.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2383: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2402: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2533: <div className="client-alphabet-filter" aria-label="Client alphabet filter">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2734: placeholder="Enter NRIC or Passport No."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:2943: <span className="muted-box">Enter WhatsApp number first</span>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:3072: placeholder="Enter reason"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:3097: Open entered address in Google Maps
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx:3241: placeholder="Enter official local category, e.g. Mukim, Parish, County, Shire, Borough, Council, Municipality."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Deadlines.jsx:150: <div style={{ marginBottom: '20px', display: 'flex', gap: '10px', alignItems: 'center' }}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Documents.jsx:248: placeholder="Enter the filename stored with this document record"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:395: setValidationMessage("Enter at least one identifying detail before searching.");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:513: setValidationMessage("Confirm that duplicate search was performed and reviewed before entering a new client profile.");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:685: onKeyDown={(event) => {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:686: if (event.key === "Enter") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:691: placeholder="Enter full name, given name, surname, preferred name, alias, ID/NRIC, passport number, phone, WhatsApp, email, or company name"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx:877: <p>Confirm the duplicate search gate above before entering brand-new client details.</p>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:125: <div style={smallLabelStyle}>Operations Command Center</div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:190: <h3 style={sectionTitleStyle}>Enterprise Progress Chart</h3>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:268: alignItems: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:358: alignItems: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:359: justifyContent: "center"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:368: alignItems: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:369: justifyContent: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:394: alignItems: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:396: textAlign: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:403: alignItems: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:404: justifyContent: "center",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx:409: textAlign: "center"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\SystemDashboard.jsx:28: <h2>🧠 SYSTEM CONTROL CENTER</h2>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:88: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:237: .sidebar .leos-sidebar-tool-btn:focus {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:252: .sidebar .leos-sidebar-tool-btn.leos-primary-tool:focus {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:318: align-items: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:360: text-align: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1111: justify-content: center;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1440: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1676: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1693: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1703: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1710: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1935: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:1955: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2162: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2178: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2284: /* Toolbar: Previous left, Home centered, Next right, all on the same horizontal line. */
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2288: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2301: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2309: .module-toolbar-center {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2310: justify-content: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2312: text-align: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2429: .module-toolbar-center,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2431: justify-content: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2453: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2467: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2470: .module-toolbar .toolbar-center {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2471: justify-self: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2473: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2474: justify-content: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2476: text-align: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2483: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2610: .module-toolbar .toolbar-center,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2613: justify-content: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2691: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2725: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:2865: align-items: center !important;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:3140: .sidebar a[aria-current],
```

## Inspection Status

Phase 13F.1 read-only inspection created.

Implementation Status: NOT STARTED.

## Next Step

Use this inspection to identify the smallest safe frontend-only implementation files.

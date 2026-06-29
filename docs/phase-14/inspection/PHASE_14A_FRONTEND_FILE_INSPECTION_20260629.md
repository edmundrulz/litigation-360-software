# Litigation 360 / LEOS 360
# Phase 14A Frontend File Inspection

Date: 2026-06-29
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: 9381b5b docs(phase-14): add client intake frontend prototype execution plan

## Current Status

Phase 14A is in frontend prototype planning.

Implementation Status: NOT STARTED
Production Rollout Status: BLOCKED

## Purpose

Inspect likely frontend files before approving any Phase 14A client intake prototype implementation.

This inspection is read-only except for creation of this documentation file.

## Files Inspected

```text
.\frontend\src\App.jsx
.\frontend\src\index.css
.\frontend\src\pages\Clients.jsx
.\frontend\src\pages\Matters.jsx
```

## Page Files Found

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Dashboard.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Deadlines.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Documents.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\LegalHomePage.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\OperationsDashboard.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ProjectDashboard.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Staff.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\SystemDashboard.jsx
```

## Component Files Found

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx
```

## App / Routing / Navigation Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:7: import Clients from "./pages/Clients";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:9: import Matters from "./pages/Matters";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:24: const workspaceSections = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:39: module: "Clients",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:61: module: "Matters",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:62: title: "Matter Workspace",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:65: text: "Matter workspace and legal file tracking.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:123: { module: "Lawyer View", title: "Lawyer View", status: "PLANNED", sequence: "P5", text: "Hearings, active matters, pleadings, deadlines and court preparation." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:148: nextModule: "Clients",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:151: Clients: {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:167: Matters: {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:168: displayTitle: "Matter Workspace",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:170: description: "Matter workspace and legal file tracking.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:208: group: "Workspace Module",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:209: description: "Workspace module.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:214: const moduleRouteAliases = {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:215: "Client Details": "Clients",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:217: "Matter Workspace": "Matters",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:251: function normalizeWorkspaceModule(moduleName) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:252: return moduleRouteAliases[moduleName] || moduleName;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:256: const [view, setView] = useState("workspace");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:303: const resolvedModule = normalizeWorkspaceModule(nextModule);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:330: function openWorkspace() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:331: setView("workspace");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:347: onNavigate={(target) => {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:349: openWorkspace();
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:354: openWorkspace();
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:360: <button className={view === "workspace" ? "active" : ""} onClick={openWorkspace}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:361: End User Workspace
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:391: {view === "workspace" && (
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:392: <Workspace
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:414: if (view === "workspace" && module !== "home") return "Workspace - " + module;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:417: workspace: "End User Legal Workspace - LEOS Module Command Grid",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:424: function Workspace({ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated }) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:425: if (module === "Clients") return <ModuleFrame title="Clients" setModule={setModule} previous={previous} canGoBack={canGoBack}><Clients setModule={setModule} /></ModuleFrame>;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:427: if (module === "Matters") return <ModuleFrame title="Matters" setModule={setModule} previous={previous} canGoBack={canGoBack}><Matters /></ModuleFrame>;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:455: <h2>Litigation 360 LEOS Workspace</h2>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:535: <section className="workspace-section-list" aria-label="Workspace module groups">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:536: {workspaceSections.map((section) => (
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:537: <section className="workspace-module-section" key={section.id}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:538: <div className="workspace-section-header">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:610: Return to Main Workspace
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:630: "Clients": "home",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:631: "Cases": "Clients",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:632: "Matters": "Clients",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:642: "Clients": "Cases",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx:644: "Matters": "Court Dates",
```

## Clients Page Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:2: const API_URL = "/api/clients";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:3: const CLIENT_DIRECTORY_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:5: const DEFAULT_CLIENT_TAG_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:10: "Pending Documents",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:12: "Court Matter",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:13: "Employment Matter",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:14: "Medical Matter",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:15: "Police / Authority Matter",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:16: "Billing / Invoice Matter",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:21: function getClientDirectoryName(client) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:22: const source = client || {};
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:30: "Unnamed client"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:34: function getClientDirectoryInitial(client) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:35: const name = getClientDirectoryName(client).trim();
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:40: function normalizeClientTagList(value) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:56: "litigation360.clients.profile.v6",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:57: "litigation360.clients.profile.v5",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:58: "litigation360.clients.contactForm.v4",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:59: "litigation360.clients.contactForm.v3",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:60: "litigation360.clients.registration.v2",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:61: "litigation360.clients.localFallback.v1"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:66: const EMPTY_CLIENT = {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:117: preferredContact1: "WhatsApp Message",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:118: preferredContact2: "Phone Call",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:119: preferredContact3: "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:120: preferredContact4: "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:121: preferredContact5: "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:122: preferredContactDetail1: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:123: preferredContactDetail2: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:124: preferredContactDetail3: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:125: preferredContactDetail4: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:126: preferredContactDetail5: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:128: preferredContactHoursFrom: "09:00",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:129: preferredContactHoursTo: "18:00",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:137: isClientUnavailable: false,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:140: emergencyContactName: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:141: emergencyContactRelationship: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:142: emergencyContactCountryCode: "+60 Malaysia",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:143: emergencyContactNumber: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:144: emergencyContactEmail: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:145: emergencyContactNotes: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:185: googleContactResourceName: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:186: googleContactMatched: false,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:187: googleContactMatchSource: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:188: linkedClientId: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:189: linkedClientMatchStatus: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:191: documentType: "NRIC",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:192: documentStatus: "Pending Verification",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:193: documentAttachmentNames: [],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:194: documentReferenceNotes: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:195: documentRelatedReferenceNotes: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:202: documentationVerificationCompleted: false,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:209: clientSince: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:210: totalMattersCount: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:211: clientValueTier: "Medium",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:212: clientValueNotes: "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:214: clientRoleInMatter: "Plaintiff",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:215: caseOriginType: "New Direct Client",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:223: clientCategory: "General",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:224: clientTags: [],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:332: "Passport / Foreign Travel Document",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:511: "Other Immigration / Documented Status",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:521: "Permanent Resident Document",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:560: const CONTACT_METHOD_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:643: "Client",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:649: const CLIENT_VALUE_TIER_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:656: const CLIENT_ROLE_IN_MATTER_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:666: "New Direct Client",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:678: const DOCUMENT_TYPE_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:685: "Permanent Resident Document",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:691: "Other Supporting Document",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:696: const DOCUMENT_STATUS_OPTIONS = [
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:712: "Documents Pending",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:753: "Company Contact Person",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:762: "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:764: "Document request": "Hello, we require your documents for your matter. Please send them when available.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:765: "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:793: return "client-" + Date.now() + "-" + Math.random().toString(16).slice(2);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:796: function getClientId(client) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:797: return client.id || client._id || "";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1139: function normalizeDocumentNames(value) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1163: function readLocalClients() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1177: collected.push(...parsed.map(normalizeClient));
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1184: return mergeClients([], collected);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1187: function writeLocalClients(list) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1189: localStorage.setItem(PRIMARY_LOCAL_STORAGE_KEY, JSON.stringify(list.map(normalizeClient)));
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1191: console.warn("Local client fallback could not be written.", error);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1195: function mergeClients(primaryList, secondaryList) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1198: [...secondaryList, ...primaryList].forEach((client) => {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1199: const normalized = normalizeClient(client);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1201: getClientId(normalized) ||
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1242: function getUnavailableStatus(client) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1243: const combined = combineAvailability(client.unavailableUntilDate, client.unavailableUntilTime);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1262: function normalizeClient(rawClient) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1263: const source = rawClient || {};
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1271: source.documentIdType ||
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1296: ...EMPTY_CLIENT,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1298: id: getClientId(source) || source.id || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1348: preferredContact1: source.preferredContact1 || "WhatsApp Message",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1349: preferredContact2: source.preferredContact2 || "Phone Call",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1350: preferredContact3: source.preferredContact3 || "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1351: preferredContact4: source.preferredContact4 || "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1352: preferredContact5: source.preferredContact5 || "Not Applicable / N/A",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1353: preferredContactDetail1: source.preferredContactDetail1 || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1354: preferredContactDetail2: source.preferredContactDetail2 || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1355: preferredContactDetail3: source.preferredContactDetail3 || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1356: preferredContactDetail4: source.preferredContactDetail4 || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1357: preferredContactDetail5: source.preferredContactDetail5 || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1359: preferredContactHoursFrom: source.preferredContactHoursFrom || "09:00",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1360: preferredContactHoursTo: source.preferredContactHoursTo || "18:00",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1366: communicationTimingNotes: source.communicationTimingNotes || source.whatsappNotes || source.preferredContactTimeNote || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1367: isClientUnavailable: source.isClientUnavailable !== undefined
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1368: ? Boolean(source.isClientUnavailable)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1374: emergencyContactName: source.emergencyContactName || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1375: emergencyContactRelationship: source.emergencyContactRelationship || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1376: emergencyContactCountryCode: source.emergencyContactCountryCode || source["emergencyContactcountryCode"] || "+60 Malaysia",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1377: emergencyContactNumber: source.emergencyContactNumber || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1378: emergencyContactEmail: source.emergencyContactEmail || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1379: emergencyContactNotes: source.emergencyContactNotes || "",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx:1421: googleContactResourceName: source.googleContactResourceName || "",
```

## Matters Page Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:4: export default function Matters() {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:5: const [matters, setMatters] = useState([]);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:8: api.get("/matters")
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:9: .then(res => setMatters(res.data.data))
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:15: <h1>Matters</h1>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx:28: {matters.map(m => (
```

## Workspace Page Matches

```text
```

## Component Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:5: function EmailAutocompleteInput({
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:55: document.addEventListener("mousedown", handleClickOutside);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:58: document.removeEventListener("mousedown", handleClickOutside);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:131: <div className="email-autocomplete-input" ref={wrapperRef}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:133: <label className="email-autocomplete-label" htmlFor={id}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:147: autoComplete="email"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:151: aria-autocomplete="list"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:156: <ul className="email-autocomplete-suggestions" role="listbox">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:163: ? "email-autocomplete-suggestion is-highlighted"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:164: : "email-autocomplete-suggestion"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:181: <small className="email-autocomplete-helper">{helperText}</small>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:185: <small className="email-autocomplete-warning">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\EmailAutocompleteInput.jsx:193: export default EmailAutocompleteInput;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx:21: ["Enter / Space", "Activate the focused button or submit the active form"],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx:36: <section
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx:39: aria-modal="true"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx:60: <article className="keyboard-shortcuts-card" key={group.title}>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\KeyboardShortcutsHelp.jsx:74: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:91: transform: translateX(3px);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:111: .panel-card {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:127: .panel-card h2,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:128: .firm-card h2,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:129: .partner-card h2 {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:135: .panel-card p,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:136: .firm-card p,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:137: .partner-card p {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:159: .firm-card,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:160: .partner-card {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:186: .partner-card small {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:192: .panel-card {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:255: .folder-card,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:256: .news-card,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:257: .settings-card,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:269: .folder-card,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:274: .folder-card:hover,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:276: .news-card:hover {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:285: .news-card {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:290: .news-card span {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:304: .settings-card strong,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:305: .news-card strong,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:306: .folder-card strong {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:310: .settings-card span,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:311: .news-card small,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:312: .folder-card small {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:334: /* Phase 13B.2B - Menu Platform sidebar integration */
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:335: .legal-sidebar-menu-platform {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:341: .legal-sidebar-menu-platform .mp-root {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:346: .legal-sidebar-menu-platform .mp-trigger {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:352: .legal-sidebar-menu-platform .mp-dropdown-shell {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.css:358: .legal-sidebar-menu-platform .mp-dropdown-shell {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:5: import { MenuPlatform } from "../../features/menu-platform";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:27: { icon: "ðŸ“", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:28: { icon: "ðŸ“‚", title: "Matter Folders", description: "Case records, pleadings, status notes, court timelines." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:29: { icon: "ðŸ“„", title: "Documents", description: "Drafts, templates, letters, affidavits, bundles and exhibits." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:32: { icon: "ðŸ§¾", title: "Billing / Finance", description: "Invoices, receipts, fee notes and disbursement tracking." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:42: { term: "Affidavit", definition: "A written statement confirmed by oath or affirmation for use as evidence." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:43: { term: "Cause Papers", definition: "Court documents filed in a case, including pleadings and applications." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:44: { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:46: { term: "Matter", definition: "A legal file or case handled for a client." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:47: { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:54: <section className="panel-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:59: <p>Find documents, files, folders, client records, matter records and legal references.</p>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:67: placeholder="Search clients, matters, documents, deadlines, folders..."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:73: <button key={item.title} className="folder-card" type="button">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:80: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:85: <section className="panel-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:90: <p>Training, tutorials, SOPs and help documentation for staff.</p>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:96: <button type="button">ðŸ‘¤ Client Intake Workflow</button>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:97: <button type="button">ðŸ’¼ Matter Opening SOP</button>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:98: <button type="button">ðŸ“„ Document Upload & Review Guide</button>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:102: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:107: <section className="panel-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:124: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:129: <section className="panel-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:139: <div className="settings-card"><strong>ðŸ‘¤ User Preferences</strong><span>Language, default dashboard, quick links.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:140: <div className="settings-card"><strong>ðŸŽ¨ Display Settings</strong><span>Theme, density, font size, layout mode.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:141: <div className="settings-card"><strong>ðŸ”” Notifications</strong><span>Email, in-app alerts, deadline reminders.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:142: <div className="settings-card"><strong>ðŸ›¡ï¸ Access Controls</strong><span>Roles, permissions, module visibility, RBAC.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:143: <div className="settings-card"><strong>ðŸ›ï¸ Firm Profile</strong><span>Firm name, logo, tagline and contact details.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:144: <div className="settings-card"><strong>ðŸ§¾ Audit & Compliance</strong><span>Logs, retention rules, review controls.</span></div>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:146: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:151: <section className="panel-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:162: <a key={item.url} className="news-card" href={item.url} target="_blank" rel="noreferrer">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:169: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:174: <section className="panel-card hero-panel">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:180: <button type="button" onClick={() => setActivePanel("clients")}>ðŸ’¼ Open Workspace</button>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:183: </section>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:191: <div className="legal-sidebar-menu-platform" aria-label="Application menu hub">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:192: <MenuPlatform
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:236: <p>Professional legal workspace for matters, clients, documents and governance.</p>
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:241: <section className="profile-grid">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:242: <article className="firm-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:251: <article className="partner-card">
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:260: </section>
```

## Inspection Findings

The likely Phase 14A frontend prototype should avoid heavy edits to stable Clients, Matters, and Workspace flows unless routing/navigation requires a small controlled touch.

Preferred implementation shape remains:

- create a new dedicated prototype page/component
- use mock/local state only
- avoid backend calls
- avoid database writes
- avoid real client or matter creation
- avoid file upload or document storage implementation

## Candidate Allowed Files For Future Implementation Gate

Potential future allowed files, subject to separate implementation approval:

- frontend/src/pages/ClientIntakeDiscovery.jsx
- frontend/src/components/ClientIntakeDiscoveryPrototype.jsx
- frontend/src/components/ClientIntakeSectionCard.jsx
- frontend/src/components/ClientIntakeProposalPreview.jsx
- frontend/src/index.css
- frontend/src/App.jsx only if route/navigation is required

## Files To Avoid Unless Necessary

- frontend/src/pages/Clients.jsx
- frontend/src/pages/Matters.jsx
- frontend/src/pages/Workspace.jsx

Reason: these are existing stable flows. The prototype should not destabilize them.

## Forbidden Files / Areas

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure logic

## Required Next Decision

Create a Phase 14A Frontend Prototype Implementation Gate.

That gate must either:

Option A: approve a frontend-only prototype shell
Option B: require another read-only review
Option C: defer implementation

## Recommended Next Action

Approve a small frontend-only prototype shell if this inspection confirms the app has a safe route/navigation location.

## Verification Commands

```powershell
git status --short
git diff --check
npm --prefix ".\frontend" run build
git status --short
git log -10 --oneline
```

## Recent Commit Chain

```text
9381b5b docs(phase-14): add client intake frontend prototype execution plan
f087837 docs(phase-14): record client intake execution scope decision
efafca2 docs(phase-14): add client intake read-only discovery scope map
a5f1ee8 docs(phase-13): close client lifecycle and set next-phase gate
e346449 docs(phase-13): close client profile modernization
f114794 docs(phase-13): close Z4 validation intelligence
739ed1b docs(phase-13): record section completion status QA pass
d6efbb5 feat(clients): add section completion status
6716e4c docs(phase-13): record required field counter QA pass
ad60398 feat(clients): add existing required field counter
3913316 docs(phase-13): record static completion shell QA pass
6339220 feat(clients): add static completion status shell
1ceb325 docs(governance): record next-phase decision gate after Phase 13
87e77a8 docs(phase-13): update overall Phase 13 closeout SSOT
8a941b3 docs(phase-13): map client validation completion states
6da3c24 docs(phase-13): record keyboard framework QA pass
34a454d docs(phase-13): audit client validation sources
36b94fb docs(phase-13): record keyboard framework QA pass
9342d7f docs(phase-13): blueprint client validation completion intelligence
aa9c2b6 feat(app): add keyboard shortcut help framework
```

## Final Inspection Status

Phase 14A Frontend File Inspection: CREATED
Phase 14A Implementation: NOT STARTED
Backend / Database / Security Scope: NOT APPROVED
Production Rollout: BLOCKED

## Next Recommended Step

Phase 14A Frontend Prototype Implementation Gate

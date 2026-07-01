# Litigation 360 / LEOS 360
# Phase 14A Global Navigation / Orientation / Progress Audit

Date: 2026-06-30
Branch:
phase-14a-green-recovery-checkpoint
HEAD:
c1ed7df

## 1. Audit Purpose

This audit identifies current step/stage/progress/navigation variations before Clients Page section reordering resumes.

## 2. Audit Scope

- frontend/src/pages
- frontend/src/components

## 3. Search Results

## Root: frontend/src/pages

### frontend\src\pages\ClientIntakeDiscovery.jsx

- frontend\src\pages\ClientIntakeDiscovery.jsx line 141: supportingAlerts.push("Stage 4 document readiness should be improved before full legal review.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 148: supportingAlerts.push("Stage 5 risk and evidence review may be required before scope is finalised.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 155: supportingAlerts.push("Stage 6 fee estimate and approval threshold should be clarified before engagement approval.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 247: The mandatory first stage before Matter Intake, Client Details,
- frontend\src\pages\ClientIntakeDiscovery.jsx line 249: The assessment recommends whether Stage 2 or Stage 3 should happen next.
- frontend\src\pages\ClientIntakeDiscovery.jsx line 284: <p style={eyebrowStyle}>Stage 1 gateway assessment</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 285: <h2 style={h2Style}>Stage 1 Comes First</h2>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 288: will recommend either Stage 2 Matter Intake or Stage 3 Client
- frontend\src\pages\ClientIntakeDiscovery.jsx line 301: text="These fields decide whether Stage 3 Client Details, Authority & Conflict must happen before matter work."
- frontend\src\pages\ClientIntakeDiscovery.jsx line 347: text="These fields decide whether Stage 2 Matter Intake / Urgent Action should become the next route."
- frontend\src\pages\ClientIntakeDiscovery.jsx line 456: <p style={eyebrowStyle}>Priority branch after Stage 1</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 484: Continue to Stage {selectedRoute.number} — Prototype Only
- frontend\src\pages\ClientIntakeDiscovery.jsx line 607: {recommended ? "Recommended after Stage 1" : "Secondary branch"}
- frontend\src\pages\ClientIntakeDiscovery.jsx line 293: <div style={progressCardStyle}>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 774: const progressCardStyle = {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 293: <div style={progressCardStyle}>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 774: const progressCardStyle = {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 3: const STORAGE_KEY = "litigation360.workflow.stage1.preliminaryAssessment";
- frontend\src\pages\ClientIntakeDiscovery.jsx line 43: const supportingStages = [
- frontend\src\pages\ClientIntakeDiscovery.jsx line 141: supportingAlerts.push("Stage 4 document readiness should be improved before full legal review.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 148: supportingAlerts.push("Stage 5 risk and evidence review may be required before scope is finalised.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 155: supportingAlerts.push("Stage 6 fee estimate and approval threshold should be clarified before engagement approval.");
- frontend\src\pages\ClientIntakeDiscovery.jsx line 205: workflowStage: "1",
- frontend\src\pages\ClientIntakeDiscovery.jsx line 206: stageTitle: "Preliminary Assessment & Triage",
- frontend\src\pages\ClientIntakeDiscovery.jsx line 207: recommendedNextStage: analysis.primaryRoute.number,
- frontend\src\pages\ClientIntakeDiscovery.jsx line 247: The mandatory first stage before Matter Intake, Client Details,
- frontend\src\pages\ClientIntakeDiscovery.jsx line 249: The assessment recommends whether Stage 2 or Stage 3 should happen next.
- frontend\src\pages\ClientIntakeDiscovery.jsx line 284: <p style={eyebrowStyle}>Stage 1 gateway assessment</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 285: <h2 style={h2Style}>Stage 1 Comes First</h2>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 288: will recommend either Stage 2 Matter Intake or Stage 3 Client
- frontend\src\pages\ClientIntakeDiscovery.jsx line 301: text="These fields decide whether Stage 3 Client Details, Authority & Conflict must happen before matter work."
- frontend\src\pages\ClientIntakeDiscovery.jsx line 347: text="These fields decide whether Stage 2 Matter Intake / Urgent Action should become the next route."
- frontend\src\pages\ClientIntakeDiscovery.jsx line 438: placeholder="Summarise what happened, when it started, who is involved, current stage, and why help is needed now."
- frontend\src\pages\ClientIntakeDiscovery.jsx line 447: <p style={eyebrowStyle}>Recommended next stage</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 456: <p style={eyebrowStyle}>Priority branch after Stage 1</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 484: Continue to Stage {selectedRoute.number} — Prototype Only
- frontend\src\pages\ClientIntakeDiscovery.jsx line 505: <p style={eyebrowStyle}>Supporting stages</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 520: {supportingStages.map((stage) => (
- frontend\src\pages\ClientIntakeDiscovery.jsx line 521: <div key={stage.number} style={supportCardStyle}>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 523: {stage.number}. {stage.title}
- frontend\src\pages\ClientIntakeDiscovery.jsx line 525: <p>{stage.text}</p>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 607: {recommended ? "Recommended after Stage 1" : "Secondary branch"}
- frontend\src\pages\ClientIntakeDiscovery.jsx line 3: const STORAGE_KEY = "litigation360.workflow.stage1.preliminaryAssessment";
- frontend\src\pages\ClientIntakeDiscovery.jsx line 205: workflowStage: "1",
- frontend\src\pages\ClientIntakeDiscovery.jsx line 266: <section style={workflowMapStyle} aria-label="Workflow order">
- frontend\src\pages\ClientIntakeDiscovery.jsx line 267: <WorkflowNode label="1" title="Assessment" active />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 268: <WorkflowArrow />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 269: <WorkflowNode
- frontend\src\pages\ClientIntakeDiscovery.jsx line 274: <WorkflowArrow />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 275: <WorkflowNode label="4-6" title="Readiness Checks" />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 276: <WorkflowArrow />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 277: <WorkflowNode label="7" title="Draft Preview" />
- frontend\src\pages\ClientIntakeDiscovery.jsx line 631: function WorkflowNode({ label, title, active }) {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 633: <div style={workflowNodeStyle(active)}>
- frontend\src\pages\ClientIntakeDiscovery.jsx line 640: function WorkflowArrow() {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 641: return <div style={workflowArrowStyle}>→</div>;
- frontend\src\pages\ClientIntakeDiscovery.jsx line 696: const workflowMapStyle = {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 704: function workflowNodeStyle(active) {
- frontend\src\pages\ClientIntakeDiscovery.jsx line 719: const workflowArrowStyle = {

### frontend\src\pages\Clients.jsx

- frontend\src\pages\Clients.jsx line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- frontend\src\pages\Clients.jsx line 3952: Return to Stage 2 Matter Intake
- frontend\src\pages\Clients.jsx line 1517: function getClientFormCompletionProgress(form) {
- frontend\src\pages\Clients.jsx line 4260: const progress = getClientFormCompletionProgress(form);
- frontend\src\pages\Clients.jsx line 4262: <div className="form-section client-form-progress-card">
- frontend\src\pages\Clients.jsx line 4263: <h3>Client Form Completion Progress</h3>
- frontend\src\pages\Clients.jsx line 4265: {progress.percentage}% completed ({progress.completed} of {progress.total} key sections captured).
- frontend\src\pages\Clients.jsx line 4267: <div className="client-form-progress-track" aria-label="Client form completion progress">
- frontend\src\pages\Clients.jsx line 4268: <div className="client-form-progress-fill" style={{ width: progress.percentage + "%" }} />
- frontend\src\pages\Clients.jsx line 4270: {progress.missing.length > 0 && (
- frontend\src\pages\Clients.jsx line 4271: <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
- frontend\src\pages\Clients.jsx line 5235: {/* L360_ADMIN_AREA_PROGRESSIVE_WIZARD_FINAL */}
- frontend\src\pages\Clients.jsx line 5241: <div className="l360-admin-progress">
- frontend\src\pages\Clients.jsx line 1517: function getClientFormCompletionProgress(form) {
- frontend\src\pages\Clients.jsx line 4260: const progress = getClientFormCompletionProgress(form);
- frontend\src\pages\Clients.jsx line 4262: <div className="form-section client-form-progress-card">
- frontend\src\pages\Clients.jsx line 4263: <h3>Client Form Completion Progress</h3>
- frontend\src\pages\Clients.jsx line 4265: {progress.percentage}% completed ({progress.completed} of {progress.total} key sections captured).
- frontend\src\pages\Clients.jsx line 4267: <div className="client-form-progress-track" aria-label="Client form completion progress">
- frontend\src\pages\Clients.jsx line 4268: <div className="client-form-progress-fill" style={{ width: progress.percentage + "%" }} />
- frontend\src\pages\Clients.jsx line 4270: {progress.missing.length > 0 && (
- frontend\src\pages\Clients.jsx line 4271: <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
- frontend\src\pages\Clients.jsx line 5235: {/* L360_ADMIN_AREA_PROGRESSIVE_WIZARD_FINAL */}
- frontend\src\pages\Clients.jsx line 5241: <div className="l360-admin-progress">
- frontend\src\pages\Clients.jsx line 731: "Step-father",
- frontend\src\pages\Clients.jsx line 732: "Step-mother",
- frontend\src\pages\Clients.jsx line 733: "Step-sister",
- frontend\src\pages\Clients.jsx line 734: "Step-brother",
- frontend\src\pages\Clients.jsx line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- frontend\src\pages\Clients.jsx line 3952: Return to Stage 2 Matter Intake
- frontend\src\pages\Clients.jsx line 3951: <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
- frontend\src\pages\Clients.jsx line 4034: <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
- frontend\src\pages\Clients.jsx line 4166: <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>
- frontend\src\pages\Clients.jsx line 4169: <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>
- frontend\src\pages\Clients.jsx line 4207: <button type="button" className="btn btn-secondary" onClick={searchGoogleContacts}>Search Google Contacts Connector</button>
- frontend\src\pages\Clients.jsx line 4222: <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); viewClientProfile(client); }}>View Client Profile</button>
- frontend\src\pages\Clients.jsx line 4223: <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); editClient(client); }}>Edit / Amend</button>
- frontend\src\pages\Clients.jsx line 4224: <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); deleteClient(client); }}>Delete</button>
- frontend\src\pages\Clients.jsx line 4253: <button type="button" className="btn btn-secondary btn-small" onClick={saveClientDraftManually}>Manual Save Draft</button>
- frontend\src\pages\Clients.jsx line 4254: <button type="button" className="btn btn-secondary btn-small" onClick={restoreClientDraft} disabled={!hasRecoverableDraft}>Restore Draft</button>
- frontend\src\pages\Clients.jsx line 4255: <button type="button" className="btn btn-secondary btn-small" onClick={clearClientDraft} disabled={!hasRecoverableDraft}>Clear Draft</button>
- frontend\src\pages\Clients.jsx line 4886: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5248: <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 1)}>Edit</button>
- frontend\src\pages\Clients.jsx line 5255: <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 2)}>Edit</button>
- frontend\src\pages\Clients.jsx line 5258: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5277: <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 3)}>Edit</button>
- frontend\src\pages\Clients.jsx line 5280: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5297: <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 4)}>Edit</button>
- frontend\src\pages\Clients.jsx line 5300: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5315: <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 5)}>Edit</button>
- frontend\src\pages\Clients.jsx line 5318: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5361: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5396: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5404: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5442: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5450: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5488: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5496: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 5537: className="btn btn-secondary btn-small"
- frontend\src\pages\Clients.jsx line 4030: <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
- frontend\src\pages\Clients.jsx line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- frontend\src\pages\Clients.jsx line 4522: <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>

### frontend\src\pages\ClientsBackUpCopy.jsx

- frontend\src\pages\ClientsBackUpCopy.jsx line 650: "Step-father",
- frontend\src\pages\ClientsBackUpCopy.jsx line 651: "Step-mother",
- frontend\src\pages\ClientsBackUpCopy.jsx line 652: "Step-sister",
- frontend\src\pages\ClientsBackUpCopy.jsx line 653: "Step-brother",
- frontend\src\pages\ClientsBackUpCopy.jsx line 2482: <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
- frontend\src\pages\ClientsBackUpCopy.jsx line 2559: <button type="button" className="btn btn-secondary btn-small" onClick={clearDirectoryFilters}>Clear Filters</button>
- frontend\src\pages\ClientsBackUpCopy.jsx line 2594: <button type="button" className="btn btn-secondary" onClick={searchGoogleContacts}>Search Google Contacts Connector</button>
- frontend\src\pages\ClientsBackUpCopy.jsx line 2604: <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(client)}>Edit / Load</button>
- frontend\src\pages\ClientsBackUpCopy.jsx line 2478: <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>

### frontend\src\pages\Deadlines.jsx

- frontend\src\pages\Deadlines.jsx line 156: <button className="btn btn-secondary" onClick={handleCancel}>
- frontend\src\pages\Deadlines.jsx line 254: <button type="button" className="btn btn-secondary" onClick={handleCancel}>
- frontend\src\pages\Deadlines.jsx line 306: className="btn btn-secondary btn-small"
- frontend\src\pages\Deadlines.jsx line 152: <button className="btn btn-primary" onClick={() => setShowForm(true)}>
- frontend\src\pages\Deadlines.jsx line 251: <button type="submit" className="btn btn-primary">

### frontend\src\pages\Documents.jsx

- frontend\src\pages\Documents.jsx line 187: <button className="btn btn-secondary" onClick={handleCancel}>
- frontend\src\pages\Documents.jsx line 193: className="btn btn-secondary"
- frontend\src\pages\Documents.jsx line 285: <button type="button" className="btn btn-secondary" onClick={handleCancel}>
- frontend\src\pages\Documents.jsx line 183: <button className="btn btn-primary" onClick={() => setShowForm(true)}>
- frontend\src\pages\Documents.jsx line 282: <button type="submit" className="btn btn-primary" disabled={isSubmitting}>

### frontend\src\pages\MatterIntakeWizard.jsx

- frontend\src\pages\MatterIntakeWizard.jsx line 361: const stepLabel = STEPS[step - 1] || STEPS[0];
- frontend\src\pages\MatterIntakeWizard.jsx line 567: if (step === 1) {
- frontend\src\pages\MatterIntakeWizard.jsx line 581: if (step === 1) {
- frontend\src\pages\MatterIntakeWizard.jsx line 601: if (step < STEPS.length) {
- frontend\src\pages\MatterIntakeWizard.jsx line 614: if (step === 1 && clientStepMode === CLIENT_STEP_MODE.SEARCH) {
- frontend\src\pages\MatterIntakeWizard.jsx line 654: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 874: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 895: <p className="eyebrow">Step 1B</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1111: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 1134: <p className="eyebrow">Step {step}</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1163: <span className="intake-status-pill">Step 2 of {STEPS.length}</span>
- frontend\src\pages\MatterIntakeWizard.jsx line 1168: {step === 1 ? renderClientDetailsStep() : renderLaterStep()}
- frontend\src\pages\MatterIntakeWizard.jsx line 860: <p className="eyebrow">Stage 2 · Existing Client Decision</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1159: <p>Stage 2 · Client Gate</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 646: ← Previous Page
- frontend\src\pages\MatterIntakeWizard.jsx line 1105: ← Previous Page
- frontend\src\pages\MatterIntakeWizard.jsx line 650: Home Main Page
- frontend\src\pages\MatterIntakeWizard.jsx line 654: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 874: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 1111: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 663: {isTop ? "Go to Bottom/End of Page ↓" : "Go to Top of Page ↑"}
- frontend\src\pages\MatterIntakeWizard.jsx line 663: {isTop ? "Go to Bottom/End of Page ↓" : "Go to Top of Page ↑"}
- frontend\src\pages\MatterIntakeWizard.jsx line 3: const CLIENT_STEP_MODE = {
- frontend\src\pages\MatterIntakeWizard.jsx line 10: const STEPS = [
- frontend\src\pages\MatterIntakeWizard.jsx line 346: const [step, setStep] = useState(1);
- frontend\src\pages\MatterIntakeWizard.jsx line 347: const [clientStepMode, setClientStepMode] = useState(CLIENT_STEP_MODE.SEARCH);
- frontend\src\pages\MatterIntakeWizard.jsx line 361: const stepLabel = STEPS[step - 1] || STEPS[0];
- frontend\src\pages\MatterIntakeWizard.jsx line 423: setClientStepMode(CLIENT_STEP_MODE.EXISTING_SELECTED);
- frontend\src\pages\MatterIntakeWizard.jsx line 476: clientStepMode,
- frontend\src\pages\MatterIntakeWizard.jsx line 508: setClientStepMode(CLIENT_STEP_MODE.SEARCH);
- frontend\src\pages\MatterIntakeWizard.jsx line 526: setClientStepMode(CLIENT_STEP_MODE.DUPLICATE_REVIEW);
- frontend\src\pages\MatterIntakeWizard.jsx line 545: setStep(2);
- frontend\src\pages\MatterIntakeWizard.jsx line 561: setStep(2);
- frontend\src\pages\MatterIntakeWizard.jsx line 566: function previousStep() {
- frontend\src\pages\MatterIntakeWizard.jsx line 567: if (step === 1) {
- frontend\src\pages\MatterIntakeWizard.jsx line 568: if (clientStepMode !== CLIENT_STEP_MODE.SEARCH) {
- frontend\src\pages\MatterIntakeWizard.jsx line 569: setClientStepMode(CLIENT_STEP_MODE.SEARCH);
- frontend\src\pages\MatterIntakeWizard.jsx line 577: setStep((current) => Math.max(1, current - 1));
- frontend\src\pages\MatterIntakeWizard.jsx line 580: function nextStep() {
- frontend\src\pages\MatterIntakeWizard.jsx line 581: if (step === 1) {
- frontend\src\pages\MatterIntakeWizard.jsx line 582: if (clientStepMode === CLIENT_STEP_MODE.EXISTING_SELECTED) {
- frontend\src\pages\MatterIntakeWizard.jsx line 587: if (clientStepMode === CLIENT_STEP_MODE.CREATE) {
- frontend\src\pages\MatterIntakeWizard.jsx line 592: if (clientStepMode === CLIENT_STEP_MODE.DUPLICATE_REVIEW) {
- frontend\src\pages\MatterIntakeWizard.jsx line 601: if (step < STEPS.length) {
- frontend\src\pages\MatterIntakeWizard.jsx line 602: setStep((current) => current + 1);
- frontend\src\pages\MatterIntakeWizard.jsx line 614: if (step === 1 && clientStepMode === CLIENT_STEP_MODE.SEARCH) {
- frontend\src\pages\MatterIntakeWizard.jsx line 619: previousStep();
- frontend\src\pages\MatterIntakeWizard.jsx line 653: <button type="button" onClick={nextStep}>
- frontend\src\pages\MatterIntakeWizard.jsx line 654: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 669: function renderStepTabs() {
- frontend\src\pages\MatterIntakeWizard.jsx line 671: <div className="intake-step-grid">
- frontend\src\pages\MatterIntakeWizard.jsx line 672: {STEPS.map((label, index) => {
- frontend\src\pages\MatterIntakeWizard.jsx line 674: const active = number === step;
- frontend\src\pages\MatterIntakeWizard.jsx line 677: <div key={label} className={`intake-step-pill ${active ? "active" : ""}`}>
- frontend\src\pages\MatterIntakeWizard.jsx line 870: <button type="button" className="secondary-action" onClick={() => setClientStepMode(CLIENT_STEP_MODE.SEARCH)}>
- frontend\src\pages\MatterIntakeWizard.jsx line 874: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 895: <p className="eyebrow">Step 1B</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1104: <button type="button" className="secondary-action" onClick={() => setClientStepMode(CLIENT_STEP_MODE.SEARCH)}>
- frontend\src\pages\MatterIntakeWizard.jsx line 1111: Continue to Next Step →
- frontend\src\pages\MatterIntakeWizard.jsx line 1120: function renderClientDetailsStep() {
- frontend\src\pages\MatterIntakeWizard.jsx line 1121: if (clientStepMode === CLIENT_STEP_MODE.SEARCH) return renderSearchModule();
- frontend\src\pages\MatterIntakeWizard.jsx line 1122: if (clientStepMode === CLIENT_STEP_MODE.CREATE) return renderNewClientCreationModule();
- frontend\src\pages\MatterIntakeWizard.jsx line 1123: if (clientStepMode === CLIENT_STEP_MODE.EXISTING_SELECTED) return renderExistingSelectedModule();
- frontend\src\pages\MatterIntakeWizard.jsx line 1124: if (clientStepMode === CLIENT_STEP_MODE.DUPLICATE_REVIEW) return renderDuplicateReviewModule();
- frontend\src\pages\MatterIntakeWizard.jsx line 1129: function renderLaterStep() {
- frontend\src\pages\MatterIntakeWizard.jsx line 1134: <p className="eyebrow">Step {step}</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1135: <h2>{stepLabel}</h2>
- frontend\src\pages\MatterIntakeWizard.jsx line 1160: <h2>{stepLabel}</h2>
- frontend\src\pages\MatterIntakeWizard.jsx line 1163: <span className="intake-status-pill">Step 2 of {STEPS.length}</span>
- frontend\src\pages\MatterIntakeWizard.jsx line 1168: {step === 1 ? renderClientDetailsStep() : renderLaterStep()}
- frontend\src\pages\MatterIntakeWizard.jsx line 860: <p className="eyebrow">Stage 2 · Existing Client Decision</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1137: Continue the matter intake workflow using the client selected or created in this stage.
- frontend\src\pages\MatterIntakeWizard.jsx line 1159: <p>Stage 2 · Client Gate</p>
- frontend\src\pages\MatterIntakeWizard.jsx line 1137: Continue the matter intake workflow using the client selected or created in this stage.
- frontend\src\pages\MatterIntakeWizard.jsx line 1156: <div className="matter-intake-workflow">
- frontend\src\pages\MatterIntakeWizard.jsx line 1157: <div className="intake-workflow-header">

### frontend\src\pages\OperationsDashboard.jsx

- frontend\src\pages\OperationsDashboard.jsx line 79: function ProgressBar({ label, value }) {
- frontend\src\pages\OperationsDashboard.jsx line 81: <div style={progressWrapperStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 82: <div style={progressHeaderStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 87: <div style={progressTrackStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 90: ...progressFillStyle,
- frontend\src\pages\OperationsDashboard.jsx line 100: const progressData = [
- frontend\src\pages\OperationsDashboard.jsx line 101: { name: "Backend", value: data.progress.backendFoundation },
- frontend\src\pages\OperationsDashboard.jsx line 102: { name: "Database", value: data.progress.databaseLayer },
- frontend\src\pages\OperationsDashboard.jsx line 103: { name: "Monitoring", value: data.progress.monitoringLayer },
- frontend\src\pages\OperationsDashboard.jsx line 104: { name: "Integrity", value: data.progress.integrityLayer },
- frontend\src\pages\OperationsDashboard.jsx line 105: { name: "Auto-Heal", value: data.progress.autoHealLayer },
- frontend\src\pages\OperationsDashboard.jsx line 106: { name: "Dashboard", value: data.progress.operationsDashboard },
- frontend\src\pages\OperationsDashboard.jsx line 107: { name: "Security", value: data.progress.securityLayer },
- frontend\src\pages\OperationsDashboard.jsx line 108: { name: "AI", value: data.progress.aiLayer }
- frontend\src\pages\OperationsDashboard.jsx line 190: <h3 style={sectionTitleStyle}>Enterprise Progress Chart</h3>
- frontend\src\pages\OperationsDashboard.jsx line 194: <BarChart data={progressData}>
- frontend\src\pages\OperationsDashboard.jsx line 205: <h3 style={sectionTitleStyle}>Progress Bars</h3>
- frontend\src\pages\OperationsDashboard.jsx line 208: {progressData.map(item => (
- frontend\src\pages\OperationsDashboard.jsx line 209: <ProgressBar key={item.name} label={item.name} value={item.value} />
- frontend\src\pages\OperationsDashboard.jsx line 419: const progressWrapperStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 423: const progressHeaderStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 431: const progressTrackStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 438: const progressFillStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 79: function ProgressBar({ label, value }) {
- frontend\src\pages\OperationsDashboard.jsx line 81: <div style={progressWrapperStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 82: <div style={progressHeaderStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 87: <div style={progressTrackStyle}>
- frontend\src\pages\OperationsDashboard.jsx line 90: ...progressFillStyle,
- frontend\src\pages\OperationsDashboard.jsx line 100: const progressData = [
- frontend\src\pages\OperationsDashboard.jsx line 101: { name: "Backend", value: data.progress.backendFoundation },
- frontend\src\pages\OperationsDashboard.jsx line 102: { name: "Database", value: data.progress.databaseLayer },
- frontend\src\pages\OperationsDashboard.jsx line 103: { name: "Monitoring", value: data.progress.monitoringLayer },
- frontend\src\pages\OperationsDashboard.jsx line 104: { name: "Integrity", value: data.progress.integrityLayer },
- frontend\src\pages\OperationsDashboard.jsx line 105: { name: "Auto-Heal", value: data.progress.autoHealLayer },
- frontend\src\pages\OperationsDashboard.jsx line 106: { name: "Dashboard", value: data.progress.operationsDashboard },
- frontend\src\pages\OperationsDashboard.jsx line 107: { name: "Security", value: data.progress.securityLayer },
- frontend\src\pages\OperationsDashboard.jsx line 108: { name: "AI", value: data.progress.aiLayer }
- frontend\src\pages\OperationsDashboard.jsx line 190: <h3 style={sectionTitleStyle}>Enterprise Progress Chart</h3>
- frontend\src\pages\OperationsDashboard.jsx line 194: <BarChart data={progressData}>
- frontend\src\pages\OperationsDashboard.jsx line 205: <h3 style={sectionTitleStyle}>Progress Bars</h3>
- frontend\src\pages\OperationsDashboard.jsx line 208: {progressData.map(item => (
- frontend\src\pages\OperationsDashboard.jsx line 209: <ProgressBar key={item.name} label={item.name} value={item.value} />
- frontend\src\pages\OperationsDashboard.jsx line 419: const progressWrapperStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 423: const progressHeaderStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 431: const progressTrackStyle = {
- frontend\src\pages\OperationsDashboard.jsx line 438: const progressFillStyle = {

### frontend\src\pages\ProjectDashboard.jsx

- frontend\src\pages\ProjectDashboard.jsx line 76: <h3>Progress</h3>
- frontend\src\pages\ProjectDashboard.jsx line 76: <h3>Progress</h3>

## Root: frontend/src/components

### frontend\src\components\legal-management-shell\LegalManagementShell.jsx

- frontend\src\components\legal-management-shell\LegalManagementShell.jsx line 96: <button type="button">ðŸ‘¤ Client Intake Workflow</button>

### frontend\src\components\ClientIntakeDiscoveryPrototype.jsx

- frontend\src\components\ClientIntakeDiscoveryPrototype.jsx line 114: <nav className="client-intake-stepper" aria-label="Client intake sections">
- frontend\src\components\ClientIntakeDiscoveryPrototype.jsx line 347: "Key dates, event sequence, deadline timeline, limitation risk, and current procedural stage."
- frontend\src\components\ClientIntakeDiscoveryPrototype.jsx line 425: <option>Stage-based fee</option>

### frontend\src\components\ClientIntakeProposalPreview.jsx

- frontend\src\components\ClientIntakeProposalPreview.jsx line 216: const nextSteps = [
- frontend\src\components\ClientIntakeProposalPreview.jsx line 416: "Approve scope, fees, and next steps before formal work starts",
- frontend\src\components\ClientIntakeProposalPreview.jsx line 421: <PreviewBlock title="9. Recommended Next Steps">
- frontend\src\components\ClientIntakeProposalPreview.jsx line 422: <PreviewList items={nextSteps} />

## 4. Preliminary Audit Decision

Do not perform a broad all-page rewrite.

Use a single global standard and apply it first to the Clients Page only.

Other pages should be aligned later one controlled page at a time.

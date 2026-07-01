# Litigation 360 / LEOS 360
# Phase 14A Clients Core Profile Cluster Handover SSOT

Date: 2026-07-01
Branch:
phase-14a-green-recovery-checkpoint
HEAD at handover creation:
103a2a1

## 1. Executive Summary

This document is the single source of truth for the Phase 14A Clients Core Profile Cluster.

Project purpose:

- Stabilize and standardize the Clients page section order in small, safe, auditable passes.
- Preserve all existing logic, handlers, fields, validation, masking, directory behavior, draft behavior, and manual-management behavior.
- Prevent unsafe broad rewrites or accidental backend/package/App.jsx changes.

Current status:

- Pass 1 through Pass 4 are complete and closed.
- The clean break milestone has been reached.

Clean break milestone:

Phase 14A Clients Core Profile Cluster Handover.

Destination / goal:

- Continue toward the full Clients Page Section Reorder only through separately gated, one-section-at-a-time passes.
- Next expected pass is Pass 5: Matter Context / Case Origin.

## 2. Project Parameters & Protocols

Mandatory working root:

- C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

Working branch:

-
phase-14a-green-recovery-checkpoint

Primary implementation file:

- frontend/src/pages/Clients.jsx

Mandatory verification commands:

- git status --short
- git diff --name-only
- git diff --check
- npm --prefix .\frontend run build

Non-blocking warning:

- Vite chunk-size warning above 500 kB may remain.
- This is not part of the Clients reorder lane.
- It belongs only to a future performance/code-splitting lane.

Blocked scope unless separately approved:

- frontend/src/App.jsx
- frontend/src/App.css unless explicitly approved
- Backend
- Database
- API routes
- Auth
- RBAC
- Package/dependency files
- Server files
- Environment files
- Upload/storage logic
- PDF generation
- Browser print execution
- Print buttons
- Email sending
- Export behavior
- Billing/payment
- Migrations
- Production deployment
- Component extraction
- Full 10-section reorder in one patch

Implementation rules:

- One pass equals one section group only.
- No broad/global replacements.
- No handler renames.
- No state-shape changes.
- No field-key renames.
- No invented fields.
- No hidden feature additions.
- Every pass must have a gate, local map where needed, implementation commit, QA record, and closeout SSOT.

## 3. Timeline & Currency Tracker

### Past - Completed / Achieved

- Corrective Clients consolidation cleanup completed.
- Clients navigation/orientation standardization completed.
- Pass 1 completed: Header / alert / Client Summary Dashboard alignment.
- Pass 2 completed: Client Identity & Authority alignment.
- Pass 3 completed: Employment & Organisation Details alignment.
- Pass 4 completed: Family / Marital / Dependents Details alignment.
- Final verification audit generated.
- Core Profile Cluster handover generated.

### Present - Current / Active

- Current active milestone: Phase 14A Clients Core Profile Cluster Handover.
- Current state: clean break after Pass 4.
- Current implementation file: frontend/src/pages/Clients.jsx.
- Current permitted action: commit this final audit and handover, then start a new thread.

### Upcoming - Planned / Future

- Pass 5: Matter Context / Case Origin.
- Pass 6 and later: only after separate mapping and gates.
- Future performance/code-splitting lane for Vite chunk-size warning.
- Future full Clients reorder only after all section-by-section passes are complete and closed.

## 4. Decision Log

| Decision | Rationale | Status |
|---|---|---|
| Use small gated passes | Prevent unsafe broad edits and reduce regression risk | Active |
| Preserve Clients.jsx behavior | Existing validation, masking, search, draft, and manual management are fragile and must remain stable | Active |
| Do not touch App.jsx/backend/package files | Out of scope for Clients section wording/reorder | Active |
| Treat Vite chunk warning as non-blocking | Build succeeds and performance work belongs to a different lane | Active |
| Do not invent missing fields | Maps confirmed several requested concepts were not real fields | Active |
| Stop after Pass 4 for handover | Passes 1-4 form a logical core profile cluster | Completed |

## 5. Variation Registry

| Variation / Lane | Status | Notes |
|---|---|---|
| Corrective Clients consolidation cleanup | Merged / closed | Removed old static remnants and preserved real components |
| Global navigation/orientation standard | Merged / governing | Stage/step/page navigation rule set |
| Clients Navigation / Orientation Standardization | Merged / closed | Standardized Stage 2 Client Gate and page controls |
| Pass 1 - Header / Alert / Dashboard | Merged / closed | Closed with QA and closeout |
| Pass 2 - Identity & Authority | Merged / closed | No invented clientType/clientClassification/signatory fields |
| Pass 3 - Employment & Organisation | Merged / closed | Only existing employmentStatus preserved |
| Pass 4 - Family / Marital / Dependents | Merged / closed | Preserved maritalStatus, hasDependents, dependentsCount, dependentNotes |
| Full 10-section reorder in one patch | Deprecated / blocked | Too risky; must remain broken into passes |
| Component extraction | Blocked | Not approved in this cluster |
| Performance/code-splitting | Future lane | Only for Vite chunk-size warning |
| Pass 5 - Matter Context / Case Origin | Upcoming | Must open as separate gate in new thread |

## 6. Compliance Checklist

Every future addition or variation must meet all of these:

- Uses this handover as source of truth.
- Starts with a clean git status.
- Creates or references a gate before implementation.
- Creates a local map before changing fragile section anchors.
- Changes only frontend/src/pages/Clients.jsx unless separately approved.
- Preserves anchors.
- Preserves handlers.
- Preserves state shape.
- Preserves field keys.
- Preserves validation and masking.
- Preserves directory/search/table behavior.
- Preserves draft save/restore behavior.
- Runs git diff --check.
- Runs npm frontend build.
- Creates QA record.
- Creates closeout SSOT.
- Commits implementation and docs separately where possible.
- Does not proceed to the next pass until the current pass is closed.

## 7. Defined Path & Journey

Completed path:

1. Stabilize Clients top area.
2. Close navigation/orientation standard.
3. Pass 1 - Header / alert / dashboard.
4. Pass 2 - Identity & Authority.
5. Pass 3 - Employment & Organisation.
6. Pass 4 - Family / Marital / Dependents.
7. Final audit and handover.

Next path:

1. Start a new thread.
2. Paste or attach this handover SSOT.
3. Run checkpoint commands.
4. Open Pass 5 gate only.
5. Create Pass 5 local map.
6. Apply a small Clients-only Pass 5 patch.
7. Create Pass 5 QA and closeout.

## 8. Industry Standards Reference

Documentation standards:

- Use clear Phase / Pass / Gate / QA / Closeout naming.
- Use date-stamped markdown files.
- Use SSOT documents for handover and governance.
- Use explicit blocked-scope lists.
- Use evidence-based verification, not assumptions.

Naming convention:

- Gates: PHASE_14A_CLIENTS_SECTION_REORDER_PASS_X_IMPLEMENTATION_GATE_YYYYMMDD.md
- Maps: PHASE_14A_CLIENTS_SECTION_REORDER_PASS_X_TOPIC_LOCAL_MAP_YYYYMMDD.md
- QA: PHASE_14A_CLIENTS_SECTION_REORDER_PASS_X_QA_RECORD_YYYYMMDD.md
- Closeout: PHASE_14A_CLIENTS_SECTION_REORDER_PASS_X_CLOSEOUT_SSOT_YYYYMMDD.md
- Handover: PHASE_14A_CLIENTS_CORE_PROFILE_CLUSTER_HANDOVER_SSOT_YYYYMMDD.md

Git standards:

- Keep commits small.
- Use docs commits for gates, maps, QA, closeout, and handovers.
- Use refactor commits for Clients.jsx wording/alignment patches.
- Do not mix unrelated changes.

## 9. Version Control & Update Protocol

This handover is authoritative after commit.

Update rules:

- Do not edit this handover casually.
- If later passes extend the project, create a new handover or append a clearly dated supersession record.
- Do not duplicate conflicting SSOTs.
- If a future SSOT replaces this one, mark this one as superseded by filename and commit hash.
- Every future pass must cite the latest handover in its gate.

Synchronization protocol:

1. Start with git status --short.
2. Confirm the branch.
3. Read this SSOT.
4. Confirm the previous pass closeout exists.
5. Create the new gate.
6. Create the new map.
7. Patch only the approved scope.
8. Build and diff-check.
9. Commit.
10. Create QA and closeout.
11. Commit docs.

## 10. Final Verification Snapshot

Required final Clients.jsx evidence:

Stage 2 · Client Gate :: line 3944 :: <p className="client-profile-summary-kicker">Stage 2 · Client Gate</p>
Client Search & Duplicate Detection :: line 3945 :: <h2>Client Search & Duplicate Detection</h2>
Client File Alert / Status :: line 4008 :: <p className="client-profile-completion-kicker">Client File Alert / Status</p>
Client Summary Dashboard :: line 3964 :: <p className="client-profile-summary-kicker">Client Summary Dashboard</p>
Client Summary Dashboard :: line 3965 :: <h3>Client Summary Dashboard</h3>
Client Identity & Authority :: line 3975 :: <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
Client Identity & Authority :: line 4284 :: <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
Client Identity & Authority :: line 5753 :: <h4>Client Identity & Authority Review</h4>
Client Identity & Authority :: line 5755 :: <a href="#client-profile-details" className="client-profile-review-link">Jump to Client Identity & Authority</a>
client-profile-details :: line 2015 :: { anchor: "client-profile-details", label: "Identity & Authority" },
client-profile-details :: line 3975 :: <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
client-profile-details :: line 4022 :: <a href="#client-profile-details">Identity & Authority</a>
client-profile-details :: line 4284 :: <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
client-profile-details :: line 5755 :: <a href="#client-profile-details" className="client-profile-review-link">Jump to Client Identity & Authority</a>
Client Identification Details :: line 3976 :: <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
Client Identification Details :: line 4358 :: <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
client-identification-details :: line 2016 :: { anchor: "client-identification-details", label: "Identification" },
client-identification-details :: line 3976 :: <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
client-identification-details :: line 4358 :: <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
Employment & Organisation Details :: line 3977 :: <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
Employment & Organisation Details :: line 4464 :: <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
client-employment-details :: line 2017 :: { anchor: "client-employment-details", label: "Employment & Organisation" },
client-employment-details :: line 3977 :: <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
client-employment-details :: line 4464 :: <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
employmentStatus :: line 86 :: employmentStatus: "To be confirmed",
employmentStatus :: line 1317 :: employmentStatus: source.employmentStatus || "To be confirmed",
employmentStatus :: line 3483 :: normalized.employmentStatus,
employmentStatus :: line 4465 :: <p className="client-profile-card-help">Employment and organisation-related status details. Existing employmentStatus field, options, rules, validation, and handlers remain preserved.</p>
employmentStatus :: line 4470 :: <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
employmentStatus :: line 5891 :: <td>{normalized.employmentStatus || "-"}</td>
EMPLOYMENT_STATUS_OPTIONS :: line 530 :: const EMPLOYMENT_STATUS_OPTIONS = [
EMPLOYMENT_STATUS_OPTIONS :: line 4471 :: {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
Family / Marital / Dependents Details :: line 3978 :: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family / Marital / Dependents Details</a></li>
Family / Marital / Dependents Details :: line 4479 :: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family / Marital / Dependents Details</span><span className="client-profile-card-status">Family / dependents</span></h3>
client-family-marital-details :: line 2018 :: { anchor: "client-family-marital-details", label: "Family / Marital / Dependents" },
client-family-marital-details :: line 3978 :: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family / Marital / Dependents Details</a></li>
client-family-marital-details :: line 4479 :: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family / Marital / Dependents Details</span><span className="client-profile-card-status">Family / dependents</span></h3>
maritalStatus :: line 87 :: maritalStatus: "To be confirmed",
maritalStatus :: line 1318 :: maritalStatus: source.maritalStatus || "To be confirmed",
maritalStatus :: line 1529 :: ["Family / Marital / Dependents", form.maritalStatus],
maritalStatus :: line 3484 :: normalized.maritalStatus,
maritalStatus :: line 4480 :: <p className="client-profile-card-help">Family, marital, and dependents status information. Existing maritalStatus, hasDependents, dependentsCount, dependentNotes, conditional rules, validation, and handlers remain preserved.</p>
maritalStatus :: line 4485 :: <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
maritalStatus :: line 5892 :: <td>{normalized.maritalStatus || "-"}</td>
MARITAL_STATUS_OPTIONS :: line 547 :: const MARITAL_STATUS_OPTIONS = [
MARITAL_STATUS_OPTIONS :: line 4486 :: {MARITAL_STATUS_OPTIONS.map((option) => (
hasDependents :: line 88 :: hasDependents: false,
hasDependents :: line 1319 :: hasDependents: Boolean(source.hasDependents),
hasDependents :: line 2825 :: if (field === "hasDependents") {
hasDependents :: line 2827 :: next.hasDependents = checked;
hasDependents :: line 3190 :: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
hasDependents :: line 4480 :: <p className="client-profile-card-help">Family, marital, and dependents status information. Existing maritalStatus, hasDependents, dependentsCount, dependentNotes, conditional rules, validation, and handlers remain preserved.</p>
hasDependents :: line 4495 :: checked={Boolean(form.hasDependents)}
hasDependents :: line 4496 :: onChange={(event) => updateForm("hasDependents", event.target.checked)}
hasDependents :: line 4501 :: {form.hasDependents && (
dependentsCount :: line 89 :: dependentsCount: "",
dependentsCount :: line 1320 :: dependentsCount: source.dependentsCount || "",
dependentsCount :: line 2829 :: next.dependentsCount = "";
dependentsCount :: line 3190 :: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
dependentsCount :: line 3194 :: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
dependentsCount :: line 4480 :: <p className="client-profile-card-help">Family, marital, and dependents status information. Existing maritalStatus, hasDependents, dependentsCount, dependentNotes, conditional rules, validation, and handlers remain preserved.</p>
dependentsCount :: line 4508 :: value={form.dependentsCount}
dependentsCount :: line 4509 :: onChange={(event) => updateForm("dependentsCount", event.target.value)}
dependentNotes :: line 90 :: dependentNotes: "",
dependentNotes :: line 1321 :: dependentNotes: source.dependentNotes || "",
dependentNotes :: line 2830 :: next.dependentNotes = "";
dependentNotes :: line 4480 :: <p className="client-profile-card-help">Family, marital, and dependents status information. Existing maritalStatus, hasDependents, dependentsCount, dependentNotes, conditional rules, validation, and handlers remain preserved.</p>
dependentNotes :: line 4517 :: value={form.dependentNotes}
dependentNotes :: line 4518 :: onChange={(event) => updateForm("dependentNotes", event.target.value)}
ClientRequiredFieldCounter :: line 1888 :: function ClientRequiredFieldCounter() {
ClientRequiredFieldCounter :: line 4017 :: <ClientRequiredFieldCounter />
ClientSectionCompletionStatus :: line 2013 :: function ClientSectionCompletionStatus() {
ClientSectionCompletionStatus :: line 4019 :: <ClientSectionCompletionStatus />

## 11. Recent Commit Chain

103a2a1 docs(phase-14a): close clients section reorder pass four
2ee7b19 refactor(phase-14a): align clients family marital dependents section
9d2a8be docs(phase-14a): open clients section reorder pass four gate
25004f8 docs(phase-14a): close clients section reorder pass three
0c3956b refactor(phase-14a): align clients employment organisation section
ffaa780 docs(phase-14a): open clients section reorder pass three gate
c583c2c docs(phase-14a): close clients section reorder pass two
84d36b3 refactor(phase-14a): align clients identity authority section
612dc63 docs(phase-14a): open clients section reorder pass two gate
5ed09f9 docs(phase-14a): close clients section reorder pass one
63cf9f3 refactor(phase-14a): align clients header alert dashboard
5fdd1cc refactor(phase-14a): standardize clients navigation orientation
6b61562 docs(phase-14a): open clients navigation orientation implementation gate
67ce554 docs(phase-14a): define global navigation orientation standard
c1ed7df docs(phase-14a): close corrective clients consolidation cleanup
d8eeb4b refactor(phase-14a): apply clients consolidation cleanup
a0423f4 docs(phase-14a): add clients section reorder pass one anchor digest
8d05b4d docs(phase-14a): map clients section reorder pass one
bce371c docs(phase-14a): open clients section reorder implementation gate
59fd58d docs(phase-14a): add clients page section reorder planning blueprint
3a5c9f9 docs(phase-14a): open clients page section reorder planning gate
55445de docs(phase-14a): close clients page consolidation implementation
e124ca0 fix(phase-14a): clarify matter intake module metadata
3852f6f fix(phase-14a): remove repeated open status from matter intake badge
d64185c fix(phase-14a): simplify matter intake helper text
5cc3bcb fix(phase-14a): simplify matter intake stage label
ae162dd fix(phase-14a): hide duplicate module header for matter intake
d9cb9d7 fix(phase-14a): remove duplicate matter intake callout
d9fcd89 fix(phase-14a): remove duplicate matter intake step header
9bf60cb docs(phase-14a): open clients page consolidation implementation gate
3936b1c docs(phase-14a): remove trailing whitespace in clients consolidation audit blueprint
2ba6a86 docs(phase-14a): add clients page consolidation audit blueprint
5849506 docs(phase-14a): open clients page consolidation gate
1c6ade5 docs(phase-14a): refresh handover after proposal print styling
980bae3 docs(phase-14a): close proposal print styling implementation
224dd16 style(phase-14a): improve proposal read mode print styling
100cdf7 docs(phase-14a): open proposal print styling implementation gate
9396d59 docs(phase-14a): add proposal print styling planning blueprint
193ff4c docs(phase-14a): add proposal print styling planning blueprint
a4b0c07 docs(phase-14a): remove trailing whitespace in print styling blueprint

## 12. Final Handover Conclusion

Phase 14A Clients Core Profile Cluster is closed after this audit and handover are committed.

There is literally nothing more to do inside this closed cluster if the commit succeeds and git status is clean.

The only valid next action is to start a new thread and open Pass 5 under a new gate.

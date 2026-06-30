# Litigation 360 / LEOS 360
# Phase 14A Clients Page Section Reorder Planning Blueprint

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 3a5c9f9

## 1. Planning Status

PLANNING BLUEPRINT CREATED.

This is documentation-only.

No Clients.jsx reorder, JSX movement, CSS edit, App.jsx edit, component extraction, backend change, package change, or production behavior is approved by this blueprint.

## 2. Controlling Gate

PHASE_14A_CLIENTS_PAGE_SECTION_REORDER_PLANNING_GATE_20260630.md

## 3. Objective

Plan the future full Clients page section reorder into the approved 10-section structure while preserving all existing fields, actions, state, validation, masking, draft behavior, search/filter behavior, table actions, and frontend-only scope.

## 4. Current Context

The Clients page has already completed a conservative first-pass consolidation.

That first pass removed dead hidden UI, contradictory placeholder completion cards, and repetitive advisory text.

The first pass did not perform the full 10-section reorder.

The first pass did not change App.jsx or App.css.

The next reorder must be planned separately because Clients.jsx remains large and fragile.

## 5. Target Future Section Order

1. Header
2. Client File Alert / Status
3. Client Summary Dashboard
4. Client Identity & Authority
5. Conflict, Independence & Risk
6. Contact Persons & Communication
7. Engagement, Scope & Fee Readiness
8. Documents & Evidence Readiness
9. Notes, Timeline & Audit Trail
10. Bottom Actions / Navigation

## 6. Existing Current Section Groups To Inventory

Future implementation must first map the current Clients.jsx JSX into these current functional groups:

- Page header / workflow bridge.
- Client status / validation / completion shell.
- Required field counter.
- Section completion status.
- Directory search / filter controls.
- Directory table / result actions.
- Selected client profile view panel.
- Full client profile form.
- Identity and document profile fields.
- Employment / family / authority fields.
- Communication and contact preference fields.
- Address and location fields.
- Emergency contact fields.
- Verification / remarks fields.
- Draft handling controls.
- Pre-submission review panels.
- Internal notes / pending information.
- Bottom action controls and navigation.

## 7. Preserve Rules

Any future implementation must preserve:

- All existing client data capture fields.
- All existing field meanings and labels unless explicitly approved.
- Existing search/filter capability.
- Existing table/list visibility.
- Existing row-level actions.
- Existing view/edit/close/delete behavior.
- Existing draft save/restore behavior.
- Existing validation messages.
- Existing identifier masking.
- Existing local fallback behavior.
- Existing route/module continuity.
- Existing frontend-only behavior.

## 8. Safe Movement Candidates

Likely safe movement candidates, after code inspection:

- Advisory/helper text blocks.
- Section headers and surrounding wrapper blocks.
- Visual grouping shells with no state mutation.
- Read-only summary fragments.
- Static contextual paragraphs.
- Navigation checklist blocks.

These may move only if they do not carry handler dependencies or state initialization assumptions.

## 9. High-Risk / No-Move Areas Until Mapped

Do not move casually:

- Form controls connected to state updates.
- Search/filter controls.
- Directory table and row actions.
- Draft save/restore controls.
- Create/update/delete buttons.
- Validation message render blocks.
- Masked identifier render logic.
- Conditional panels tied to viewingClientProfile.
- Any block containing event handlers.
- Any block that depends on nearby conditional rendering.

These areas require exact dependency mapping before movement.

## 10. Proposed Implementation Pass Sequence

If a future implementation gate is approved, use this sequence:

### Pass 1 — Header, Alert, Dashboard Alignment

- Keep current logic untouched.
- Move only safe wrapper/header/advisory blocks.
- Align the top of page toward Header, Client File Alert / Status, and Client Summary Dashboard.
- No form-field movement yet.

### Pass 2 — Identity & Authority Grouping

- Group identity, authority, and basic profile fields.
- Preserve all field keys and handlers.
- Do not rename state variables.

### Pass 3 — Conflict, Independence & Risk Grouping

- Group risk, verification, warning, and conflict-adjacent markers.
- Preserve validation and warning rendering.

### Pass 4 — Contact Persons & Communication Grouping

- Group contact preference, primary contact, secondary contact, emergency contact, and communication notes.
- Preserve formatting and phone/email handling.

### Pass 5 — Engagement, Scope & Fee Readiness Grouping

- Group engagement context and fee/scope readiness areas only if already present.
- Do not invent new fee or scope logic.

### Pass 6 — Documents & Evidence Readiness Grouping

- Group document profile, verification, document status, and evidence-related notes.
- Preserve masking and document status behavior.

### Pass 7 — Notes, Timeline & Audit Trail Grouping

- Group internal notes, pending information, review snapshot, and audit-like sections.
- Preserve internal/staff-only meaning.

### Pass 8 — Bottom Actions / Navigation Cleanup

- Consolidate final actions and navigation only.
- Preserve save/create/update/delete/clear/reset behavior.

## 11. What Must Not Happen

Future implementation must not:

- Move the entire 5900+ line file in one pass.
- Extract components in the same reorder lane.
- Change state shape.
- Rename handler functions.
- Change route keys.
- Edit App.jsx.
- Add backend persistence.
- Add database or API assumptions.
- Add PDF, print, email, export, billing, or production behavior.
- Add dependencies.

## 12. Future Candidate Implementation Files

Primary candidate if separately approved:

- frontend/src/pages/Clients.jsx

Optional only if scoped styling is separately approved:

- frontend/src/App.css

Not candidates:

- frontend/src/App.jsx
- backend files
- database files
- API route files
- package/dependency files
- server/config/env files

## 13. Future Browser QA Checklist

### Functional Integrity

[ ] Clients page loads without crash.
[ ] Existing search/filter still works.
[ ] Existing create/edit/update/delete workflows still work.
[ ] Existing draft save/restore still works.
[ ] Existing validation messages still trigger appropriately.
[ ] Existing masking behavior remains intact.
[ ] Directory table still renders.
[ ] View Client Profile panel still works.
[ ] Row actions still work.
[ ] No key field is lost.
[ ] No key action is lost.

### Reorder UX

[ ] Header appears first.
[ ] Client File Alert / Status appears near top.
[ ] Client Summary Dashboard appears near top.
[ ] Identity & Authority section is clear.
[ ] Conflict, Independence & Risk section is clear.
[ ] Contact Persons & Communication section is clear.
[ ] Engagement, Scope & Fee Readiness section is clear.
[ ] Documents & Evidence Readiness section is clear.
[ ] Notes, Timeline & Audit Trail section is clear.
[ ] Bottom actions/navigation are clear.

### Technical Safety

[ ] App.jsx untouched.
[ ] Backend/database/API/auth/RBAC untouched.
[ ] Package/dependency files untouched.
[ ] No PDF/print/email/export behavior added.
[ ] Build passes.
[ ] git diff --check passes.

## 14. Risks and Controls

Risk: Search/filter/table behavior breaks after section movement.
Control: Do not move handler-heavy directory blocks until mapped and QA-tested.

Risk: Draft save/restore behavior breaks.
Control: Preserve state shape and submit/save handlers exactly.

Risk: Validation or masking logic is accidentally removed.
Control: Move render wrappers only; do not edit validation/masking expressions.

Risk: Full-page reorder creates an unreviewable diff.
Control: Implement one section group per commit.

Risk: Reorder turns into component extraction.
Control: Keep component extraction under a separate implementation gate.

## 15. Recommendation

Proceed to a separate frontend-only implementation gate only if the next pass is limited to one section group at a time.

Recommended next implementation gate:

PHASE_14A_CLIENTS_PAGE_SECTION_REORDER_IMPLEMENTATION_GATE_20260630.md

Recommended first implementation scope:

Pass 1 only — Header, Client File Alert / Status, and Client Summary Dashboard alignment.

Do not perform the full 10-section reorder in one commit.

## 16. Git Status at Blueprint Creation

CLEAN

## 17. Recent Commit Chain

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
c5610b4 docs(phase-14a): add proposal print styling planning blueprint
da0f4ab docs(phase-14a): integrate ui housekeeping thread into main ssot
4326e8b docs(phase-14a): open workflow badge extraction planning gate
658c039 docs(phase-14a): open proposal print styling planning gate
593e2c9 docs(phase-14a): refresh handover after proposal read mode
0deb23b docs(phase-14a): close proposal read mode implementation
202c8d5 docs(phase-14a): refresh handover after proposal read mode and button standardization
7a12ad5 docs(phase-14a): close proposal read mode preview
c836537 docs(phase-14a): refresh handover after workflow label button standardization
633c87e docs(phase-14a): close workflow label and button standardization

## 18. Planning Outcome

This blueprint is complete as a planning artifact.

No code, CSS, App.jsx, backend, database, API, package, PDF, print, email, export, billing, migration, or production changes have been performed in this planning lane.

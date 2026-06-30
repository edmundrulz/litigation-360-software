# Litigation 360 / LEOS 360
# Phase 14A Workflow Label and Button Standardization Implementation Gate

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 68ad7a3

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Workflow Label and Button Standardization Implementation

This gate approves a controlled frontend-only implementation pass after completion of the workflow numbering audit, end-to-end billing workflow map, and button design system standard.

## 2. Controlling Documents

This implementation gate is controlled by:

- docs/phase-14/audits/PHASE_14A_WORKFLOW_NUMBERING_AUDIT_RECORD_20260630.md
- docs/phase-14/maps/PHASE_14A_END_TO_END_BILLING_WORKFLOW_MAP_20260630.md
- docs/phase-14/standards/PHASE_14A_BUTTON_DESIGN_SYSTEM_STANDARD_20260630.md

## 3. Objective

Replace misleading fixed workflow numbering and inconsistent button/navigation presentation with a clearer workflow-node label system and unified button standard.

Current issue:

- Labels such as Step 1 / 6 or Stage 1 of 6 are misleading because the workflow is not actually at the beginning and the real process extends beyond six visible stages.
- Navigation buttons are inconsistent in shape, height, border, spacing, hierarchy, and label wording.

## 4. Approved Implementation Scope

Approved:

- Frontend-only UI label correction.
- Frontend-only navigation/button styling standardization.
- Remove or replace misleading Step 1 / 6, Stage 1 of 6, or fixed /6 visible labels.
- Introduce named workflow-node labeling.
- Standardize Previous, Home, Continue, Go to Bottom, and Return to Top button presentation.
- Preserve page navigation behavior.
- Preserve route keys and component names.
- Preserve build stability.

## 5. Approved Candidate Files

Primary likely files:

- frontend/src/App.jsx
- frontend/src/App.css

Optional only if the actual button/navigation markup is located there:

- frontend/src/components/*.jsx
- frontend/src/pages/*.jsx

Documentation update if needed:

- docs/phase-14/audits/PHASE_14A_WORKFLOW_NUMBERING_AUDIT_RECORD_20260630.md
- docs/phase-14/standards/PHASE_14A_BUTTON_DESIGN_SYSTEM_STANDARD_20260630.md

## 6. Strictly Blocked Scope

Do not touch:

- Backend
- Database
- API routes
- Auth
- RBAC
- Package files
- Server files
- Environment files
- Upload logic
- File storage
- PDF generation
- Browser print implementation
- Email sending
- Billing/payment implementation
- Migrations
- Production deployment

## 7. Route and Label Safety Rule

Do not use broad/global replacements in App.jsx.

Route keys, component names, import names, object keys, and visible display labels must be treated separately.

Do not change stable internal route keys unless explicitly required and verified.

Examples of protected route keys:

- Documents
- Clients
- Draft Engagement Preview
- Review Submit

## 8. Required Workflow Label Standard

Do not display:

- Step 1 / 6
- Stage 1 of 6
- 1 / 6
- Any fixed total count until the full workflow is approved

Preferred visible format:

Phase 14A - [Workflow Area] - Current Node: [Node Name] - [Status]

Compact badge format:

Current Node: [Node Name] - [Status]

Optional secondary metadata:

Workflow Code: WF-[number]

## 9. Approved Status Values

Allowed statuses:

- DRAFT
- OPEN
- IN REVIEW
- READY
- BLOCKED
- APPROVED
- CLOSED

Status must describe readiness and state, not fake progress.

## 10. Required Button Label Standard

Preferred navigation labels:

- Previous
- Home
- Continue
- Go to Bottom
- Return to Top

Replace overly long labels where safe:

- Previous Page -> Previous
- Home Main Page -> Home
- Continue to Next Step -> Continue
- Go to Bottom/End of Page -> Go to Bottom
- Return to Top/Beginning of Page -> Return to Top

## 11. Required Button Visual Hierarchy

Navigation groups must use:

- Previous = secondary / outline
- Home = secondary / neutral
- Continue = primary / filled
- Go to Bottom = tertiary / subtle
- Return to Top = tertiary / subtle

Only one primary action should appear in a navigation group.

## 12. Required Button Styling Standard

Use consistent:

- Height
- Border radius
- Padding
- Font weight
- Border width
- Gap
- Hover state
- Active state
- Focus-visible state
- Disabled state
- Responsive stacking behavior

Recommended baseline:

- Height: 44px minimum preferred
- Border radius: 10px to 12px
- Font weight: 600
- Horizontal padding: 16px to 24px
- Gap: 12px to 16px

## 13. Browser QA Checklist

[ ] No visible Step 1 / 6 badge remains.
[ ] No misleading Stage 1 of 6 label remains.
[ ] No fixed /6 workflow count remains unless clearly marked as draft/provisional.
[ ] Workflow badge uses node-based naming.
[ ] Status badge still shows state such as OPEN.
[ ] Previous button label is standardized.
[ ] Home button label is standardized.
[ ] Continue button label is standardized.
[ ] Go to Bottom button label is standardized.
[ ] Return to Top button label is standardized.
[ ] Button height and radius are consistent.
[ ] Primary/secondary/tertiary hierarchy is visually clear.
[ ] Only one primary action appears in each navigation group.
[ ] Hover/focus states remain visible.
[ ] Mobile layout does not break.
[ ] Existing page navigation still works.
[ ] Existing Documents route key remains stable.
[ ] Existing Clients route/card behavior remains stable.
[ ] No backend/database/storage/PDF/email behavior added.
[ ] Build passes.

## 14. Verification Commands

- git status --short
- git diff --check
- npm --prefix ".\frontend" run build
- git log -15 --oneline

## 15. Known Non-Blocking Warning

Vite may report a chunk-size warning above 500 kB after minification.

Decision: NON-BLOCKING.

This remains reserved for a future performance/code-splitting lane.

## 16. Gate Approval Decision

APPROVED TO PROCEED WITH CONTROLLED FRONTEND-ONLY IMPLEMENTATION.

Implementation must be small, targeted, and reversible.

Do not start backend, database, billing, storage, PDF, email, package, or production work.

## 17. Git Status at Gate Creation

CLEAN

## 18. Recent Commit Chain

68ad7a3 docs(phase-14a): add workflow numbering and button design audit records
da29a6b docs(phase-14a): open workflow numbering and button design audit gate
d330fe9 feat(phase-14a): add proposal read mode preview
3ac24ea docs(phase-14a): open proposal read mode implementation gate
0bc34e6 docs(phase-14a): add proposal print read mode planning blueprint
3b76782 docs(phase-14a): add proposal print read mode planning blueprint
b64af52 docs(phase-14a): open proposal print read mode planning gate
dad355a docs(phase-14a): open proposal print read mode planning gate
24177be docs(phase-14a): close scope and exclusions preview enhancement
8f7db07 docs(phase-14a): open scope and exclusions preview gate
efaedbc docs(phase-14a): preserve green recovery closeout handover
54a59e3 feat(phase-14a): add document checklist preview
1416763 fix(phase-14a): stabilize documents route key and labels
b4a1374 docs(phase-14a): add thread closeout audit and handover
0ded7e6 fix(phase-14a): stabilize intake gateway and matter intake navigation

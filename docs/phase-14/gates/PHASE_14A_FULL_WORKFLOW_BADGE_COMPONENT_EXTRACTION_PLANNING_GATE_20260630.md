# Litigation 360 / LEOS 360
# Phase 14A Full Workflow Badge Component Extraction Planning Gate

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 658c039

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Full Workflow Badge Component Extraction Planning

This gate is planning-first only.

No component extraction, App.jsx refactor, CSS refactor, or UI implementation is approved by this document.

## 2. Objective

Plan the safe extraction of repeated workflow badge and workflow-node display patterns into a reusable frontend component in a future implementation lane.

The purpose is to reduce repeated label logic, prevent future misleading fixed step counters, and make workflow status display consistent across pages.

## 3. Why This Gate Exists

Recent Phase 14A work replaced misleading fixed numbering such as Step 1 of 6 and Step 7 with safer workflow-node language.

However, repeated badge/label patterns may still live directly inside App.jsx or page-level JSX.

Before extracting anything, the project needs a controlled planning document that identifies:

- Current badge locations
- Current workflow label patterns
- Safe component props
- Styling boundaries
- Files that may be touched later
- QA requirements
- Rollback strategy

## 4. Approved Scope for This Gate

Approved now:

- Documentation planning only
- Audit of current workflow badge locations
- Proposed reusable badge component API
- Proposed file/folder placement
- Proposed CSS class naming
- Risk controls
- Future implementation checklist

Not approved yet:

- Creating a new component file
- Refactoring App.jsx
- Moving logic out of App.jsx
- Changing visible UI
- Changing route keys
- Changing navigation maps
- Changing CSS
- Package/dependency changes

## 5. Candidate Future Component

Potential future component name:

WorkflowStatusBadge

Potential future path:

frontend/src/components/WorkflowStatusBadge.jsx

Potential future CSS:

Reuse existing App.css styles first, or create scoped CSS only if separately approved.

## 6. Candidate Future Props

Possible props:

- workflowArea
- nodeName
- status
- code
- variant
- isProvisional
- helperText

Example future usage:

WorkflowStatusBadge workflowArea='Phase 14A' nodeName='Documents & Evidence Readiness' status='OPEN'

Do not implement this yet.

## 7. Required Planning Questions

The planning blueprint must answer:

1. Where are workflow badges currently rendered?
2. Which labels are user-facing only?
3. Which values are internal route keys and must not change?
4. Which statuses are allowed?
5. Should workflow code be shown to users or kept internal?
6. Should provisional numbering ever be displayed?
7. How should the badge behave on mobile?
8. Which CSS classes should be reused?
9. What is the smallest safe future implementation?
10. What rollback steps are required if extraction breaks navigation?

## 8. Locked Safety Rules

Do not use broad/global replacements in App.jsx.

Route keys, component names, import names, object keys, and visible display labels must be treated separately.

Protected route keys and labels include:

- Documents
- Clients
- Draft Engagement Preview
- Review Submit
- Documents & Evidence Readiness
- Client Details / Authority & Conflict

## 9. Strictly Blocked Scope

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
- Export behavior
- Billing/payment implementation
- Migrations
- Production deployment

## 10. Required Future QA Themes

Any later implementation gate must verify:

- Existing pages still render.
- Documents route key remains stable.
- Clients card still opens.
- Review Submit still opens.
- Proposal Preview and Read Mode remain intact.
- Workflow badge text remains node-based.
- No fixed Step 1 of 6 or /6 counters return.
- Status values remain visible.
- Mobile layout does not break.
- Build passes.

## 11. Verification Commands

- git status --short
- git diff --check
- npm --prefix ".\frontend" run build
- git log -20 --oneline

## 12. Known Non-Blocking Warning

Vite may report a chunk-size warning above 500 kB after minification.

Decision: NON-BLOCKING.

This remains reserved for a future performance/code-splitting lane.

## 13. Gate Approval Decision

APPROVED FOR PLANNING ONLY.

Next output should be a planning blueprint, not implementation.

Recommended next document:

PHASE_14A_FULL_WORKFLOW_BADGE_COMPONENT_EXTRACTION_PLANNING_BLUEPRINT_20260630.md

## 14. Git Status at Gate Creation

CLEAN

## 15. Recent Commit Chain

658c039 docs(phase-14a): open proposal print styling planning gate
593e2c9 docs(phase-14a): refresh handover after proposal read mode
0deb23b docs(phase-14a): close proposal read mode implementation
202c8d5 docs(phase-14a): refresh handover after proposal read mode and button standardization
7a12ad5 docs(phase-14a): close proposal read mode preview
c836537 docs(phase-14a): refresh handover after workflow label button standardization
633c87e docs(phase-14a): close workflow label and button standardization
de1d83f feat(phase-14a): standardize workflow labels and navigation buttons
6893f93 feat(phase-14a): standardize workflow labels and navigation buttons
611cb85 docs(phase-14a): open workflow label and button standardization gate
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

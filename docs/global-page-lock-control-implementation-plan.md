# GLOBAL PAGE LOCK CONTROL IMPLEMENTATION PLAN

Project:
Litigation 360 / LEOS

Branch:
docs/global-page-lock-control-implementation-plan

Base:
fix/phase-2-ui-component-visual-fix

Checkpoint:
checkpoint/global-page-lock-audit-merged-20260708

Purpose:
Define the approved implementation plan for centralized global page locking before any source code implementation begins.

Current Known State:
- PR #8 merged into fix/phase-2-ui-component-visual-fix
- Global page lock control audit exists at:
  docs/global-page-lock-control-audit-20260708-084053.md
- Audit confirmed Page 3 lock gates were preserved
- Audit did not prove that every page is functionally protected by a centralized page-lock system
- Existing disabled fields, blocked counters, readOnly inputs, and CSS comments are not sufficient proof of global page-level locking

Protected Locks:
- Page 3 required counter lock
- Page 3 alphabet filter lock
- Page 3 real percentage lock

Non-Negotiable Rule:
All pages are considered locked by default unless a page/module is explicitly approved for development.

Implementation Principle:
Default deny. Explicit unlock only.

---

## 1. Goal

Create a centralized page-lock control system that prevents accidental editing, visual changes, or workflow changes to pages that are not approved for active development.

The system must make it clear:

- Which pages are locked
- Which pages are approved for development
- Which pages are audit-only
- Which pages are intentionally excluded
- Which locks are protected and must not be removed

---

## 2. Scope

The future implementation should cover frontend page-level governance only.

In scope:
- Central page lock registry
- Page/module lock metadata
- Development status labels
- Guard/helper logic for page editability
- Clear UI indicators where appropriate
- Documentation of locked/unlocked state
- Safe implementation sequence
- Page 3 lock preservation checks

Out of scope unless separately approved:
- Backend changes
- Database changes
- Auth/RBAC changes
- API changes
- Server/environment changes
- User permission model replacement
- Destructive refactor
- Removing existing Page 3 locks
- Reworking navigation architecture
- Rewriting existing page components

---

## 3. Proposed Central Lock Model

Create a single source of truth for page lock state.

Recommended future file:

frontend/src/config/pageLockRegistry.js

Suggested page state model:

- locked
- audit-only
- development-approved
- deprecated
- placeholder

Example conceptual structure:

pageLockRegistry = {
  dashboard: {
    title: "Dashboard",
    status: "locked",
    reason: "Completed / not approved for current development",
    developmentAllowed: false
  },
  clients: {
    title: "Clients",
    status: "development-approved",
    reason: "Page 3 visual polish approved only after lock safeguards",
    developmentAllowed: true,
    protectedLocks: [
      "required-counter",
      "alphabet-filter",
      "real-percentage"
    ]
  }
}

This is a planning reference only. Do not implement in this docs branch.

---

## 4. Required Page Coverage

All known frontend pages must be mapped.

Pages identified during audit:

- Cases.jsx
- ClientIntakeDiscovery.jsx
- Clients.jsx
- ClientsBackUpCopy.jsx
- Dashboard.jsx
- Deadlines.jsx
- Documents.jsx
- LegalHomePage.jsx
- MatterIntakeWizard.jsx
- Matters.jsx
- OperationsDashboard.jsx
- ProjectDashboard.jsx
- Staff.jsx
- SystemDashboard.jsx

Each page must receive one of the approved states:

- locked
- audit-only
- development-approved
- deprecated
- placeholder

No page should remain unmapped.

---

## 5. Suggested Default Page Status

Initial proposed default:

| Page | Proposed Status | Notes |
|---|---|---|
| Dashboard.jsx | locked | No active development approval |
| LegalHomePage.jsx | locked | No active development approval |
| Clients.jsx | development-approved / restricted | Only if Page 3 polish continues |
| ClientsBackUpCopy.jsx | deprecated / locked | Should not be active development target |
| Cases.jsx | locked | Existing local blocked/disabled logic is not global lock proof |
| Matters.jsx | locked | No active development approval |
| Deadlines.jsx | locked | No active development approval |
| Documents.jsx | locked | No active development approval |
| Staff.jsx | locked | No active development approval |
| MatterIntakeWizard.jsx | locked | Contains form protection references but not global proof |
| ClientIntakeDiscovery.jsx | locked | No active development approval |
| OperationsDashboard.jsx | locked | No active development approval |
| ProjectDashboard.jsx | locked | No active development approval |
| SystemDashboard.jsx | locked | No active development approval |

---

## 6. Future Implementation Sequence

Future implementation should happen in a separate implementation branch only.

Recommended branch:

fix/global-page-lock-control-system

Recommended sequence:

1. Confirm base branch is clean
2. Create implementation branch
3. Add page lock registry
4. Add page lock helper functions
5. Add non-invasive page status indicator
6. Add route/page guard only if safe
7. Map all known pages
8. Preserve Page 3 required counter lock
9. Preserve Page 3 alphabet filter lock
10. Preserve Page 3 real percentage lock
11. Run build
12. Run existing quality gates
13. Create PR
14. Review changed files carefully
15. Merge only after approval

---

## 7. Safety Gates

Before implementation:
- Working tree must be clean
- Base branch must be up to date
- Audit report must exist
- Implementation plan must be merged
- Page 3 locks must be treated as protected

During implementation:
- No backend changes
- No database changes
- No auth/RBAC changes
- No API changes
- No server/environment changes
- No destructive refactor
- No broad rewrite
- No accidental branch mixing

Before commit:
- npm --prefix frontend run build
- git diff --stat
- git diff --name-only
- Confirm changed files match approved scope

Before merge:
- PR must show expected files only
- Page 3 lock gates must pass
- No conflicts with base branch
- Review must confirm docs/plan intent was followed

---

## 8. Acceptance Criteria

Implementation is acceptable only when:

- Every frontend page is mapped in a single page lock registry
- Default state is locked unless explicitly approved
- Page 3 protected locks remain intact
- No backend/database/auth/RBAC/API/server/environment files are changed
- Build passes
- PR description clearly states scope and exclusions
- Future developers can immediately tell whether a page is editable, audit-only, or locked

---

## 9. Current Thread Closeout Position

This branch is documentation-only.

No implementation is started here.

When this plan is committed, pushed, reviewed, merged, pulled locally, tagged, and cleaned up, the thread can close at a safe planning milestone.

Final expected status:

CLOSED AT SAFE GLOBAL PAGE LOCK PLANNING MILESTONE

- PR #8 audit merged
- Implementation plan created
- No source implementation started
- No backend/database/auth/RBAC/API/server/environment changes made
- Page 3 locks preserved
- Ready for future approved implementation branch


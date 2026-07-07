# PHASE 14G SOURCE IMPACT ASSESSMENT

Project:
Litigation 360 / LEOS

Repository:
edmundrulz/litigation-360-software

Branch:
docs/14g-source-impact-assessment

Date:
2026-07-07

Status:
DOCUMENTATION ONLY / SOURCE IMPACT ASSESSMENT ONLY / NO SOURCE EDITS

---

## 1. Purpose

This document identifies the likely source-file impact for a future Phase 14G dashboard placeholder UI implementation.

This assessment does not authorize implementation.

The purpose is to define exactly which files may be inspected, which files may later be edited with approval, which files must remain untouched, and what checks must pass before any future UI work is committed.

---

## 2. Current Baseline

Base branch:

docs/14f-navigation-placeholder-plan

Current base commit:

4fdf874 Merge pull request #7 from edmundrulz/fix/14f-menu-exit-label-visibility

Current base checkpoint tag:

checkpoint/phase-14f-menu-label-visibility-merged-20260707

Completed readiness review branch:

docs/14g-implementation-readiness-review

Completed readiness review commit:

f9a3fe5 docs: add Phase 14G implementation readiness review

Completed readiness review checkpoint tag:

checkpoint/phase-14g-implementation-readiness-review-20260705

---

## 3. Safety Rules

This branch is documentation-only.

Do not edit source code in this branch.

Do not edit:

1. frontend source files
2. backend source files
3. database files
4. authentication files
5. RBAC files
6. API route files
7. server files
8. environment files
9. production logic
10. locked Page 3 controls

Protected Page 3 controls:

1. Page 3 Required / Complete / Missing counter
2. Page 3 alphabet filter structured control
3. Page 3 real percentage calculation

---

## 4. Future Implementation Objective

The possible future implementation objective is limited to dashboard placeholder UI work only.

Allowed future implementation concept:

1. Add visual-only dashboard grouping headings.
2. Add visual-only placeholder cards.
3. Add Coming Soon labels.
4. Add short helper descriptions.
5. Preserve existing dashboard cards.
6. Preserve existing routes.
7. Preserve Page 3 locks.

Not allowed:

1. Backend wiring
2. Database changes
3. Authentication changes
4. RBAC changes
5. API changes
6. Server changes
7. Environment file changes
8. Real notifications
9. Real court integrations
10. Real document generation
11. Legal AI
12. Predictive analytics
13. Client portal functionality
14. Mobile app functionality
15. Payment gateway functionality

---

## 5. Files Approved For Inspection

The following files may be inspected before implementation.

Inspection does not mean editing.

### Frontend application shell

1. frontend/src/App.jsx
2. frontend/src/App.css

Reason:
Likely location of main dashboard layout, menu, routes, and global visual structure.

### Dashboard-related components

Potential inspection targets:

1. frontend/src/components
2. frontend/src/features
3. frontend/src/pages

Reason:
Dashboard cards, menu platform, legal footer, or shared UI structures may exist here.

### Existing page components

Potential inspection targets:

1. frontend/src/pages/Staff.jsx
2. frontend/src/pages/Clients.jsx
3. frontend/src/pages/Cases.jsx
4. frontend/src/pages/Deadlines.jsx
5. frontend/src/pages/MatterIntakeWizard.jsx

Reason:
These may reveal existing card styles, route patterns, or page-specific visual conventions.

### Frontend package/config files

Inspection only:

1. frontend/package.json
2. frontend/vite.config.js
3. frontend/eslint.config.js

Reason:
Used to confirm available build/test/lint scripts before running checks.

### Root package/config files

Inspection only:

1. package.json
2. package-lock.json

Reason:
Used only to confirm whether root scripts exist.

---

## 6. Files That May Be Edited Later With Explicit Approval

Future implementation may edit only approved frontend files.

Likely editable files in a future implementation branch:

1. frontend/src/App.jsx
2. frontend/src/App.css
3. dashboard-specific component files if confirmed
4. menu-platform display files if confirmed and scoped
5. shared card component files if confirmed and scoped

Editing must be limited to visual placeholder layout only.

No future implementation should edit these files until a separate implementation branch is created and approved.

---

## 7. Files That Must Not Be Edited

Do not edit:

1. backend files
2. database files
3. migration files
4. auth files
5. RBAC files
6. API route files
7. server files
8. environment files
9. deployment files
10. production logic files
11. Page 3 source files unless explicitly approved

Do not edit:

1. .env
2. .env.example
3. backend route files
4. database files
5. package-lock files unless dependency changes are explicitly approved

No dependency installation is approved for placeholder UI work.

---

## 8. Special Locked Area: Page 3

The following must remain unchanged:

1. Page 3 Required / Complete / Missing counter
2. Page 3 alphabet filter structured control
3. Page 3 real percentage calculation

Future implementation must not change any logic, layout, calculation, selector, or styling that affects these controls.

If any Page 3 lock check fails, the implementation must stop and must not be committed.

---

## 9. Placeholder Items For Future UI

Approved placeholder items for future UI planning:

1. My Work
2. Clients & Parties
3. Matter Registry
4. Calendar & Deadline Centre
5. Communications Centre
6. Risk, Compliance & Audit
7. Admin Settings
8. System Configuration
9. Help & Support

Each placeholder must be clearly marked:

Coming Soon

Each placeholder must state:

Navigation placeholder only. Functionality not enabled yet.

---

## 10. Expected Future UI Impact

Expected UI impact should be limited to:

1. visual grouping headings
2. placeholder card layout
3. Coming Soon badge styling
4. short helper text
5. dashboard section ordering
6. safe visual alignment

Expected UI impact must not include:

1. route rewiring
2. active module replacement
3. backend connection
4. database connection
5. authentication changes
6. permission changes
7. live integrations

---

## 11. Required Pre-Implementation Verification

Before future implementation starts, verify:

1. current branch
2. clean git status
3. latest five commits
4. available frontend scripts
5. current dashboard source locations
6. Page 3 lock checks
7. absence of unrelated untracked files

---

## 12. Required Post-Implementation Verification

After future implementation, verify:

1. only approved frontend files changed
2. no backend files changed
3. no database files changed
4. no auth files changed
5. no RBAC files changed
6. no API route files changed
7. no server files changed
8. no environment files changed
9. existing dashboard cards still appear
10. placeholder cards are clearly marked Coming Soon
11. Page 3 locks pass
12. build/test checks pass or missing scripts are documented

---

## 13. Recommended Future Implementation Branch

Recommended branch:

feature/14g-dashboard-placeholder-ui

Recommended future commit message:

feat: add dashboard placeholder UI grouping

This source impact assessment does not authorize creating that implementation branch yet.

---

## 14. Handover Recommendation

This document creates a safe transition point between planning and implementation.

After this assessment is complete, the next safe milestone should be:

Phase 14G Handover / Implementation Go-No-Go

That handover should decide whether to:

1. continue documentation-only planning
2. create an implementation branch
3. pause for review
4. request stakeholder approval
5. defer implementation

---

## 15. Acceptance Criteria

This assessment is complete only when:

1. This file exists at:
   docs/phase-14/implementation-plan/PHASE_14G_SOURCE_IMPACT_ASSESSMENT_20260707.md

2. Likely source files are identified.
3. Forbidden files are identified.
4. Page 3 locks are protected.
5. Placeholder scope is documented.
6. Future implementation boundaries are documented.
7. No source files are edited.
8. Branch is committed and pushed.
9. Checkpoint tag is created and pushed.

---

## 16. Safety Confirmation

This file is documentation-only.

No frontend source files were edited.

No backend source files were edited.

No database files were edited.

No authentication files were edited.

No RBAC files were edited.

No API route files were edited.

No server files were edited.

No environment files were edited.

No production logic was edited.

No merge was performed.

No cherry-pick was performed.

---

## 17. Recommended Commit Message

docs: add Phase 14G source impact assessment

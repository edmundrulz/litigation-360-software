# Litigation 360 / LEOS 360
# Phase 13C.2 Read-only Source Audit

Date: 2026-06-27

## Status

Phase 13C.2: READ-ONLY AUDIT COMPLETE

## Objective

Inspect the current visible application navigation model before making any navigation or workflow changes.

## Files Audited

Primary source:

- frontend/src/App.jsx

Supporting module presence checked:

- frontend/src/pages/Clients.jsx
- frontend/src/pages/Cases.jsx
- frontend/src/pages/Matters.jsx
- frontend/src/pages/Deadlines.jsx
- frontend/src/pages/Documents.jsx
- frontend/src/pages/Staff.jsx
- frontend/src/pages/MatterIntakeWizard.jsx

## Evidence Files Created

- docs/phase-13/audit-evidence/PHASE_13C2_APP_NAVIGATION_EVIDENCE_20260627.txt
- docs/phase-13/audit-evidence/PHASE_13C2_VISIBLE_WORKSPACE_EVIDENCE_20260627.txt
- docs/phase-13/audit-evidence/PHASE_13C2_MODULE_FILE_PRESENCE_20260627.txt

## Findings

### Visible Shell

The visible application shell is controlled from:

- frontend/src/App.jsx

The shell contains:

- left sidebar
- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre
- main workspace area
- topbar
- LEOS module command grid

### Navigation State

Current App.jsx navigation uses frontend state:

- view
- module
- moduleHistory

### Navigation Functions

Current navigation behaviour is controlled by:

- goToModule
- backToPreviousModule
- openWorkspace
- viewTitle
- Workspace
- ModuleFrame

### Open Modules

Open workspace modules include:

- Clients
- Cases
- Matters
- Court Dates
- Documents
- Staff
- Review / Save & Submit
- Matter Intake

### Planned Modules

Planned modules are visible in the module grid but disabled.

This is useful for roadmap visibility, but the UX may need grouping or clearer separation later.

## Risks Identified

Potential UX risks for later planning:

- Navigation logic is centralized in App.jsx.
- Module names are string-based.
- Back behaviour depends on moduleHistory.
- Review / Save & Submit appears as a workflow step but is handled as a module.
- Matter Intake appears available but may need clearer user journey positioning.
- Planned modules remain visible beside open modules and may visually compete with usable modules.

## Safety Scope Confirmation

This phase only created documentation and audit evidence.

No frontend source files changed.
No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No migration files changed.
No package files changed.
No production infrastructure files changed.

## Recommended Next Step

Phase 13C.3 Navigation UX Blueprint.

Purpose:

- define the intended user journey
- decide how modules should connect
- decide whether Matter Intake should become the preferred starting point
- decide whether Review / Save & Submit is a workflow step or standalone module
- define safer frontend-only changes before code implementation

## Status

Phase 13C.2 Read-only Source Audit: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT REQUIRED FOR READ-ONLY AUDIT


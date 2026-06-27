# Litigation 360 / LEOS 360
# Phase 13D.4 Frontend Module Frame Patch

Date: 2026-06-27

## Objective

Improve opened module frame consistency and workflow continuity.

## Implementation

Updated the shared ModuleFrame experience in App.jsx.

Added:

- moduleFrameDetails metadata
- getModuleFrameDetails helper
- workflow group labels
- module descriptions
- workflow positions
- Return to Workspace control
- Next Recommended Step control
- polished module frame header
- responsive module frame actions

## Workflow Sequence

Matter Intake:
- Step 1 of 6
- Next: Client Details

Client Details:
- Step 2 of 6
- Next: Case / Matter Details

Case / Matter Details:
- Step 3 of 6
- Next: Court Dates

Court Dates:
- Step 4 of 6
- Next: Documents

Documents:
- Step 5 of 6
- Next: Review / Save & Submit

Review / Save & Submit:
- Step 6 of 6
- No next step

Matter Workspace:
- Reference Module
- Next: Court Dates

Staff:
- Administration
- No next step

## Files Changed

- frontend/src/App.jsx
- frontend/src/App.css

## Safety Scope

Frontend-only.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No migration files changed.
No package files changed.
No production infrastructure files changed.

## Required QA

- Matter Intake frame shows Start Here and Step 1 of 6
- Client Details frame shows Start Here and Step 2 of 6
- Case / Matter Details frame shows Active Legal Work and Step 3 of 6
- Court Dates frame shows Active Legal Work and Step 4 of 6
- Documents frame shows Active Legal Work and Step 5 of 6
- Review / Save & Submit frame shows Review And Completion and Step 6 of 6
- Staff frame shows Office Administration
- Back works
- Return to Workspace works
- Next Recommended Step works where available
- Existing sidebar buttons still work
- App Menu still works
- Build passes

## Status

Phase 13D.4: READY FOR BUILD VERIFICATION
Browser QA: PENDING


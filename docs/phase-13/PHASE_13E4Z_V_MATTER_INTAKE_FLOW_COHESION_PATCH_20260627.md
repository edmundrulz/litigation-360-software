# Litigation 360 / LEOS 360
# Phase 13E.4Z-V Matter Intake Flow Cohesion Patch

Date: 2026-06-27

## Objective

Make the Matter Intake journey behave as one connected conveyor-style workflow instead of appearing disconnected from the standalone Clients module.

## Problem

Browser review showed the sequence could feel disjointed:

- Matter Intake has its own client search and editable profile flow
- The standalone Clients module has a separate directory/index flow
- The user could lose context if the journey appears to jump from Matter Intake into Clients
- The same search concept appeared in two different places without a clear boundary

## Decision

Matter Intake must remain self-contained.

The standalone Clients module remains available, but only through an explicit secondary action.

## Implemented

### App.jsx

- Removed Matter Intake -> Clients from the generic ModuleFrame next map
- Confirmed Matter Intake suppresses the outer ModuleFrame action toolbar
- Matter Intake now relies on its own internal wizard actions only

### MatterIntakeWizard.jsx

- Added explicit Open Full Clients Directory secondary action
- Renamed Step 1 next action to Continue to Case / Matter Details
- Clarified Step 2 wording so the user understands the selected, loaded, or created client carries forward

## Correct Flow

Matter Intake should now read as:

1. Client Search & Duplicate Check
2. Load Existing Client or Create New Client
3. Editable Client Profile
4. Continue to Case / Matter Details
5. Deadline Details
6. Document Details
7. Review
8. Review / Save & Submit

## Boundary Between Workflows

Matter Intake:

- used for new matter opening workflow
- search/load/create client inside the matter-opening process
- continues to case/matter details

Clients module:

- standalone client database / directory
- opened only when user explicitly chooses Open Full Clients Directory
- not the automatic next step from Matter Intake

## Safety Scope

Frontend-only flow cohesion patch.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Matter Intake opens
- Outer duplicate top-right toolbar is not shown
- Step 1 Client Search & Duplicate Check is visible
- Open Full Clients Directory appears as a secondary action
- Clicking Open Full Clients Directory opens Clients module intentionally
- Returning to Matter Intake shows intake workflow again
- Search no-result flow stays inside Matter Intake
- Create New Client Profile From Search stays inside Matter Intake
- Step 1 next action says Continue to Case / Matter Details
- Clicking Continue to Case / Matter Details opens Step 2 inside Matter Intake
- It does not jump to Workspace - Clients
- Step 2 shows Case / Matter Details
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z-V: READY FOR BUILD VERIFICATION


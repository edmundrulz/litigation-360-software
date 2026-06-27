# Litigation 360 / LEOS 360
# Phase 13D.3 Module Frame UX Blueprint

Date: 2026-06-27

## Status

Phase 13D.3: BLUEPRINT READY

## Objective

Define a consistent module-frame experience for opened workspace modules before modifying App.jsx.

## Base Findings From Phase 13D.2

The visible app uses:

- App.jsx as the central workspace shell
- Workspace function for module selection
- ModuleFrame wrapper for live modules
- module state for current module
- moduleHistory for back behaviour

## UX Problem To Solve

The workspace is now grouped by workflow, but opened modules should give clearer guidance.

Users should always know:

- where they are
- what workflow group they are in
- whether the current module is part of a guided sequence
- how to go back
- how to return to the workspace
- what the next recommended step is

## Target Module Frame Structure

Each opened module should show a consistent frame header:

1. Context eyebrow / group label
2. Module title
3. Short module description
4. Workflow position where applicable
5. Control row:
   - Back
   - Return to Workspace
   - Next Recommended Step

## Workflow Sequence

Legal workflow modules:

1. Matter Intake
2. Client Details
3. Case / Matter Details
4. Court Dates
5. Documents
6. Review / Save & Submit

Administrative module:

- Staff

Non-workflow module:

- Matter Workspace

## Recommended Module Metadata

### Matter Intake

Group:
Start Here

Description:
Guided starting point for new matter intake and workflow preparation.

Position:
Step 1 of 6

Next Recommended Step:
Client Details

### Client Details

Group:
Start Here

Description:
Client records, contact information, onboarding, and profile management.

Position:
Step 2 of 6

Next Recommended Step:
Case / Matter Details

### Case / Matter Details

Group:
Active Legal Work

Description:
Case files, parties, progress, and litigation status.

Position:
Step 3 of 6

Next Recommended Step:
Court Dates

### Court Dates

Group:
Active Legal Work

Description:
Hearings, mentions, deadlines, reminders, and court date tracking.

Position:
Step 4 of 6

Next Recommended Step:
Documents

### Documents

Group:
Active Legal Work

Description:
Drafts, filings, templates, evidence, and document management.

Position:
Step 5 of 6

Next Recommended Step:
Review / Save & Submit

### Review / Save & Submit

Group:
Review And Completion

Description:
Final review point before saving, submission, or future workflow handoff.

Position:
Step 6 of 6

Next Recommended Step:
None

### Matter Workspace

Group:
Active Legal Work

Description:
Matter workspace and legal file tracking.

Position:
Reference module

Next Recommended Step:
Court Dates

### Staff

Group:
Office Administration

Description:
Staff records and internal team administration.

Position:
Administration

Next Recommended Step:
None

## Back Behaviour

Preserve existing moduleHistory-based Back behaviour.

Recommended display:

- If canGoBack is true: show Back
- Always show Return to Workspace
- If a next step exists: show Next Recommended Step

## Return To Workspace Behaviour

Return to Workspace should call:

setModule("home")

It should not alter sidebar view state because it is used inside the End User Workspace.

## Next Recommended Step Behaviour

Next Recommended Step should call:

setModule(nextModule)

No backend/API/server behaviour.

## Recommended Implementation Approach For Phase 13D.4

Create local metadata in App.jsx:

- moduleFrameDetails
- getModuleFrameDetails(title)

Update ModuleFrame props to support:

- description
- group
- workflowPosition
- nextModule
- nextLabel

Update Workspace module rendering so each ModuleFrame receives metadata.

Add CSS classes:

- module-frame
- module-frame-header
- module-context
- module-description
- module-frame-actions
- module-next-button
- module-secondary-button

## Safety Rules For Phase 13D.4

Allowed:

- frontend/src/App.jsx
- frontend/src/App.css
- docs/phase-13 implementation record

Forbidden:

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure

## Required QA After Implementation

- Matter Intake frame shows Step 1 of 6
- Client Details frame shows Step 2 of 6
- Case / Matter Details frame shows Step 3 of 6
- Court Dates frame shows Step 4 of 6
- Documents frame shows Step 5 of 6
- Review / Save & Submit frame shows Step 6 of 6
- Staff frame shows Office Administration
- Back works
- Return to Workspace works
- Next Recommended Step works for sequence modules
- App Menu still works
- Sidebar buttons still work
- Build passes

## Status

Phase 13D.3 Module Frame UX Blueprint: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


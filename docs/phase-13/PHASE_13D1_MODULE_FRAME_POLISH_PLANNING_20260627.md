# Litigation 360 / LEOS 360
# Phase 13D.1 Workspace Module Frame Polish Planning

Date: 2026-06-27

## Status

Phase 13D.1: PLANNING STARTED

## Base State

Previous workstream closed:

- Phase 13B Menu Platform Workstream
- Phase 13C Navigation / Workspace Workflow Workstream

Current workspace structure:

Start Here:
- Matter Intake
- Client Details

Active Legal Work:
- Case / Matter Details
- Matter Workspace
- Court Dates
- Documents

Review And Completion:
- Review / Save & Submit

Office Administration:
- Staff

Planned Platform Modules:
- roadmap modules visible but disabled

## Objective

Plan a safe frontend-only improvement to the module frame experience.

The goal is to make opened modules feel consistent, guided, and professional.

## Current Problem Area

After Phase 13C, workspace navigation is grouped properly.

However, opened modules still need a clearer and more consistent frame experience.

Potential issues:

- Back button wording may not be clear enough
- Return to Workspace behaviour should be consistently visible
- Next Recommended Step should guide users through the workflow
- Module title area may need more context
- Review / Save & Submit should feel like a final workflow step
- Matter Intake should feel like the beginning of the guided process
- Users should always know where they are, where they came from, and what to do next

## Non-Negotiable Safety Scope

Allowed in Phase 13D.1:

- docs/phase-13
- docs/qa/phase-13

Forbidden unless explicitly approved:

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure

## Recommended Phase 13D Sequence

### Phase 13D.1 Planning

Define the intended module-frame polish model.

### Phase 13D.2 Read-only Source Audit

Inspect current ModuleFrame, Workspace, backToPreviousModule, and module workflow logic.

### Phase 13D.3 Module Frame UX Blueprint

Define exact frame structure:

- module title
- breadcrumb/context label
- Back button
- Return to Workspace button
- Next Recommended Step button
- workflow position indicator

### Phase 13D.4 Frontend-only Module Frame Patch

Possible safe files:

- frontend/src/App.jsx
- frontend/src/App.css
- docs/phase-13 implementation record

No backend/API/server/package changes.

### Phase 13D.5 Browser QA

Verify:

- every live module opens
- Back works
- Return to Workspace works
- Next Recommended Step works where applicable
- sidebar buttons still work
- App Menu still works

### Phase 13D.6 Closeout SSOT

Close Phase 13D.

## Proposed Workflow Step Order

Recommended workflow sequence:

1. Matter Intake
2. Client Details
3. Case / Matter Details
4. Court Dates
5. Documents
6. Review / Save & Submit

Staff remains an office administration module and should not be part of the legal workflow sequence.

## Proposed Module Frame Behaviour

Each live module should show:

- Current module title
- Workflow group label
- Workflow position if applicable
- Back button
- Return to Workspace button
- Next Recommended Step button when applicable

Example:

Matter Intake:
- Back: Return to Workspace
- Next: Client Details

Client Details:
- Back: Matter Intake or previous module
- Next: Case / Matter Details

Case / Matter Details:
- Back: Client Details
- Next: Court Dates

Court Dates:
- Back: Case / Matter Details
- Next: Documents

Documents:
- Back: Court Dates
- Next: Review / Save & Submit

Review / Save & Submit:
- Back: Documents
- Next: none

Staff:
- Back: Return to Workspace
- Next: none

## Recommended Immediate Next Step

Phase 13D.2 Read-only Source Audit.

Reason:
Before editing module frame code, inspect current App.jsx ModuleFrame structure and navigation behaviour.

## Status

Phase 13D.1 Planning: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


# Litigation 360 / LEOS 360
# Phase 13C.1 Navigation And Workspace Workflow Planning

Date: 2026-06-27

## Status

Phase 13C.1: PLANNING STARTED

## Base State

Previous workstream closed:

- Phase 13B Menu Platform Workstream
- Final menu platform is stable
- Browser regression QA passed
- Keyboard/accessibility QA passed
- Menu Platform workstream is closed

## Objective

Plan the next safe frontend-first improvement area after menu stabilization.

The objective is to define how users move through the visible application workspace.

## Current Visible Application Structure

The visible app shell contains:

- Left sidebar
- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre
- Main workspace area
- LEOS module command grid

Open workspace modules include:

- Clients
- Cases
- Matters
- Court Dates
- Documents
- Staff
- Matter Intake
- Review / Save & Submit

## Current Problem Area

The menu platform is now stable, but the broader workspace navigation still needs a clear user journey.

Questions to resolve:

- What should happen after opening each workspace module?
- Should modules have consistent back / next controls?
- Should the menu trigger module navigation?
- Should dashboard cards and sidebar buttons use one shared navigation model?
- Should Review / Save & Submit be treated as a workflow step or standalone module?
- Should Matter Intake become the preferred starting point?
- Should planned modules remain visible or be grouped separately?

## Non-Negotiable Safety Scope

Allowed in Phase 13C.1:

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

## Recommended Phase 13C Sequence

### Phase 13C.1 Planning

Define the intended navigation model.

### Phase 13C.2 Read-only Source Audit

Inspect current App.jsx navigation state, module switching, back behaviour, and module grid.

### Phase 13C.3 Navigation UX Blueprint

Create a user journey map for:

- New matter workflow
- Existing client workflow
- Case/matter review workflow
- Document workflow
- Admin/staff workflow

### Phase 13C.4 Frontend-only Navigation Patch

Only after planning and audit.

Possible safe changes:

- clearer active module labels
- consistent back button
- clearer next-step actions
- improved module grouping
- no backend/API/server changes

### Phase 13C.5 Browser QA

Verify navigation works without breaking existing modules.

### Phase 13C.6 Closeout SSOT

Close Phase 13C navigation workstream.

## Recommended Immediate Next Step

Phase 13C.2 Read-only Source Audit.

Reason:
Before changing navigation, inspect the current App.jsx navigation logic and module frame behaviour.

## Status

Phase 13C.1 Planning: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


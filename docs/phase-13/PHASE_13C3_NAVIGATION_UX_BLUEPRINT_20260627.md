# Litigation 360 / LEOS 360
# Phase 13C.3 Navigation UX Blueprint

Date: 2026-06-27

## Status

Phase 13C.3: BLUEPRINT READY

## Objective

Define a safe frontend-first navigation model for the visible workspace before changing App.jsx.

This blueprint decides how users should move through:

- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre
- LEOS module command grid
- live modules
- workflow steps
- planned modules

## Current Navigation Model

The visible app currently uses:

- view
- module
- moduleHistory

The main workspace supports:

- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre

Open modules include:

- Clients
- Cases
- Matters
- Court Dates
- Documents
- Staff
- Matter Intake
- Review / Save & Submit

Planned modules are visible but disabled.

## UX Problem To Solve

The current workspace works, but the user journey is not yet clearly guided.

Issues:

- Users may not know which module to start with.
- Matter Intake should likely become the preferred guided starting point.
- Review / Save & Submit behaves more like a workflow step than a standalone module.
- Existing modules are mixed with planned roadmap modules.
- Back / next behaviour needs consistent language.
- There is no clear guided path from client intake to case/matter to documents to review.
- Planned modules may visually compete with open modules.

## Recommended Navigation Model

### 1. Keep Main Sidebar Views

Keep the current main sidebar views:

- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre

Reason:
These are already understandable high-level areas.

### 2. Improve End User Workspace Structure

End User Workspace should be organized into clearer groups:

#### Start Here

- Matter Intake
- Client Details

#### Active Legal Work

- Case / Matter Details
- Court Dates
- Documents

#### Review And Completion

- Review / Save & Submit

#### Office Administration

- Staff

#### Future / Planned

- Tasks
- Notifications
- Reports
- Lawyer View
- Clerk View
- Admin View
- Finance View
- Partner View
- Legal AI
- Knowledge Management
- Predictive Analytics
- Executive Command Centre
- Workflow Automation
- Government Integrations
- Client Portal
- Mobile App
- Autonomous Operations
- Marketplace

### 3. Recommended Default User Journey

Preferred guided workflow:

1. Matter Intake
2. Client Details
3. Case / Matter Details
4. Court Dates
5. Documents
6. Review / Save & Submit

This should become the main legal workflow path.

### 4. Module Behaviour Rules

Each live module should have:

- clear title
- back button
- return to workspace button
- optional next recommended action
- consistent module frame structure

### 5. Back Behaviour

Current moduleHistory should remain for now.

Recommended wording:

- Back
- Return to Workspace
- Next Recommended Step

Do not introduce router-level navigation yet.

### 6. Planned Module Behaviour

Planned modules should remain visible, but should be visually grouped separately.

Recommended behaviour:

- planned cards remain disabled
- planned cards show clear PLANNED status
- planned modules do not interrupt the live workflow
- planned section should appear after live workflow modules

### 7. Menu Platform Relationship

The App Menu should remain a support/tooling hub, not the primary module router yet.

Recommended position:

- App Menu: settings, file actions, FAQ, support, about/system
- Workspace Grid: actual legal workflow module navigation

Do not connect every menu item to workspace modules yet.

### 8. Phase 13C.4 Candidate Frontend Patch

Recommended safe code changes later:

- group workspace cards into sections
- place Matter Intake first
- rename action labels for clarity
- add clearer workflow sequence
- keep existing module state model
- keep backend untouched
- keep package files untouched

## Proposed Future Workspace Layout

End User Workspace:

### Start Here

1. Matter Intake
2. Client Details

### Active Legal Work

3. Case / Matter Details
4. Court Dates
5. Documents

### Review And Completion

6. Review / Save & Submit

### Office Administration

- Staff

### Planned Platform Modules

- all planned modules grouped separately

## Forbidden Changes At This Stage

Do not change:

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure

Do not add:

- real routing
- backend persistence
- API integration
- authentication-dependent navigation
- role-based menus

## Recommended Next Step

Phase 13C.4 Frontend Workspace Navigation Patch.

Safe implementation target:

- frontend/src/App.jsx
- frontend/src/App.css if visual grouping requires CSS
- docs/phase-13 implementation record

Expected outcome:

- workspace modules grouped by workflow
- Matter Intake promoted as preferred start
- Review / Save & Submit framed as final workflow step
- planned modules separated visually
- existing module navigation preserved

## Status

Phase 13C.3 Navigation UX Blueprint: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED

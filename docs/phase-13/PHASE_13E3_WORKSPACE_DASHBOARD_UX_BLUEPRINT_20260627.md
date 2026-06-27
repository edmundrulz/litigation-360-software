# Litigation 360 / LEOS 360
# Phase 13E.3 Workspace Dashboard UX Blueprint

Date: 2026-06-27

## Status

Phase 13E.3: BLUEPRINT READY

## Objective

Define the intended End User Workspace dashboard polish before modifying frontend source files.

## Base State

Previous phases completed:

- Phase 13E.1 Dashboard Polish Planning
- Phase 13E.2 Dashboard Read-only Source Audit

The dashboard currently includes:

- hero section
- quick action buttons
- summary cards
- grouped workspace sections
- live workflow cards
- planned platform module cards

## Dashboard UX Goal

The End User Workspace should feel like a guided legal workflow command centre.

It should help users immediately understand:

1. where to start
2. what live legal workflow modules are available
3. what is for review/completion
4. what is for office administration
5. what is planned but not active yet

## Target Dashboard Hierarchy

Recommended hierarchy:

1. Hero / command centre introduction
2. Primary workflow quick action
3. Secondary quick actions
4. Operational summary cards
5. Live workflow sections
6. Planned platform modules

## Hero Section Blueprint

The hero section should communicate:

- this is the End User Workspace
- Matter Intake is the best starting point
- the workspace is organized by legal workflow
- users can continue active work or review completion steps

Recommended hero title:

End User Workspace

Recommended hero subtitle:

Start intake, continue legal work, manage documents, and complete review steps from one guided workspace.

## Quick Action Blueprint

Quick actions should be visually prioritized.

Primary action:

- Start Matter Intake

Secondary actions:

- Open Client Details
- Continue Legal Work
- Review / Save & Submit

Recommended behaviour:

- Start Matter Intake opens Matter Intake
- Open Client Details opens Clients
- Continue Legal Work opens Cases or Matter Workspace
- Review / Save & Submit opens Review Submit

## Summary Card Blueprint

Summary cards should be easy to scan and should not visually overpower the workflow sections.

Recommended cards:

1. Live Workspace Modules
2. Workflow Sections
3. Planned Modules
4. Last Verified Build

Suggested copy:

Live Workspace Modules:
Current active modules available in the workspace.

Workflow Sections:
Grouped legal workflow areas for intake, active work, completion, and administration.

Planned Modules:
Roadmap modules visible but disabled until future implementation.

Last Verified Build:
Frontend production build remains the safety gate.

## Workspace Section Blueprint

Each workspace section should have:

- section title
- short description
- clear visual spacing
- workflow cards grouped inside the section

Recommended sections:

### Start Here

Description:
Begin new matters, client onboarding, and intake preparation.

Cards:
- Matter Intake
- Client Details

### Active Legal Work

Description:
Continue active case work, matter tracking, court dates, and documents.

Cards:
- Case / Matter Details
- Matter Workspace
- Court Dates
- Documents

### Review And Completion

Description:
Review captured information and prepare for save, submission, or future workflow handoff.

Cards:
- Review / Save & Submit

### Office Administration

Description:
Manage staff and internal administration records.

Cards:
- Staff

### Planned Platform Modules

Description:
Future roadmap modules. These remain visible for product direction but disabled until implementation.

Cards:
- all planned modules

## Card Treatment Blueprint

Live workflow cards should be more visually prominent than planned cards.

Live card treatment:

- clearer title
- stronger description
- visible workflow badge
- hover feedback
- consistent spacing

Planned card treatment:

- muted styling
- disabled state
- roadmap badge
- no click confusion

## Matter Intake Priority Rule

Matter Intake must remain:

- first card in Start Here
- primary dashboard quick action
- visually positioned as the recommended starting point

## Safety Scope For Phase 13E.4

Allowed files:

- frontend/src/App.jsx
- frontend/src/App.css
- docs/phase-13 implementation record

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

## Required QA After Phase 13E.4

Browser QA must verify:

- dashboard loads correctly
- hero section is readable
- Start Matter Intake action works
- secondary quick actions work
- Matter Intake remains first
- live workflow sections remain clear
- planned modules remain disabled
- opened module frames still work
- sidebar buttons still work
- App Menu still works
- production build passes

## Recommended Implementation Direction

Phase 13E.4 should be a frontend-only visual polish patch.

Recommended changes:

- refine hero copy
- improve action button hierarchy
- improve summary card labels/copy
- improve section spacing
- improve planned module separation
- avoid changing routing architecture
- avoid introducing backend/API calls

## Status

Phase 13E.3 Dashboard UX Blueprint: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


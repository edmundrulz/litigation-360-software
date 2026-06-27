# Litigation 360 / LEOS 360
# Phase 13E.1 End User Workspace Dashboard Polish Planning

Date: 2026-06-27

## Status

Phase 13E.1: PLANNING STARTED

## Base State

Previous workstreams closed:

- Phase 13B Menu Platform
- Phase 13C Workspace Navigation
- Phase 13D Module Frame Polish

Current visible workspace is controlled from frontend/src/App.jsx.

## Objective

Plan a frontend-only polish pass for the End User Workspace dashboard.

The aim is to make the dashboard easier to read, more professional, and more useful as a starting point for legal workflow users.

## Current Dashboard Areas

The End User Workspace currently contains:

- hero section
- quick action buttons
- summary / monitor cards
- grouped workspace module sections
- planned platform modules

## Problem Area

After Phase 13C and 13D, navigation is more structured, but the dashboard can still be improved for readability.

Potential issues:

- Hero section may be too generic
- Quick actions may need clearer hierarchy
- Summary cards may need better visual grouping
- Workflow module sections may need stronger spacing
- Planned modules may visually compete with active modules
- Dashboard should better guide users toward Matter Intake first
- The page should feel like a workflow command centre, not just a list of cards

## Non-Negotiable Safety Scope

Allowed in Phase 13E.1:

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

## Recommended Phase 13E Sequence

### Phase 13E.1 Planning

Define dashboard polish scope.

### Phase 13E.2 Read-only Source Audit

Inspect current hero, actions, summary, grid, workspace-section, and planned-card CSS.

### Phase 13E.3 Dashboard UX Blueprint

Define exact dashboard layout and visual hierarchy.

### Phase 13E.4 Frontend Dashboard Polish Patch

Possible safe files:

- frontend/src/App.jsx
- frontend/src/App.css
- docs/phase-13 implementation record

### Phase 13E.5 Browser QA

Verify:

- dashboard remains readable
- Matter Intake remains clearly first
- live workflow sections are clear
- planned modules remain visually separate
- sidebar buttons still work
- App Menu still works
- module frames still work
- build passes

### Phase 13E.6 Closeout SSOT

Close Phase 13E.

## Recommended Dashboard Direction

The dashboard should communicate:

1. Start a guided legal workflow
2. Continue active legal work
3. Review and complete
4. Manage office administration
5. View future platform roadmap

## Recommended Immediate Next Step

Phase 13E.2 Read-only Source Audit.

Reason:
Before editing dashboard visuals, inspect current App.jsx dashboard markup and App.css layout classes.

## Status

Phase 13E.1 Planning: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


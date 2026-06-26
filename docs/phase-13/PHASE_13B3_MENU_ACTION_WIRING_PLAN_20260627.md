# Litigation 360 / LEOS 360
# Phase 13B.3 Menu Action Wiring Plan

Date: 2026-06-27

## Status

Phase 13B.3: PLANNING STARTED

## Base State

Previous workstream:
Phase 13B.2 Menu Platform Workstream closed.

Final accepted menu structure:

Primary:
- File
- System
- Settings

Help & Info:
- FAQ
- Submit Query / Request
- About App
- About System

User visual QA confirmed the menu is:
- much better
- cleaner
- visually appealing

## Objective

Define safe frontend-first behaviour for each menu item before wiring any action logic.

This prevents:
- dead buttons
- duplicated actions
- unsafe backend assumptions
- premature API/server edits
- random integration changes

## Non-Negotiable Safety Scope

Allowed for Phase 13B.3 planning:
- docs/phase-13
- docs/qa/phase-13

Allowed later for frontend-only wiring:
- frontend/src/features/menu-platform
- frontend/src/App.jsx
- frontend/src/App.css only if visual trigger handling is required

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
- deployment configuration

## Current Menu Action Matrix

| Menu Item | Current Type | Current State | Recommended Behaviour |
|---|---|---|---|
| File | Submenu | Opens child items | Keep |
| File / Open | Action | Needs useful response | Show frontend-only Open placeholder panel |
| File / Save | Action | Needs useful response | Show frontend-only mock save confirmation |
| File / Import | Action | Needs useful response | Show frontend-only import placeholder panel |
| File / Export | Action | Needs useful response | Show frontend-only export placeholder panel |
| File / Recent Files | Panel | Existing panel | Keep |
| System | Panel | Existing panel | Keep and polish later |
| Settings | Panel | Existing panel | Keep and polish later |
| FAQ | Panel | Existing panel | Keep |
| Submit Query / Request | Panel | Existing mock ticket panel | Keep frontend mock only |
| About App | Panel | Existing panel | Keep |
| About System | Panel | Existing panel | Keep |

## Recommended Implementation Sequence

### Phase 13B.3A - File Action Feedback Panels

Purpose:
Make File / Open, Save, Import, and Export respond visibly without backend integration.

Expected result:
- Clicking Open shows an Open placeholder panel
- Clicking Save shows a mock save status panel
- Clicking Import shows an Import placeholder panel
- Clicking Export shows an Export placeholder panel
- No backend/API/server work

### Phase 13B.3B - Settings/System/About Panel Polish

Purpose:
Make existing information panels more consistent and enterprise-grade.

Expected result:
- Settings panel looks intentional
- System panel clearly shows frontend/environment info only
- About App and About System remain readable and stable

### Phase 13B.3C - Support Request Mock Hardening

Purpose:
Improve frontend-only ticket UX without real backend submission.

Expected result:
- clearer form validation
- clearer mock ticket confirmation
- attachment limits remain frontend-only
- no real upload or API call

### Phase 13B.3D - Keyboard + Accessibility QA

Purpose:
Validate portal overlay behaviour.

Expected result:
- Escape closes menu
- backdrop closes menu
- focus starts in search
- tab navigation remains usable
- menu does not trap user incorrectly
- screen reader roles are acceptable

### Phase 13B.3E - Closeout SSOT

Purpose:
Record final action wiring state and browser QA.

## Phase 13B.3A Recommended Next Build

The safest next build is:

Phase 13B.3A - File Action Feedback Panels

Reason:
The File menu currently contains action items that should not feel dead.
This can be fixed frontend-only without backend risk.

## Verification Required For Every Phase 13B.3 Code Patch

Run:

git status --short
git diff --name-only
git diff --check
npm --prefix ".\frontend" run build
git status --short

## Phase 13B.3 Status

Planning: READY FOR COMMIT
Implementation: NOT STARTED
Browser QA: NOT STARTED


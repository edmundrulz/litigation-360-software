# Litigation 360 / LEOS 360
# Phase 13B.2D Menu Visibility Hotfix

Date: 2026-06-26
Base HEAD: 2cabb42 feat(menu): integrate menu platform into visible app sidebar

## Defect

The App Menu appeared in the visible sidebar, but the dropdown opened only partially visible.

Observed issue:
- Menu opened from the sidebar
- Large menu panel was clipped / half visible
- Search field and pinned items were visible only partially
- Layout was unacceptable for real use

## Root Cause

The menu dropdown was positioned from inside the narrow visible sidebar.

The dropdown was too wide for the sidebar-origin placement and was not forced into a viewport-safe overlay position.

## Fix

Updated App.css so the visible App Menu opens as:

- centered viewport-safe overlay on desktop
- full-screen sheet on mobile/tablet widths
- high z-index overlay above the app shell
- no clipping beside the sidebar

## Files Changed

- frontend/src/App.css
- frontend/src/App.jsx

## Safety Scope

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.

## Required Verification

Run:

git status --short
git diff --check
npm --prefix ".\frontend" run build

Then browser QA:

- App Menu opens fully visible
- Search input is fully visible
- Pinned items are fully visible
- Panel area is visible
- FAQ opens
- Submit Query / Request opens
- Escape closes menu
- Existing sidebar buttons still work
- Mobile viewport does not clip menu

## Status

Phase 13B.2D: READY FOR BUILD VERIFICATION
Browser QA: PENDING


---

## Supersession Note

Status: SUPERSEDED BY PHASE 13B.2E

Phase 13B.2D attempted to fix sidebar menu visibility by adjusting App.css positioning.

After review, the better professional implementation was Phase 13B.2E:

- Render MenuPlatform through React portal
- Add opaque backdrop
- Move overlay shell ownership into MenuPlatform.css
- Keep App.css limited to sidebar trigger styling
- Use solid opaque menu surfaces
- Treat the menu hub as an application dialog instead of a sidebar flyout

Therefore Phase 13B.2D is retained as evidence of the intermediate defect response, but Phase 13B.2E is the authoritative fix.


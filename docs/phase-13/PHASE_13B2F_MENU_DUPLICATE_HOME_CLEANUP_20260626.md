# Litigation 360 / LEOS 360
# Phase 13B.2F Menu Duplicate + Home Cleanup

Date: 2026-06-26

## Defect

The App Menu displayed repeated items:

- Home appeared under Pinned and Primary
- Settings appeared under Pinned and Primary
- FAQ appeared under Pinned and Help & Info
- Submit Query / Request appeared under Pinned and Help & Info

The Home item also had no meaningful function in the current app flow.

## Root Cause

The menu rendered both:

1. A Pinned/Favorites block
2. The full section list

This caused duplicated top-level actions.

Home was also included in the schema even though the current visible app already has a workspace/home control through the main sidebar and module system.

## Fix

- Removed Home from menuConfig.js
- Removed favorite/pinned duplication from visible menu rendering
- Kept a single clean section list:
  - Primary
  - Help & Info
- Preserved File, System, Settings, FAQ, Submit Query / Request, About App, and About System

## Files Changed

- frontend/src/features/menu-platform/menuConfig.js
- frontend/src/features/menu-platform/MenuPlatform.jsx

## Expected Menu After Fix

Primary:
- File
- System
- Settings

Help & Info:
- FAQ
- Submit Query / Request
- About App
- About System

## Safety Scope

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.

## Verification Required

Run:

git status --short
git diff --check
npm --prefix ".\frontend" run build

Browser QA:

- App Menu opens
- No Pinned section appears
- Home does not appear
- File appears once
- System appears once
- Settings appears once
- FAQ appears once
- Submit Query / Request appears once
- About App appears once
- About System appears once
- Overlay remains visually solid and professional

## Status

Phase 13B.2F: READY FOR BUILD VERIFICATION
Browser QA: PENDING


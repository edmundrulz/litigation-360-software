# Litigation 360 / LEOS 360
# Phase 13B.2B Sidebar Integration Read-Only Inspection

Date: 2026-06-26
Current HEAD: cf2618d docs(phase-13): close Phase 13B.2A menu platform package

## Purpose

Identify the safest frontend-only integration point for the reusable MenuPlatform package.

## Current Status

Phase 13B.2A: CLOSED
Menu Platform Package: COMMITTED
Build: PASS
Production Wiring: NOT STARTED
Phase 13B.2B: READ-ONLY INSPECTION ONLY

## Candidate Files Found

- frontend/src/App.jsx
- frontend/src/App.css
- frontend/src/components/legal-management-shell/LegalManagementShell.jsx
- frontend/src/components/legal-management-shell/LegalManagementShell.css
- frontend/src/components/legal-management-shell/firmProfile.config.json
- frontend/src/components/legal-management-shell/legalNewsLinks.config.json
- frontend/src/layout/layout.jsx
- frontend/src/utils/appGuard.js

## Probable Integration Target

Primary candidate:

frontend/src/components/legal-management-shell/LegalManagementShell.jsx

Supporting style candidate:

frontend/src/components/legal-management-shell/LegalManagementShell.css

## Rules

No code patch is approved yet.

Allowed now:
- inspect files
- identify sidebar/header/menu trigger location
- record exact integration point
- prepare controlled plan

Forbidden now:
- backend edits
- database edits
- auth/RBAC edits
- API route edits
- server edits
- package edits
- production infrastructure edits
- random UI rewiring


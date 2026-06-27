# Litigation 360 / LEOS 360
# Phase 13E.4X Workflow Toolbar Previous / Save & Next Hotfix

Date: 2026-06-27

## Objective

Fix workflow toolbar behaviour inside module pages.

## Issue

On the Client Details page:

- Previous showed a disabled/block sign behaviour
- Previous did not simply return to the main workspace
- Save & Next did not move to the next workflow page

## Root Cause

The workflow module frame relied on history-based back behaviour and did not enforce a clear module workflow map.

For the first workflow step, Client Details, history may be empty. This caused Previous to behave like a disabled or blocked button.

## Fix

Replaced ModuleFrame toolbar logic with explicit workflow maps.

Previous map:

- Clients -> home
- Cases -> Clients
- Matters -> Clients
- Court Dates -> Cases
- Documents -> Court Dates
- Review / Save & Submit -> Documents
- Staff -> home
- Matter Intake -> home

Next map:

- Clients -> Cases
- Cases -> Court Dates
- Matters -> Court Dates
- Court Dates -> Documents
- Documents -> Review Submit
- Matter Intake -> Clients

## Expected Behaviour

On Client Details:

- Previous returns to the main workspace
- Main Page returns to the main workspace
- Save & Next moves to Case / Matter Details

On Documents:

- Save & Next moves to Review / Save & Submit

On Review / Save & Submit:

- Complete / Return Home returns to the main workspace

## Files Changed

- frontend/src/App.jsx

## Safety Scope

Frontend-only App.jsx workflow toolbar fix.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Open Client Details
- Previous returns to main workspace
- Reopen Client Details
- Save & Next opens Case / Matter Details
- Save & Next from Cases opens Court Dates
- Save & Next from Court Dates opens Documents
- Save & Next from Documents opens Review / Save & Submit
- Review / Save & Submit screen still loads
- Complete / Return Home returns to main workspace
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4X: READY FOR BUILD VERIFICATION


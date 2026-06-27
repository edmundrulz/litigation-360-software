# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z4-D Existing Required Field Counter Patch

Date: 2026-06-27

## Status

Phase 13E.4Z-Z4-D: EXISTING REQUIRED FIELD COUNTER PATCH

## Objective

Add a non-destructive required-field counter to the Client Profile Completion Status shell.

## Implementation Type

Frontend-only informational counter.

## Files Changed

- frontend/src/pages/Clients.jsx
- frontend/src/App.css
- docs/phase-13/PHASE_13E4Z_Z4_D_EXISTING_REQUIRED_FIELD_COUNTER_PATCH_20260627.md

## What Changed

Added ClientRequiredFieldCounter.

The counter reads currently rendered controls with:

- required
- aria-required=true

It displays:

- Required
- Complete
- Missing

## Important Limitation

The counter is informational.

Existing Clients validation remains authoritative.

The counter does not:

- create required fields
- remove required fields
- alter existing required rules
- block save/create
- change save/create handlers
- change draft/localStorage logic
- change backend/API payloads
- mark profile complete

## Preservation Confirmation

Preserved:

- all original Clients fields
- all original required markers
- all original validation logic
- all original backend/API behaviour
- all original local fallback behaviour
- all original draft/save/reset behaviour
- all original directory/table behaviour
- all original Matter Intake bridge behaviour
- Return to Matter Intake action

## Safety Scope

Frontend only.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## QA Required

- Clients page opens
- Client Profile Completion Status shell remains visible
- required field counter appears
- Required / Complete / Missing metrics appear
- changing visible required fields updates the counter
- existing validation remains unchanged
- save/create controls remain unchanged
- backend/local fallback warnings remain visible
- Matter Intake No Match redirect remains functional
- Return to Matter Intake remains functional
- no white screen
- no browser console red runtime error
- production build passes

## Status

Phase 13E.4Z-Z4-D: READY FOR BUILD VERIFICATION


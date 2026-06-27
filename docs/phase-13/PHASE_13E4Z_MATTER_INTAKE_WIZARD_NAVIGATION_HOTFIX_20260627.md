# Litigation 360 / LEOS 360
# Phase 13E.4Z Matter Intake Wizard Navigation Hotfix

Date: 2026-06-27

## Objective

Fix the visible Matter Intake Wizard Previous and Save & Next controls.

## Confirmed Source

The duplicate/source audit confirmed the visible controls are inside:

- frontend/src/pages/MatterIntakeWizard.jsx

The previous App.jsx ModuleFrame patch did not affect these visible controls.

## Issue

Browser output showed:

- Previous displayed blocked/disabled behaviour on Step 1
- Previous should return to the main workspace on Step 1
- Save & Next did not proceed to the next wizard page
- Final step wording used Save & Submit Details

## Fix

Implemented:

- App.jsx passes setModule into MatterIntakeWizard
- MatterIntakeWizard accepts setModule
- Previous on Step 1 returns to main workspace
- Previous on later steps moves backward normally
- Save & Next moves to the next wizard step
- Save & Next is set to type=button
- nextStep is frontend-safe and not blocked by future backend persistence
- Save & Submit Details wording changed to Review / Save & Submit

## Existing Ineffective Commit Note

Commit 9f8ad30 patched App.jsx ModuleFrame controls.

Browser output did not change because the visible controls came from MatterIntakeWizard.jsx.

This hotfix addresses the confirmed real source.

## Safety Scope

Frontend-only targeted wizard navigation fix.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Open End User Workspace
- Open Matter Intake
- On Step 1 Client Details, click Previous
- Expected: returns to main workspace
- Reopen Matter Intake
- On Step 1 Client Details, click Save & Next
- Expected: moves to Case / Matter Details
- Continue Save & Next through Deadline Details
- Continue Save & Next through Document Details
- Continue to Review / Save & Submit
- No blocked Previous icon
- No blank Review screen
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z: READY FOR BUILD VERIFICATION


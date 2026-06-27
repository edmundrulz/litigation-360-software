# Litigation 360 / LEOS 360
# Phase 13E.4Z-R Matter Intake Wizard Runtime Recovery

Date: 2026-06-27

## Objective

Resolve the white/blank page when clicking Save & Next inside the Matter Intake Wizard.

## Issue

Browser QA confirmed:

- Previous / Save & Next source was inside MatterIntakeWizard.jsx
- Earlier App.jsx toolbar fix did not affect the visible controls
- Save & Next still caused a white/blank page after changing step

## Likely Cause

The old wizard rendered a runtime-crashing step after changing from Step 1 to Step 2.

Build passed because the file was syntactically valid, but the browser failed at runtime.

## Recovery Action

Replaced MatterIntakeWizard.jsx with a known-good self-contained wizard.

The recovered wizard provides:

- Step 1 Client Details
- Step 2 Case / Matter Details
- Step 3 Deadline Details
- Step 4 Document Details
- Step 5 Review
- Step 6 Review / Save & Submit
- Previous returns to main workspace on Step 1
- Previous moves backward on later steps
- Save & Next moves forward reliably
- Final step opens Review Submit completion screen

## Files Changed

- frontend/src/pages/MatterIntakeWizard.jsx

## Safety Scope

Frontend-only wizard runtime recovery.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Open Matter Intake
- Step 1 loads
- Previous from Step 1 returns to main workspace
- Reopen Matter Intake
- Save & Next opens Step 2
- Save & Next opens Step 3
- Save & Next opens Step 4
- Save & Next opens Step 5
- Save & Next opens Step 6
- Complete / Review Submit opens Review / Save & Submit
- No white screen
- No blank page
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z-R: READY FOR BUILD VERIFICATION


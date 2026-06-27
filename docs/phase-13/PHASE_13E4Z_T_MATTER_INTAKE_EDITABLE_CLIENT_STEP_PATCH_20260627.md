# Litigation 360 / LEOS 360
# Phase 13E.4Z-T Matter Intake Editable Client Step Patch

Date: 2026-06-27

## Objective

Replace the static Matter Intake Step 1 Client Details display with an editable, searchable, duplicate-aware frontend intake screen.

## Background

The previous runtime recovery stopped the white/blank page by replacing the unstable wizard with a safe self-contained wizard.

That recovery made the wizard stable, but Step 1 remained display-only.

This phase implements the next layer: editable client intake.

## Implemented

MatterIntakeWizard.jsx now includes:

- Search Existing Client panel
- Clear Search action
- frontend-only sample duplicate / possible match detection
- duplicate result cards
- Load Existing Client Into Intake action
- Mark As Reviewed action
- Paste From Email / Document textarea
- simple extraction of email, phone, likely name, and likely address
- editable client intake fields
- Full Name field
- Email field
- Phone field
- Address field
- ID / Passport / Reference field
- Client Type field
- Intake Source field
- Notes field
- Save Draft button using local browser storage
- Clear Draft button
- Reset Client Intake button
- Save & Next validation
- Step 2 summary using Step 1 client intake state
- Review summary using Step 1 client intake state

## Save & Next Rule

On Step 1, Save & Next requires at least one of:

- Full Name
- Email
- Phone

If all three are empty, the wizard shows an inline warning and does not proceed.

If at least one is entered, the wizard proceeds to Step 2 Case / Matter Details.

## Duplicate Search Behaviour

This phase is frontend-only.

Search uses sample placeholder client records in MatterIntakeWizard.jsx.

Exact / strong match is shown when email or phone matches.

Possible match is shown when name or address matches.

Future backend search can replace the sample records without changing the user-facing workflow.

## Safety Scope

Frontend-only Matter Intake wizard patch.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Files Changed

- frontend/src/pages/MatterIntakeWizard.jsx

## Required Browser QA

- Matter Intake opens
- Client Search panel visible
- Search field accepts typing
- Search Existing Client returns sample match for John / Edmund / edmundrulz / 0162172852
- Clear Search clears search state
- Paste textarea accepts text
- Apply Pasted Text fills simple detected values where possible
- Editable fields accept manual typing
- Save Draft shows local draft saved message
- Clear Draft shows draft cleared message
- Reset Client Intake clears editable fields
- Save & Next blocks when Full Name, Email, and Phone are all empty
- Save & Next proceeds when at least one of Full Name, Email, or Phone exists
- Step 2 Case / Matter Details loads
- Previous from Step 1 returns to main workspace
- No white screen
- No blank page
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z-T: READY FOR BUILD VERIFICATION


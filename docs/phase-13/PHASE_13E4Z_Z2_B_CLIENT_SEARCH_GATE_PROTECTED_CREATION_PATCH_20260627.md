# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z2-B Split Matter Intake Client Step Into Search Gate And Protected New Client Creation

Date: 2026-06-27

## Objective

Split Matter Intake Step 1 into two distinct protected client functions:

1. Client Search & Duplicate Detection
2. New Client Profile Creation

## Implemented

### MatterIntakeWizard.jsx

Replaced Step 1 rendering with strict internal client sub-modes:

- search
- create
- existing-selected
- duplicate-review

## Search Gate Behaviour

The landing interface is now Client Search & Duplicate Detection.

It includes:

- dedicated search bar
- broad identifying placeholder
- search tips
- duplicate confidence indicators
- result summary cards
- View Full Profile
- Select This Client
- No Match Found — Create New Client Profile

## Protected Creation Behaviour

New Client Profile Creation is now separate from the search screen.

It includes:

- mandatory confirmation gate
- Individual Information
- Contact Details
- Identification
- Employment/Entity
- Address
- Intake Metadata
- Client Type selector
- Save Draft
- Clear Draft
- Reset Client Intake

## Workflow Enforcement

- Search and new client form do not render together.
- New client form cannot be accessed before search.
- No Match Found pathway appears only after search.
- Existing client selection is separate and can continue to Case / Matter Details.
- Duplicate hard stop blocks continuation when entered new-client details match an existing record.
- Duplicate override requires Duplicate Decision/Review Notes.
- Search audit trail records search, profile view, selected existing client, no-duplicate confirmation, hard stop, and override/new-client decisions.

## Safety Scope

Frontend-only Matter Intake workflow split.

No Clients.jsx changes.
No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Matter Intake opens
- Step 1 starts on Client Search & Duplicate Detection only
- Editable new client profile form is not visible on search landing screen
- Search can be performed
- Search results show confidence indicators
- View Full Profile opens read-only preview without leaving Matter Intake
- Select This Client opens existing-client selected summary
- Existing-client summary can continue to Case / Matter Details
- No Match Found — Create New Client Profile appears only after search
- Clicking No Match Found opens New Client Profile Creation
- Creation screen shows mandatory confirmation gate
- New client form appears only after confirmation is checked
- Previous from create screen returns to search screen
- Duplicate hard stop appears when entered details match existing sample record
- Duplicate override requires Duplicate Decision/Review Notes
- Continue to Case / Matter Details works after valid new-client confirmation
- No blank page
- No white screen
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z-Z2-B: READY FOR BUILD VERIFICATION


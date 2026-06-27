# Litigation 360 / LEOS 360
# Phase 13E.4Z-S Matter Intake Editable Client Search Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-S: EDITABLE CLIENT SEARCH BLUEPRINT

## Purpose

Define the correct Matter Intake Step 1 behaviour before further code changes.

The current Matter Intake Wizard runtime recovery stopped the white/blank page, but the recovered Client Details step is display-only.

This blueprint defines the expected editable, searchable, duplicate-aware client intake workflow.

## Current State

Current recovered wizard commit:

- a9f9159 fix(workspace): recover matter intake wizard runtime flow

Current behaviour:

- Matter Intake opens
- Step 1 Client Details displays client summary values
- Save & Next navigation is runtime-stabilized
- Previous from Step 1 should return to main workspace
- Client details are displayed as static summary content
- Client details are not editable inside the wizard
- Client search is not available inside the wizard
- Paste-from-email/document intake is not available inside the wizard
- Duplicate detection inside the wizard is not implemented
- Existing-client selection inside the wizard is not implemented

## Problem Statement

The user expectation is correct:

Matter Intake should not begin as a static display card.

It should begin with a client search and editable intake interface.

The user must be able to:

- search for an existing client
- detect possible duplicate clients
- select or load an existing client
- create a new client if no match exists
- paste text from an email or document
- amend extracted or entered values
- add, clear, or delete draft client values
- continue to Case / Matter Details only after the client intake state is clear

## Correct Step 1 Workflow

### Step 1A: Search Existing Client

The first visible action should be client search.

Search fields should support:

- client full name
- given name
- surname
- email
- phone number
- NRIC / passport / ID reference
- company name
- address keyword
- matter reference if available

Expected interface:

- search input
- Search Existing Client button
- Clear Search button
- helper text explaining search-first workflow

### Step 1B: Search Results / Duplicate Decision

If exact match is found:

Display warning:

- Client already exists

Show existing client result card with:

- name
- email
- phone
- address
- client reference if available
- status
- last updated date if available

Available actions:

- Open Existing Client Profile
- Load Existing Client Into Intake
- Start New Matter For Existing Client

If partial match is found:

Display possible match panel with:

- possible matching records
- confidence indicator
- matched fields
- side-by-side comparison between entered/pasted values and existing values

Available actions:

- Select Existing Client
- Load Existing Client Into Intake
- Continue As New Client
- Mark Not Duplicate

If no match is found:

Display:

- No existing client found

Available action:

- Create New Client Profile

### Step 1C: Paste From Email / Document

The wizard should include a paste box.

Purpose:

Allow staff to paste unstructured intake text from:

- email
- WhatsApp message
- letter
- PDF extract
- document notes
- copied call notes

Expected fields extracted or manually filled:

- full name
- email
- phone
- address
- ID reference
- matter type
- opposing party
- urgency/deadline notes
- source notes

Frontend-only extraction can be simple at this phase.

Allowed initial behaviour:

- paste text remains visible
- user manually copies values into editable fields
- optional simple email/phone extraction can be added later

### Step 1D: Editable Client Details Form

After search decision, the wizard should show editable fields.

Minimum Phase 13E.4Z-T editable fields:

- Full Name
- Email
- Phone
- Address
- ID / Passport / Reference
- Client Type
- Intake Source
- Notes

Required buttons:

- Save Draft
- Clear Draft
- Reset Client Intake
- Save & Next

### Step 1E: Save & Next Rules

Save & Next from Step 1 should:

- not white-screen
- not depend on backend persistence yet
- preserve the current client intake state in React state
- move to Step 2 Case / Matter Details
- show a clear warning if required minimum fields are empty

Minimum required fields for frontend-only phase:

- Full Name OR Email OR Phone

If all three are empty:

- show inline warning
- do not proceed

If at least one exists:

- proceed to Step 2

## Expected Screen Sequence

Correct Matter Intake sequence:

1. Matter Intake
2. Client Search / Duplicate Check
3. Editable Client Details
4. Case / Matter Details
5. Deadline Details
6. Document Details
7. Review
8. Review / Save & Submit
9. Completion Review

## Duplicate Handling Rules

### Exact Duplicate

Exact duplicate should trigger when any of these are identical:

- email
- phone
- NRIC/passport/reference
- full name plus address

Expected result:

- block silent duplicate creation
- show duplicate warning
- allow user to open/load existing profile

### Partial Duplicate

Partial duplicate should trigger when:

- similar name
- same surname and phone area
- same address
- same email domain with similar name
- same company name
- same phone number without country code match

Expected result:

- warn but do not hard block
- show possible match
- allow user to continue as new with confirmation

## Role / Permission Notes

The current display-only state is not treated as an RBAC restriction.

For this frontend phase:

- editing should be available
- delete should be limited to clearing draft data only
- no database delete should be implemented
- no backend permission model should be changed
- no auth/RBAC file should be edited

Future backend/RBAC phase can define:

- who may create clients
- who may amend clients
- who may merge duplicate clients
- who may delete clients
- who may override duplicate warnings

## Phase 13E.4Z-T Recommended Code Scope

Next implementation phase:

- Phase 13E.4Z-T Matter Intake Editable Client Step Patch

Allowed files:

- frontend/src/pages/MatterIntakeWizard.jsx
- optional frontend/src/App.css only if small styling is needed
- docs/phase-13 implementation record
- docs/qa/phase-13 QA record

Do not edit:

- backend files
- database files
- auth files
- RBAC files
- API route files
- server files
- package files
- production infrastructure files

## Phase 13E.4Z-T Minimum Deliverables

Implement only Step 1 improvements:

- Search Existing Client panel
- duplicate result placeholder
- paste-from-email/document textarea
- editable client fields
- Save Draft button
- Clear Draft button
- Reset Client Intake button
- Save & Next validation
- Save & Next moves to Step 2
- Previous from Step 1 returns to main workspace

Do not implement real backend database search yet.

Use frontend-only mock/search against local wizard state or existing placeholder data.

## Required Browser QA For Phase 13E.4Z-T

Test cases:

1. Matter Intake opens
2. Client Search panel visible
3. Search field accepts typing
4. Search button returns no-match state for unknown value
5. Search button returns duplicate/possible-match placeholder for known sample value
6. Paste box accepts copied text
7. Editable fields accept manual typing
8. Clear Draft clears editable intake fields
9. Save & Next blocks if name/email/phone are all empty
10. Save & Next proceeds if at least name/email/phone exists
11. Step 2 Case / Matter Details loads
12. Previous from Step 1 returns to main workspace
13. Browser console has no red runtime error
14. Production build passes

## Final Decision

The current display-only Client Details state is not final.

It is only a runtime recovery state.

Proceed to Phase 13E.4Z-T only after this blueprint is committed.

## Status

Phase 13E.4Z-S Blueprint: READY FOR COMMIT


# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z2-A Client Search Gate & Protected New Client Creation Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z2-A: BLUEPRINT AND SOURCE ANCHOR AUDIT

## Objective

Redesign Matter Intake Step 1 into two clearly separated protected interfaces:

1. Client Search & Duplicate Detection
2. New Client Profile Creation

The search interface and new-client form must never appear on the same screen at the same time.

## Current Problem Confirmed By Browser Review

Current Matter Intake Step 1 shows:

- Client Search / Duplicate Detection
- No results found state
- Create New Client Profile From Search action
- Editable Client Profile form

all on the same visible screen.

This weakens duplicate prevention because users can visually bypass the search-first workflow and begin filling a new client profile before the search gate is fully respected.

## Required Final Behaviour

Matter Intake Step 1 must become a gated internal process:

### Step 1A: Client Search & Duplicate Detection

This is the primary landing interface.

It must include:

- prominent dedicated search bar
- placeholder instructing users to enter any identifying information:
  - full name
  - given name
  - surname
  - preferred name
  - alias
  - ID/NRIC
  - passport number
  - phone
  - WhatsApp
  - email
  - company name
- search tips helper
- real-time or deliberate search results
- duplicate confidence indicators:
  - exact match
  - partial match
  - phonetic match
  - high probability
  - medium probability
  - low probability
- result summary cards showing:
  - full name
  - date of birth
  - primary contact details
  - ID/NRIC
  - last matter date
- result actions:
  - View Full Profile
  - Select This Client
- No Match Found — Create New Client Profile pathway only after search has been performed

### Step 1B: New Client Profile Creation

This is a separate protected interface.

It must be available only after:

- a search was performed
- the user deliberately confirms no suitable existing record was found

It must include a mandatory confirmation gate:

- user confirms they searched and reviewed possible duplicates
- form remains protected until confirmation is made

The editable fields must preserve the original prompt labels and defaults:

#### Individual Information

- Full Name
- Given Name
- Surname
- Preferred Name
- Alias / Also Known As

#### Contact Details

- Email
- Phone
- WhatsApp

#### Identification

- ID / NRIC / Reference
- Passport Number
- Date Of Birth
- dd/mm/yyyy format

#### Employment / Entity

- Company / Organisation Name

#### Address

- Full Address
- City / Area
- Postcode
- State
- Country
- default: Malaysia

#### Intake Metadata

- Intake Source
- Duplicate Decision / Review Notes
- General Intake Notes

#### Client Type

- Individual
- Organisation

Client Type may dynamically show or hide relevant fields, but no original data may be discarded.

## Critical Workflow Rules

### Rule 1: Search and creation never render together

The search module and new profile form must be separate render branches.

### Rule 2: No bypass

Users cannot access new client creation until at least one deliberate search is performed.

### Rule 3: No-match path only after search

No Match Found — Create New Client Profile only appears after search.

### Rule 4: Existing client path

If a match is found, user can:

- View Full Profile
- Select This Client

Selecting an existing client links it to the Matter Intake and proceeds safely.

### Rule 5: Duplicate hard stop

If the user tries to create a new client and entered details match an existing record:

- block Continue to Case / Matter Details
- show matching records
- require explicit override justification in Duplicate Decision / Review Notes
- log the override decision

### Rule 6: Audit trail

Matter Intake must track:

- search terms used
- result counts
- result cards reviewed
- selected existing client
- no-match confirmation
- duplicate override reason
- final decision

## Recommended Internal State

MatterIntakeWizard.jsx should use an internal client sub-mode.

Recommended states:

- search
- create
- existing-selected
- duplicate-review

Recommended variables:

- clientStepMode
- searchPerformed
- searchAuditTrail
- selectedExistingClient
- confirmedNoDuplicate
- duplicateOverrideRequired
- duplicateOverrideMatches
- viewedClientIds

## Rendering Contract

Matter Intake Step 1 should render using strict branching:

- if clientStepMode is search:
  - render Client Search & Duplicate Detection only

- if clientStepMode is create:
  - render New Client Profile Creation only

- if clientStepMode is existing-selected:
  - render selected existing client summary only

- if clientStepMode is duplicate-review:
  - render duplicate hard-stop review only

## Implementation Scope For Next Code Patch

Allowed files:

- frontend/src/pages/MatterIntakeWizard.jsx
- frontend/src/App.css
- docs/phase-13
- docs/qa/phase-13

Avoid touching Clients.jsx in the first code patch.

The original Clients module remains preserved as Advanced Client Directory / Manual Management.

## Prohibited In Next Code Patch

Do not:

- delete original Clients.jsx logic
- rewrite original Clients.jsx form
- remove original Clients fields
- change backend files
- change database files
- change auth/RBAC files
- change API routes
- change server files
- change package files

## Acceptance Criteria For Code Patch

The next code patch must pass:

- Matter Intake opens
- Step 1 starts on Client Search & Duplicate Detection only
- New Client Profile form is not visible on the landing search screen
- No Match Found — Create New Client Profile appears only after search
- Clicking No Match Found opens New Client Profile Creation
- New Client Profile Creation includes confirmation gate
- Previous returns from create mode to search mode
- Select This Client creates selected-client summary
- Continue to Case / Matter Details works after valid existing selection
- Continue to Case / Matter Details works after valid new profile and duplicate confirmation
- Duplicate hard stop appears when matching details are found during creation
- Duplicate override requires reason
- Search audit trail is maintained in component state
- No blank page
- No white screen
- Production build passes

## GitHub Review Decision

GitHub is not required before the local code patch.

Recommended GitHub timing:

- after local code patch
- after production build passes
- after browser QA passes
- then push branch or commit for review

## Status

Phase 13E.4Z-Z2-A: READY FOR VERIFICATION AND COMMIT


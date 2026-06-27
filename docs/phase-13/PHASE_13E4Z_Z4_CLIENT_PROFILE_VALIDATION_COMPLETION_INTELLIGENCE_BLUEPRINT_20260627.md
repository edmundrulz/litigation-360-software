# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z4 Client Profile Validation / Completion Intelligence Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z4: CLIENT PROFILE VALIDATION / COMPLETION INTELLIGENCE BLUEPRINT

## Objective

Define the next controlled modernization layer for the full Clients profile workflow: validation visibility, completion intelligence, required-field blocker surfacing, and profile-readiness guidance.

This phase is documentation/control only.

No frontend code is changed in this phase.
No validation logic is changed in this phase.
No backend, database, auth, RBAC, API, server, package, or infrastructure files are changed in this phase.

## Strategic Purpose

The full Clients profile form is now the authoritative client creation pathway.

The next improvement is to make the existing validation and completion state easier to understand without changing the underlying rules.

The objective is not to invent new validation.

The objective is to surface existing required-field, missing-field, compliance, and readiness state in a professional and cognitively clear way.

## Current Completed Foundation

Previous completed Z3 layers established:

- search-first Matter Intake client gate
- protected duplicate detection
- No Match redirect to Advanced Client Directory / Manual Management
- full Clients profile preservation
- CSS-first profile shell
- explicit section heading wrappers
- static summary rail
- section jump links
- pre-submission review panel
- final Z3 closeout / SSOT handover

## Authoritative Source Of Truth

The existing Clients.jsx form remains authoritative.

The validation/completion intelligence layer must derive from existing form state, required fields, and existing validation behaviour only.

It must not create a competing validation engine unless separately approved and mapped.

## Non-Negotiable Preservation Rule

Z4 must not remove, relax, bypass, rename unsafely, or alter:

- existing required fields
- existing required markers
- existing validation rules
- existing field labels
- existing helper text
- existing backend/API payloads
- existing local fallback behaviour
- existing draft/save/reset behaviour
- existing create/save handlers
- existing manual client management protocol
- existing directory/table behaviour
- existing Matter Intake bridge
- Return to Matter Intake action

## Problem To Solve

The full Clients profile is comprehensive but dense.

Users need clearer answers to:

- what is complete
- what is missing
- which sections require attention
- which fields block save/create
- which fields are optional but recommended
- which compliance items are pending
- whether backend/local fallback status affects confidence
- whether the profile is ready for final save

## Desired Final UX

The user should see:

1. A profile completion status.
2. A required-field blocker summary.
3. Section-level completion states.
4. Compliance-sensitive pending items.
5. Review-required warnings.
6. Jump links to incomplete sections.
7. Confirmation that existing validation remains authoritative.

## Intelligence Types

### 1. Completion Intelligence

Show whether the profile is complete enough for save/create review.

Potential display:

- Profile Completion
- Required Sections Complete
- Required Items Remaining
- Review Required

Important rule: if exact completion cannot be safely computed from existing validation state, the first patch must remain informational only.

### 2. Required-Field Blocker Intelligence

Surface missing required fields before the user reaches save/create.

Potential blocker categories:

- identity incomplete
- identification incomplete
- contact information incomplete
- address/service location incomplete
- documentation verification incomplete
- internal pending information unresolved

Important rule: do not invent blockers. Only surface blockers already required by existing form logic or confirmed field registry.

### 3. Section-Level Status Intelligence

Each major profile section may show one of:

- Complete
- Review Required
- Pending
- Not Started
- Optional
- Backend Check Required

Status must be text-based and not colour-only.

### 4. Compliance Intelligence

Make compliance-sensitive areas visible before save.

Candidate areas:

- identity verification
- document verification
- pending document reason
- internal remarks
- missing / unknown / pending information
- duplicate search / no-match context, where relevant
- backend/local fallback warning

Compliance display must not replace manual review.

### 5. Navigation Intelligence

Allow users to jump directly to problem areas using existing section anchors from Z3-G2.

Do not create new routing or duplicate forms.

## Recommended Implementation Strategy

Proceed in controlled layers.

### Z4-A: Existing Validation Source Audit

Documentation/control only.

Identify:

- existing required fields
- existing validation functions
- field error state
- save/create blockers
- draft state
- backend/local warning state
- field labels and section mapping
- existing completion/progress calculations if any

### Z4-B: Validation / Completion Mapping Blueprint

Documentation/control only.

Create a canonical map:

- section name
- existing fields
- required fields
- optional but recommended fields
- validation source
- blocker wording
- jump anchor
- display status rule

### Z4-C: Static Completion Status Shell Patch

Frontend-only.

Allowed:

- add completion/status container
- display informational status cards
- no computed validation yet
- no save logic change
- no backend/API change

### Z4-D: Existing Required Field Counter Patch

Frontend-only after audit confirms safe field keys.

Allowed:

- calculate missing required count from existing form state
- show missing required categories
- link to existing anchors

Not allowed:

- change required rules
- block submission differently
- alter save/create handlers

### Z4-E: Section-Level Completion Patch

Frontend-only.

Allowed:

- show section-level status based on audited field groups
- use safe text statuses
- preserve all original behaviour

### Z4-F: Validation Intelligence QA + Closeout

Documentation/control.

Confirm:

- build passes
- browser QA passes
- original validation remains active
- no backend/API changes
- no field deletion
- no save flow change

## Required Source Audit Before Code

Before any Z4 code patch, inspect:

- form state object
- validation functions
- error state
- required field declarations
- save/create handler
- draft handler
- localStorage draft handler
- backend/local fallback warnings
- current progress/completion logic if any
- section heading ids from Z3-G2
- pre-submission review panel from Z3-I

## Recommended Source Audit Command

Run this before Z4 code:

`powershell
Select-String -Path ".\frontend\src\pages\Clients.jsx" `
  -Pattern "required|fieldErrors|errors|validate|validation|setValidation|mandatory|Missing|requiredFields|form\.|handleSubmit|save|create|draft|CLIENT_ONBOARDING_DRAFT_KEY|localStorage|backend|fallback|client-profile-review|client-profile-summary|client-profile-card-title" `
  -Context 4,10
`",
",


Do not:

- change validation rules
- create new backend calls
- change API payloads
- alter database schema
- change auth/RBAC
- change server/package files
- replace Clients.jsx
- remove fields
- rename field keys unsafely
- hide required fields
- bypass duplicate review
- bypass documentation verification
- create a second save flow
- mark incomplete records as complete

## Future QA Requirements

Each future Z4 code patch must confirm:

- Clients page opens
- full original form remains visible
- validation rules remain unchanged
- existing save/create controls remain unchanged
- completion display appears
- blocker display does not falsely mark profiles complete
- jump links work
- backend/local fallback warnings remain visible
- Matter Intake No Match redirect still works
- Return to Matter Intake still works
- no white screen
- no browser console red runtime error
- production build passes

## Recommended Next Step

Phase 13E.4Z-Z4-A — Existing Validation Source Audit

## Status

Phase 13E.4Z-Z4 Blueprint: READY FOR VERIFICATION AND COMMIT

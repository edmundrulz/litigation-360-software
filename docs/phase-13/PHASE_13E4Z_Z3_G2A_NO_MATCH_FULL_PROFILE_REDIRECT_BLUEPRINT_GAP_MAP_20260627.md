# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z3-G2A No Match Full Profile Redirect Blueprint + Gap Map

Date: 2026-06-27

## Status

Phase 13E.4Z-Z3-G2A: BLUEPRINT / GAP MAP / CONTROL GATE

## Objective

Rewrite the No Match Found client creation pathway so that it no longer opens the simplified Matter Intake new-client profile form.

Instead, the No Match Found flow must redirect users to the Advanced Client Directory / Manual Management interface, where the full Client Registration / Full Client Profile process already exists.

## Required User Flow

Previous flow:

Matter Intake
→ Client Search & Duplicate Detection
→ No Match Found
→ simplified New Client Profile Creation form

New required flow:

Matter Intake
→ Client Search & Duplicate Detection
→ No Match Found
→ Continue to Advanced Client Directory / Manual Management
→ Workspace - Clients
→ Client Registration / Full Client Profile
→ full manual client profile form

## Reason For Change

The simplified Matter Intake new-client form is visually cleaner but does not contain the full operational, compliance, client-management, and manual-management depth required for an authoritative client profile.

The Advanced Client Directory / Manual Management form is the authoritative full profile process and must become the unified destination for new client creation from both entry points.

## Non-Negotiable Rule

The simplified Matter Intake new-client creation form must not be treated as the authoritative profile creation form.

The Advanced Client Directory / Manual Management version remains the source of truth.

## Preservation Requirements

The unified No Match flow must preserve and expose all fields, data points, protocols, validations, help text, labels, warnings, and linked functions available in the Advanced Client Directory / Manual Management pathway.

This includes but is not limited to:

- complete client profile details
- complete identification details
- complete contact information
- address and service location details
- emergency contact / next of kin
- employment details
- family and marital details
- matter context and case origin
- client source and value indicators
- billing preferences
- service tier classification
- communication preferences
- communication history, where available
- custom attributes, where available
- relationship mapping, where available
- document verification status
- document attachments, where available
- audit trails, where available
- internal remarks
- missing / unknown / pending information
- backend availability warnings
- local fallback warnings
- save / create / clear behaviours
- validation rules
- required markers
- help text
- manual management protocols

## Gap Map: Simplified Matter Intake Form vs Advanced Manual Management

### Gap 1: Contact Depth

Simplified flow may only capture limited identity/contact information.

Advanced manual management must preserve:

- phone
- email
- alternative phone
- WhatsApp/contact preference
- communication preference notes
- contact restrictions
- correspondence channels

Resolution:

No Match must redirect to Advanced Client Directory / Manual Management.

### Gap 2: Billing / Commercial Metadata

Simplified flow does not reliably expose full billing and service metadata.

Advanced manual management must preserve:

- billing preference
- service tier
- value indicators
- client source
- client classification
- commercial notes

Resolution:

Do not duplicate these fields in Matter Intake. Use the full Clients profile.

### Gap 3: Relationship / Family / Emergency Mapping

Simplified flow does not provide full relationship mapping depth.

Advanced manual management must preserve:

- family and marital metadata
- next of kin
- emergency contact
- relationship notes
- dependency/context fields where present

Resolution:

Redirect to the full manual profile.

### Gap 4: Matter Origin / Case Context

Simplified flow may collect matter intake context but does not preserve full profile-level matter origin metadata.

Advanced manual management must preserve:

- matter context
- client role
- case origin
- referral/source details
- prior firm/takeover context
- internal notes

Resolution:

Use the Advanced Client Directory / Manual Management form as the canonical full profile entry point.

### Gap 5: Documentation / Attachment / Verification

Simplified flow does not provide full documentation verification workflow.

Advanced manual management must preserve:

- documentation verification status
- pending document reason
- document retention notes
- attachment/document metadata where present
- compliance warnings

Resolution:

No Match creation must occur through the full Clients form.

### Gap 6: Audit Trail / Protocol / Backend Awareness

Simplified flow risks bypassing manual-management warnings and local/backend context.

Advanced manual management must preserve:

- backend check required state
- local saved clients fallback
- manual management protocol
- audit/context notes where present
- existing save/create behaviour

Resolution:

Redirect rather than duplicate.

## Implementation Strategy

### Code Change Required

Matter Intake No Match Found action should change from:

Open simplified New Client Profile Creation screen

to:

Redirect to Advanced Client Directory / Manual Management.

### Preferred Technical Behaviour

When the user clicks the No Match Found create action:

1. Store the no-match search context in localStorage using a safe namespaced key.
2. Redirect to Clients workspace through existing setModule path.
3. Clients page displays existing full form.
4. Optional bridge note may show that the user arrived from Matter Intake No Match.
5. User completes the authoritative full profile form there.

## LocalStorage Context Key

Recommended key:

litigation360.noMatchClientCreationContext

Suggested stored payload:

- source: matter-intake-no-match
- searchTerm
- timestamp
- instruction: create-full-client-profile-in-advanced-directory

This context is informational only.

It must not create a client automatically.

It must not bypass duplicate checks.

It must not change validation.

## UI Text Recommendation

Replace simplified form trigger text with:

Create Full Client Profile in Advanced Directory

Helper text:

No matching client was found. To preserve complete profile details, compliance fields, billing preferences, communication history, document verification, audit trails, and manual-management protocols, continue to the Advanced Client Directory to create the full client profile.

## Prohibited

Do not:

- copy the full Clients form into MatterIntakeWizard.jsx
- maintain two competing new-client creation forms
- weaken validation
- remove required markers
- bypass backend/local fallback warnings
- invent new backend fields
- alter API payloads
- alter auth/RBAC/server/database files
- alter save/reset/draft behaviour
- remove the Advanced Client Directory pathway

## Files Expected For Future Patch

Likely frontend files:

- frontend/src/pages/MatterIntakeWizard.jsx
- frontend/src/pages/Clients.jsx
- frontend/src/App.css

Docs / QA:

- docs/phase-13
- docs/qa/phase-13

## QA Required After Future Patch

- Matter Intake opens
- client search still works
- No Match Found state still appears
- No Match Found no longer opens the simplified new-client profile form
- No Match Found action redirects to Workspace - Clients
- Advanced Client Directory / Manual Management appears
- full Client Registration / Full Client Profile form appears
- all full manual profile sections remain visible
- required markers remain visible
- backend warning remains visible
- local fallback warning remains visible
- Return to Matter Intake remains available
- no white screen
- no console red runtime error
- production build passes

## Status

Phase 13E.4Z-Z3-G2A: READY FOR VERIFICATION AND COMMIT


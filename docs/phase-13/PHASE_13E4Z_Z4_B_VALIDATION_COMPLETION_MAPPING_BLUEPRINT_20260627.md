# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z4-B Validation / Completion Mapping Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z4-B: VALIDATION / COMPLETION MAPPING BLUEPRINT

## Objective

Map the existing Clients.jsx full-profile sections into a conservative validation and completion intelligence framework before any computed UI is introduced.

This phase is documentation/control only.

No frontend code is changed in this phase.
No validation logic is changed in this phase.
No backend, database, auth, RBAC, API, server, package, or infrastructure files are changed in this phase.

## Source Basis

This mapping is based on the Z4-A audit outputs:

- PHASE_13E4Z_Z4_A_EXISTING_VALIDATION_SOURCE_AUDIT_20260627.txt
- PHASE_13E4Z_Z4_A_CLIENTS_FIELD_VALIDATION_ANCHOR_SCAN_20260627.txt
- PHASE_13E4Z_Z4_A_EXISTING_VALIDATION_SOURCE_AUDIT_SUMMARY_20260627.md

## Core Rule

Z4 validation/completion intelligence must only surface existing Clients.jsx form state, required fields, labels, validation behaviour, warnings, and save/create constraints.

It must not invent new required rules.
It must not weaken existing required rules.
It must not create a second save flow.
It must not alter backend/API payloads.
It must not alter draft/localStorage behaviour.

## Mapping Strategy

Each section is mapped using:

- section name
- existing jump anchor
- purpose
- likely required/completion signals
- optional/recommended signals
- status wording
- blocker wording
- preservation notes

Exact field keys must be confirmed from the Z4-A audit before any computed code patch.

## Status Wording Standard

Allowed status wording:

- Complete
- Review Required
- Pending
- Not Started
- Optional
- Backend Check Required
- Local Fallback Active
- Verify Before Saving

Do not use vague or alarming labels such as OK, Bad, Failed, Broken, or Problem.

## Section Mapping

### 1. Client Profile Details

Anchor:

- client-profile-details

Purpose:

- identity and profile foundation

Likely completion signals:

- client legal name or organisation name
- client type
- profile classification
- primary identity/profile fields already present in Clients.jsx

Optional / recommended signals:

- preferred name
- alias
- additional classification notes

Display status rule:

- Complete only if existing required identity/profile fields are populated according to existing Clients.jsx rules.
- Review Required if identity/profile fields are partially completed.
- Not Started if no meaningful identity/profile signal is present.

Blocker wording:

- Client profile identity requires review before saving.

Preservation note:

- Do not change existing name/type/classification field keys or required markers.

### 2. Client Identification Details

Anchor:

- client-identification-details

Purpose:

- identity verification and duplicate-risk control

Likely completion signals:

- identification reference
- NRIC/passport/company registration field where present
- date of birth or registration context where present
- document/identity verification values already present in Clients.jsx

Optional / recommended signals:

- secondary ID information
- nationality or registration context where already present

Display status rule:

- Complete only if existing identification requirements are satisfied.
- Pending if identity details are partly filled or verification status is unresolved.
- Review Required if identification fields conflict or are incomplete under existing rules.

Blocker wording:

- Identification details require review before treating this profile as complete.

Preservation note:

- Do not introduce new identity validation rules without separate audit.

### 3. Employment Details

Anchor:

- client-employment-details

Purpose:

- employment and organisation context

Likely completion signals:

- employment status
- employer / organisation
- job title / occupation where present

Optional / recommended signals:

- industry
- employer address
- work contact details

Display status rule:

- Optional unless existing Clients.jsx validation marks employment fields as required.
- Review Required if partially filled fields suggest incomplete employment context.

Blocker wording:

- Employment details are incomplete or require review.

Preservation note:

- Do not convert optional employment fields into blockers unless already required.

### 4. Family and Marital Details

Anchor:

- client-family-marital-details

Purpose:

- personal relationship and dependency context

Likely completion signals:

- marital status
- spouse/family/dependency fields where present

Optional / recommended signals:

- relationship notes
- family context notes

Display status rule:

- Optional unless existing rules require a value.
- Pending if relationship-related fields are partially filled.

Blocker wording:

- Family or marital details require review.

Preservation note:

- Do not infer sensitive or family details. Only display what the user entered.

### 5. Matter Context and Case Origin

Anchor:

- client-matter-context-origin

Purpose:

- matter onboarding and origin tracking

Likely completion signals:

- client role
- matter origin
- case source
- prior firm / takeover context where present

Optional / recommended signals:

- referral notes
- matter source comments

Display status rule:

- Review Required if matter-origin fields are partly filled.
- Pending if source/origin information is expected but absent under existing rules.

Blocker wording:

- Matter context or case origin requires review.

Preservation note:

- Do not merge Matter Intake validation with Clients validation unless explicitly mapped.

### 6. Client Source and Value Indicators

Anchor:

- client-source-value-indicators

Purpose:

- business development, source, and client value metadata

Likely completion signals:

- client source
- referral source
- value indicator
- service tier / classification where present

Optional / recommended signals:

- billing/commercial notes
- value commentary

Display status rule:

- Optional unless source/value fields are already required.
- Review Required if commercial/source metadata is partially filled.

Blocker wording:

- Client source or value information requires review.

Preservation note:

- Do not invent billing/service-tier fields. Only map fields confirmed in Clients.jsx.

### 7. Will / Estate Handling Metadata

Anchor:

- client-will-estate-metadata

Purpose:

- specialist will, estate, probate, and inheritance workflow metadata

Likely completion signals:

- will / estate / probate indicator
- estate handling metadata where present

Optional / recommended signals:

- estate notes
- related party notes

Display status rule:

- Optional unless the profile indicates an estate/will/probate context.
- Review Required if estate context is selected but supporting details are incomplete.

Blocker wording:

- Estate or will handling details require review.

Preservation note:

- Do not trigger estate blockers unless existing field state indicates estate relevance.

### 8. Health / OKU / Disability and Accommodation Metadata

Anchor:

- client-health-oku-accommodation

Purpose:

- accessibility, accommodation, and support needs

Likely completion signals:

- OKU/disability/accommodation indicator where present
- accommodation notes where present

Optional / recommended signals:

- communication support requirements
- service accommodation notes

Display status rule:

- Optional unless an accommodation indicator is selected.
- Review Required if accommodation is indicated but supporting notes are incomplete.

Blocker wording:

- Accommodation or support details require review.

Preservation note:

- Use neutral, respectful wording. Do not infer health status.

### 9. Contact Information and Communication Preferences

Anchor:

- client-contact-communication-preferences

Purpose:

- communication readiness

Likely completion signals:

- phone
- email
- WhatsApp/contact preference
- preferred communication method

Optional / recommended signals:

- alternative phone
- communication notes
- restrictions or consent notes where present

Display status rule:

- Complete only if existing contact requirements are satisfied.
- Review Required if no reliable contact channel is present.
- Pending if contact preference exists but matching channel is missing.

Blocker wording:

- Contact information requires review before saving.

Preservation note:

- Do not alter email/phone validation or autocomplete behaviour.

### 10. Address and Service Location Details

Anchor:

- client-address-service-location

Purpose:

- service, correspondence, and location readiness

Likely completion signals:

- address
- postcode
- city
- state
- country
- service location
- correspondence address where present

Optional / recommended signals:

- address notes
- administrative area notes

Display status rule:

- Complete only if existing address/service-location requirements are satisfied.
- Review Required if address fields are partially filled.

Blocker wording:

- Address or service location details require review.

Preservation note:

- Do not change existing address synchronization behaviour.

### 11. Emergency Contact / Next of Kin Details

Anchor:

- client-emergency-next-of-kin

Purpose:

- secondary contact and emergency reference

Likely completion signals:

- emergency contact name
- relationship
- emergency phone

Optional / recommended signals:

- next-of-kin notes
- alternative emergency contact

Display status rule:

- Optional unless existing rules require emergency contact.
- Review Required if emergency contact fields are partially filled.

Blocker wording:

- Emergency contact details require review.

Preservation note:

- Do not make emergency contact mandatory unless existing validation already does.

### 12. Documentation Verification Status

Anchor:

- client-documentation-verification

Purpose:

- compliance and document-readiness visibility

Likely completion signals:

- document verification status
- pending document reason
- document notes
- identification-document status where present

Optional / recommended signals:

- document retention notes
- verification comments

Display status rule:

- Complete only if existing documentation verification state says complete.
- Pending if verification is not complete or document reason is provided.
- Review Required if document status is inconsistent.

Blocker wording:

- Documentation verification requires review before profile is treated as complete.

Preservation note:

- Do not bypass documentation verification. Do not create attachment logic without backend approval.

### 13. Internal Remarks / Pending Information

Anchor:

- client-internal-remarks-issues

Purpose:

- operational risk, missing information, unresolved notes, and follow-up tracking

Likely completion signals:

- internal remarks
- missing information
- pending follow-up
- unresolved issue notes

Optional / recommended signals:

- internal review comments
- handover comments

Display status rule:

- Review Required if pending/missing/unresolved information is entered.
- Optional if no internal remarks are present and existing rules do not require them.

Blocker wording:

- Internal remarks or pending information require review.

Preservation note:

- Do not hide pending information behind a green completion status.

## Global Status Calculation Rules

Future computed UI may use these principles only after field keys are confirmed:

1. A section can be Complete only when all confirmed required fields in that section are satisfied.
2. A section can be Review Required when partial data exists or compliance-sensitive information is pending.
3. A section can be Optional only when no existing validation rule requires the section.
4. A profile can show Verify Before Saving when any required or compliance-sensitive section is pending.
5. A profile must not be marked fully complete if backend/local fallback warnings indicate uncertainty.

## Future Patch Readiness

Z4-C should be static/informational first.

Z4-D may add required-field counts only after exact field keys are confirmed.

Z4-E may add section-level completion only after each section's field group is confirmed.

## Prohibited

Do not:

- alter validation
- alter save/create handlers
- alter draft handlers
- alter backend/API calls
- alter localStorage contracts
- change field names
- remove fields
- hide fields
- introduce backend dependencies
- make optional fields mandatory
- mark incomplete profiles complete
- create a second save flow

## Required Next Phase

Phase 13E.4Z-Z4-C — Static Completion Status Shell Patch

Recommended nature:

- frontend-only
- static/informational
- no computed validation
- no field-key dependency yet
- no save logic change
- no backend/API change

## Status

Phase 13E.4Z-Z4-B: READY FOR VERIFICATION AND COMMIT

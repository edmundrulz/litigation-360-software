# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z3-B Full Client Profile Field Registry Extraction

Date: 2026-06-27

## Status

Phase 13E.4Z-Z3-B: FIELD REGISTRY EXTRACTION

## Objective

Create a source-derived preservation registry for the existing full Clients profile before any UI modernization of Clients.jsx.

This phase protects the original full client profile process from functional, compliance, validation, or protocol regression.

## Files Generated

### Raw Source Evidence

- docs/phase-13/PHASE_13E4Z_Z3_B_CLIENTS_FIELD_REGISTRY_RAW_EVIDENCE_20260627.txt

Purpose:

- Captures relevant Clients.jsx source evidence around labels, placeholders, required markers, validation references, protocol text, save/reset/draft behaviour, and form sections.

### CSV Field Registry Extract

- docs/phase-13/PHASE_13E4Z_Z3_B_CLIENTS_FIELD_REGISTRY_EXTRACT_20260627.csv

Purpose:

- Provides a source-derived line-level registry for original labels/placeholders/components detected from Clients.jsx.

## Non-Negotiable Preservation Rule

No Clients.jsx modernization may proceed unless the original field registry is preserved.

The redesign must not remove, relax, or bypass:

- mandatory fields
- required field indicators
- validation rules
- input constraints
- conditional business rules
- approval or verification workflows
- duplicate review processes
- documentation verification protocols
- local saved client fallback
- draft/save/reset processes
- backend warning state
- audit and compliance notes
- original manual management capability

## Field Preservation Model

Every existing client profile item must be treated as one of these categories:

### Category A: Mandatory / Compliance Critical

These fields block or affect completion under current rules.

Modernization rule:

- preserve required state
- preserve validation
- preserve warning/error behaviour
- show stronger visual indicators
- include in pre-submission review

### Category B: Conditional Mandatory

These fields become required only when a trigger condition is met.

Modernization rule:

- preserve trigger logic
- do not hide without status
- show conditional reason
- include unresolved conditional requirements in summary rail

### Category C: Optional But Operationally Useful

These fields support profile completeness but do not block completion.

Modernization rule:

- preserve field
- visually separate from required items
- do not remove unless separately approved

### Category D: Protocol / Directive / Warning Text

These are not fields but operational instructions.

Modernization rule:

- preserve directive text
- improve readability only
- do not weaken meaning

### Category E: Action / Workflow Control

Examples:

- Create New Client Profile
- Save Modified Client
- Clear Form
- Return to Matter Intake
- manual client selection
- local fallback / backend warning

Modernization rule:

- preserve action intent
- preserve existing process sequence
- improve visual grouping only

## Proposed Modern Section Mapping

The modernization should map original fields into these section cards.

### 1. Client Identity

Preserve identity fields such as:

- Title
- Full Name
- Given Name
- Surname / Last Name
- Gender
- Preferred Name
- Alias / Also Known As
- Client Type
- manual exception fields if present

### 2. Client Identification Details

Preserve identification/demographic fields such as:

- identification/document status
- ID Type
- identity card colour / document class
- NRIC No. / Passport No.
- Date of Birth
- State of Birth / Registration
- Age Category
- Generational Classification
- Ethnicity

### 3. Employment Details

Preserve employment/entity fields such as:

- employment status
- employer / organisation
- occupation / role
- related entity metadata

### 4. Family and Marital Details

Preserve family/dependency fields such as:

- marital/family status
- dependant status
- relationship-linked metadata

### 5. Matter Context and Case Origin

Preserve origin fields such as:

- client role in matter
- case origin
- takeover / previous firm fields
- matter origin notes
- protocol warning text

### 6. Client Source and Value Indicators

Preserve source and business fields such as:

- client source
- total matters / cases count
- estimated client value tier
- revenue / value notes

### 7. Will / Estate Handling Metadata

Preserve estate-related fields and conditional directives.

### 8. Health / OKU / Disability and Accommodation Metadata

Preserve accommodation, OKU, health, communication support, and handling metadata.

### 9. Contact Information and Communication Preferences

Preserve contact and routing fields such as:

- email address
- primary phone number
- WhatsApp number
- WhatsApp same-as-primary-phone behaviour
- messaging app
- contact preference
- preferred contact hours
- first contact choice
- second contact choice
- additional contact options
- communication timing notes
- comments

### 10. Address and Service Location Details

Preserve address and location fields such as:

- address type
- country
- building / house number
- postcode
- building / house name
- city
- region
- street address
- correspondence address synchronization
- same-as-residential behaviour
- administrative area fields

### 11. Emergency Contact / Next of Kin Details

Preserve next-of-kin fields such as:

- emergency contact name
- relationship to client
- emergency contact number
- emergency contact email

### 12. Documentation Verification Status

Preserve documentation workflow fields such as:

- documentation verification complete
- document type
- document status
- verification / review status
- scanned copy status
- document retained notes
- internal remarks and still issues
- missing, unknown, or pending reason

### 13. Internal Notes and Intake Notes

Preserve note fields such as:

- internal remarks
- intake notes
- duplicate decision / review notes
- operational comments
- missing/pending instructions

## Required Next Review

Before the first Clients.jsx modernization patch, review the generated CSV and raw evidence.

The next code phase must not proceed unless:

- all major current form sections are represented
- all visible mandatory groups are accounted for
- save/reset/draft behaviours are preserved
- backend/local fallback warnings remain represented
- Matter Intake bridge remains represented
- full manual form depth remains represented

## Recommended Next Phase

Proceed next to:

Phase 13E.4Z-Z3-C — Full Client Profile Section Card Shell Patch

Scope:

- Clients.jsx and App.css only
- visual card wrappers and section headers only
- no deletion of fields
- no validation rewrites
- no backend changes
- no save/reset/draft behaviour changes

## GitHub Review Decision

GitHub review is optional after this registry commit.

Recommended timing:

- If the generated registry looks incomplete, ask for GitHub review or manual code review before UI patch.
- If registry is acceptable, perform one small local shell patch first, then use GitHub review after build and browser QA.

## Status

Phase 13E.4Z-Z3-B: READY FOR VERIFICATION AND COMMIT


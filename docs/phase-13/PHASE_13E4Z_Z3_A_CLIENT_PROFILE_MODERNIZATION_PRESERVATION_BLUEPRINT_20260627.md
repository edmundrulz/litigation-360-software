# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z3-A Full Client Profile Modernization Preservation Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z3-A: PRESERVATION AUDIT AND UI MODERNIZATION BLUEPRINT

## Objective

Design the next safe modernization layer for the existing full Clients profile creation page while preserving every original mandatory field, validation rule, business process, protocol, directive, compliance check, draft behaviour, local fallback, and operational requirement.

This phase is documentation/control only.

No code modernization is performed in this phase.

## Non-Negotiable Preservation Rule

The existing Clients.jsx form remains the authoritative full client profile process.

The modernization must not remove, relax, rename unsafely, or bypass:

- mandatory fields
- required field indicators
- validation rules
- input constraints
- conditional business rules
- approval or review workflows
- duplicate review process
- client verification protocols
- document verification rules
- local saved client fallback
- draft/save/reset processes
- backend check messaging
- audit or compliance notes
- security-sensitive handling
- original manual management capability

## Current Problem

The current Clients page is functionally rich and operationally thorough, but visually dense.

Observed issues:

- very long single-page form
- weak section separation
- difficult visual scanning
- required versus optional fields are not visually strong enough
- validation status is not summarized clearly
- user must scroll a long distance without a persistent completion map
- advanced protocols are present but visually crowded
- original form is complete but not yet modernized into a progressive, accessible profile-creation experience

## Modernization Principle

Modernize the layout, not the contract.

The redesign may change:

- card layout
- section grouping
- visual hierarchy
- spacing
- responsive behavior
- accessibility structure
- validation display
- progress summary
- contextual help
- pre-submission review screen

The redesign must not change:

- field keys
- required logic
- validator logic
- default values
- backend payload meaning
- save/reset/draft behavior
- original process obligations

## Proposed New Page Structure

### Page Header

Title:

- Create New Client Profile

Subtitle:

- All mandatory client, compliance, contact, and verification fields must be completed according to firm intake protocol.

Header badges:

- Backend Check Required
- Draft Status
- Last Saved
- Local Fallback Active if backend is unavailable

### Progress Strip

Three-stage profile process:

1. Search Completed
2. Client Profile
3. Review & Confirm

This confirms that new-client creation follows duplicate prevention.

### Main Layout

Desktop:

- 8-column main form
- 4-column sticky right summary rail

Tablet:

- single-column form
- summary rail becomes collapsible top card

Mobile:

- one section per row
- sticky bottom action bar
- section jump menu

## Proposed Section Architecture

The current full profile form should be visually reorganized into these cards.

### Section 1: Client Identity

Preserve all current identity fields.

Examples:

- Title
- Full Name
- Given Name
- Surname / Last Name
- Gender
- Preferred Name
- Alias / Also Known As
- Client Type
- Manual blogger / exception checkbox if present

### Section 2: Client Identification Details

Preserve all identification and demographic fields.

Examples:

- Identification / Document Status
- ID Type
- Identity Card Colour / Document Class
- NRIC No. / Passport No.
- Date of Birth
- State of Birth / Registration
- Age Category
- Generational Classification
- Ethnicity

### Section 3: Employment Details

Preserve all employment fields.

Examples:

- Employment Status
- Employer / Organisation
- Occupation / role
- related entity fields

### Section 4: Family and Marital Details

Preserve all family and dependency fields.

Examples:

- Marital / Family Status
- Has dependants
- relationship-linked metadata

### Section 5: Matter Context and Case Origin

Preserve all matter-origin workflow fields.

Examples:

- Client role in matter
- Case origin
- takeover / previous firm fields
- origin explanation and related protocol notes

### Section 6: Client Source and Value Indicators

Preserve all source, commercial, and value fields.

Examples:

- Client Source
- Total Matters / Cases Count
- Estimated Client Value Tier
- Revenue / Value Notes

### Section 7: Will / Estate Handling Metadata

Preserve all estate-related conditional handling fields.

Examples:

- Will status
- estate handling fields
- probate/inheritance metadata where present

### Section 8: Health / OKU / Disability and Accommodation Metadata

Preserve all health, disability, and accommodation fields.

Examples:

- Health / OKU status
- Communication Accommodation Required
- accommodation details

### Section 9: Contact Information and Communication Preferences

Preserve all contact and communication rules.

Examples:

- Email Address
- Primary Phone Number
- WhatsApp active same-as-primary-phone number
- Messaging app
- WhatsApp consent / routing
- Preferred contact channel
- Preferred contact hours
- 1st contact choice
- 2nd contact choice
- Additional contact options
- Communication timing notes
- Do-not-contact or special instructions if present

### Section 10: Address and Service Location Details

Preserve all address and administrative location fields.

Examples:

- Address Type
- Country
- Building / House No.
- Postcode
- Building / House Name
- City
- Region
- Street Address
- Correspondence Address synchronization
- same-as-residential toggles
- correspondence address
- location administrative classification
- administrative area details

### Section 11: Emergency Contact / Next of Kin Details

Preserve all emergency and next-of-kin fields.

Examples:

- Emergency Contact Name
- Relationship to Client
- Emergency Contact Number
- Emergency Contact Email

### Section 12: Documentation Verification Status

Preserve all document verification fields and protocol notes.

Examples:

- Documentation Verification Complete
- Document Type
- Document Status
- Verification / Review Status
- Attach scanned copy
- Document retained reference notes
- Internal remarks and still issues
- Missing, unknown, or pending reason

### Section 13: Internal Notes and Intake Notes

Preserve all internal note-taking fields.

Examples:

- Internal Remarks
- Intake Notes
- Duplicate Decision / Review Notes
- missing, unknown, or pending instructions
- operational comments

## Required Versus Optional Visual System

Mandatory fields must become visually clearer.

### Required Field Representation

Every existing mandatory field should show:

- original label
- asterisk
- Required badge
- inline validation message area
- optional help icon explaining why the field is required

### Optional Field Representation

Optional fields should keep original label and normal input state.

### Compliance-Sensitive Field Representation

Compliance-sensitive fields should have additional context badges where useful:

- Required for Verification
- Required for Contact Routing
- Required for Document Review
- Required for Service Location
- Required for Matter Intake Protocol

These badges are visual only and must not change requirements.

## Validation UX

### Field-Level Validation

Use inline messages below the affected field.

Examples:

- Full Name is required.
- Date of Birth must use dd/mm/yyyy.
- Document verification pending reason is required when verification is not completed.
- Primary phone or approved contact method is required under current protocol.

### Section-Level Validation

Each section card should show:

- Complete
- Incomplete
- Review Required
- Error count

### Global Validation Summary

Sticky summary rail should show:

- total mandatory fields completed
- total mandatory fields remaining
- blocking sections
- compliance review alerts

## Accessibility Requirements

The redesigned page must target WCAG 2.1 AA.

Required behaviours:

- semantic section headings
- logical heading order
- label/input association
- accessible field descriptions
- ARIA-expanded for collapsible sections
- ARIA-controls for section toggles
- aria-live region for validation summary
- keyboard navigation across all fields and buttons
- visible focus indicators
- no information conveyed by colour alone
- contrast-safe badges and error states
- screen-reader friendly required markers
- tooltip content accessible by keyboard
- minimum practical tap target size

## Progressive Disclosure Rules

Progressive disclosure is allowed only if it does not weaken requirements.

Rules:

- all sections remain visible in the navigation
- collapsed sections show completion/error status
- required conditional fields appear when their condition is triggered
- hidden conditional fields are still enforced when applicable
- the review screen lists unresolved conditional requirements
- no required field is removed from the data contract

## Sticky Right Summary Rail

Desktop rail should include:

- Profile completion percentage
- Required fields remaining
- Blocking sections
- Duplicate search confirmation status
- Documentation verification status
- Draft status
- Section jump links
- Compliance reminders

## Sticky Bottom Action Bar

Actions:

- Save Draft
- Clear Draft
- Reset Client Intake
- Back to Search
- Continue to Review

The action bar must preserve existing save/reset behaviour.

## Pre-Submission Summary Screen

Add a Review & Confirm screen before final profile creation.

The screen should show:

### Identity Summary

- main identity fields
- client type
- ID/document summary

### Contact Summary

- email
- phone
- WhatsApp
- communication preferences

### Address Summary

- residential/correspondence/service address details

### Matter and Intake Summary

- client role
- origin
- source
- duplicate decision notes

### Compliance Summary

- document verification status
- pending reasons
- special handling flags
- required-field completion

### Final Protocol Confirmation

The final confirmation must not replace validation.

It only confirms that the user reviewed the data under the existing intake protocol.

## Zero-Regression Field Registry Requirement

Before any code refactor, create a machine-readable or table-based registry mapping:

- original section
- original field label
- internal key if visible
- required or optional
- default value
- validation behaviour
- conditional trigger
- new section
- new visual component
- preservation status

No modernization patch is complete until this registry is created and reviewed.

## Implementation Recommendation

Do not rewrite the whole Clients.jsx form in one pass.

Use small layers:

### Z3-B: Field Registry Extraction

Documentation/control first.

### Z3-C: Section Card Shell Patch

Code patch.

- add visual wrappers
- no field logic changes
- no field deletion

### Z3-D: Sticky Summary Rail Blueprint

Documentation first.

### Z3-E: Sticky Summary Rail Patch

Code patch.

- visual summary only
- no validation logic replacement

### Z3-F: Pre-Submission Review Blueprint

Documentation first.

### Z3-G: Pre-Submission Review Patch

Code patch only after full regression review.

## Acceptance Criteria For Future Code Patch

A code patch must pass:

- Clients page opens
- full original client form remains visible
- original directory remains visible
- original required fields remain required
- existing validation still blocks invalid submission
- save/reset/draft actions still work
- local fallback warning remains
- backend check warning remains
- Matter Intake bridge remains
- Return to Matter Intake works
- no original fields intentionally removed
- no white screen
- no browser console red runtime error
- production build passes

## GitHub Review Decision

GitHub review is not needed before this blueprint commit.

Recommended GitHub review timing:

- after Z3-B field registry is committed
- before the first code refactor of Clients.jsx
- or after the first code patch passes local build and browser QA

## Status

Phase 13E.4Z-Z3-A: READY FOR VERIFICATION AND COMMIT


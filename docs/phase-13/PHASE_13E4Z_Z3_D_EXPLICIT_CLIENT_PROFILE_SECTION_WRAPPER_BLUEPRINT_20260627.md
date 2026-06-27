# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z3-D Explicit Client Profile Section Wrapper Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z3-D: EXPLICIT SECTION WRAPPER BLUEPRINT

## Objective

Prepare the next safe modernization layer for the full Clients profile page by defining explicit professional section wrappers around the existing Clients.jsx form sections.

This phase is documentation/control only.

No Clients.jsx code is changed in this phase.

## Final Outcome Standard

The final Clients profile creation experience must be:

- highly professional
- visually uniform
- cognitively clear
- accessible
- responsive
- compliance-preserving
- benchmark-aligned with modern SaaS, legal-tech, gov-tech, CRM, banking, insurance, healthcare intake, and professional-services workflow systems

## Non-Negotiable Preservation Rule

The existing Clients.jsx full profile process remains authoritative.

Future wrapper implementation must not remove, relax, bypass, rename unsafely, or alter:

- mandatory fields
- required indicators
- validation rules
- data binding
- state management
- save/reset/draft behaviour
- backend/API compatibility
- local fallback behaviour
- client table/directory logic
- manual selection logic
- documentation verification process
- duplicate review process
- compliance notes
- operational warnings
- Matter Intake bridge
- Return to Matter Intake action

## Current Phase Context

Previous completed layers:

- Z3-A created the full profile modernization preservation blueprint
- Z3-B extracted a full client profile field registry
- Z3-C created a source/design audit gate
- Z3-C2 applied a CSS-first section card shell and browser QA passed

Current limitation:

The Clients page is visually improved but still relies mostly on broad CSS styling. The next improvement should introduce explicit JSX section wrappers only where anchors are safe.

## Design Principles

### Preserve Contract, Modernize Presentation

All original fields remain present and bound to the same logic.

The wrapper only changes structure and readability.

### Progressive Disclosure Without Concealment

The page may become visually grouped, but required information cannot disappear.

Grouped sections must still show:

- section title
- completion state
- required-field blockers
- warning state if applicable

### Professional Enterprise Visual Language

Use:

- clean white section cards
- consistent border radius
- soft shadows
- calm neutral background
- teal/green workflow accents
- amber warning states
- red validation states
- clear typography hierarchy
- generous spacing between cards
- compact spacing inside related field groups

### Accessibility First

Each wrapper must support:

- semantic headings
- keyboard navigation
- visible focus state
- screen-reader friendly section labels
- no colour-only indicators
- readable contrast
- responsive behaviour
- stable tab order

## Proposed Wrapper Architecture

Future code patch should use a scoped class family:

- client-profile-modern-shell
- client-profile-card
- client-profile-card-header
- client-profile-card-kicker
- client-profile-card-title
- client-profile-card-body
- client-profile-card-status
- client-profile-card-help
- client-profile-card-warning
- client-profile-form-grid
- client-profile-action-bar

Avoid broad generic names such as:

- card
- section
- panel
- box
- container

## Section Wrapper Map

Future wrappers should preserve and visually group these existing full Clients profile sections:

1. Client Profile Details
2. Client Identification Details
3. Employment Details
4. Family and Marital Details
5. Matter Context and Case Origin
6. Client Source and Value Indicators
7. Will / Estate Handling Metadata
8. Health / OKU / Disability and Accommodation Metadata
9. Contact Information and Communication Preferences
10. Address and Service Location Details
11. Emergency Contact / Next of Kin Details
12. Documentation Verification Status
13. Internal Remarks / Pending Information

## Implementation Strategy For Next Code Phase

Proceed later to:

Phase 13E.4Z-Z3-E — Explicit Client Profile Section Wrapper Patch

Strict scope:

- frontend/src/pages/Clients.jsx
- frontend/src/App.css
- docs/phase-13
- docs/qa/phase-13

Implementation rules:

- add wrappers only around confirmed sections
- do not move individual fields across sections
- do not delete any field
- do not alter input names/values/handlers
- do not alter validation
- do not alter backend/API logic
- do not alter localStorage/draft logic
- do not alter save/reset behaviour
- do not alter Matter Intake bridge

## QA Required After Future Patch

- Clients page opens
- all profile sections still visible
- all original fields remain visible
- all save/reset/create actions remain visible
- backend warning remains visible
- local fallback warning remains visible
- Return to Matter Intake works
- field values can still be typed
- dropdowns still open
- date/ID/document fields remain present
- no white screen
- no browser console red runtime error
- production build passes

## Deprecations

None in this phase.

## Migration Notes

The CSS-first shell from Z3-C2 remains active.

The future explicit wrapper patch should reduce reliance on broad CSS selectors by giving confirmed sections stable scoped wrapper classes.

## Status

Phase 13E.4Z-Z3-D: READY FOR VERIFICATION AND COMMIT

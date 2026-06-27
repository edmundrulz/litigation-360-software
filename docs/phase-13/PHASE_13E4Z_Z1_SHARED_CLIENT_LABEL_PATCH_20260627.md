# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z1 Shared Client Label Patch

Date: 2026-06-27

## Objective

Apply the first conservative shared-vocabulary code patch between Matter Intake and Clients.

## Scope

This phase standardizes visible labels only.

It does not merge components.
It does not rewrite Clients.jsx.
It does not remove original Clients fields.
It does not remove validation.
It does not alter backend, database, auth, RBAC, API routes, server logic, or package files.

## Implemented

### MatterIntakeWizard.jsx

- Aligns client search heading language
- Keeps Advanced Client Directory / Manual Management wording
- Keeps Continue to Case / Matter Details wording
- Adds a small shared-vocabulary helper note

### Clients.jsx

- Aligns selected visible labels with Matter Intake vocabulary
- Renames visible directory language to Advanced Client Directory / Manual Management where safe
- Renames visible profile heading to Client Registration / Full Client Profile where safe
- Renames visible search action language to Search Existing Client where safe
- Preserves original Clients manual workflow and field depth

### App.css

- Adds a small accessibility/safety class for the inserted hidden heading

## Preserved

- Original Clients.jsx form
- Original Clients.jsx fields
- Original Clients.jsx directory/table behaviour
- Original Clients.jsx validation logic
- Original Clients.jsx draft behaviour
- Original Clients.jsx local fallback behaviour
- Original Clients.jsx save/reset/edit protocols
- Matter Intake conveyor flow
- Advanced/manual bridge and return path

## Expected Behaviour

Matter Intake and Clients should now use more consistent client workflow vocabulary while still remaining two controlled modes:

1. Matter Intake Conveyor Mode
2. Advanced Manual Client Management Mode

## Required QA

- Matter Intake opens
- Matter Intake client search heading remains readable
- Matter Intake Continue to Case / Matter Details still works
- Advanced Client Directory / Manual Management still opens Clients
- Clients page still opens
- Clients page bridge panel remains visible
- Return to Matter Intake still works
- Original Clients form still appears
- Original Clients directory/table still appears
- No fields are visually removed
- No white screen
- No browser console red runtime error
- Production build passes

## Status

Phase 13E.4Z-Z1: READY FOR BUILD VERIFICATION


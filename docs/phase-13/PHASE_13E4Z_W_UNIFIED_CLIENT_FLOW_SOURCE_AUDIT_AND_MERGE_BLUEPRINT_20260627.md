# Litigation 360 / LEOS 360
# Phase 13E.4Z-W Unified Client Flow Source Audit & Merge Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-W: SOURCE AUDIT AND MERGE BLUEPRINT

## Objective

Merge the duplicated client-related page flows into one coherent system.

Current issue:

- Matter Intake has a conveyor-style client search and editable intake workflow.
- Clients has the original/manual client directory and large client profile form.
- The two flows look and behave differently.
- Main page selections can lead users into different client experiences.
- Search, create, edit, and profile management are not visually or logically unified.

## Existing Flow A: Matter Intake Conveyor

Source file:

- frontend/src/pages/MatterIntakeWizard.jsx

Current purpose:

- Search existing client
- Detect possible duplicate
- Create new client from search
- Paste from email/document
- Edit key client intake fields
- Continue to Case / Matter Details inside Matter Intake

Current route/module trigger:

- App.jsx module: Matter Intake
- Workspace branch renders MatterIntakeWizard

Current layout:

- Client Search & Duplicate Check
- Paste From Email / Document
- Creation Decision
- Editable Client Profile
- Step conveyor: Client Details, Case / Matter Details, Deadline Details, Document Details, Review, Review / Save & Submit

Current strength:

- Good conveyor process
- Better visual layout
- Search-first logic
- No-results-to-create-client flow
- Keeps intake inside one workflow

Current weakness:

- It is not connected to the full original Clients directory/profile system.
- It uses frontend sample records.
- It does not yet reuse the full original client profile fields from Clients.jsx.
- It can still open the standalone Clients module as a separate experience.

## Existing Flow B: Original / Manual Clients Module

Source file:

- frontend/src/pages/Clients.jsx

Current purpose:

- Client database / directory
- Client registration / client profile
- Manual client selection
- Search/filter client list
- Large detailed client form
- Add/create client profile
- Locally saved clients fallback when backend unavailable

Current route/module trigger:

- App.jsx module: Clients
- Workspace branch renders Clients

Current layout:

- Client Registration / Client Profile
- Client Directory / Index
- Search By
- Search Clients
- Manual Client Selection
- Category / Tag
- Alphabet index
- Client table
- Large manual profile form

Current strength:

- More complete client profile field coverage
- Has original manual management behaviour
- Supports deeper profile metadata

Current weakness:

- Layout is visually older and less polished than Matter Intake.
- It feels disconnected from the Matter Intake conveyor.
- It repeats search/client-selection concepts already present in Matter Intake.
- It does not clearly receive or preserve Matter Intake context.
- It can appear as a separate system rather than part of one user journey.

## Main Page Trigger Problem

The application currently exposes both concepts as separate module choices:

- Matter Intake
- Clients

This causes two different user expectations:

1. Matter Intake user expects conveyor workflow.
2. Clients user expects manual directory/profile management.

Both are valid, but they need one shared client selection/profile system.

## Intended Final Behaviour

Final decision:

All client creation and client selection should use one unified client flow.

Recommended structure:

### Primary flow

Matter Intake should be the default conveyor for opening a new matter.

Sequence:

1. Search client
2. Review match / no match
3. Load existing client or create new client
4. Edit client profile fields
5. Confirm selected/new client
6. Continue to Case / Matter Details

### Manual/original flow

The original Clients module should remain available as Advanced Client Directory / Manual Profile Management.

It should be explicitly marked as:

- advanced
- standalone
- database management
- not the automatic next step in Matter Intake

### Shared behaviour

Both paths should share:

- same search vocabulary
- same client identifiers
- same duplicate logic
- same selected-client summary
- same visual design system
- same profile field grouping
- same action labels

## Final Unified Route Logic

Recommended App.jsx routing:

- Matter Intake opens the unified conveyor client intake workflow.
- Clients opens the unified client management shell.
- The client management shell should visually reuse the same search/profile components.
- Open Full Clients Directory from Matter Intake should open Clients intentionally, with context preserved or clearly separated.

## Required Merge Plan

### Phase 13E.4Z-X

Unify client-flow triggers and context rules.

Tasks:

- Audit App.jsx module triggers.
- Confirm every button that opens Matter Intake or Clients.
- Prevent automatic jump from Matter Intake to Clients.
- Ensure explicit Clients opening is labelled Advanced Client Directory.
- Add breadcrumb or context text when moving between Matter Intake and Clients.

### Phase 13E.4Z-Y

Create shared client search/profile UI pattern.

Tasks:

- Standardize search labels between MatterIntakeWizard.jsx and Clients.jsx.
- Use the same field names.
- Use the same no-result language.
- Use the same duplicate warning language.
- Use the same Create New Client Profile From Search concept.
- Preserve the original Clients.jsx full field depth, but visually align it with the polished Matter Intake layout.

### Phase 13E.4Z-Z

Full merge or component extraction.

Future task only.

Potential approach:

- Extract shared ClientSearchPanel component.
- Extract shared ClientProfileForm component.
- Use these in both MatterIntakeWizard.jsx and Clients.jsx.
- Keep advanced Clients directory separate but visually consistent.

Do not attempt full component extraction in the current phase unless explicitly approved.

## Immediate Next Recommended Implementation

Proceed next to:

Phase 13E.4Z-X Unified Client Flow Trigger Patch

Minimum safe change:

- Rename the Matter Intake secondary button from Open Full Clients Directory to Advanced Client Directory / Manual Management.
- Add clear text explaining that this leaves the conveyor workflow.
- Add a return path from Clients back to Matter Intake if possible.
- Standardize labels so Users understand:
  - Matter Intake = conveyor process
  - Clients = advanced/manual directory
- Do not replace the huge Clients.jsx file yet.
- Do not attempt backend/database/RBAC changes.

## Safety Scope

Documentation/source audit only.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Status

Phase 13E.4Z-W: READY FOR COMMIT


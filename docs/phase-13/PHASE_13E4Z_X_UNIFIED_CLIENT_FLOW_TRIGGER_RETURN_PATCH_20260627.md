# Litigation 360 / LEOS 360
# Phase 13E.4Z-X Unified Client Flow Trigger & Return Path Patch

Date: 2026-06-27

## Objective

Create the first safe code connection between the Matter Intake conveyor workflow and the original Clients manual management workflow.

## Conservative Merge Rule

This phase does not replace or rewrite the original Clients module.

The original Clients.jsx process remains preserved, including:

- client directory
- search/filter/manual selection
- full client profile form
- detailed fields
- validation behaviour
- draft behaviour
- local saved clients fallback
- original client management protocol depth

## Problem

The application had two client-related flows:

1. Matter Intake conveyor workflow
2. Original Clients manual directory/profile workflow

They were improved separately, but not yet clearly connected.

## Implemented

### App.jsx

- Passes setModule into Clients
- Confirms Matter Intake does not auto-next into Clients through the generic module frame

### MatterIntakeWizard.jsx

- Renamed Open Full Clients Directory to Advanced Client Directory / Manual Management
- Added helper text explaining that the action opens the full manual Clients workspace and that the guided conveyor remains separate

### Clients.jsx

- Accepts optional setModule prop
- Adds a non-destructive bridge panel near the top of the Clients page
- Adds Return to Matter Intake action
- Does not remove any original Clients logic, fields, validations, or protocols

### App.css

- Adds small bridge-panel styling only

## Final Behaviour For This Phase

Matter Intake:

- remains the guided conveyor process
- continues internally to Case / Matter Details
- only opens Clients through an explicit advanced/manual action

Clients:

- remains the full manual directory/profile management workspace
- now clearly identifies itself as Advanced Client Directory / Manual Management
- provides Return to Matter Intake

## Safety Scope

Frontend-only trigger and return path patch.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required Browser QA

- Matter Intake opens
- Matter Intake shows Advanced Client Directory / Manual Management
- Helper text explains that it opens the full manual Clients workspace
- Continue to Case / Matter Details stays inside Matter Intake
- Advanced Client Directory / Manual Management opens Clients intentionally
- Clients page shows Advanced Client Directory / Manual Management bridge panel
- Clients page shows Return to Matter Intake
- Return to Matter Intake returns to Matter Intake
- Original Clients directory remains visible
- Original Clients form remains visible
- No original Clients fields are removed
- No blank page
- No white screen
- Browser console has no red runtime error
- Production build passes

## Status

Phase 13E.4Z-X: READY FOR BUILD VERIFICATION


# Phase 15A-F09A Refactor Approval Checkpoint

Project:
Litigation 360 / LEOS 360

Branch:
docs/15a-f09a-refactor-approval-checkpoint

Base branch:
docs/14f-navigation-placeholder-plan

Base HEAD verified:
800ca8c5980c381f1d74c13ffe78bf610db585e0

Base HEAD summary:
merge: add phase 15a f09 backend service refactor planning

Date:
2026-07-09

## Purpose

This document records the Phase 15A-F09A approval checkpoint before any backend service refactor implementation.

F09A is approval checkpoint only.

No backend source code is changed by this checkpoint document.

No Codex-generated implementation is included in this checkpoint.

## Current Verified Baseline

The following baseline has been verified from the F09A branch:

- Branch: docs/15a-f09a-refactor-approval-checkpoint
- HEAD: 800ca8c
- F09 planning document present
- Legal Control Desk service file present
- F08A route contract test file present
- F08B service contract test file present

## F09 Planning Constraints Confirmed

The F09 planning document confirms the following non-negotiable constraints:

- No frontend change.
- No visual change.
- No API route contract change.
- No public service function name change.
- No response shape change.
- Existing backend contract tests must continue to pass.
- F09A remains approval-only unless a specific one-file or two-file source movement is explicitly approved.

## Service Export Boundary Confirmed

The Legal Control Desk service public export boundary remains:

- CONTROL_DESK_VERSION
- getLegalControlDeskHealth
- getLegalControlDeskSummary
- getLegalControlDeskWorkQueue
- getLegalControlDeskRiskSnapshot
- getLegalControlDeskActionPlan
- getLegalControlDeskDeadlineControl
- getLegalControlDeskDataQuality
- getLegalControlDeskMatterControl
- getLegalControlDeskClientControl
- getLegalControlDeskExecutiveBrief
- getLegalControlDeskPriorityMatrix
- getLegalControlDeskReadinessScore

Any future refactor implementation must preserve these names and their public response contracts.

## F09A Regression Verification

Route contract regression target:

- backend/src/routes/legalControlDesk.contract.test.js

Route contract result:

- PASS src/routes/legalControlDesk.contract.test.js
- Tests: 12 passed, 12 total
- Test Suites: 1 passed, 1 total

Service contract regression target:

- backend/src/services/legalControlDeskService.contract.test.js

Service contract result:

- PASS src/services/legalControlDeskService.contract.test.js
- Tests: 13 passed, 13 total
- Test Suites: 1 passed, 1 total

Combined F09A verification result:

- Route contract tests: 12 passed
- Service contract tests: 13 passed
- Combined total: 25 passed
- Combined suites: 2 passed

## Codex Availability Boundary

Codex is available for future use.

However, Codex is not authorized to perform implementation in F09A.

Any Codex use must be separately approved with:

- Exact branch.
- Exact files.
- Exact prompt or task.
- Exact expected output.
- Exact verification command.
- No broad refactor instruction.
- No multi-file uncontrolled edit.
- No frontend or visual file access unless separately approved.

## Implementation Not Approved In F09A

The following are not approved in this checkpoint:

- No source code movement.
- No helper extraction.
- No snapshot extraction.
- No builder extraction.
- No route edits.
- No service logic edits.
- No database edits.
- No frontend edits.
- No package edits.
- No CI edits.
- No Codex execution.

## Future Approval Candidates

Potential future implementation gates may include:

F09B:
Extract pure helper utilities only.

F09C:
Extract SQLite snapshot reading only.

F09D:
Extract aggregation builders only.

F09E:
Keep legalControlDeskService.js as the public facade only.

Each future gate must be approved separately.

## Required Future Verification

Before any future source refactor commit, the following must pass:

- npx jest src/routes/legalControlDesk.contract.test.js --runInBand --detectOpenHandles
- npx jest src/services/legalControlDeskService.contract.test.js --runInBand --detectOpenHandles

Expected minimum result:

- 25 backend contract tests passed.
- Protected frontend diff check clean.
- Committed files match approved scope only.

## Protected Frontend Boundary

The following files remain protected and untouched:

- frontend/src/App.jsx
- frontend/src/App.css
- frontend/src/components/MenuPlatform.jsx
- frontend/src/components/MenuPlatform.css

## F09A Checkpoint Status

PHASE 15A-F09A:
REFACTOR APPROVAL CHECKPOINT ONLY

Status:
APPROVAL CHECKPOINT / NO SOURCE CODE CHANGES / NO CODEX EXECUTION / NO FRONTEND CHANGES

## Next Recommended Gate

After this checkpoint document is committed, merged, tagged, and checkpointed, the next safe milestone is:

Phase 15A-F09B:
Pure utility extraction approval only.

F09B must not begin implementation until the exact files and exact movement are approved.

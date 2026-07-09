# Phase 15A-F09 Backend Service Refactor Planning

Project:
Litigation 360 / LEOS 360

Branch:
docs/15a-f09-backend-service-refactor-planning

Base branch:
docs/14f-navigation-placeholder-plan

Base HEAD verified:
dc33b6c2fc5a9ce5de861794c228378904b068e5

Base HEAD summary:
merge: add phase 15a f08c regression verification control note

Date:
2026-07-09

## Purpose

This document defines the Phase 15A-F09 backend service refactor plan for the Legal Control Desk service layer.

F09 is planning only.

No backend source code is changed by this planning document.

## Current Verified Baseline

The current baseline includes:

- F08 documentation and integration planning.
- F08A Legal Control Desk route contract tests.
- F08B Legal Control Desk service contract tests.
- F08C combined regression verification control note.

The current backend contract verification remains stable.

Route contract regression result:

- PASS src/routes/legalControlDesk.contract.test.js
- Tests: 12 passed, 12 total
- Test Suites: 1 passed, 1 total

Service contract regression result:

- PASS src/services/legalControlDeskService.contract.test.js
- Tests: 13 passed, 13 total
- Test Suites: 1 passed, 1 total

Combined result:

- 25 backend contract tests passed
- 2 backend contract test suites passed

## Current Service Structure Observed

The Legal Control Desk service currently combines the following responsibilities in one service file:

- Version and configuration constants.
- Date and status utility helpers.
- Deadline status classification.
- SQLite snapshot reading.
- Work queue aggregation.
- Deadline control aggregation.
- Risk snapshot aggregation.
- Data quality aggregation.
- Matter control aggregation.
- Client control aggregation.
- Readiness score calculation.
- Priority matrix construction.
- Executive brief construction.
- Action plan construction.
- Overall aggregation orchestration.
- Public service response functions.
- Module exports.

## Refactor Problem Statement

The service is functional and tested, but the file is carrying multiple independent responsibilities.

The refactor objective is not to change behavior.

The refactor objective is to improve maintainability, separation of concerns, and future testability while preserving the existing public service contract.

## Non-Negotiable Refactor Constraints

Any future F09 implementation must obey these constraints:

- No frontend change.
- No visual change.
- No MenuPlatform change.
- No CSS or layout change.
- No API route contract change.
- No public service function name change.
- No CONTROL_DESK_VERSION change.
- No response shape change.
- No database schema change.
- No package file change unless separately approved.
- No CI configuration change unless separately approved.
- Existing F08A and F08B tests must continue to pass before and after each implementation step.

## Proposed Future File Boundaries

This is a planning proposal only.

Potential future split:

1. legalControlDeskService.js

Purpose:
Keep public exported service functions and orchestration only.

Potential contents:
- CONTROL_DESK_VERSION export.
- getLegalControlDeskHealth.
- getLegalControlDeskSummary.
- getLegalControlDeskWorkQueue.
- getLegalControlDeskRiskSnapshot.
- getLegalControlDeskActionPlan.
- getLegalControlDeskDeadlineControl.
- getLegalControlDeskDataQuality.
- getLegalControlDeskMatterControl.
- getLegalControlDeskClientControl.
- getLegalControlDeskExecutiveBrief.
- getLegalControlDeskPriorityMatrix.
- getLegalControlDeskReadinessScore.

2. legalControlDeskSnapshot.js

Purpose:
Own read-only SQLite snapshot access.

Potential contents:
- readSqliteSnapshot.

3. legalControlDeskUtils.js

Purpose:
Own pure helper utilities.

Potential contents:
- getGeneratedAt.
- toDateOnly.
- addDays.
- normaliseStatus.
- isClosedMatter.
- isDeadlineComplete.
- getDeadlineStatus.

4. legalControlDeskBuilders.js

Purpose:
Own aggregation builders.

Potential contents:
- buildWorkQueue.
- buildDeadlineControl.
- buildRiskSnapshot.
- buildDataQuality.
- buildMatterControl.
- buildClientControl.
- buildActionPlan.
- buildReadinessScore.
- buildPriorityMatrix.
- buildExecutiveBrief.
- buildAggregation.

Alternative future split may separate builders further into deadline, matter, client, readiness, priority, and executive brief modules. That should only be done if the smaller split is too large after first implementation.

## Recommended Future Implementation Sequence

F09A:
Documentation-only implementation plan finalization.

F09B:
Extract pure utility helpers into a new backend utility module.

F09C:
Extract SQLite snapshot reading into a dedicated snapshot module.

F09D:
Extract aggregation builder functions into a dedicated builder module.

F09E:
Keep legalControlDeskService.js as the public facade and orchestration layer.

F09F:
Run full route and service contract regression.

Each future implementation should be its own small branch, one purpose at a time.

## Required Verification Gate For Any Future Code Refactor

Before any future source refactor commit:

- Run route contract tests.
- Run service contract tests.
- Confirm 25 tests pass.
- Confirm protected frontend diff is empty.
- Confirm committed files match the approved scope only.

Minimum required commands for future verification:

- npx jest src/routes/legalControlDesk.contract.test.js --runInBand --detectOpenHandles
- npx jest src/services/legalControlDeskService.contract.test.js --runInBand --detectOpenHandles

Expected result:

- Route contract tests: 12 passed.
- Service contract tests: 13 passed.
- Combined tests: 25 passed.

## Risk Assessment

Primary risk:
Moving helper functions incorrectly may alter aggregation behavior.

Mitigation:
Move one responsibility group at a time and rerun F08A plus F08B contract tests after each step.

Secondary risk:
Changing module exports may break routes or tests.

Mitigation:
Keep legalControlDeskService.js public exports unchanged.

Third risk:
Accidental frontend or visual edits.

Mitigation:
Every future implementation must include protected frontend diff checks for:

- frontend/src/App.jsx
- frontend/src/App.css
- frontend/src/components/MenuPlatform.jsx
- frontend/src/components/MenuPlatform.css

## F09 Planning Status

PHASE 15A-F09:
BACKEND SERVICE REFACTOR PLANNING ONLY

Status:
PLANNED / NO SOURCE CODE CHANGES / NO FRONTEND CHANGES

## Next Recommended Gate

After this planning document is committed, merged, tagged, and checkpointed, the next safe step is:

Phase 15A-F09A:
Refactor implementation approval checkpoint.

F09A should still be approval-only unless a specific one-file or two-file source movement is explicitly approved.

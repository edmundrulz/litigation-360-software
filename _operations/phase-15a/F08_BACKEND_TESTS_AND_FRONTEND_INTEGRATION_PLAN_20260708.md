# PHASE 15A-F08 BACKEND TESTS AND FRONTEND INTEGRATION PLAN

Project:
LEOS 360 / Litigation 360

Date:
2026-07-08

Branch:
test/15a-f08-contract-tests-frontend-plan

Base branch:
docs/14f-navigation-placeholder-plan

Base HEAD:
cf31e84 merge: add phase 15a backend contract audit report

---

## 1. Purpose

This document defines the Phase 15A-F08 combined milestone.

F08 combines two safe next steps:

1. Backend Legal Control Desk endpoint contract test planning.
2. Frontend integration planning only.

This milestone does not approve frontend implementation, visual edits, CSS edits, backend refactoring, or database schema changes.

---

## 2. Current Safe Base

The current safe base branch is:

docs/14f-navigation-placeholder-plan

The current known merged HEAD is:

cf31e84 merge: add phase 15a backend contract audit report

Phase 15A F01-F07 is complete, merged, audited, and checkpointed.

The Phase 15A backend Legal Control Desk stack is treated as stable.

---

## 3. Protected Visual Baseline

The protected visual baseline remains locked.

Protected visual baseline commit:

4fdf874 Merge pull request #7 from edmundrulz/fix/14f-menu-exit-label-visibility

Protected tags:

checkpoint/phase-14f-menu-label-visibility-merged-20260707
lock/visual-baseline-do-not-touch-20260708

Do not touch without separate explicit approval:

frontend/src/App.jsx
frontend/src/App.css
frontend/src/components/MenuPlatform.jsx
frontend/src/components/MenuPlatform.css
App Menu
Sidebar
frontend visual shell
layout
appearance
CSS
MenuPlatform
any visual or UI styling

F08 does not approve frontend source changes.

---

## 4. Confirmed Backend API Contract

The Legal Control Desk route is registered in:

backend/src/index.js

Route base:

app.use("/api/legal-control-desk", require("./routes/legalControlDesk"));

Confirmed read-only endpoints:

GET /api/legal-control-desk/health
GET /api/legal-control-desk/summary
GET /api/legal-control-desk/work-queue
GET /api/legal-control-desk/risk-snapshot
GET /api/legal-control-desk/action-plan
GET /api/legal-control-desk/deadline-control
GET /api/legal-control-desk/data-quality
GET /api/legal-control-desk/matter-control
GET /api/legal-control-desk/client-control
GET /api/legal-control-desk/executive-brief
GET /api/legal-control-desk/priority-matrix
GET /api/legal-control-desk/readiness-score

Total confirmed routes:

12

Confirmed module version:

CONTROL_DESK_VERSION: 15A-F06

Confirmed mode:

read-only-executive-brief-matrix

Confirmed data source mode:

sqlite-live

Confirmed database:

better-sqlite3

---

## 5. Test Framework Discovery Result

Existing test framework:

Jest

Existing request testing library:

Supertest

Root package.json confirms:

"test": "jest --runInBand"

Root devDependencies confirm:

jest: ^30.4.2
supertest: ^7.2.2

backend/package.json confirms:

"test": "jest"
"test:watch": "jest --watch"
"test:coverage": "jest --coverage"

backend devDependencies confirm:

jest: ^29.5.0
supertest: ^6.3.3

Conclusion:

F08 should use the existing Jest + Supertest stack.

No new test framework is required.

---

## 6. Existing Backend Test Pattern Observed

Existing backend test-style files already exist under:

backend/enterprise

Examples discovered:

backend/enterprise/audit/test-audit-engine.js
backend/enterprise/automation-bus/test-automation-bus.js
backend/enterprise/automation-consumer/test-consumer-engine.js
backend/enterprise/automation-dashboard/test-dashboard.js
backend/enterprise/automation-handlers/test-client-created-handler.js
backend/enterprise/dead-letter-queue/test-dead-letter-engine.js
backend/enterprise/event-catalog/test-event-catalog.js
backend/enterprise/hardening/startup-validator/test-startup-validator.js
backend/enterprise/monitoring/test-health-monitor.js
backend/enterprise/notification-hub/test-notification-hub.js
backend/enterprise/reliability/test-reliability-engine.js
backend/enterprise/retry-engine/test-retry-engine.js

This confirms the project already uses test-style JavaScript files.

F08 should follow the existing JavaScript/Jest style and avoid introducing a new structure unless separately approved.

---

## 7. Recommended Backend Test Scope

Recommended F08 backend test scope:

Legal Control Desk endpoint contract tests only.

Recommended test type:

Read-only endpoint contract tests using Jest + Supertest.

Recommended target:

backend/src/index.js

Recommended endpoint group:

/api/legal-control-desk/*

Recommended coverage:

health
summary
work-queue
risk-snapshot
action-plan
deadline-control
data-quality
matter-control
client-control
executive-brief
priority-matrix
readiness-score

---

## 8. Proposed Backend Test File Path

Recommended future test file:

backend/src/routes/legalControlDesk.contract.test.js

Reason:

The test is route/API-contract focused.
It belongs near the backend route layer.
It does not require frontend changes.
It does not require database schema changes.
It can use Supertest against the exported Express app.

No test file is approved yet by this document.

Before creating the test file, the exact full file content must be shown and approved.

---

## 9. Proposed Endpoint Contract Assertions

Each endpoint should confirm:

HTTP status is 200
Response is JSON
Response contains ok: true
Response contains version: 15A-F06 where applicable
Response contains generatedAt where applicable
Response contains the expected top-level contract key

Recommended top-level contract keys:

GET /health             -> module, version, status, mode
GET /summary            -> summary, dataSource, workQueue, riskSnapshot, deadlineControl, dataQuality, matterControl, clientControl, actionPlan, readinessScore, priorityMatrix, executiveBrief
GET /work-queue         -> workQueue
GET /risk-snapshot      -> riskSnapshot
GET /action-plan        -> actionPlan
GET /deadline-control   -> deadlineControl
GET /data-quality       -> dataQuality
GET /matter-control     -> matterControl
GET /client-control     -> clientControl
GET /executive-brief    -> executiveBrief
GET /priority-matrix    -> priorityMatrix
GET /readiness-score    -> readinessScore

The tests should not assert unstable live numeric values too tightly unless those values are intentionally frozen for test purposes.

Avoid brittle assertions against exact counts where SQLite data may change.

---

## 10. Frontend Integration Planning Only

F08 includes frontend planning only.

No frontend implementation is approved.

The future frontend integration should be designed around these principles:

Read-only dashboard connection
No mutation actions
No visual redesign
No MenuPlatform changes
No sidebar changes
No CSS/layout changes
No App shell changes
No protected visual baseline changes

Future frontend integration should consume the 12 backend endpoints only after separate visual/source approval.

---

## 11. Future Frontend Integration Sequence

When frontend implementation is separately approved in a future milestone, the recommended order is:

1. Confirm protected baseline.
2. Create a new frontend-specific branch.
3. Define data adapter only.
4. Add API client functions for the 12 endpoints.
5. Add non-visual contract/data mapping tests if available.
6. Connect to an existing approved placeholder area only.
7. Run visual comparison against baseline.
8. Stop for manual review before any layout or CSS change.

F08 does not execute this sequence.

F08 only documents it.

---

## 12. Risks and Controls

Risk:
Frontend visual regression.

Control:
No frontend files touched in F08.

Risk:
Backend test brittleness due to live SQLite data.

Control:
Assert contract shape, status, version, and key presence instead of exact live counts.

Risk:
Unexpected app startup side effects from requiring backend/src/index.js.

Control:
Use Supertest against the exported Express app only after confirming the server export pattern is compatible.

Risk:
Existing backend server starts during tests.

Control:
If the current app export causes listen/startup side effects, stop and propose a separate backend app/server split only after approval.

Risk:
Backend service file is large.

Control:
Do not refactor in F08. Refactor only after endpoint tests exist and only under a separate approved milestone.

---

## 13. Approval Gate Before Source Edits

F08 documentation may be committed first.

Before any backend test source file is created, the following must be shown and approved:

Exact test file path
Exact full file content
Exact npm command to run
Expected test result
Rollback plan
Files that will be touched
Files that will not be touched

No source edits are approved by default.

---

## 14. Completion Criteria

F08 documentation phase is complete when:

F08 branch exists.
Working tree starts clean.
Protected frontend files remain untouched.
Jest + Supertest discovery is documented.
The 12 Legal Control Desk endpoints are documented.
Frontend integration is documented as planning-only.
No frontend files are edited.
No backend source files are edited.
F08 documentation file is committed.
F08 checkpoint tag is created.
Final handover is produced.

---

## 15. Recommended Next Milestone After Documentation

After this F08 documentation file is committed, the next possible approval gate is:

F08A: Create backend Legal Control Desk endpoint contract test file.

Recommended future file:

backend/src/routes/legalControlDesk.contract.test.js

This should be reviewed separately before creation.

No implementation is approved by this document.

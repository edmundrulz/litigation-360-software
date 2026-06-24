# LITIGATION 360 - PHASE 10F COURT OPERATIONS ENGINE PROTOCOL

## Purpose
Create court operations automation so court dates generate deadlines, reminders, tasks, workflows, and visible notifications.

## Why
Court dates are high-risk legal operation events. The system must not rely on memory or manual follow-up.

## Created Files
- backend\src\automation\courtOperationsEngine.js
- backend\src\routes\courtOperationsRoutes.js
- backend\src\index.js route mount

## Court Event Types
- MENTION
- HEARING
- TRIAL
- CASE_MANAGEMENT
- DECISION
- FILING_DEADLINE
- SUBMISSION
- OTHER

## API Endpoints
- GET /api/enterprise/court-operations/health
- GET /api/enterprise/court-operations/metrics
- GET /api/enterprise/court-operations/event-types
- GET /api/enterprise/court-operations/list
- GET /api/enterprise/court-operations/upcoming
- GET /api/enterprise/court-operations/overdue-deadlines
- GET /api/enterprise/court-operations/tasks
- GET /api/enterprise/court-operations/:id
- POST /api/enterprise/court-operations/create
- POST /api/enterprise/court-operations/:id/start-preparation
- GET /api/enterprise/court-operations/test/court-preparation

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/court-operations/health
- http://localhost:5000/api/enterprise/court-operations/event-types
- http://localhost:5000/api/enterprise/court-operations/test/court-preparation

## Rules
- No deletion.
- Backup before modification.
- Every court date must generate deadlines, reminders, and tasks.
- Every court preparation must be workflow-trackable.
- Overdue deadlines must be visible in health metrics.

# LITIGATION 360 - PHASE 10D WORKFLOW AUTOMATION ENGINE PROTOCOL

## Purpose
Create a workflow engine that tracks legal operational processes from creation to completion.

## Why
The Event Bus moves events. The Notification Framework makes alerts visible. The Workflow Engine turns operations into trackable, step-based processes.

## Created Files
- backend\src\automation\workflowEngine.js
- backend\src\routes\workflowRoutes.js
- backend\src\index.js route mount

## Workflow Templates
- NEW_CLIENT_INTAKE
- MATTER_OPENING
- COURT_DATE_PREPARATION
- DOCUMENT_REVIEW

## API Endpoints
- GET /api/enterprise/workflows/health
- GET /api/enterprise/workflows/metrics
- GET /api/enterprise/workflows/templates
- GET /api/enterprise/workflows/list
- GET /api/enterprise/workflows/:id
- POST /api/enterprise/workflows/create
- POST /api/enterprise/workflows/:id/start
- POST /api/enterprise/workflows/:id/complete-step
- POST /api/enterprise/workflows/:id/fail
- GET /api/enterprise/workflows/test/new-client-intake

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/workflows/health
- http://localhost:5000/api/enterprise/workflows/templates
- http://localhost:5000/api/enterprise/workflows/test/new-client-intake

## Rules
- No deletion.
- Backup before modification.
- Every workflow must have status, steps, history, createdAt, and payload.
- Failed workflows must create critical notifications.
- Workflow health must expose created, started, active, completed, and failed counts.

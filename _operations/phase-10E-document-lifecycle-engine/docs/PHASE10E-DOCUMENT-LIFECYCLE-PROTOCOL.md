# LITIGATION 360 - PHASE 10E DOCUMENT LIFECYCLE ENGINE PROTOCOL

## Purpose
Create document lifecycle governance so uploaded documents are never orphaned, unreviewed, untracked, or silently superseded.

## Why
Documents are a legal-practice risk point. Every document needs matter linkage, state tracking, review history, and audit visibility.

## Created Files
- backend\src\automation\documentLifecycleEngine.js
- backend\src\routes\documentLifecycleRoutes.js
- backend\src\index.js route mount

## Lifecycle States
- UPLOADED
- CLASSIFIED
- ASSIGNED_TO_MATTER
- REVIEW
- APPROVED
- FILED
- ARCHIVED
- SUPERSEDED
- REJECTED

## API Endpoints
- GET /api/enterprise/documents/lifecycle/health
- GET /api/enterprise/documents/lifecycle/metrics
- GET /api/enterprise/documents/lifecycle/states
- GET /api/enterprise/documents/lifecycle/list
- GET /api/enterprise/documents/lifecycle/orphaned
- GET /api/enterprise/documents/lifecycle/:id
- POST /api/enterprise/documents/lifecycle/create
- POST /api/enterprise/documents/lifecycle/:id/classify
- POST /api/enterprise/documents/lifecycle/:id/assign
- POST /api/enterprise/documents/lifecycle/:id/transition
- POST /api/enterprise/documents/lifecycle/:id/start-review
- GET /api/enterprise/documents/lifecycle/test/document-review

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/documents/lifecycle/health
- http://localhost:5000/api/enterprise/documents/lifecycle/states
- http://localhost:5000/api/enterprise/documents/lifecycle/test/document-review

## Rules
- No deletion.
- Backup before modification.
- No document should remain orphaned unless intentionally rejected or archived.
- Invalid state transitions must create critical notifications.
- Review start must create a workflow.

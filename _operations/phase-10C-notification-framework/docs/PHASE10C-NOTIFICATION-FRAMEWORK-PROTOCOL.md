# LITIGATION 360 - PHASE 10C NOTIFICATION FRAMEWORK PROTOCOL

## Purpose
Create a system-wide notification framework for dashboard alerts, warnings, critical notices, court reminders, task alerts, deadline alerts, and system health alerts.

## Why
The Event Bus moves information. The Notification Framework makes important information visible.

## Created Files
- backend\src\automation\notificationService.js
- backend\src\routes\notificationRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/notifications/health
- GET /api/enterprise/notifications/metrics
- GET /api/enterprise/notifications/list
- POST /api/enterprise/notifications/create
- POST /api/enterprise/notifications/:id/read
- GET /api/enterprise/notifications/test
- GET /api/enterprise/notifications/test-critical

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/notifications/health
- http://localhost:5000/api/enterprise/notifications/test
- http://localhost:5000/api/enterprise/notifications/list

## Rules
- No deletion.
- Backup before modification.
- Every notification must have title, message, level, source, createdAt, and read status.
- Critical notifications must be visible in metrics.
- Notification health must expose status, unread count, critical count, and stored notification count.

# LITIGATION 360 - PHASE 10J PREDICTIVE LITIGATION ANALYTICS ENGINE

## Purpose
Create predictive litigation analytics for matter risk, deadline risk, workload risk, and capacity pressure.

## Created Files
- backend\src\automation\predictiveAnalyticsEngine.js
- backend\src\routes\predictiveAnalyticsRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/predictive/health
- GET /api/enterprise/predictive/metrics
- GET /api/enterprise/predictive/dashboard
- GET /api/enterprise/predictive/matter/:matterId
- GET /api/enterprise/predictive/deadlines
- GET /api/enterprise/predictive/workload
- GET /api/enterprise/predictive/capacity
- GET /api/enterprise/predictive/test/dashboard
- GET /api/enterprise/predictive/test/matter

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/predictive/health
- http://localhost:5000/api/enterprise/predictive/dashboard
- http://localhost:5000/api/enterprise/predictive/test/matter

## Rule
This is deterministic predictive analytics. It does not use external AI yet.

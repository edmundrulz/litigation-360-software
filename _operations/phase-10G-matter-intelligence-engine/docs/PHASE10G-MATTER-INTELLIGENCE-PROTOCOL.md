# LITIGATION 360 - PHASE 10G MATTER INTELLIGENCE ENGINE PROTOCOL

## Purpose
Create a Matter Intelligence layer that gives every matter a health score, risk flags, timeline, matter profile, and operational intelligence summary.

## Why
Previous phases created operational systems. Phase 10G gives the system matter-level understanding.

## Created Files
- backend\src\automation\matterIntelligenceEngine.js
- backend\src\routes\matterIntelligenceRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/matters/intelligence/health
- GET /api/enterprise/matters/intelligence/metrics
- GET /api/enterprise/matters/intelligence/summary
- POST /api/enterprise/matters/intelligence/profile
- GET /api/enterprise/matters/intelligence/:matterId
- GET /api/enterprise/matters/intelligence/:matterId/profile
- GET /api/enterprise/matters/intelligence/:matterId/health-score
- GET /api/enterprise/matters/intelligence/:matterId/risk-flags
- GET /api/enterprise/matters/intelligence/:matterId/timeline
- GET /api/enterprise/matters/intelligence/test/matter-brain

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/matters/intelligence/health
- http://localhost:5000/api/enterprise/matters/intelligence/test/matter-brain
- http://localhost:5000/api/enterprise/matters/intelligence/MATTER-PHASE-10G-TEST

## Rules
- No deletion.
- Backup before modification.
- Every matter must have a profile.
- Every matter intelligence response must include health, riskFlags, documents, courtEvents, courtTasks, workflows, and timeline.
- High-risk matters must create critical notifications.

# Litigation 360 Master Operations Handbook

Generated: 2026-06-19T07:28:38.814Z

## System Classification
Litigation 360 is currently structured as a Legal Enterprise Operating System foundation.

## Operating Rule
No deployment, release, migration, or major upgrade should proceed without the Deployment Gatekeeper result.

## Core Operational Layers
- 10A Handler Registry
- 10B Universal Event Bus
- 10C Notification Framework
- 10D Workflow Engine
- 10E Document Lifecycle
- 10F Court Operations
- 10G Matter Intelligence
- 10H Executive Command Centre
- 10I Legal Operations Assistant
- 10J Predictive Analytics
- 10K Court Navigation
- 10L Maps Integration
- 10M Autonomous Operations
- 10N Enterprise Governance
- 10O Enterprise Hardening
- 10P Backup Recovery
- 10Q Enterprise Monitoring
- 10R Performance Optimization
- 10S Frontend Operations Dashboard
- 10T Frontend App Integration
- 10U Frontend Backend Connectivity Validator
- 10V Frontend Smoke Testing
- 10W Frontend Build Validation
- 10X.0 Baseline Audit
- 10X.1 Deployment Readiness Centre
- 10X.2 Environment Validation
- 10X.3 Release Validator
- 10X.3A Enterprise Architecture Registry
- 10X.4 Deployment Scoring Engine
- 10X.5 Executive Deployment Dashboard
- 10X.6 Deployment Gatekeeper

## Critical Operations Coverage
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur â€” Wisma PERKESO / Jalan Tun Razak
- PERKESO Headquarters â€” Jalan Ampang
- Court navigation
- Maps integration
- Backup recovery
- Enterprise monitoring
- Deployment scoring
- Deployment gatekeeper

## Daily Operator Routine
1. Start backend with START-L360-CLEAN.bat.
2. Start frontend with npm run dev inside frontend.
3. Check /api/enterprise/monitoring/health.
4. Check /api/enterprise/scoring/health.
5. Check /api/enterprise/gatekeeper/health.
6. Review blockers and warnings before changes.

## Do Not
- Manually create files in random folders.
- Deploy without gatekeeper approval.
- Delete _operations folders without backup.
- Ignore failed validation reports.

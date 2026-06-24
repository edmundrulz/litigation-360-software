# LITIGATION 360 - PHASE 10S FRONTEND OPERATIONS DASHBOARD

## Purpose
Create reusable frontend files for an enterprise operations dashboard.

## Created Paths
- frontend\src\enterprise\api\enterpriseApi.js
- frontend\src\enterprise\components\EnterpriseStatusCard.jsx
- frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx

## How To Use
Import the page into your existing React router or App.jsx:

import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";

Then render:

<EnterpriseOperationsDashboard />

## Dashboard Refresh
- Auto-refresh every 15 seconds
- Manual refresh button included

## Backend Endpoints Used
- /api/enterprise/monitoring/health
- /api/enterprise/monitoring/dashboard
- /api/enterprise/hardening/deployment/readiness
- /api/enterprise/performance/benchmark
- /api/enterprise/backup-recovery/health
- /api/enterprise/governance/health
- /api/enterprise/autonomous/health
- /api/enterprise/maps/health
- /api/enterprise/navigation/health
- /api/enterprise/predictive/health
- /api/enterprise/assistant/health
- /api/enterprise/command-centre/health

## Special Monitoring
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur
- PERKESO Headquarters Jalan Ampang

@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set HANDBOOK=%ROOT%\docs\MASTER-HANDBOOK
set OPS=%ROOT%\_operations\phase-10M-master-documentation
set REPORTS=%OPS%\reports

mkdir "%HANDBOOK%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1

(
echo # 10 Security Manual
echo.
echo ## Purpose
echo Defines the security baseline for Litigation 360.
echo.
echo ## Security Areas
echo - Authentication
echo - Role-based access control
echo - Audit logging
echo - Data protection
echo - User permissions
echo - Incident response
echo - Backup protection
echo.
echo ## Minimum Security Rule
echo No user should access client, case, matter, document, finance, admin, or system data unless their role permits it.
echo.
echo ## Future Security Enhancements
echo - MFA
echo - Password policy
echo - Session timeout
echo - Login audit
echo - Device audit
echo - Admin approval logs
echo - Security dashboard
) > "%HANDBOOK%\10-SECURITY-MANUAL.md"

(
echo # 11 Deployment Manual
echo.
echo ## Purpose
echo Defines repeatable deployment steps for Litigation 360.
echo.
echo ## Root Path
echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
echo.
echo ## Backend Start
echo cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
echo npm start
echo.
echo ## Frontend Start
echo cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
echo npm run dev
echo.
echo ## Frontend Build
echo cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
echo npm run build
echo.
echo ## Deployment Rule
echo Every deployment requires backup, rollback, build verification, backend health verification, UI testing, and report creation.
) > "%HANDBOOK%\11-DEPLOYMENT-MANUAL.md"

(
echo # 12 Backup and Recovery Manual
echo.
echo ## Purpose
echo Defines how Litigation 360 is protected and restored after failure.
echo.
echo ## Backup Targets
echo - frontend\src\App.jsx
echo - frontend\src\App.css
echo - backend\src\index.js
echo - backend\litigation360.db
echo - docs
echo - scripts
echo - _operations
echo.
echo ## Recovery Rule
echo Do not modify critical files unless a timestamped backup exists.
echo.
echo ## Rollback Rule
echo If build fails, restore the previous working file from _operations phase backups.
echo.
echo ## Disaster Recovery Minimum
echo A recovery point must include application files, database file, documentation, scripts, and latest reports.
) > "%HANDBOOK%\12-BACKUP-RECOVERY-MANUAL.md"

(
echo # 13 Data Governance Manual
echo.
echo ## Purpose
echo Defines how Litigation 360 data should be named, stored, protected, retained, and recovered.
echo.
echo ## Core Data Domains
echo - Clients
echo - Cases
echo - Matters
echo - Court dates
echo - Documents
echo - Staff
echo - Audit logs
echo - Deployment reports
echo - Health reports
echo.
echo ## Data Rules
echo - Client data must be accurate.
echo - Matter data must be linked to the correct client.
echo - Case data must be linked to the correct matter.
echo - Documents must be traceable.
echo - Court dates must be auditable.
echo - Staff roles must be controlled.
echo.
echo ## Future Data Governance
echo - Data dictionary
echo - Entity relationship map
echo - Retention schedule
echo - Archive policy
echo - Deletion policy
echo - Export policy
) > "%HANDBOOK%\13-DATA-GOVERNANCE-MANUAL.md"

(
echo # 14 API Catalog
echo.
echo ## Known Health Endpoints
echo - GET /api/status
echo - GET /api/health
echo - GET /api/enterprise/monitoring/health
echo - GET /api/enterprise/governance/health
echo - GET /api/enterprise/performance/health
echo - GET /api/enterprise/deployment-centre/health
echo - GET /api/enterprise/navigation/health
echo - GET /api/enterprise/backup-recovery/health
echo.
echo ## Backend Base URL
echo http://localhost:5000
echo.
echo ## Frontend Dev URL
echo http://localhost:5173
echo or
echo http://localhost:5174
echo.
echo ## API Rule
echo API endpoints must be documented before being treated as production-ready.
) > "%HANDBOOK%\14-API-CATALOG.md"

(
echo PHASE 10M.3 SECURITY DEPLOYMENT DATA REPORT
echo Date: %date% %time%
echo.
echo Created:
echo 10-SECURITY-MANUAL.md
echo 11-DEPLOYMENT-MANUAL.md
echo 12-BACKUP-RECOVERY-MANUAL.md
echo 13-DATA-GOVERNANCE-MANUAL.md
echo 14-API-CATALOG.md
echo.
echo Result:
echo PHASE 10M.3: PASS
) > "%REPORTS%\PHASE-10M-3-REPORT.txt"

echo.
echo =========================================
echo PHASE 10M.3: PASS
echo =========================================
echo Created security, deployment, backup recovery, data governance, and API docs.
echo.
pause
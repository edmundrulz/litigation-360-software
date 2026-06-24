@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set HANDBOOK=%ROOT%\docs\MASTER-HANDBOOK
set OPS=%ROOT%\_operations\phase-10M-master-documentation
set REPORTS=%OPS%\reports

mkdir "%HANDBOOK%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1

(
echo # 05 System Architecture
echo.
echo ## Root Path
echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
echo.
echo ## Core Layers
echo - Frontend: React / Vite
echo - Backend: Node.js / Express
echo - Database: litigation360.db
echo - Operations: _operations folder
echo - Documentation: docs folder
echo - Scripts: scripts folder
echo.
echo ## Known Ports
echo - Backend: 5000
echo - Frontend: 5173 or 5174
echo.
echo ## Backend Entry Point
echo backend\src\index.js
echo.
echo ## Frontend Entry Point
echo frontend\src\App.jsx
) > "%HANDBOOK%\05-SYSTEM-ARCHITECTURE.md"

(
echo # 06 Module Catalog
echo.
echo ## Live Modules
echo - Clients
echo - Cases
echo - Matters
echo - Court Dates
echo - Documents
echo - Staff
echo.
echo ## Planned Modules
echo - Tasks
echo - Notifications
echo - Court Navigation
echo - Reports
echo - Lawyer View
echo - Clerk View
echo - Admin View
echo - Finance View
echo - Partner View
echo - Legal AI
echo - Knowledge Management
echo - Predictive Analytics
echo - Executive Command Centre
echo - Workflow Automation
echo - Government Integrations
echo - Client Portal
echo - Mobile App
echo - Marketplace
echo - Autonomous Operations
echo.
echo ## Rule
echo Live modules may be clickable only if real page files exist.
echo Planned modules must show PLANNED and must not fake functionality.
) > "%HANDBOOK%\06-MODULE-CATALOG.md"

(
echo # 07 Operations Manual
echo.
echo ## Daily Startup
echo 1. Start backend.
echo 2. Start frontend.
echo 3. Open Vite URL.
echo 4. Run health checks.
echo 5. Confirm dashboard loads.
echo.
echo ## Daily Shutdown
echo 1. Stop frontend dev server.
echo 2. Stop backend server.
echo 3. Confirm no unwanted node process remains.
echo.
echo ## Health Checks
echo curl.exe http://localhost:5000/api/health
echo curl.exe http://localhost:5000/api/enterprise/monitoring/health
echo curl.exe http://localhost:5000/api/enterprise/deployment-centre/health
echo.
echo ## Build Check
echo cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
echo npm run build
) > "%HANDBOOK%\07-OPERATIONS-MANUAL.md"

(
echo # 08 Testing Manual
echo.
echo ## Test Levels
echo 1. File verification
echo 2. Build verification
echo 3. Backend health verification
echo 4. Frontend browser verification
echo 5. User acceptance testing
echo 6. Documentation verification
echo.
echo ## UAT Checklist
echo - Dashboard loads
echo - Clients opens
echo - Back To Main Workspace works
echo - Cases opens
echo - Matters opens
echo - Court Dates opens
echo - Documents opens
echo - Staff opens
echo - Planned modules show PLANNED
echo - No browser back button needed
echo - No blank screen
echo - No proxy errors
) > "%HANDBOOK%\08-TESTING-MANUAL.md"

(
echo # 09 Troubleshooting Guide
echo.
echo ## Backend Connection Refused
echo Meaning: backend is not running on port 5000.
echo Fix:
echo cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
echo npm start
echo.
echo ## Frontend Port 5173 In Use
echo Meaning: Vite selected another port.
echo Fix: open the exact Vite URL shown, usually 5174.
echo.
echo ## npm run build Fails
echo Meaning: frontend has syntax, import, or build issue.
echo Fix: stop deployment and run rollback script for the current phase.
echo.
echo ## PowerShell Here-String Error
echo Meaning: script was pasted incompletely or terminator was missing.
echo Fix: replace the script fully, do not patch line by line.
echo.
echo ## BAT File Not Recognized
echo Meaning: file name or folder is wrong.
echo Fix: run dir *.bat and confirm exact filename.
) > "%HANDBOOK%\09-TROUBLESHOOTING.md"

(
echo PHASE 10M.2 ARCHITECTURE AND MODULE CATALOG REPORT
echo Date: %date% %time%
echo.
echo Created:
echo 05-SYSTEM-ARCHITECTURE.md
echo 06-MODULE-CATALOG.md
echo 07-OPERATIONS-MANUAL.md
echo 08-TESTING-MANUAL.md
echo 09-TROUBLESHOOTING.md
echo.
echo Result:
echo PHASE 10M.2: PASS
) > "%REPORTS%\PHASE-10M-2-REPORT.txt"

echo.
echo =========================================
echo PHASE 10M.2: PASS
echo =========================================
echo Created architecture, module, operations, testing, and troubleshooting docs.
echo.
pause
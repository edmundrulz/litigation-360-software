@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set HANDBOOK=%ROOT%\docs\MASTER-HANDBOOK
set OPS=%ROOT%\_operations\phase-10M-master-documentation
set REPORTS=%OPS%\reports
set REGISTERS=%OPS%\registers

mkdir "%HANDBOOK%" >nul 2>&1
mkdir "%OPS%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1
mkdir "%REGISTERS%" >nul 2>&1

echo Creating Phase 10M Master Handbook...

(
echo # Litigation 360 Master Handbook
echo.
echo ## Project
echo Litigation 360
echo.
echo ## Classification
echo Legal Enterprise Operating System ^(LEOS^)
echo.
echo ## Current Program
echo Phase 10 Master Completion Program
echo.
echo ## Handbook Purpose
echo This handbook is the authoritative A-Z operating, technical, governance, testing, recovery, training, and commercial reference for Litigation 360.
echo.
echo ## Master Document Register
echo 00-MASTER-INDEX.md
echo 01-EXECUTIVE-SUMMARY.md
echo 02-VISION-MISSION.md
echo 03-PHASE-10-COMPLETION-MAP.md
echo 04-PROTOCOLS-CHECKS-VERIFICATION.md
echo 99-PHASE-10M-PROGRESS-TRACKER.md
echo.
echo ## Phase 10 Streams
echo 10M Master Documentation
echo 10N Governance
echo 10O Architecture
echo 10P Operations
echo 10Q Testing
echo 10R Security
echo 10S Deployment and Recovery
echo 10T Data Governance
echo 10U Training
echo 10V Commercial Readiness
echo 10W Dashboard
echo 10X Final Consolidation
) > "%HANDBOOK%\00-MASTER-INDEX.md"

(
echo # 01 Executive Summary
echo.
echo ## What Is Litigation 360?
echo Litigation 360 is a Legal Enterprise Operating System designed to manage legal operations, clients, matters, cases, documents, court dates, staff workflows, monitoring, deployment readiness, and future AI-enabled legal operations.
echo.
echo ## Problem It Solves
echo Law firms often operate across scattered files, manual reminders, disconnected documents, fragmented client records, and limited operational visibility.
echo.
echo Litigation 360 aims to centralise legal operations into one controlled, monitored, recoverable, and expandable system.
echo.
echo ## Current Verified Capabilities
echo - Backend operational
echo - Frontend operational
echo - Database connected
echo - Health endpoints available
echo - Monitoring engine available
echo - Governance engine available
echo - Performance engine available
echo - Deployment readiness centre available
echo - Backup recovery health available
echo - Navigation and module structure operational
echo.
echo ## Current Live Modules
echo - Clients
echo - Cases
echo - Matters
echo - Court Dates
echo - Documents
echo - Staff
echo.
echo ## Strategic Direction
echo Litigation 360 is evolving from legal practice software into a full Legal Enterprise Operating System.
) > "%HANDBOOK%\01-EXECUTIVE-SUMMARY.md"

(
echo # 02 Vision and Mission
echo.
echo ## Vision
echo To become a complete Legal Enterprise Operating System capable of supporting law firms, legal teams, administrators, clerks, partners, and future AI-powered legal operations.
echo.
echo ## Mission
echo To unify client management, matter management, court operations, document governance, staff coordination, analytics, monitoring, deployment readiness, automation, and future AI into one structured platform.
echo.
echo ## Objectives
echo - Reduce manual legal administration
echo - Improve visibility over legal operations
echo - Centralise matter and document control
echo - Improve reliability and recoverability
echo - Create an enterprise-ready platform foundation
echo - Prepare for future AI, analytics, and integrations
echo.
echo ## Success Criteria
echo Litigation 360 is successful when a law firm can operate, monitor, recover, troubleshoot, and expand the platform without relying only on the original creator.
) > "%HANDBOOK%\02-VISION-MISSION.md"

(
echo # 03 Phase 10 Completion Map
echo.
echo ## Phase 10 Purpose
echo Phase 10 is the practical ceiling phase before Phase 11.
echo.
echo Its purpose is to complete software stability, documentation, governance, operations, testing, security, deployment, data governance, training, commercial readiness, dashboard visibility, and final consolidation.
echo.
echo ## Phase 10 Streams
echo ^| Stream ^| Name ^| Purpose ^| Status ^|
echo ^|---^|---^|---^|---^|
echo ^| 10M ^| Master Documentation ^| Capture all project knowledge ^| IN PROGRESS ^|
echo ^| 10N ^| Governance ^| Roles, approvals, change control ^| NOT STARTED ^|
echo ^| 10O ^| Architecture ^| System, frontend, backend, database architecture ^| NOT STARTED ^|
echo ^| 10P ^| Operations ^| Daily, weekly, monthly SOPs ^| NOT STARTED ^|
echo ^| 10Q ^| Testing ^| Smoke, regression, UAT, recovery tests ^| NOT STARTED ^|
echo ^| 10R ^| Security ^| Authentication, RBAC, audit, data protection ^| NOT STARTED ^|
echo ^| 10S ^| Deployment and Recovery ^| Install, upgrade, rollback, DR ^| NOT STARTED ^|
echo ^| 10T ^| Data Governance ^| Dictionary, retention, backup policy ^| NOT STARTED ^|
echo ^| 10U ^| Training ^| User and developer guides ^| NOT STARTED ^|
echo ^| 10V ^| Commercial Readiness ^| Pricing, ROI, support, investor material ^| NOT STARTED ^|
echo ^| 10W ^| Dashboard ^| KPIs, executive visibility ^| IN PROGRESS ^|
echo ^| 10X ^| Final Consolidation ^| Final readiness review ^| NOT STARTED ^|
echo.
echo ## Phase 10 Exit Rule
echo Phase 11 must not begin until Phase 10X confirms that documentation, governance, operations, testing, recovery, security, training, and roadmap artifacts exist.
) > "%HANDBOOK%\03-PHASE-10-COMPLETION-MAP.md"

(
echo # 04 Protocols, Checks and Verification
echo.
echo ## Mandatory Working Standard
echo Every phase must include:
echo.
echo 1. Objective
echo 2. Exact file and folder path
echo 3. Backup protocol
echo 4. Deployment script
echo 5. Rollback script
echo 6. Verification command
echo 7. Expected output
echo 8. Testing checklist
echo 9. PASS/FAIL criteria
echo 10. Next action only after verification
echo.
echo ## No-Go Rules
echo - No assumptions
echo - No vague instructions
echo - No risky regex patching
echo - No file replacement without backup
echo - No phase closure without verification
echo - No fake-live planned modules
echo.
echo ## Verification Levels
echo Level 1 File verification
echo Level 2 Build verification
echo Level 3 Backend verification
echo Level 4 Frontend verification
echo Level 5 User acceptance testing
echo Level 6 Documentation record
echo.
echo ## Phase Completion Rule
echo A phase is PASS only when build, backend, frontend, user test, rollback, and documentation are complete.
) > "%HANDBOOK%\04-PROTOCOLS-CHECKS-VERIFICATION.md"

(
echo # Phase 10M Progress Tracker
echo.
echo ## Phase 10M.1 Master Handbook Foundation
echo Status: GENERATED
echo.
echo ## Created Documents
echo - 00-MASTER-INDEX.md
echo - 01-EXECUTIVE-SUMMARY.md
echo - 02-VISION-MISSION.md
echo - 03-PHASE-10-COMPLETION-MAP.md
echo - 04-PROTOCOLS-CHECKS-VERIFICATION.md
echo.
echo ## Next Documents
echo - 05-SYSTEM-ARCHITECTURE.md
echo - 06-MODULE-CATALOG.md
echo - 07-OPERATIONS-MANUAL.md
echo - 08-TESTING-MANUAL.md
echo - 09-TROUBLESHOOTING.md
echo.
echo ## Overall Phase 10 Estimate
echo Software: 85 percent
echo Documentation: 40 percent
echo Governance: 35 percent
echo Operations: 45 percent
echo Testing: 50 percent
echo Security: 55 percent
echo Training: 15 percent
echo Commercial: 25 percent
) > "%HANDBOOK%\99-PHASE-10M-PROGRESS-TRACKER.md"

(
echo PHASE 10M MASTER HANDBOOK INSTALL REPORT
echo Date: %date% %time%
echo.
echo Created:
echo %HANDBOOK%
echo.
echo Documents:
echo 00-MASTER-INDEX.md
echo 01-EXECUTIVE-SUMMARY.md
echo 02-VISION-MISSION.md
echo 03-PHASE-10-COMPLETION-MAP.md
echo 04-PROTOCOLS-CHECKS-VERIFICATION.md
echo 99-PHASE-10M-PROGRESS-TRACKER.md
echo.
echo Result:
echo PHASE 10M.1 MASTER HANDBOOK FOUNDATION: PASS
) > "%REPORTS%\PHASE-10M-INSTALL-REPORT.txt"

echo.
echo =========================================
echo PHASE 10M.1 MASTER HANDBOOK FOUNDATION: PASS
echo =========================================
echo.
echo Created:
echo %HANDBOOK%
echo.
echo Report:
echo %REPORTS%\PHASE-10M-INSTALL-REPORT.txt
echo.
pause
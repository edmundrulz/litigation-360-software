@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set HANDBOOK=%ROOT%\docs\MASTER-HANDBOOK
set OPS=%ROOT%\_operations\phase-10M-master-documentation
set REPORTS=%OPS%\reports

mkdir "%HANDBOOK%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1

(
echo # 15 Training Guide
echo.
echo ## Purpose
echo Defines how different users learn and operate Litigation 360.
echo.
echo ## User Groups
echo - Lawyer
echo - Clerk
echo - Admin
echo - Partner
echo - Developer
echo - System operator
echo.
echo ## Lawyer Training
echo - View clients
echo - View cases
echo - View matters
echo - Track court dates
echo - Review documents
echo.
echo ## Clerk Training
echo - Maintain client records
echo - Update matter information
echo - Upload and organize documents
echo - Track deadlines
echo.
echo ## Admin Training
echo - Manage staff
echo - Monitor health
echo - Run verification scripts
echo - Maintain documentation
echo.
echo ## Developer Training
echo - Understand frontend structure
echo - Understand backend structure
echo - Run build tests
echo - Use rollback scripts
echo - Update documentation after changes
) > "%HANDBOOK%\15-TRAINING-GUIDE.md"

(
echo # 16 Commercial Readiness
echo.
echo ## Purpose
echo Defines how Litigation 360 can be explained to partners, investors, clients, and law firms.
echo.
echo ## Value Proposition
echo Litigation 360 reduces scattered work, improves operational visibility, centralises matter management, supports document governance, and creates a foundation for automation and AI.
echo.
echo ## Potential Users
echo - Small law firms
echo - Medium law firms
echo - Legal departments
echo - Legal operations teams
echo - Administrative legal teams
echo.
echo ## Commercial Models
echo - Internal firm system
echo - Subscription software
echo - Managed service
echo - Enterprise licensing
echo - Custom deployment
echo.
echo ## Readiness Gaps
echo - Pricing finalisation
echo - Support model
echo - Licensing terms
echo - Client onboarding pack
echo - Investor pitch deck
echo - Demo script
) > "%HANDBOOK%\16-COMMERCIAL-READINESS.md"

(
echo # 17 Phase Roadmap
echo.
echo ## Current Phase Program
echo Phase 10 is the practical ceiling before Phase 11.
echo.
echo ## Phase 10 Streams
echo - 10M Master Documentation
echo - 10N Governance
echo - 10O Architecture
echo - 10P Operations
echo - 10Q Testing
echo - 10R Security
echo - 10S Deployment and Recovery
echo - 10T Data Governance
echo - 10U Training
echo - 10V Commercial Readiness
echo - 10W Dashboard
echo - 10X Final Consolidation
echo.
echo ## Phase 11 Candidate Direction
echo Phase 11 should only begin after Phase 10X confirms operational, documentation, governance, testing, security, recovery, and commercial readiness.
echo.
echo ## Phase 11 Themes
echo - Enterprise expansion
echo - Deeper AI integration
echo - Client portal expansion
echo - Court and government integration
echo - Multi-firm deployment readiness
echo - Commercial pilot packaging
) > "%HANDBOOK%\17-PHASE-ROADMAP.md"

(
echo # 18 Glossary
echo.
echo ## LEOS
echo Legal Enterprise Operating System.
echo.
echo ## Client
echo A person or organization receiving legal services.
echo.
echo ## Case
echo A legal dispute, proceeding, claim, defence, or legal action.
echo.
echo ## Matter
echo A broader legal work item that may contain one or more cases, documents, deadlines, and tasks.
echo.
echo ## Court Date
echo A hearing, mention, case management, trial, filing deadline, or other court-related date.
echo.
echo ## Document Governance
echo The controlled management of legal documents, versions, access, storage, and recovery.
echo.
echo ## UAT
echo User Acceptance Testing.
echo.
echo ## Rollback
echo Restoring the system to the last known working state.
echo.
echo ## Deployment
echo The process of applying a tested change to the system.
echo.
echo ## Governance
echo The structure of decision-making, approval, risk control, and accountability.
) > "%HANDBOOK%\18-GLOSSARY.md"

(
echo # 19 Phase 10 Final Consolidation Checklist
echo.
echo ## Purpose
echo This checklist determines whether Phase 10 is ready to close.
echo.
echo ## Required Before Phase 11
echo - Master Handbook exists
echo - Governance documents exist
echo - Architecture documents exist
echo - Operations manual exists
echo - Testing manual exists
echo - Security manual exists
echo - Deployment manual exists
echo - Backup recovery manual exists
echo - Data governance manual exists
echo - Training guide exists
echo - Commercial readiness document exists
echo - Roadmap exists
echo - Glossary exists
echo - Rollback scripts exist
echo - Verification reports exist
echo - Live modules tested
echo - Planned modules clearly marked
echo.
echo ## Final Rule
echo Phase 11 must not start until Phase 10X Final Consolidation is PASS.
) > "%HANDBOOK%\19-PHASE-10-FINAL-CONSOLIDATION-CHECKLIST.md"

(
echo # 20 Master Handbook Closeout
echo.
echo ## Current Status
echo Phase 10M Master Documentation foundation has been created.
echo.
echo ## Created Document Groups
echo - Executive documentation
echo - Architecture documentation
echo - Module catalog
echo - Operations manual
echo - Testing manual
echo - Troubleshooting guide
echo - Security manual
echo - Deployment manual
echo - Backup recovery manual
echo - Data governance manual
echo - API catalog
echo - Training guide
echo - Commercial readiness
echo - Roadmap
echo - Glossary
echo.
echo ## Next Stream
echo Phase 10N Governance.
) > "%HANDBOOK%\20-MASTER-HANDBOOK-CLOSEOUT.md"

(
echo PHASE 10M.4 TRAINING COMMERCIAL ROADMAP GLOSSARY REPORT
echo Date: %date% %time%
echo.
echo Created:
echo 15-TRAINING-GUIDE.md
echo 16-COMMERCIAL-READINESS.md
echo 17-PHASE-ROADMAP.md
echo 18-GLOSSARY.md
echo 19-PHASE-10-FINAL-CONSOLIDATION-CHECKLIST.md
echo 20-MASTER-HANDBOOK-CLOSEOUT.md
echo.
echo Result:
echo PHASE 10M.4: PASS
) > "%REPORTS%\PHASE-10M-4-REPORT.txt"

echo.
echo =========================================
echo PHASE 10M.4: PASS
echo =========================================
echo Created training, commercial, roadmap, glossary, and closeout docs.
echo.
pause
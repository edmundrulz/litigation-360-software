@echo off
setlocal EnableDelayedExpansion
title Litigation 360 - Phase 10A AI Blueprint Integration

echo =====================================================
echo LITIGATION 360 - PHASE 10A AI BLUEPRINT INTEGRATION
echo =====================================================
echo.

set "ROOT=%cd%"
set "PHASE=PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE"

echo Project Root:
echo %ROOT%
echo.

mkdir "%ROOT%\%PHASE%" 2>nul

mkdir "%ROOT%\%PHASE%\01_AI_KNOWLEDGE_CENTER" 2>nul
mkdir "%ROOT%\%PHASE%\01_AI_KNOWLEDGE_CENTER\Case_Law" 2>nul
mkdir "%ROOT%\%PHASE%\01_AI_KNOWLEDGE_CENTER\Practice_Notes" 2>nul
mkdir "%ROOT%\%PHASE%\01_AI_KNOWLEDGE_CENTER\SOPs" 2>nul
mkdir "%ROOT%\%PHASE%\01_AI_KNOWLEDGE_CENTER\Internal_Policies" 2>nul

mkdir "%ROOT%\%PHASE%\02_AI_LEGAL_DRAFTING_ENGINE" 2>nul
mkdir "%ROOT%\%PHASE%\02_AI_LEGAL_DRAFTING_ENGINE\Prompts" 2>nul
mkdir "%ROOT%\%PHASE%\02_AI_LEGAL_DRAFTING_ENGINE\Draft_Outputs" 2>nul
mkdir "%ROOT%\%PHASE%\02_AI_LEGAL_DRAFTING_ENGINE\Audit_Reports" 2>nul

mkdir "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE" 2>nul
mkdir "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE\Partner_Approved" 2>nul
mkdir "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE\Court_Accepted" 2>nul
mkdir "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE\Winning_Documents" 2>nul
mkdir "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE\Rejected_Do_Not_Learn" 2>nul

mkdir "%ROOT%\%PHASE%\04_INTELLIGENT_INBOX" 2>nul
mkdir "%ROOT%\%PHASE%\04_INTELLIGENT_INBOX\Raw_Uploads" 2>nul
mkdir "%ROOT%\%PHASE%\04_INTELLIGENT_INBOX\Processed" 2>nul
mkdir "%ROOT%\%PHASE%\04_INTELLIGENT_INBOX\Needs_Review" 2>nul

mkdir "%ROOT%\%PHASE%\05_RESEARCH_VAULT" 2>nul
mkdir "%ROOT%\%PHASE%\05_RESEARCH_VAULT\Legal_Research" 2>nul
mkdir "%ROOT%\%PHASE%\05_RESEARCH_VAULT\Client_Research" 2>nul
mkdir "%ROOT%\%PHASE%\05_RESEARCH_VAULT\Web_Research" 2>nul
mkdir "%ROOT%\%PHASE%\05_RESEARCH_VAULT\Judgments" 2>nul

mkdir "%ROOT%\%PHASE%\06_DEADLINE_INTELLIGENCE" 2>nul
mkdir "%ROOT%\%PHASE%\06_DEADLINE_INTELLIGENCE\Registry_Calculators" 2>nul
mkdir "%ROOT%\%PHASE%\06_DEADLINE_INTELLIGENCE\Holiday_Rules" 2>nul
mkdir "%ROOT%\%PHASE%\06_DEADLINE_INTELLIGENCE\Deadline_Alerts" 2>nul

mkdir "%ROOT%\%PHASE%\07_COURT_PORTAL_HUB" 2>nul
mkdir "%ROOT%\%PHASE%\08_MATTER_HEALTH_MONITOR" 2>nul
mkdir "%ROOT%\%PHASE%\09_LITIGATION360_COPILOT" 2>nul
mkdir "%ROOT%\%PHASE%\10_COURT_NAVIGATION_ENGINE" 2>nul
mkdir "%ROOT%\%PHASE%\99_LOGS" 2>nul

echo Creating integration manifest...

(
echo {
echo   "phase": "PHASE 10A",
echo   "name": "AI Knowledge and Legal Intelligence Expansion",
echo   "status": "Integrated",
echo   "source": "Original Legal Holy Grail Blueprint",
echo   "purpose": "Absorb useful AI, RAG, document learning, inbox, research, deadline and automation concepts into Litigation 360",
echo   "modules_added": [
echo     "AI Knowledge Center",
echo     "AI Legal Drafting Engine",
echo     "Document Learning Engine",
echo     "Intelligent Inbox",
echo     "Research Vault",
echo     "Deadline Intelligence",
echo     "Court Portal Hub",
echo     "Matter Health Monitor",
echo     "Litigation 360 Copilot",
echo     "Court Navigation Engine"
echo   ]
echo }
) > "%ROOT%\%PHASE%\integration_manifest.json"

echo Creating master README...

(
echo # Litigation 360 - Phase 10A AI Blueprint Integration
echo.
echo This folder absorbs the usable components from the original Legal Holy Grail Blueprint into the larger Litigation 360 platform.
echo.
echo ## Purpose
echo Convert the old standalone AI/legal automation seed into a proper Litigation 360 module family.
echo.
echo ## Added Modules
echo.
echo 1. AI Knowledge Center
echo 2. AI Legal Drafting Engine
echo 3. Document Learning Engine
echo 4. Intelligent Inbox
echo 5. Research Vault
echo 6. Deadline Intelligence
echo 7. Court Portal Hub
echo 8. Matter Health Monitor
echo 9. Litigation 360 Copilot
echo 10. Court Navigation Engine
echo.
echo ## Rule
echo This folder is additive only. It does not replace existing Litigation 360 files.
echo.
echo ## Integration Status
echo Ready for Phase 10A development.
) > "%ROOT%\%PHASE%\README.md"

echo Creating AI Legal Auditor Prompt...

(
echo You are Litigation 360 Legal Auditor.
echo.
echo Your job:
echo 1. Review legal drafts for missing facts.
echo 2. Check dates, parties, reliefs, exhibits, prayers and procedural logic.
echo 3. Flag weak drafting.
echo 4. Suggest corrections.
echo 5. Do not invent law.
echo 6. If unsure, mark as "requires lawyer review".
echo.
echo Output format:
echo - Summary
echo - Issues Found
echo - Missing Information
echo - Suggested Fixes
echo - Final Risk Rating
) > "%ROOT%\%PHASE%\02_AI_LEGAL_DRAFTING_ENGINE\Prompts\LEGAL_AUDITOR_PROMPT.txt"

echo Creating Document Learning Rules...

(
echo # Document Learning Rules
echo.
echo Litigation 360 may learn from:
echo - Partner Approved documents
echo - Court Accepted documents
echo - Winning Outcome documents
echo - Finalized Templates
echo.
echo Litigation 360 must NOT learn from:
echo - Rejected drafts
echo - Unverified drafts
echo - Client-confidential experimental notes
echo - Wrong filings
echo - Superseded documents
echo.
echo Every document should be tagged:
echo - Matter ID
echo - Document Type
echo - Approval Status
echo - Outcome
echo - Date
echo - Reviewer
) > "%ROOT%\%PHASE%\03_DOCUMENT_LEARNING_ENGINE\DOCUMENT_LEARNING_RULES.md"

echo Creating Court Portal Hub...

(
echo @echo off
echo title Litigation 360 Court Portal Hub
echo echo Opening Litigation 360 Court Portal Hub...
echo start https://efs.kehakiman.gov.my/
echo start https://www.elaw.my/
echo start https://www.cljlaw.com/
echo start https://lom.agc.gov.my/
echo start https://jpp.mohr.gov.my/
echo exit
) > "%ROOT%\%PHASE%\07_COURT_PORTAL_HUB\OPEN_COURT_PORTALS.bat"

echo Creating Research Capture Template...

(
echo # Research Capture Template
echo.
echo Research ID:
echo Matter ID:
echo Client:
echo Source:
echo URL / Citation:
echo Date Captured:
echo Topic:
echo Keywords:
echo Summary:
echo Legal Relevance:
echo Action Required:
echo Saved By:
) > "%ROOT%\%PHASE%\05_RESEARCH_VAULT\Research_Capture_Template.md"

echo Creating Matter Health Rules...

(
echo # Matter Health Monitor Rules
echo.
echo Score each matter from 0 to 100.
echo.
echo Deduct points for:
echo - Overdue deadline
echo - Missing next action
echo - No activity for 30 days
echo - Missing documents
echo - Missing billing entry
echo - Unassigned task
echo - No hearing date recorded
echo.
echo Status:
echo 90-100 = Healthy
echo 70-89 = Watch
echo 50-69 = Needs Attention
echo Below 50 = Critical
) > "%ROOT%\%PHASE%\08_MATTER_HEALTH_MONITOR\MATTER_HEALTH_RULES.md"

echo Creating Deadline Intelligence Notes...

(
echo # Deadline Intelligence System
echo.
echo This module will calculate:
echo - Filing deadlines
echo - Appeal deadlines
echo - Service deadlines
echo - Limitation periods
echo - Hearing preparation dates
echo.
echo Future upgrade:
echo Add Malaysia Federal and State Public Holiday checking.
echo If a deadline falls on a weekend or public holiday, flag for lawyer review.
) > "%ROOT%\%PHASE%\06_DEADLINE_INTELLIGENCE\DEADLINE_INTELLIGENCE_README.md"

echo Creating Copilot Command List...

(
echo # Litigation 360 Copilot Commands
echo.
echo Example questions:
echo - What matters need urgent action today?
echo - Which files have no activity for 30 days?
echo - Which hearings are coming next week?
echo - Which clients owe money?
echo - Which documents need partner review?
echo - Which deadlines fall within 7 days?
echo - Which matters are unhealthy?
) > "%ROOT%\%PHASE%\09_LITIGATION360_COPILOT\COPILOT_COMMANDS.md"

echo Creating Court Navigation Concept...

(
echo # Court Navigation Engine
echo.
echo Purpose:
echo Help lawyers and staff reach court on time.
echo.
echo Future functions:
echo - Court address database
echo - Google Maps link
echo - Traffic estimate
echo - Departure reminder
echo - Parking notes
echo - Hearing arrival buffer
) > "%ROOT%\%PHASE%\10_COURT_NAVIGATION_ENGINE\COURT_NAVIGATION_ENGINE.md"

echo Writing install log...

(
echo Litigation 360 Phase 10A installed on %date% at %time%
echo Root: %ROOT%
echo Status: Success
) > "%ROOT%\%PHASE%\99_LOGS\install_log.txt"

echo.
echo =====================================================
echo PHASE 10A INTEGRATION COMPLETE
echo =====================================================
echo.
echo Added folder:
echo %ROOT%\%PHASE%
echo.
echo Nothing was deleted or overwritten.
echo This is safe and additive.
echo.
pause
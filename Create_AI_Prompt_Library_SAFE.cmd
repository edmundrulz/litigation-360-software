@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM AI PROMPT LIBRARY AUTO-CREATOR - SAFE ASCII CMD VERSION
REM Creates folders and prompt template files on Desktop.
REM ============================================================

set "ROOT=%USERPROFILE%\Desktop\AI-Prompt-Library"
set "LOG=%ROOT%\creation-log.txt"

cls
echo ============================================================
echo AI PROMPT LIBRARY AUTO-CREATOR
echo ============================================================
echo.
echo Target folder:
echo %ROOT%
echo.

REM Create root folder
if not exist "%ROOT%" mkdir "%ROOT%"
if errorlevel 1 (
    echo ERROR: Could not create root folder.
    echo Try running this file as Administrator or choose another folder.
    pause
    exit /b 1
)

REM Start log
echo AI Prompt Library creation log > "%LOG%"
echo Created on %DATE% %TIME% >> "%LOG%"
echo Root: %ROOT% >> "%LOG%"
echo. >> "%LOG%"

REM Create folders
for %%D in (
    "Legal"
    "Software"
    "Development"
    "Project Management"
    "Education"
    "Litigation360"
    "Master"
    "SOP"
    "Audit Reports"
    "Backups"
    "Testing"
) do (
    if not exist "%ROOT%\%%~D" mkdir "%ROOT%\%%~D"
    echo Created folder: %%~D >> "%LOG%"
)

REM ============================================================
REM MASTER INDEX
REM ============================================================
> "%ROOT%\Master\Master Prompt Index.txt" (
    echo MASTER PROMPT LIBRARY INDEX
    echo ===========================
    echo.
    echo Use this library by opening any prompt file, copying the text, and pasting it into ChatGPT when needed.
    echo.
    echo Main folders:
    echo - Legal
    echo - Software
    echo - Development
    echo - Project Management
    echo - Education
    echo - Litigation360
    echo - SOP
    echo - Audit Reports
    echo - Testing
    echo - Backups
    echo.
    echo Recommended usage:
    echo 1. Open Launch-Prompt-Library.cmd
    echo 2. Choose the prompt category
    echo 3. Copy the prompt
    echo 4. Paste it into ChatGPT with your current code, issue, document, or project status
)

REM ============================================================
REM LEGAL PROMPTS
REM ============================================================
> "%ROOT%\Legal\Rules Compliance Review.txt" (
    echo RULES COMPLIANCE REVIEW PROMPT
    echo ==============================
    echo.
    echo Review this draft against the relevant Rules of Court and highlight any potential procedural inconsistencies.
    echo.
    echo Check for:
    echo 1. Filing deadline issues
    echo 2. Missing procedural requirements
    echo 3. Incorrect format or structure
    echo 4. Missing supporting documents
    echo 5. Possible limitation or time-bar risks
    echo 6. Public holiday or non-working day deadline conflicts
    echo 7. Any requirement that should be verified before filing
    echo.
    echo Provide:
    echo - Issues found
    echo - Severity level
    echo - Why it matters
    echo - Recommended correction
    echo - Final filing readiness verdict
)

> "%ROOT%\Legal\Opposing Counsel Simulation.txt" (
    echo OPPOSING COUNSEL SIMULATION PROMPT
    echo ==================================
    echo.
    echo Act as opposing counsel. Find weaknesses, gaps, risks, and vulnerable points in the following argument before filing.
    echo.
    echo Review for:
    echo 1. Weak factual assumptions
    echo 2. Missing evidence
    echo 3. Contradictions
    echo 4. Procedural weaknesses
    echo 5. Possible counter-arguments
    echo 6. Ambiguous wording
    echo 7. Authorities or legal principles that may be challenged
    echo.
    echo Provide:
    echo - Top weaknesses
    echo - Three strong counter-arguments
    echo - How to neutralize each point
    echo - What evidence should be added
    echo - Final litigation risk rating
)

> "%ROOT%\Legal\Adversarial Strategy.txt" (
    echo ADVERSARIAL STRATEGY PROMPT
    echo ===========================
    echo.
    echo Propose three specific counter-arguments that competent opposing counsel would use to neutralize these claims.
    echo.
    echo For each counter-argument, provide:
    echo 1. The likely attack
    echo 2. Why it may work
    echo 3. How damaging it is
    echo 4. The best response
    echo 5. Evidence needed to strengthen our position
)

REM ============================================================
REM SOFTWARE PROMPTS
REM ============================================================
> "%ROOT%\Software\Senior Architect Full Review.txt" (
    echo SENIOR SOFTWARE ARCHITECT FULL REVIEW PROMPT
    echo ===========================================
    echo.
    echo I want you to act as a senior software architect, cybersecurity reviewer, DevOps engineer, QA tester, and systems reliability engineer.
    echo.
    echo Thoroughly review, diagnose, stress-test, and harden the following command, code, or script logic:
    echo.
    echo [PASTE COMMAND / CODE / SCRIPT HERE]
    echo.
    echo Your review must cover:
    echo 1. Code logic correctness
    echo 2. Bugs, crashes, dead ends, and failure points
    echo 3. Security risks, injection risks, permission risks, and unsafe behavior
    echo 4. Data safety risks including accidental deletion, overwriting, duplication, corruption, or file loss
    echo 5. Integration issues with frontend, backend, database, API, services, environment variables, ports, dependencies, and OS
    echo 6. Redundancies, obsolete logic, weak design, and inefficient steps
    echo 7. Backup, rollback, recovery, fail-safe, kill-switch, logging, audit trail, and error handling
    echo 8. Stability, reliability, maintainability, scalability, and performance
    echo 9. Edge cases, rare failures, abnormal user behavior, and unexpected input/output
    echo 10. Production-readiness, debugging, monitoring, and operational safety
    echo.
    echo Provide:
    echo - Full risk assessment
    echo - Detected weaknesses
    echo - Severity rating: Critical / High / Medium / Low
    echo - Exact fixes
    echo - Safer corrected code or command where needed
    echo - Recommended safeguards
    echo - Pre-run checklist
    echo - Post-run verification checklist
    echo - Rollback/recovery plan
    echo - Final verdict: Safe to run / Unsafe to run / Safe only after fixes
)

> "%ROOT%\Development\Verify Before Change.txt" (
    echo VERIFY BEFORE CHANGE PROMPT
    echo ===========================
    echo.
    echo Verify thoroughly that the provided script is complete and contains every element currently in use.
    echo.
    echo Requirements:
    echo 1. Review the entire script for completeness and integrity
    echo 2. Identify gaps, truncated sections, or missing command logic
    echo 3. Flag code that may have been altered, removed, or substituted
    echo 4. Confirm whether this appears to be the exact version currently deployed
    echo 5. Do not modify anything yet
    echo.
    echo Important rule:
    echo The final version must contain all existing code PLUS new additions. It cannot be shorter or contain less than the current working version.
    echo.
    echo Provide:
    echo - Whether the script appears complete
    echo - Suspicious gaps or missing sections
    echo - Whether it appears to match the current version
    echo - Recommendations before adding new code
)

> "%ROOT%\Development\Safe Modification Rules.txt" (
    echo SAFE MODIFICATION RULES PROMPT
    echo ==============================
    echo.
    echo I need you to verify that code changes are completely safe and will not cause loss of functionality.
    echo.
    echo Conditions:
    echo 1. No buttons, UI elements, or components disappear or become non-functional
    echo 2. No omissions, reductions, removals, or alterations of existing features
    echo 3. No substitutions or replacements unless explicitly authorized
    echo 4. No unauthorized line removals, commenting out, or deletion
    echo 5. No runtime errors, bugs, crashes, or unexpected behavior
    echo 6. All business rules, calculations, and logic remain unchanged
    echo.
    echo Before making any modification, stop and ask for explicit authorization.
)

> "%ROOT%\Development\Step By Step Helper.txt" (
    echo STEP BY STEP HELPER PROMPT
    echo ==========================
    echo.
    echo Guide me one step at a time.
    echo.
    echo Rules:
    echo 1. Give me one step only
    echo 2. Show the exact command, code, or action
    echo 3. Wait for my confirmation before moving to the next step
    echo 4. Verify each section works before continuing
    echo 5. Keep explanations short and practical
    echo 6. If there is an error, stop and diagnose it first
    echo.
    echo Start by asking what task I am working on, what system I am using, and what result I want.
)

REM ============================================================
REM PROJECT MANAGEMENT PROMPTS
REM ============================================================
> "%ROOT%\Project Management\Project Status Report.txt" (
    echo PROJECT STATUS REPORT PROMPT
    echo ============================
    echo.
    echo Create a comprehensive project progress check report.
    echo.
    echo Include:
    echo 1. Current Status Overview
    echo 2. Completed Work
    echo 3. Outstanding Items
    echo 4. Progress Recap
    echo 5. Progress Metrics
    echo 6. Benchmarks
    echo 7. ETA
    echo 8. Bookmarks and decision gates
    echo 9. Visual indicators for completion status
    echo 10. Handover notes
    echo.
    echo Make the report clean, professional, stakeholder-ready, and copy-paste-ready.
)

> "%ROOT%\Project Management\Fresh Start Handover Summary.txt" (
    echo FRESH START HANDOVER SUMMARY PROMPT
    echo ===================================
    echo.
    echo Consolidate and summarize our current progress so I can start fresh without re-explaining everything.
    echo.
    echo Include:
    echo 1. Current progress
    echo 2. Benchmarks achieved
    echo 3. Next steps and direction
    echo 4. Pending tasks
    echo 5. Known issues
    echo 6. Copy-paste ready summary
    echo.
    echo The output must allow me to immediately resume work from the summary alone.
)

REM ============================================================
REM EDUCATION PROMPTS
REM ============================================================
> "%ROOT%\Education\Study Strategy Master Prompt.txt" (
    echo STUDY STRATEGY MASTER PROMPT
    echo ============================
    echo.
    echo Provide comprehensive study strategies, practical notes, actionable pointers, and detailed guidance for improving my ability to:
    echo.
    echo 1. Understand questions and narrative passages
    echo 2. Recall key details, quotes, plot points, names, and sequence of events
    echo 3. Revise efficiently and identify knowledge gaps
    echo 4. Decode complex language, symbolism, metaphors, foreshadowing, subtext, and hidden meanings
    echo 5. Explain properly in written or verbal responses
    echo.
    echo Include:
    echo - Immediate actionable steps
    echo - Common mistakes to avoid
    echo - Examples
    echo - SQ3R method
    echo - Close reading methods
    echo - Annotation techniques
    echo - Test anxiety management tips
)

REM ============================================================
REM LITIGATION 360 MASTER REQUIREMENTS
REM ============================================================
> "%ROOT%\Litigation360\Litigation360 Master Requirements.txt" (
    echo LITIGATION 360 MASTER REQUIREMENTS SUMMARY
    echo ==========================================
    echo.
    echo The platform must support a complete legal practice management ecosystem covering:
    echo.
    echo 1. Document and Case Management
    echo 2. Workflow and Task Management
    echo 3. Staff Operations and Performance
    echo 4. Security and Access Control
    echo 5. Client and CRM Management
    echo 6. Financial and Business Intelligence
    echo 7. Backup, Recovery, and Compliance
    echo 8. AI Assistance
    echo 9. Audit Trails
    echo 10. Business Continuity
    echo.
    echo System objective:
    echo Operate as a reliable legal operations conveyor belt with checks and balances, deadline protection, accountability, business continuity, and management visibility.
)

> "%ROOT%\Litigation360\Public Holiday Deadline Logic.txt" (
    echo PUBLIC HOLIDAY DEADLINE LOGIC PROMPT
    echo ====================================
    echo.
    echo Integrate Malaysian Public Holiday logic into the Deadline Calculator.
    echo.
    echo Requirements:
    echo 1. Prevent filing dates from falling on Malaysian public holidays
    echo 2. Prevent filing dates from falling on weekends where applicable
    echo 3. Support national holidays
    echo 4. Support state-specific holidays where needed
    echo 5. Roll forward or calculate according to the applicable legal rule
    echo 6. Flag any deadline that requires human verification
    echo 7. Log the calculation reason
    echo.
    echo Output:
    echo - Safe proposed deadline
    echo - Original calculated date
    echo - Holiday/weekend conflict if any
    echo - Adjustment reason
    echo - Verification warning
)

REM ============================================================
REM QUICK COMMANDS
REM ============================================================
> "%ROOT%\Development\Useful CMD Commands.txt" (
    echo USEFUL CMD COMMANDS
    echo ===================
    echo.
    echo List files in current folder:
    echo dir /b ^> filelist.txt
    echo.
    echo Git initial stable release:
    echo git init
    echo git add .
    echo git commit -m "Initial stable release - System Online"
    echo.
    echo Litigation 360 backend:
    echo cd C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
    echo npm run safe
    echo.
    echo Litigation 360 frontend:
    echo cd C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
    echo npm run dev
    echo.
    echo OT Booking App frontend:
    echo cd C:\Users\jep_edmundrulz\Desktop\MyProject\OT-Booking-App\frontend
    echo.
    echo OT Booking App backend:
    echo cd C:\Users\jep_edmundrulz\Desktop\MyProject\OT-Booking-App\backend
)

REM ============================================================
REM CREATE LAUNCHER
REM ============================================================
> "%ROOT%\Launch-Prompt-Library.cmd" (
    echo @echo off
    echo setlocal
    echo set "ROOT=%%~dp0"
    echo :MENU
    echo cls
    echo echo ============================================================
    echo echo AI PROMPT LIBRARY
    echo echo ============================================================
    echo echo.
    echo echo 1. Legal - Rules Compliance Review
    echo echo 2. Legal - Opposing Counsel Simulation
    echo echo 3. Software - Senior Architect Full Review
    echo echo 4. Development - Verify Before Change
    echo echo 5. Development - Safe Modification Rules
    echo echo 6. Development - Step By Step Helper
    echo echo 7. Project Management - Project Status Report
    echo echo 8. Project Management - Fresh Start Handover Summary
    echo echo 9. Education - Study Strategy Master Prompt
    echo echo 10. Litigation360 - Master Requirements
    echo echo 11. Useful CMD Commands
    echo echo 12. Open Prompt Library Folder
    echo echo 0. Exit
    echo echo.
    echo set /p choice=Select option: 
    echo if "%%choice%%"=="1" notepad "%%ROOT%%Legal\Rules Compliance Review.txt"
    echo if "%%choice%%"=="2" notepad "%%ROOT%%Legal\Opposing Counsel Simulation.txt"
    echo if "%%choice%%"=="3" notepad "%%ROOT%%Software\Senior Architect Full Review.txt"
    echo if "%%choice%%"=="4" notepad "%%ROOT%%Development\Verify Before Change.txt"
    echo if "%%choice%%"=="5" notepad "%%ROOT%%Development\Safe Modification Rules.txt"
    echo if "%%choice%%"=="6" notepad "%%ROOT%%Development\Step By Step Helper.txt"
    echo if "%%choice%%"=="7" notepad "%%ROOT%%Project Management\Project Status Report.txt"
    echo if "%%choice%%"=="8" notepad "%%ROOT%%Project Management\Fresh Start Handover Summary.txt"
    echo if "%%choice%%"=="9" notepad "%%ROOT%%Education\Study Strategy Master Prompt.txt"
    echo if "%%choice%%"=="10" notepad "%%ROOT%%Litigation360\Litigation360 Master Requirements.txt"
    echo if "%%choice%%"=="11" notepad "%%ROOT%%Development\Useful CMD Commands.txt"
    echo if "%%choice%%"=="12" explorer "%%ROOT%%"
    echo if "%%choice%%"=="0" exit /b
    echo pause
    echo goto MENU
)

echo Created launcher: Launch-Prompt-Library.cmd >> "%LOG%"

REM ============================================================
REM CREATE README
REM ============================================================
> "%ROOT%\README-FIRST.txt" (
    echo README - AI PROMPT LIBRARY
    echo ==========================
    echo.
    echo Your prompt library has been created.
    echo.
    echo How to use:
    echo 1. Open this folder.
    echo 2. Double-click Launch-Prompt-Library.cmd.
    echo 3. Select the prompt you want.
    echo 4. Copy the text from Notepad.
    echo 5. Paste into ChatGPT with your project details, code, or document.
    echo.
    echo Important:
    echo This library does not run legal, software, or AI commands by itself.
    echo It stores reusable prompts safely for copy-paste use.
)

cls
echo ============================================================
echo DONE - AI PROMPT LIBRARY CREATED SUCCESSFULLY
echo ============================================================
echo.
echo Location:
echo %ROOT%
echo.
echo Open this file next:
echo %ROOT%\Launch-Prompt-Library.cmd
echo.
echo A log was created here:
echo %LOG%
echo.
explorer "%ROOT%"
pause
exit /b 0

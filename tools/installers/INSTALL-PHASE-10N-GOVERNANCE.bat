@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set HANDBOOK=%ROOT%\docs\MASTER-HANDBOOK
set OPS=%ROOT%\_operations\phase-10N-governance
set REPORTS=%OPS%\reports
set REGISTERS=%OPS%\registers
set TEMPLATES=%OPS%\templates

mkdir "%HANDBOOK%" >nul 2>&1
mkdir "%OPS%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1
mkdir "%REGISTERS%" >nul 2>&1
mkdir "%TEMPLATES%" >nul 2>&1

echo # Governance Charter > "%HANDBOOK%\21-GOVERNANCE-CHARTER.md"
echo # Roles and Responsibilities > "%HANDBOOK%\22-ROLES-RESPONSIBILITIES.md"
echo # Change Management > "%HANDBOOK%\23-CHANGE-MANAGEMENT.md"
echo # Decision Register > "%HANDBOOK%\24-DECISION-REGISTER.md"
echo # Risk Register > "%HANDBOOK%\25-RISK-REGISTER.md"
echo # Release Governance > "%HANDBOOK%\26-RELEASE-GOVERNANCE.md"
echo # Approval Matrix > "%HANDBOOK%\27-APPROVAL-MATRIX.md"
echo # Version Control > "%HANDBOOK%\28-VERSION-CONTROL.md"
echo # Issue Escalation > "%HANDBOOK%\29-ISSUE-ESCALATION.md"
echo # Governance Closeout > "%HANDBOOK%\30-GOVERNANCE-CLOSEOUT.md"

echo Change ID,Date,Description,Reason,Risk Level,Rollback Available,Tested,Approved,Released,Status > "%REGISTERS%\CHANGE-REGISTER.csv"

echo Decision ID,Date,Decision,Reason,Approved By,Status > "%REGISTERS%\DECISION-REGISTER.csv"

echo Risk ID,Date,Description,Likelihood,Impact,Mitigation,Owner,Status > "%REGISTERS%\RISK-REGISTER.csv"

echo Release ID,Date,Version,Build Status,UAT Status,Rollback Available,Approved,Released > "%REGISTERS%\RELEASE-REGISTER.csv"

echo # Change Request Template > "%TEMPLATES%\CHANGE-REQUEST-TEMPLATE.md"
echo # Decision Template > "%TEMPLATES%\DECISION-TEMPLATE.md"
echo # Risk Template > "%TEMPLATES%\RISK-TEMPLATE.md"
echo # Release Template > "%TEMPLATES%\RELEASE-TEMPLATE.md"
echo # Incident Template > "%TEMPLATES%\INCIDENT-TEMPLATE.md"

(
echo PHASE 10N GOVERNANCE INSTALL REPORT
echo Date: %date% %time%
echo.
echo Governance documents created.
echo Registers created.
echo Templates created.
echo.
echo PHASE 10N.0 PASS
) > "%REPORTS%\PHASE-10N-0-REPORT.txt"

echo.
echo =====================================
echo PHASE 10N.0 PASS
echo =====================================
pause
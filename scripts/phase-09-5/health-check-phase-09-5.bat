@echo off
echo Litigation 360 Phase 9.5 Health Check
echo Checking folders...
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_PHASE_09_5_ENTERPRISE_CORE" (echo OK: Phase 9.5 pack exists) else (echo MISSING: Phase 9.5 pack)
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\data\document-intake\01_INBOX_NEW_DOCUMENTS" (echo OK: Intake inbox exists) else (echo MISSING: Intake inbox)
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\configs\document-intake-config.json" (echo OK: Intake config exists) else (echo MISSING: Intake config)
pause

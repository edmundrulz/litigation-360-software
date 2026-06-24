# PHASE 12.0M ROLLBACK GUIDE

Generated: 2026-06-22 10:59:12

Rollback Folder:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0M-20260622-105912

## What Was Backed Up

See:
PHASE-12.0M-BACKUP-MANIFEST.csv

## Primary Restore Step

To restore App.jsx manually:

Copy this backup:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0M-20260622-105912\App.jsx__App.jsx

Back to:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx

PowerShell command:

Copy-Item -LiteralPath "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0M-20260622-105912\App.jsx__App.jsx" -Destination "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx" -Force

## New Files Added

The integration may have added or overwritten:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\LegalHomePage.jsx

If rollback is needed, restore backed-up files where available.

If these files were newly created and you want to remove them, do that only after confirming with ChatGPT.

## Safety

Do not delete anything unless you are intentionally rolling back and have confirmed the backup exists.
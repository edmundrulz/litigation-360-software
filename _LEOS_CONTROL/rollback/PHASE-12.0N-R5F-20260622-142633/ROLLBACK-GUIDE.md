# PHASE 12.0N-R5F ROLLBACK GUIDE

Generated: 2026-06-22 14:26:34

## Restore Clients.jsx

Copy this backup:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0N-R5F-20260622-142633\Clients.jsx.BACKUP-BEFORE-12.0N-R5F

Back to:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx

PowerShell command:

Copy-Item -LiteralPath "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0N-R5F-20260622-142633\Clients.jsx.BACKUP-BEFORE-12.0N-R5F" -Destination "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx" -Force

## Note

This rollback only affects Clients.jsx.
No database or backend rollback is needed.
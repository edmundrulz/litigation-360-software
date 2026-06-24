# PHASE 12.0N-R2 ROLLBACK GUIDE

Generated: 2026-06-22 12:54:12

## Restore index.html

Copy-Item -LiteralPath "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0N-R2-20260622-125412\index.html.BACKUP-BEFORE-12.0N-R2" -Destination "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\index.html" -Force

## Restore previous enhancer JS, if needed

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0N-R2-20260622-125412\legal-management-enhancer.js.BACKUP-BEFORE-12.0N-R2

## Restore previous enhancer CSS, if needed

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\rollback\PHASE-12.0N-R2-20260622-125412\legal-management-enhancer.css.BACKUP-BEFORE-12.0N-R2

## Safe note

Restoring index.html removes the active enhancer script reference.
No database or backend rollback is needed.
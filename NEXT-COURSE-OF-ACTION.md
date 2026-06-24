# NEXT COURSE OF ACTION — LITIGATION 360

## Current Position

You have not implemented the older SSOT 11.0 Pre-Phase 11 script.

The final consolidated handover says the correct restart point is:

PHASE 12.0A — MASTER SSOT DEPLOYMENT AND CONTROL STRUCTURE CREATION

## Do Not Do Yet

- Do not start Phase 11.
- Do not start Phase 11.1 Security Hardening.
- Do not clean duplicates.
- Do not delete files.
- Do not rename files.
- Do not move project folders.
- Do not refactor backend/frontend code.
- Do not modify the database.

## Immediate Next Step

Run only the safe Phase 12.0A script from the Litigation 360 project root:

```powershell
cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
powershell -ExecutionPolicy Bypass -File "PHASE-12.0A-SAFE-SSOT-DEPLOYMENT.ps1"
```

Or right-click the `.ps1` file and run it in PowerShell after placing it inside the project root.

## What This Script Does

It only creates `_LEOS_CONTROL` and saves the SSOT/control documents.

It does not modify application code.

## Verification After Running

```powershell
Get-ChildItem "_LEOS_CONTROL" -Recurse -File | Select-Object FullName
```

Open the master SSOT:

```powershell
notepad "_LEOS_CONTROL\00_SSOT\SSOT-12.0-CONSOLIDATED-MASTER.md"
```

Open the deployment report:

```powershell
notepad "_LEOS_CONTROL\99_LOGS\PHASE-12.0A-SAFE-SSOT-DEPLOYMENT-REPORT.md"
```

## After That

Proceed to Phase 12.0B:

READ-ONLY VERIFICATION AND EVIDENCE COLLECTION

That means checking the project state without modifying it:
- Git status
- Folder structure
- Package files
- Backend startup
- Frontend startup
- Ports
- Database files
- Routes
- Modules
- Existing backups
- Existing logs
- Existing reports

Only after evidence exists can anything be marked PASS.

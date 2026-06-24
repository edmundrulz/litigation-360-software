# NEXT COURSE OF ACTION — FEATURE EXPLORATION LAB

## What this does

This is not a production unlock. It creates a controlled Feature Exploration Lab so every feature can be discovered, mapped, connected, and tested in order.

## Correct sequence

1. Run PHASE-12.0A first if you have not already done it.
2. Copy PHASE-12.0B-SAFE-FEATURE-EXPLORATION-LAB-UNLOCK.ps1 into your project root.
3. Run it from PowerShell.
4. Open the generated feature matrix and runbook.
5. Explore only P1 workflow first:
   Workspace → Client Details → Matter Details → Deadline Details → Document Details → Review → Save & Submit.
6. Record what works, what is missing, and what errors appear.
7. Only after evidence exists should we connect one module at a time.

## Commands

```powershell
cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
powershell -ExecutionPolicy Bypass -File ".\PHASE-12.0B-SAFE-FEATURE-EXPLORATION-LAB-UNLOCK.ps1"
```

## Open outputs

```powershell
notepad "_LEOS_CONTROL\feature-exploration\runbooks\FEATURE-EXPLORATION-RUNBOOK.md"
notepad "_LEOS_CONTROL\reports\PHASE-12.0B-FEATURE-EXPLORATION-LAB-REPORT.md"
```


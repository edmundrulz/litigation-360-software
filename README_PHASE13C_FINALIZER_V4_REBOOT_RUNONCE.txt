L360 PHASE 13C FINALIZER V4 — REBOOT RUNONCE PACK
=================================================

WHY THIS EXISTS
---------------
V3 failed because Windows still locked:

  C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

The safest fix is to run finalization right after a reboot/login,
before VS Code, File Explorer, frontend/backend servers, or browser dev
sessions relock the folder.

HOW TO USE
----------
1. Extract this ZIP anywhere.

2. Double-click:

   INSTALL_L360_PHASE13C_FINALIZER_V4_RUNONCE.bat

3. It registers V4 to run ONCE at your next Windows login.

4. Restart Windows.

5. Login.

6. Do not open VS Code or File Explorer first.

7. Wait for the L360 V4 after-reboot window.

EXPECTED SUCCESS
----------------
You want:

  V4 SUCCESS

Then run:

  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\L360_START_ALL.bat

Expected:

  Mode: MAIN
  Backend: PASS
  Frontend: PASS

Then rerun:

  L360_PHASE13B_FRONTEND_STATUS_CLARITY.bat

FILES WRITTEN
-------------
Result:
  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\PHASE13C_V4_AFTER_REBOOT_RESULT.txt

Logs:
  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\logs

SAFETY
------
V4 does not delete anything.
V4 does not touch LEOS_CONTROL.
V4 does not run git clean/reset.
V4 does not edit backend/database/RBAC/auth/routes/package/env files.

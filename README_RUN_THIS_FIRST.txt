L360 POWERHELL 7 MASTER LAUNCHER PACK
====================================

WHAT THIS IS
------------
This pack creates a simple launcher for Litigation 360 / LEOS.

Double-click:

  L360_START_ALL.bat

It will:
1. Use PowerShell 7 if available.
2. Prefer the cleanroom folder:
   C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software-CLEANROOM-13C
3. Fall back to the main folder only if cleanroom does not exist.
4. Stop existing dev servers on common L360 ports.
5. Start backend in one PowerShell window.
6. Start frontend in one PowerShell window.
7. Start live monitor in one PowerShell window.
8. Create logs in:
   C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\logs

WHAT IT DOES NOT DO
-------------------
It does NOT delete project folders.
It does NOT rename project folders.
It does NOT touch litigation-360-software_LEOS_CONTROL.
It does NOT complete cleanroom cutover.
It only proves whether the cleanroom can run.

HOW TO INSTALL
--------------
Option A:
Extract this ZIP to:

  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER

Then double-click:

  L360_START_ALL.bat

Option B:
Extract anywhere, then double-click L360_START_ALL.bat.
The script still uses the fixed Litigation 360 project paths.

WINDOWS THAT SHOULD OPEN
------------------------
1. L360 BACKEND
2. L360 FRONTEND
3. L360 LIVE MONITOR

WHAT SUCCESS LOOKS LIKE
-----------------------
The monitor window should eventually show:

Backend : PASS
Frontend: PASS

Then open:

  http://localhost:5173

IF SOMETHING FAILS
------------------
Do not paste monitor table lines into PowerShell.
Copy the text from:
  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\L360_LAST_LAUNCH_STATE.txt

And the latest backend/frontend log files from:
  C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER\logs

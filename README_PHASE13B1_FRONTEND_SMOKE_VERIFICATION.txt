L360 PHASE 13B.1 FRONTEND SMOKE VERIFICATION PACK
=================================================

Use this after:
- Phase 13B final SSOT verification passed
- L360_START_ALL.bat shows Backend PASS and Frontend PASS
- http://localhost:5173 loads

WHAT THIS DOES
--------------
It verifies:
- folder state
- injector file safety
- main.jsx import
- frontend build if build script exists
- backend/frontend runtime endpoints if launcher is open
- SPA route smoke checks

It writes:
  C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_ACTIVE_CONTROL\100_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.md

WHAT IT DOES NOT DO
-------------------
It does not edit app source code.
It does not touch backend/database/RBAC/auth/package/env.
It does not run git clean/reset/init/commit.

HOW TO RUN
----------
Keep L360_START_ALL.bat windows running.

Extract this ZIP anywhere.

Double-click:
  L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.bat

EXPECTED
--------
Overall automated pass: True

NEXT AFTER PASS
---------------
Do the manual browser checklist.

Then the next safe gate is:
  APPROVE SAFE GIT BASELINE ONLY

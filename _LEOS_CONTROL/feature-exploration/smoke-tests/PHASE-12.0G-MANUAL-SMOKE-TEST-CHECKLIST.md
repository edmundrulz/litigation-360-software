# PHASE 12.0G MANUAL BROWSER / API SMOKE TEST CHECKLIST

Generated: 2026-06-22 08:31:54

Project Root:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

## Safety

This phase uses GET-only checks.

No create, edit, delete, migration, source change, database write, production unlock, or Phase 11 work is allowed.

## Start Servers Manually If Needed

Backend examples:

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend"
node server.js

or from project root:

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
node server.js

Frontend example:

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"
npm run dev

## Browser Pages To Check

Open these manually if frontend is running:

- http://localhost:5173/
- http://localhost:5173/dashboard
- http://localhost:5173/clients
- http://localhost:5173/cases
- http://localhost:5173/matters
- http://localhost:5173/matter-intake
- http://localhost:5173/deadlines
- http://localhost:5173/documents

Do not treat Court Dates as connectable yet unless a frontend route/page exists.

## Backend GET Checks

The script tested common GET endpoints on detected backend ports.

HTTP 200 means route responded.
HTTP 401 / 403 means route likely exists but is protected.
Connection failure means server may be off or route/port is different.
404 means route path not confirmed.

## Manual PASS Criteria

A feature can be considered LAB-SMOKE-PASS only if:

1. Frontend page opens without white screen.
2. Backend GET endpoint responds with 200, 401, or 403.
3. Browser console has no fatal error.
4. Backend terminal has no crash.
5. No database write was attempted.
6. No production unlock was performed.

## Current Court Dates Rule

Court Dates remains blocked for connection because Phase 12.0F found backend evidence but no frontend file evidence.

## Next Step After This

Paste the Phase 12.0G report into ChatGPT.

Then proceed to Phase 12.0H:
- classify which modules are lab-smoke-pass
- identify missing frontend API calls for Deadlines/Documents
- decide the first safe manual connection repair, if needed
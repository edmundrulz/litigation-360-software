# PHASE 12.0M POST-INTEGRATION SMOKE CHECKLIST

Generated: 2026-06-22 10:59:12

## Start / Restart Frontend

In PowerShell:

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"
npm run dev

## Open New Isolated Route

http://localhost:5173/legal-home

## Expected Result

The Legal Management UI shell should open with:

- left sidebar
- scales of justice branding
- Search button
- Instructions button
- Glossary button
- MY/SG Legal News button
- Settings button
- firm profile section
- managing partner profile section

## Check Existing Routes Still Work

Open:

http://localhost:5173/
http://localhost:5173/clients
http://localhost:5173/cases
http://localhost:5173/deadlines
http://localhost:5173/documents

## PASS Criteria

- /legal-home opens
- no white screen
- no fatal browser console error
- existing pages still open
- backend terminal does not crash

## FAIL Criteria

- frontend fails to compile
- white screen
- App.jsx route error
- import error
- existing pages stop working

## Important

Production unlock remains NO.
Phase 11 remains locked.
Court Dates remains blocked.
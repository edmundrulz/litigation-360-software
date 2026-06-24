# LITIGATION 360 FEATURE EXPLORATION RUNBOOK

Generated: 2026-06-22 07:50:20

## Purpose

Use this runbook to explore and connect all features in a controlled way.

## Important Rule

This is NOT a production unlock.

This is a lab exploration unlock.

## Approved Exploration Flow

1. Start from Workspace.
2. Open Client Details.
3. Confirm Client Details can save or display correctly.
4. Connect Client to Matter.
5. Connect Matter to Deadline.
6. Connect Matter to Document.
7. Connect Deadline to Court Date / Notifications where available.
8. Connect Document to Review.
9. Test Review + Save & Submit.
10. Record evidence.
11. Update matrix.
12. Only then prepare feature-specific change requests.

## Priority Order

P1:
- Workspace
- Client Details
- Matter Details
- Deadline Details
- Document Details
- Review + Save & Submit
- Dashboard / ECC
- Authentication
- RBAC
- Audit Logging

P2:
- Notifications
- Automation Bus
- Reports

P3:
- Communications Hub
- Client Portal
- Finance / Billing

P4:
- Knowledge Graph
- AI Copilot / Legal Intelligence

## Manual App Startup Commands

Open Terminal 1:

`powershell
cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
node server.js
`

Open Terminal 2:

`powershell
cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
npm run dev
`

If your backend/frontend folders are separate, open each command inside the correct folder.

## Verification Commands

`powershell
Get-ChildItem "_LEOS_CONTROL\feature-exploration" -Recurse -File | Select-Object FullName
`

`powershell
notepad "_LEOS_CONTROL\feature-exploration\matrix\FEATURE-EXPLORATION-MATRIX.csv"
`

`powershell
notepad "_LEOS_CONTROL\feature-exploration\runbooks\FEATURE-EXPLORATION-RUNBOOK.md"
`

## PASS Criteria

PASS only if:

- Feature matrix exists.
- Route discovery report exists.
- Module discovery report exists.
- Change request exists.
- Impact assessment exists.
- No source files were modified.
- No database files were modified.
- No deletion occurred.
- Phase 11 remains locked.

## FAIL Criteria

FAIL if:

- Source files were modified without approval.
- Database files were modified.
- Features were activated in production.
- Phase 11 was opened before certification.
- Planned modules were made fake-live.
- Any cleanup/deletion/migration occurred.

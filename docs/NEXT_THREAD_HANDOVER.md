# Next Thread Handover

## Project
Litigation 360 / LEOS

## Current Mode
Clean-break rebaseline.

## Status
Phase 14C is partial and not complete.

## First Commands
git status --short
git log -5 --oneline
npm --prefix ".\frontend" run build
git diff --stat

## Dirty Files To Review
- frontend/src/pages/Cases.jsx
- frontend/src/pages/ClientIntakeDiscovery.jsx
- frontend/src/pages/Clients.jsx
- frontend/src/pages/MatterIntakeWizard.jsx

## Business MVP Direction
After clean-break is resolved, shift to Legal Practice Control Desk MVP.

Priority:
1. Daily Dashboard
2. Matter Register
3. Client Register
4. Deadline Tracker
5. Document Checklist
6. Task / Follow-up List

# PHASE 12.0L V2 CONTROLLED FRONTEND INTEGRATION PLAN

Generated: 2026-06-22 10:40:39

Project Root:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

## Current Finding

Active App file detected:
frontend\src\App.jsx

Phase 12.0K prototype ready:
True

## Recommended Integration Strategy

Use a new isolated route first:

/legal-home

Do not replace the current dashboard.
Do not replace existing Clients, Matters, Deadlines or Documents pages.
Do not touch Court Dates.
Do not modify Authentication or RBAC yet.

## Candidate File Destination

Later, only after Phase 12.0M approval, copy the staged candidate files into:

frontend\src\components\legal-management-shell\
frontend\src\pages\LegalHomePage.jsx

## Suggested React Import

Add this to App.jsx only after approval:

import LegalHomePage from "./pages/LegalHomePage";

## Suggested Route

Inside the existing <Routes> block, add only one new route:

<Route path="/legal-home" element={<LegalHomePage />} />

## Why /legal-home First?

Because it is isolated.
It does not disturb your working modules:

- Workspace
- Clients
- Matters
- Deadlines
- Documents

It lets you open and test the new interface here:

http://localhost:5173/legal-home

## Safety Rule

Phase 12.0L V2 is plan-only.

No active source files were changed.

## Production Rule

Production unlock remains NO.

Phase 11 remains locked.

Court Dates remains blocked.
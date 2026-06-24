# Phase 10ZF - Internal Navigation + LEOS Module Menu Protocol

## Objective
Restore a full Level 10/11 Litigation 360 LEOS workspace menu while keeping only verified existing modules clickable.

## Deployment Scope
Changed:
- frontend/src/App.jsx
- frontend/src/App.css

Created:
- _operations/phase-10ZF-navigation-module-menu/backups
- _operations/phase-10ZF-navigation-module-menu/reports
- docs/phase-10ZF

## Working Modules
- Clients
- Cases
- Matters
- Court Dates
- Documents
- Staff

## Planned Modules Displayed
- Tasks
- Notifications
- Court Navigation
- Reports
- Lawyer View
- Clerk View
- Admin View
- Finance View
- Partner View
- Legal AI
- Knowledge Management
- Predictive Analytics
- Executive Command Centre
- Workflow Automation
- Government Integrations
- Client Portal
- Mobile App
- Autonomous Operations
- Marketplace

## Navigation Protocol
Use internal app buttons only.
Do not use browser Back button.
Every opened module has:
- Back to Main Workspace

## Verification Protocol
1. npm run build must pass.
2. Start backend.
3. Start frontend.
4. Open active Vite URL.
5. Confirm SYSTEM HEALTHY.
6. Click Clients.
7. Click Back to Main Workspace.
8. Repeat for Cases, Matters, Court Dates, Documents, Staff.
9. Confirm planned modules are visible but disabled.
10. Confirm Operations Centre still shows live module health.

## Rollback Protocol
copy _operations\phase-10ZF-navigation-module-menu\backups\App.jsx.before-10ZF frontend\src\App.jsx
copy _operations\phase-10ZF-navigation-module-menu\backups\App.css.before-10ZF frontend\src\App.css

## Success Criteria
- Build passes.
- Sidebar works.
- Internal Back button works.
- Full LEOS module menu visible.
- Existing pages open.
- Planned modules do not pretend to be live.
- Live monitor updates from backend.

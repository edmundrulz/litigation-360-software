# PHASE 14F NAVIGATION PLACEHOLDER PLAN

Project:
Litigation 360 / LEOS

Branch:
docs/14f-navigation-placeholder-plan

Date:
2026-07-04

Status:
DOCUMENTATION ONLY / NAVIGATION PLACEHOLDER PLAN ONLY / NO SOURCE EDITS

Related Audit:
docs/phase-14/audit/visual-ux/DASHBOARD_CATEGORY_COVERAGE_MAP_20260704.md

Purpose:
Define the safest placeholder-only navigation expansion plan for the main LEOS / Litigation 360 dashboard after the Phase 14F Dashboard Category Coverage Map.

This document does not authorize UI implementation yet.

---

## 1. Safety Rules

This phase is documentation-only.

Do not edit:

1. frontend source files
2. backend source files
3. database files
4. authentication files
5. RBAC files
6. API routes
7. server files
8. environment files
9. production logic
10. Page 3 locked controls

Protected Page 3 controls:

- Page 3 Required / Complete / Missing counter
- Page 3 alphabet filter structured control
- Page 3 real percentage calculation

No placeholder card should be wired to:

- backend modules
- database tables
- API routes
- auth permissions
- real legal AI
- live government integrations
- court filing systems
- payment gateways
- real document generation
- client portal access
- mobile app functionality

---

## 2. Objective

The objective of Phase 14F-B is to prepare a safe placeholder plan before any dashboard UI changes.

The goal is to define:

1. which placeholder cards should be added first
2. where each placeholder should appear
3. what label each placeholder should use
4. what description each placeholder should show
5. what should remain disabled or inactive
6. what must not be connected yet
7. what files should remain untouched
8. what acceptance checks must pass before implementation

---

## 3. Source Audit Reference

Completed Phase 14F-A branch:

audit/14f-dashboard-category-coverage-map

Completed commit:

8ddd3ce docs: add dashboard category coverage map

Completed checkpoint tag:

checkpoint/phase-14f-dashboard-category-coverage-map-20260704

Coverage map file:

docs/phase-14/audit/visual-ux/DASHBOARD_CATEGORY_COVERAGE_MAP_20260704.md

---

## 4. Current Dashboard Areas

The current dashboard contains these areas:

1. Legal Operations Command Centre
2. Priority Actions
3. Today's Tasks
4. Notifications & Alerts
5. Start Workflow
6. Active Legal Work
7. Completion
8. Admin
9. Future Planned Platform Modules

Current cards include:

1. Preliminary Assessment & Triage
2. Matter Opening & Client Gate
3. Client Details / Authority & Conflict
4. Case / Matter Details
5. Matter Workspace
6. Court Dates
7. Documents & Evidence Readiness
8. Draft Engagement Preview
9. Staff

---

## 5. Recommended Placeholder Cards To Add First

| Priority | Placeholder Card | Recommended Area | Status |
|---|---|---|---|
| 1 | My Work | Daily Work | Placeholder only |
| 2 | Clients & Parties | Legal Operations | Placeholder only |
| 3 | Matter Registry | Legal Operations | Placeholder only |
| 4 | Calendar & Deadline Centre | Daily Work / Legal Operations | Placeholder only |
| 5 | Communications Centre | Legal Operations | Placeholder only |
| 6 | Risk, Compliance & Audit | Firm Management | Placeholder only |
| 7 | Admin Settings | Platform Control | Placeholder only |
| 8 | System Configuration | Platform Control | Placeholder only |
| 9 | Help & Support | Platform Control | Placeholder only |

---

## 6. Placeholder Card Specifications

### 6.1 My Work

Recommended label:
My Work

Recommended description:
Personal dashboard for assigned tasks, deadlines, approvals, drafts, and notifications.

Recommended placement:
Daily Work section, near Tasks and Notifications.

Recommended sub-items:
- My Tasks
- My Deadlines
- My Matters
- My Approvals
- My Drafts
- My Alerts

Implementation status:
Placeholder only.

Do not connect to backend yet.

---

### 6.2 Clients & Parties

Recommended label:
Clients & Parties

Recommended description:
Central record for clients, opposing parties, witnesses, lawyers, courts, agencies, and related contacts.

Recommended placement:
Legal Operations section, near Intake & Engagement and Matter Registry.

Recommended sub-items:
- Clients
- Opposing Parties
- Witnesses
- Lawyers
- Courts
- Agencies
- Conflict Links

Implementation status:
Placeholder only.

Do not connect to real client database yet.

---

### 6.3 Matter Registry

Recommended label:
Matter Registry

Recommended description:
Master list of all matters by status, owner, risk, and lifecycle stage.

Recommended placement:
Legal Operations section, before Matter Workspace.

Recommended sub-items:
- All Matters
- Open Matters
- Pending Intake
- Pending Client
- Blocked Matters
- Closed Matters
- Archived Matters

Implementation status:
Placeholder only.

Do not create or modify database tables yet.

---

### 6.4 Calendar & Deadline Centre

Recommended label:
Calendar & Deadline Centre

Recommended description:
Central control area for court dates, filing deadlines, limitation dates, review dates, and reminders.

Recommended placement:
Daily Work or Legal Operations section, near Court Dates.

Recommended sub-items:
- Court Dates
- Filing Deadlines
- Limitation Dates
- Client Meetings
- Internal Review Dates
- Reminder Rules

Implementation status:
Placeholder only.

Do not connect to calendar integrations yet.

---

### 6.5 Communications Centre

Recommended label:
Communications Centre

Recommended description:
Central home for emails, letters, court correspondence, internal notes, call logs, and meeting notes.

Recommended placement:
Legal Operations section, near Documents & Evidence.

Recommended sub-items:
- Client Emails
- Letters
- Court Correspondence
- Internal Notes
- Call Logs
- Meeting Notes

Implementation status:
Placeholder only.

Do not connect to Gmail, Outlook, WhatsApp, SMS, or live messaging yet.

---

### 6.6 Risk, Compliance & Audit

Recommended label:
Risk, Compliance & Audit

Recommended description:
Control area for conflicts, limitation risk, missing authority, audit trails, access logs, and compliance checks.

Recommended placement:
Firm Management section.

Recommended sub-items:
- Conflict Register
- Limitation Risk
- Missing Authority
- Missing Documents
- Audit Trail
- Access Logs
- Approval History

Implementation status:
Placeholder only.

Do not implement permissions, RBAC, or audit log storage yet.

---

### 6.7 Admin Settings

Recommended label:
Admin Settings

Recommended description:
Administrative control area for staff, users, roles, teams, firm profile, workflow rules, and notification rules.

Recommended placement:
Platform Control section, near current Staff card.

Recommended sub-items:
- Staff
- User Accounts
- Roles & Permissions
- Teams / Departments
- Firm Profile
- Workflow Rules
- Notification Rules

Implementation status:
Placeholder only.

Do not change existing Staff page logic yet.

---

### 6.8 System Configuration

Recommended label:
System Configuration

Recommended description:
Technical configuration area for system health, integrations, backups, imports, exports, feature flags, and diagnostics.

Recommended placement:
Platform Control section.

Recommended sub-items:
- System Health
- Integration Settings
- Backup / Restore
- Import / Export
- Feature Flags
- Diagnostics

Implementation status:
Placeholder only.

Do not alter environment files, server files, or deployment settings yet.

---

### 6.9 Help & Support

Recommended label:
Help & Support

Recommended description:
Support area for user guides, workflow help, FAQs, support tickets, bug reports, release notes, and training materials.

Recommended placement:
Platform Control section or bottom navigation group.

Recommended sub-items:
- Help Centre
- User Guide
- Workflow Guide
- FAQ
- Support Tickets
- Bug Report
- Release Notes
- Training Materials

Implementation status:
Placeholder only.

Do not create live support ticketing yet.

---

## 7. Recommended Dashboard Grouping Model

### Layer 1: Daily Work

Recommended cards:

1. Command Hub
2. My Work
3. Tasks
4. Notifications
5. Calendar & Deadline Centre

Purpose:
Give users immediate access to daily responsibilities, urgent work, alerts, deadlines, and assigned matters.

---

### Layer 2: Legal Operations

Recommended cards:

1. Intake & Engagement
2. Clients & Parties
3. Matter Registry
4. Matter Workspace
5. Documents & Evidence
6. Communications Centre
7. Court Work
8. Review & Completion

Purpose:
Organize the full legal workflow from enquiry to active matter handling and completion.

---

### Layer 3: Firm Management

Recommended cards:

1. Staff
2. Finance & Billing
3. Reports & Analytics
4. Risk, Compliance & Audit
5. Templates & Content Management
6. Knowledge Management

Purpose:
Support firm-level control, reporting, finance, compliance, templates, and knowledge.

---

### Layer 4: Platform Control

Recommended cards:

1. Admin Settings
2. User Accounts
3. Roles & Permissions
4. System Configuration
5. System Health
6. Integrations
7. Data Management
8. Developer Centre
9. Help & Support

Purpose:
Control platform settings, access, diagnostics, integration planning, backups, and support.

---

## 8. Implementation Boundaries For Future UI Phase

Allowed later:

1. Add visible placeholder cards.
2. Add clear labels.
3. Add short descriptions.
4. Add disabled or coming-soon indicators.
5. Group cards visually.
6. Preserve all current working cards.
7. Preserve all existing routes.
8. Preserve all existing page logic.

Not allowed later without separate approval:

1. Backend connections
2. Database migrations
3. Auth changes
4. RBAC changes
5. API changes
6. Real notification wiring
7. Real calendar integration
8. Real document generation
9. Live court system integration
10. Payment gateway setup
11. Client portal live access
12. Mobile app code
13. Legal AI automation
14. Predictive analytics

---

## 9. Files That Should Remain Untouched During This Planning Phase

Do not edit any source files during this documentation branch.

Specifically do not edit:

1. frontend/src/App.jsx
2. frontend/src/App.css
3. frontend/src/pages/Clients.jsx
4. frontend/src/pages/Staff.jsx
5. frontend/src/pages/Page3 or any Page 3-related component
6. backend files
7. database files
8. server files
9. environment files
10. auth or RBAC files
11. API route files

This branch should only add:

docs/phase-14/implementation-plan/PHASE_14F_NAVIGATION_PLACEHOLDER_PLAN_20260704.md

---

## 10. Recommended Future UI Branch

Recommended future branch name:

feature/14f-dashboard-navigation-placeholders

Recommended future scope:

- Add placeholder cards only.
- Do not wire functionality.
- Do not alter backend.
- Do not alter database.
- Do not alter auth.
- Do not alter Page 3.
- Do not remove current dashboard cards.
- Do not rename current working routes without review.

---

## 11. Suggested Placeholder Copy

Recommended placeholder badge:

Coming Soon

Recommended disabled helper text:

Navigation placeholder only. Functionality not enabled yet.

Recommended safety note:

This card is visual-only and must not be connected to backend, database, auth, RBAC, court filing, payment, AI, or document generation logic during Phase 14F-B.

---

## 12. Acceptance Criteria

This documentation task is complete only when:

1. This file exists at:
   docs/phase-14/implementation-plan/PHASE_14F_NAVIGATION_PLACEHOLDER_PLAN_20260704.md

2. The plan identifies the first placeholder cards.

3. The plan defines recommended placement.

4. The plan defines placeholder descriptions.

5. The plan defines what must not be connected yet.

6. The plan protects Page 3 locked controls.

7. The plan confirms no source files were edited.

8. Git status shows only this documentation file changed before commit.

9. The branch is committed and pushed.

10. A checkpoint tag is created after push.

---

## 13. Recommended Commit Message

Recommended commit message:

docs: add Phase 14F navigation placeholder plan

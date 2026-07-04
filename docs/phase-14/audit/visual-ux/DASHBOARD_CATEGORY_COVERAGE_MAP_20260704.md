# DASHBOARD CATEGORY COVERAGE MAP

Project:
Litigation 360 / LEOS

Branch:
audit/14f-dashboard-category-coverage-map

Date:
2026-07-04

Status:
DOCUMENTATION ONLY / DASHBOARD CATEGORY AUDIT ONLY / NO SOURCE EDITS

Purpose:
Audit the main dashboard category structure and define a complete, gap-free navigation and category model before any UI implementation.

---

## 1. Current Dashboard Structure Observed

The current main dashboard displays the following major areas:

- LEOS Legal Workspace Command Hub
- Litigation 360 LEOS Workspace
- Legal Operations Command Centre
- Priority Actions
- Today’s Tasks
- Notifications & Alerts
- Live Backend Modules
- Failed Checks
- Last Refresh

### Start Workflow

Current visible cards:

1. Preliminary Assessment & Triage
2. Matter Opening & Client Gate
3. Client Details / Authority & Conflict

### Active Legal Work

Current visible cards:

4. Case / Matter Details
5. Matter Workspace
6. Court Dates
7. Documents & Evidence Readiness

### Completion

Current visible card:

8. Draft Engagement Preview

### Admin

Current visible card:

- Staff

### Future Planned Platform Modules

Current visible future modules:

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

---

## 2. Gap Analysis Within Existing Main Categories

## 2.1 Legal Operations Command Centre

### Current Coverage

The command centre already provides a useful high-level operational overview through:

- Priority actions
- Today’s tasks
- Notifications and alerts
- Backend module count
- Failed checks
- Last refresh timestamp

### Missing Subcategories

Recommended additions:

1. My Work
2. Recent Activity
3. Firm-Wide Workload
4. Critical Deadlines
5. Escalations
6. Blocked Items Detail
7. Failed Checks Detail
8. System Health Detail
9. Data Quality Warnings
10. Global Search

### Rationale

The current command centre is strong as a summary layer, but it needs drill-down homes for work ownership, risk, failed checks, recent changes, and search. Without these, the dashboard can show alerts but does not clearly tell the user where to investigate them.

Priority:
VERY HIGH

Implementation Recommendation:
Add as visual/navigation placeholders first. Do not connect backend logic yet.

---

## 2.2 Start Workflow

### Current Coverage

The dashboard currently includes:

1. Preliminary Assessment & Triage
2. Matter Opening & Client Gate
3. Client Details / Authority & Conflict

### Missing Subcategories

Recommended improved workflow:

1. New Enquiry Intake
2. Preliminary Assessment & Triage
3. Client Identity / KYC
4. Parties & Conflict Check
5. Matter Type Selection
6. Jurisdiction / Court / Forum
7. Limitation Date Capture
8. Fee Quote / Retainer Setup
9. Engagement Letter & Client Approval
10. Matter Opening Confirmation

### Rationale

The current start workflow begins too late. A complete legal intake journey should start from enquiry capture, then proceed through identity, parties, conflict, matter classification, jurisdiction, limitation risk, fee/retainer setup, and engagement approval.

Priority:
VERY HIGH

Implementation Recommendation:
Do not replace the existing cards yet. Add missing categories to the planned navigation model first.

---

## 2.3 Active Legal Work

### Current Coverage

The dashboard currently includes:

4. Case / Matter Details
5. Matter Workspace
6. Court Dates
7. Documents & Evidence Readiness

### Missing Subcategories

Recommended improved active legal work model:

1. Matter Overview
2. Matter Timeline
3. Matter Tasks & Checklist
4. Calendar & Deadlines
5. Documents & Evidence
6. Pleadings & Court Filings
7. Communications & Notes
8. Parties & Contacts
9. Billing & Disbursements
10. Risk & Compliance
11. Internal Review & Approvals
12. Closure / Archive

### Rationale

Active legal work requires more than matter details and documents. The system needs clear homes for timeline, tasks, communications, parties, filings, billing, risk, approvals, and closure.

Priority:
VERY HIGH

Implementation Recommendation:
Create placeholders only in the next phase. Do not change existing matter logic yet.

---

## 2.4 Completion

### Current Coverage

The completion section currently contains:

8. Draft Engagement Preview

### Recommended Rename

Rename Completion to:

Review, Approval & Activation

### Recommended Subcategories

1. Final Intake Review
2. Draft Engagement Preview
3. Approval Gate
4. Client Acceptance / Signature
5. Matter Activation
6. Rework / Rejection Route
7. Submission Log
8. Handover to Active Work

### Rationale

Completion is too narrow as currently structured. Draft Engagement Preview is only one part of the final review process. A legal workflow also needs approval, acceptance, activation, rework handling, and handover.

Priority:
HIGH

Implementation Recommendation:
Rename only after Page 3 and current dashboard locks are preserved.

---

## 2.5 Admin

### Current Coverage

The Admin section currently shows only:

- Staff

### Missing Subcategories

Recommended Admin expansion:

1. Staff
2. User Accounts
3. Roles & Permissions
4. Teams / Departments
5. Firm Profile
6. Matter Types
7. Workflow Rules
8. Notification Rules
9. Templates
10. Billing Settings
11. Court / Agency Settings
12. Audit Logs
13. Security Settings
14. Data Retention
15. Backup / Restore
16. Import / Export
17. Integration Settings
18. System Health
19. Developer Controls

### Rationale

Admin cannot only contain staff management. A complete legal operations platform requires users, permissions, firm configuration, workflows, templates, notification rules, billing settings, audit logs, security, data controls, integrations, and system health.

Priority:
VERY HIGH

Implementation Recommendation:
Admin should be split into People, Firm Settings, Legal Configuration, Security, System, Integrations, Finance Setup, and Audit & Compliance.

---

## 2.6 Future Planned Platform Modules

### Current Issue

The future planned modules mix different types of concepts:

- Functional modules
- Role views
- Analytics
- AI
- Integrations
- Client access
- Mobile access
- Marketplace
- Automation

### Recommended Grouping

1. Core Operations
   - Tasks
   - Notifications
   - Workflow Automation

2. Role Dashboards
   - Lawyer View
   - Clerk View
   - Admin View
   - Finance View
   - Partner View

3. Intelligence
   - Legal AI
   - Predictive Analytics
   - Executive Command Centre

4. Knowledge & Content
   - Knowledge Management

5. External Access
   - Client Portal
   - Mobile App

6. Integrations
   - Court Navigation
   - Government Integrations

7. Ecosystem
   - Marketplace

8. Automation & Monitoring
   - Autonomous Operations

### Rationale

Grouping future modules makes the roadmap easier to scan and prevents unrelated modules from appearing as one flat list.

Priority:
MEDIUM HIGH

Implementation Recommendation:
Group visually later. No functional implementation yet.

---

## 3. Missing Main Categories To Introduce

| Main Category | Purpose | Recommended Subcategories | Priority | Implementation Timing |
|---|---|---|---|---|
| My Work | Personal dashboard for each user | My Tasks, My Deadlines, My Matters, My Approvals, My Drafts, My Alerts | Very High | Add placeholder next |
| Clients & Parties | Central home for people and organizations | Clients, Opposing Parties, Witnesses, Lawyers, Courts, Agencies, Conflict Links | Very High | Add placeholder next |
| Matter Registry | Master list of all matters | All Matters, Open, Pending, Blocked, Closed, Archived, Ownership | Very High | Add placeholder next |
| Calendar & Deadline Centre | Central date control | Court Dates, Filing Deadlines, Limitation Dates, Meetings, Review Dates, Reminder Rules | Very High | Add placeholder next |
| Communications Centre | Correspondence and notes | Emails, Letters, Court Correspondence, Internal Notes, Call Logs, Meeting Notes | Very High | Add placeholder next |
| Finance & Billing | Matter-related finance | Fee Quotes, Retainers, Invoices, Payments, Disbursements, Time Tracking | High | Later |
| Risk, Compliance & Audit | Legal and operational safety | Conflict Register, Limitation Risk, Missing Authority, Audit Trail, Access Logs | Very High | Add placeholder next |
| Templates & Content Management | Reusable legal content | Letter Templates, Pleadings, Affidavits, Checklists, Clause Bank, Version History | High | Later |
| Reports & Analytics | Management reporting | Matter Reports, Deadline Reports, Staff Reports, Billing Reports, Risk Reports | High | Later |
| System Settings & Configuration | Platform behaviour control | Firm Settings, Workflow Settings, Notification Settings, Court Settings, Feature Flags | Very High | Add placeholder next |
| User Account & Preferences | User self-management | Profile, Password, 2FA, Notifications, Theme, Signature, Sessions | High | Later |
| Help, Training & Support | User guidance | Help Centre, User Guide, FAQ, Support Tickets, Bug Report, Release Notes | Medium High | Add placeholder next |
| Integrations Centre | External system connections | Email, Calendar, Storage, Court Portals, Government Systems, E-Signature, API Keys | High | Later |
| Data Management | Data safety and migration | Import, Export, Backup, Restore, Cleanup, Duplicate Detection, Retention Rules | High | Later |
| Developer Centre | Technical diagnostics | Environment Status, Failed Checks, Feature Flags, Logs, Build Notes | Medium High | Later |

---

## 4. Recommended Final Dashboard Category Structure

## Layer 1: Daily Work

Recommended main areas:

1. Command Hub
2. My Work
3. Tasks
4. Notifications
5. Calendar & Deadlines

Purpose:
This layer gives each user immediate visibility over daily responsibilities, urgent work, deadlines, and alerts.

---

## Layer 2: Legal Operations

Recommended main areas:

1. Intake & Engagement
2. Clients & Parties
3. Matter Registry
4. Matter Workspace
5. Documents & Evidence
6. Communications
7. Court Work
8. Review & Completion

Purpose:
This layer contains the core legal workflow from enquiry to matter handling, documents, evidence, court work, and completion.

---

## Layer 3: Firm Management

Recommended main areas:

1. Staff
2. Finance & Billing
3. Reports & Analytics
4. Risk, Compliance & Audit
5. Templates & Content Management
6. Knowledge Management

Purpose:
This layer supports firm-level administration, financial tracking, risk control, reporting, and reusable content.

---

## Layer 4: Platform Control

Recommended main areas:

1. Admin & Settings
2. User Accounts
3. Roles & Permissions
4. System Health
5. Integrations
6. Data Management
7. Developer Centre
8. Help & Support

Purpose:
This layer controls system configuration, access, integrations, backups, diagnostics, and support.

---

## 5. Priority Implementation Order

## Phase 14F-A: Documentation Lock

Scope:

- Create this category coverage map.
- No source edits.
- Commit documentation only.

Status:
CURRENT TASK

---

## Phase 14F-B: Navigation Placeholder Plan

Scope:

- Add safe UI placeholder cards later.
- No backend connection.
- No database changes.
- No real functionality yet.

Highest priority placeholder cards:

1. My Work
2. Clients & Parties
3. Matter Registry
4. Calendar & Deadline Centre
5. Communications Centre
6. Risk, Compliance & Audit
7. Admin Settings
8. System Configuration
9. Help & Support

---

## Phase 14F-C: Sidebar / Dashboard Grouping

Scope:

- Group visible dashboard modules into cleaner sections.
- Keep existing cards working.
- Do not remove working modules.
- Do not rename working routes without confirmation.

---

## Phase 14F-D: Role-Based Expansion

Scope:

- Lawyer View
- Clerk View
- Admin View
- Finance View
- Partner View

---

## Phase 14F-E: Settings / Permissions / Audit

Scope:

- User accounts
- Roles
- Permissions
- Audit logs
- Access logs
- Security settings

---

## Phase 14F-F: Advanced Modules

Scope:

- Legal AI
- Predictive Analytics
- Marketplace
- Autonomous Operations
- Mobile App

---

## 6. Do-Not-Implement-Yet List

The following must not be implemented during this documentation/audit phase:

1. Legal AI automation
2. Predictive analytics
3. Marketplace
4. Autonomous operations
5. Government live integrations
6. Backend permissions
7. Database migrations
8. Payment gateway
9. Client portal live access
10. Mobile app
11. Real document generation
12. Real court filing integration
13. Authentication or RBAC changes
14. Server/API route changes
15. Production logic changes

---

## 7. Immediate Next Recommended UI Additions

The next implementation phase should add only placeholder-level navigation or cards.

Recommended highest-priority placeholder cards:

1. My Work
2. Clients & Parties
3. Matter Registry
4. Calendar & Deadline Centre
5. Communications Centre
6. Risk, Compliance & Audit
7. Admin Settings
8. System Configuration
9. Help & Support

Important:
These should first be added as visual/navigation placeholders only. They should not be connected to real backend modules, database tables, live integrations, document generation, AI automation, or court systems.

---

## 8. Acceptance Criteria

This audit is complete only when:

1. This file exists at:
   docs/phase-14/audit/visual-ux/DASHBOARD_CATEGORY_COVERAGE_MAP_20260704.md

2. The current dashboard structure is documented.

3. Missing categories are listed.

4. Missing subcategories are listed.

5. Proposed final structure is included.

6. Priority order is included.

7. Do-not-implement-yet items are clearly stated.

8. No source code was edited.

9. Git status shows only this new documentation file changed.

---

## 9. Safety Confirmation

This file is documentation-only.

No frontend source files were edited.

No backend source files were edited.

No database files were edited.

No auth, RBAC, API route, server, environment, or production logic files were edited.

Locked Page 3 controls remain protected:

- Page 3 Required / Complete / Missing counter
- Page 3 alphabet filter structured control
- Page 3 real percentage calculation

---

## 10. Recommended Commit Message

Recommended commit message:

docs: add dashboard category coverage map

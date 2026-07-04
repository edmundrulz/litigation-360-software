# PHASE 14F ROLE-BASED EXPANSION PLAN

Project:
Litigation 360 / LEOS

Repository:
edmundrulz/litigation-360-software

Branch:
docs/14f-role-based-expansion-plan

Date:
2026-07-04

Status:
DOCUMENTATION ONLY / ROLE-BASED EXPANSION PLAN ONLY / NO SOURCE EDITS

---

## 1. Purpose

This document defines the safe future role-based dashboard expansion model for the LEOS / Litigation 360 platform.

This phase does not authorize UI implementation.

The goal is to define how role-based views should eventually be structured before any frontend, backend, RBAC, authentication, database, or permission logic is changed.

---

## 2. Safety Rules

This branch is documentation-only.

Do not edit:

1. frontend source files
2. backend source files
3. database files
4. auth files
5. RBAC files
6. API route files
7. server files
8. environment files
9. production logic
10. locked Page 3 controls

Protected Page 3 controls:

- Page 3 Required / Complete / Missing counter
- Page 3 alphabet filter structured control
- Page 3 real percentage calculation

No role-based permissions are to be implemented in this phase.

No real access control changes are authorized in this phase.

---

## 3. Related Completed Work

### Phase 14F-A Dashboard Category Coverage Map

Branch:

audit/14f-dashboard-category-coverage-map

Commit:

8ddd3ce docs: add dashboard category coverage map

File:

docs/phase-14/audit/visual-ux/DASHBOARD_CATEGORY_COVERAGE_MAP_20260704.md

Checkpoint tag:

checkpoint/phase-14f-dashboard-category-coverage-map-20260704

Status:

COMPLETE / PUSHED / TAGGED

---

### Phase 14F-B Navigation Placeholder Plan

Branch:

docs/14f-navigation-placeholder-plan

Commits:

- d14d0ab docs: add Phase 14F navigation placeholder plan
- 25881f2 docs: close phase 14f navigation placeholder plan
- 4cdfdaf docs: add current thread final handover

Tags:

- checkpoint/phase14f-navigation-placeholder-plan-20260704
- checkpoint/phase14f-navigation-placeholder-closeout-20260704
- checkpoint/current-thread-final-handover-20260704

Status:

COMPLETE / PUSHED / TAGGED / CLOSED / CLEAN

---

### Phase 14F-C Dashboard / Sidebar Grouping Plan

Branch:

docs/14f-dashboard-sidebar-grouping-plan

Commit:

8a585f8 docs: add Phase 14F dashboard sidebar grouping plan

File:

docs/phase-14/implementation-plan/PHASE_14F_DASHBOARD_SIDEBAR_GROUPING_PLAN_20260704.md

Checkpoint tag:

checkpoint/phase-14f-dashboard-sidebar-grouping-plan-20260704

Status:

COMPLETE / PUSHED / TAGGED / CLEAN

---

## 4. Objective Of Role-Based Expansion

The future platform should eventually support separate views for different user roles.

The purpose of role-based expansion is to reduce clutter, improve user focus, and show each user only the work areas most relevant to their responsibilities.

Important:

This document only defines the role view model.

It does not implement authentication.

It does not implement RBAC.

It does not implement permissions.

It does not hide or expose real data.

It does not change routes.

It does not change backend logic.

---

## 5. Recommended Role Views

The recommended role views are:

1. Lawyer View
2. Clerk View
3. Admin View
4. Finance View
5. Partner View
6. Client Portal View
7. Developer / System Operator View

The first five are internal firm roles.

Client Portal View is external-facing and should be treated as future-only.

Developer / System Operator View is internal technical-control only and should not be exposed to ordinary users.

---

## 6. Role View: Lawyer View

## 6.1 Purpose

The Lawyer View should help lawyers manage legal judgment, matter progress, court work, client advice, evidence, documents, and approvals.

## 6.2 Recommended Dashboard Areas

1. My Work
2. My Matters
3. Court Dates
4. Filing Deadlines
5. Documents & Evidence
6. Pleadings & Drafts
7. Client Communications
8. Internal Review & Approvals
9. Risk & Limitation Alerts
10. Matter Timeline

## 6.3 Recommended Cards

1. Assigned Matters
2. Urgent Court Deadlines
3. Drafts Awaiting Review
4. Client Instructions Pending
5. Evidence Gaps
6. Upcoming Hearings
7. Limitation Risk
8. Partner Approval Required
9. Recently Updated Matters
10. Notes / Attendance Records

## 6.4 Not For Initial Implementation

Do not implement:

1. Real permission filtering
2. Legal AI drafting
3. Court filing submission
4. Automated advice generation
5. Real limitation calculation
6. Real document generation

Implementation status:

Future placeholder only.

---

## 7. Role View: Clerk View

## 7.1 Purpose

The Clerk View should help clerks manage filings, bundles, document readiness, court dates, reminders, administrative follow-up, and routine matter processing.

## 7.2 Recommended Dashboard Areas

1. Filing Queue
2. Court Dates
3. Document Checklist
4. Bundle Preparation
5. Client Follow-Up
6. Internal Task Queue
7. Missing Information
8. Service / Dispatch Tracking
9. Hearing Preparation Support
10. Completion Checklist

## 7.3 Recommended Cards

1. Documents To File
2. Bundle Preparation
3. Missing Documents
4. Court Date Reminders
5. Filing Blocked
6. Client Follow-Up Needed
7. Service Deadline
8. Dispatch / Delivery Tracking
9. Hearing Pack Preparation
10. Admin Notes

## 7.4 Not For Initial Implementation

Do not implement:

1. Real court portal integration
2. Real filing submission
3. Automated bundle creation
4. Real deadline computation
5. External dispatch integration
6. Real client communication automation

Implementation status:

Future placeholder only.

---

## 8. Role View: Admin View

## 8.1 Purpose

The Admin View should help administrative users manage staff records, users, workflow setup, firm details, matter configuration, templates, notifications, and platform administration.

## 8.2 Recommended Dashboard Areas

1. Staff
2. User Accounts
3. Teams / Departments
4. Firm Profile
5. Workflow Rules
6. Matter Types
7. Notification Rules
8. Templates
9. System Configuration
10. Help / Support Control

## 8.3 Recommended Cards

1. Staff Directory
2. User Accounts
3. Team Assignments
4. Firm Settings
5. Matter Type Setup
6. Workflow Setup
7. Notification Rules
8. Template Library
9. System Health Summary
10. Support Requests

## 8.4 Not For Initial Implementation

Do not implement:

1. Real user creation
2. Password or login changes
3. RBAC changes
4. Production settings changes
5. Environment file edits
6. Server configuration changes

Implementation status:

Future placeholder only.

---

## 9. Role View: Finance View

## 9.1 Purpose

The Finance View should help finance users manage fee quotes, retainers, invoices, payments, disbursements, outstanding balances, billing reports, and matter-level financial tracking.

## 9.2 Recommended Dashboard Areas

1. Fee Quotes
2. Retainers
3. Invoices
4. Payments
5. Disbursements
6. Outstanding Balances
7. Billing Reports
8. Time Tracking
9. Finance Approvals
10. Matter Financial Summary

## 9.3 Recommended Cards

1. Pending Fee Quotes
2. Retainers Awaiting Payment
3. Draft Invoices
4. Overdue Invoices
5. Payment Received
6. Disbursements Pending Review
7. Matter Balances
8. Billing Approval Queue
9. Finance Reports
10. Export Ready Reports

## 9.4 Not For Initial Implementation

Do not implement:

1. Payment gateway
2. Real invoice generation
3. Accounting system integration
4. Tax calculation
5. Real payment records
6. Financial export automation

Implementation status:

Future placeholder only.

---

## 10. Role View: Partner View

## 10.1 Purpose

The Partner View should provide senior oversight over legal risk, matter progress, staff workload, client approvals, financial position, escalations, reports, and executive-level firm performance.

## 10.2 Recommended Dashboard Areas

1. Executive Command Centre
2. Firm-Wide Workload
3. Matter Risk Overview
4. Critical Deadlines
5. Approval Queue
6. Financial Overview
7. Staff Workload
8. Client Risk
9. Reports & Analytics
10. Escalations

## 10.3 Recommended Cards

1. Critical Matters
2. High-Risk Deadlines
3. Approval Required
4. Blocked Matters
5. Staff Capacity
6. Revenue Snapshot
7. Outstanding Client Decisions
8. Compliance Warnings
9. Recently Escalated Items
10. Management Reports

## 10.4 Not For Initial Implementation

Do not implement:

1. Real executive analytics
2. Predictive analytics
3. Financial dashboard wiring
4. Firm-wide permission filtering
5. AI-generated risk scoring
6. Automated escalation logic

Implementation status:

Future placeholder only.

---

## 11. Role View: Client Portal View

## 11.1 Purpose

The Client Portal View should eventually give clients controlled external access to matter updates, documents, approvals, invoices, messages, and appointment information.

## 11.2 Recommended Dashboard Areas

1. My Matter Status
2. Documents Shared With Me
3. Approvals Required
4. Messages
5. Appointments
6. Invoices / Payments
7. Instructions Requested
8. Secure Upload
9. Help / Support

## 11.3 Recommended Cards

1. Matter Summary
2. Next Step
3. Documents To Review
4. Signatures Required
5. Messages From Firm
6. Upcoming Appointments
7. Invoice Status
8. Upload Requested Documents
9. Contact Firm

## 11.4 Strict Future-Only Restriction

Client Portal View must remain future-only until security, authentication, permissions, data isolation, audit logging, and external access controls are fully designed and approved.

Do not implement:

1. Client login
2. External access
3. Document sharing
4. Upload portal
5. Messaging
6. Payment gateway
7. E-signature
8. Client-specific permissions

Implementation status:

Future only.

---

## 12. Role View: Developer / System Operator View

## 12.1 Purpose

The Developer / System Operator View should eventually help technical operators inspect diagnostics, build status, failed checks, feature flags, environment status, deployment safety, and system logs.

## 12.2 Recommended Dashboard Areas

1. System Health
2. Failed Checks
3. Diagnostics
4. Feature Flags
5. Build Notes
6. Environment Status
7. Integration Logs
8. Backup Status
9. Release Notes
10. Developer Handover

## 12.3 Recommended Cards

1. Failed Checks Detail
2. Backend Module Status
3. Frontend Build Status
4. Environment Review
5. Feature Flag Register
6. API Health
7. Integration Logs
8. Backup Status
9. Recent Deployments
10. Developer Notes

## 12.4 Not For Initial Implementation

Do not implement:

1. Real system logs
2. Environment file editing
3. Deployment controls
4. Production toggles
5. Secret management
6. Server diagnostics

Implementation status:

Future placeholder only.

---

## 13. Recommended Role-Based Navigation Model

Future sidebar or dashboard role filter should support:

1. All View
2. Lawyer View
3. Clerk View
4. Admin View
5. Finance View
6. Partner View
7. Client Portal View
8. Developer View

Initial implementation should not enforce permissions.

Initial implementation, when approved, should only show visual role-view placeholders.

Recommended label:

Role Views

Recommended helper text:

Role-based placeholders only. Permission filtering not enabled yet.

---

## 14. Relationship Between Role Views And Main Navigation Layers

Role views should not replace the main navigation structure.

Role views should sit above or beside the main four-layer model:

1. Daily Work
2. Legal Operations
3. Firm Management
4. Platform Control

Role views should act as filtered perspectives.

Example:

- Lawyer View emphasizes matters, court dates, documents, evidence, and approvals.
- Clerk View emphasizes filings, checklists, bundles, reminders, and document readiness.
- Admin View emphasizes staff, users, workflows, templates, and settings.
- Finance View emphasizes quotes, invoices, payments, retainers, and disbursements.
- Partner View emphasizes risk, workload, approvals, reports, and escalation.
- Client Portal View is external-facing and future-only.
- Developer View is internal technical-control only.

---

## 15. Implementation Boundaries For Future UI Work

Allowed later with approval:

1. Add visual role-view section.
2. Add role-view placeholder cards.
3. Add Coming Soon badges.
4. Add non-functional role selector.
5. Add role-view descriptions.
6. Preserve existing cards and routes.
7. Preserve Page 3 locks.
8. Preserve backend and database.

Not allowed without separate approval:

1. Real RBAC
2. Auth changes
3. User permission logic
4. Data filtering by role
5. Backend route protection
6. Database schema changes
7. Client external access
8. Financial integrations
9. Court integrations
10. AI automation
11. Predictive analytics
12. Production logic changes

---

## 16. Recommended Future Implementation Branch

Recommended branch name:

feature/14f-role-view-placeholders

Recommended future scope:

1. Add role-view placeholder section only.
2. Add non-functional role cards.
3. Add Coming Soon indicators.
4. Do not wire auth.
5. Do not implement RBAC.
6. Do not filter data.
7. Do not touch backend, database, auth, RBAC, API routes, server files, or environment files.
8. Do not touch locked Page 3 controls.

---

## 17. Acceptance Criteria

This planning branch is complete only when:

1. This file exists at:
   docs/phase-14/implementation-plan/PHASE_14F_ROLE_BASED_EXPANSION_PLAN_20260704.md

2. Lawyer View is documented.

3. Clerk View is documented.

4. Admin View is documented.

5. Finance View is documented.

6. Partner View is documented.

7. Client Portal View is marked future-only.

8. Developer / System Operator View is documented.

9. Implementation boundaries are documented.

10. Page 3 locks are protected.

11. No source files are edited.

12. Git status shows only this documentation file changed before commit.

13. Branch is committed and pushed.

14. Checkpoint tag is created and pushed.

---

## 18. Safety Confirmation

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

## 19. Recommended Commit Message

Recommended commit message:

docs: add Phase 14F role-based expansion plan

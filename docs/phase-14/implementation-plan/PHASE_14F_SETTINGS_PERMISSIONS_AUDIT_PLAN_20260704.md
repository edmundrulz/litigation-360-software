# PHASE 14F SETTINGS / PERMISSIONS / AUDIT PLAN

Project:
Litigation 360 / LEOS

Repository:
edmundrulz/litigation-360-software

Branch:
docs/14f-settings-permissions-audit-plan

Date:
2026-07-04

Status:
DOCUMENTATION ONLY / SETTINGS PERMISSIONS AUDIT PLAN ONLY / NO SOURCE EDITS

---

## 1. Purpose

This document defines the safe future planning model for platform settings, user accounts, roles, permissions, audit trails, access logs, security settings, and system control areas.

This phase does not authorize implementation.

This document is a planning/control-layer document only.

---

## 2. Safety Rules

Do not edit:

1. frontend source files
2. backend source files
3. database files
4. authentication files
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

This branch must not implement:

1. login changes
2. user creation
3. password reset
4. real RBAC
5. permission filtering
6. backend route protection
7. access control enforcement
8. audit log storage
9. security configuration changes
10. database migrations

---

## 3. Related Completed Phase 14F Work

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

Checkpoint tag:
checkpoint/phase-14f-dashboard-sidebar-grouping-plan-20260704

Status:
COMPLETE / PUSHED / TAGGED / CLEAN

---

### Phase 14F-D Role-Based Expansion Plan

Branch:
docs/14f-role-based-expansion-plan

Checkpoint tag:
checkpoint/phase-14f-role-based-expansion-plan-20260704

Status:
COMPLETE / PUSHED / TAGGED / CLEAN

---

## 4. Objective

The future platform should eventually include a controlled settings, permissions, and audit structure.

The objective is to define the model before implementation so future work can be handled safely and without accidental backend, database, authentication, or RBAC changes.

This plan covers:

1. user accounts
2. staff account mapping
3. role definitions
4. permission categories
5. access logs
6. audit trails
7. security settings
8. firm settings
9. notification settings
10. workflow settings
11. system configuration
12. implementation boundaries

---

## 5. Recommended Main Settings Areas

The future settings area should be split into these main groups:

1. User Accounts
2. Roles & Permissions
3. Staff / User Mapping
4. Firm Settings
5. Workflow Settings
6. Notification Settings
7. Security Settings
8. Audit Logs
9. Access Logs
10. Data Retention
11. System Configuration
12. Integration Settings
13. Developer Controls

---

## 6. User Accounts Planning Model

## 6.1 Purpose

User Accounts should eventually control platform login identities and user-level profile records.

## 6.2 Recommended Fields

1. full name
2. email address
3. role
4. department
5. status
6. assigned matters
7. last login
8. account created date
9. account updated date
10. account disabled date

## 6.3 Recommended Account Statuses

1. Active
2. Invited
3. Pending Setup
4. Suspended
5. Disabled
6. Archived

## 6.4 Not For Current Implementation

Do not implement:

1. account creation
2. login logic
3. password storage
4. password reset
5. invitation emails
6. account suspension logic
7. backend user table changes

Status:
Future planning only.

---

## 7. Roles & Permissions Planning Model

## 7.1 Recommended Internal Roles

1. Lawyer
2. Clerk
3. Admin
4. Finance
5. Partner
6. System Operator
7. Read-Only Reviewer

## 7.2 Recommended External Roles

1. Client
2. External Counsel
3. Auditor
4. Government / Court Portal User

External roles are future-only and must not be implemented until security design is approved.

## 7.3 Recommended Permission Groups

1. Matter Access
2. Client Access
3. Document Access
4. Court Date Access
5. Finance Access
6. Staff Access
7. Reports Access
8. Settings Access
9. Audit Access
10. Developer Access

## 7.4 Recommended Permission Levels

1. View
2. Create
3. Edit
4. Delete
5. Approve
6. Export
7. Assign
8. Configure
9. Archive
10. Full Control

## 7.5 Not For Current Implementation

Do not implement:

1. real RBAC
2. permission middleware
3. backend route protection
4. frontend route hiding
5. database permission tables
6. access enforcement logic

Status:
Future planning only.

---

## 8. Staff / User Mapping

## 8.1 Purpose

The platform should eventually distinguish between staff records and login accounts.

A staff record may exist without login access.

A user account may map to a staff profile.

## 8.2 Recommended Mapping States

1. Staff Only
2. User Account Only
3. Staff Linked To User Account
4. Disabled Staff
5. Archived Staff
6. External Contact

## 8.3 Rationale

This prevents accidental confusion between human resource records and system login permissions.

## 8.4 Not For Current Implementation

Do not change the current Staff page.

Do not modify Staff.jsx.

Do not create user-account logic.

Status:
Future planning only.

---

## 9. Audit Logs Planning Model

## 9.1 Purpose

Audit Logs should eventually record important actions across the platform.

## 9.2 Recommended Audit Events

1. matter created
2. matter updated
3. matter archived
4. client updated
5. document uploaded
6. document downloaded
7. document deleted
8. court date changed
9. deadline changed
10. approval granted
11. approval rejected
12. permission changed
13. user account changed
14. login event
15. failed login event
16. export generated
17. setting changed
18. integration changed

## 9.3 Recommended Audit Fields

1. event ID
2. event type
3. user
4. role
5. affected record
6. previous value
7. new value
8. timestamp
9. IP address
10. device/session reference
11. matter reference
12. severity
13. notes

## 9.4 Not For Current Implementation

Do not implement real audit logging.

Do not add audit tables.

Do not add backend audit middleware.

Status:
Future planning only.

---

## 10. Access Logs Planning Model

## 10.1 Purpose

Access Logs should eventually show who accessed what and when.

## 10.2 Recommended Access Log Events

1. successful login
2. failed login
3. logout
4. session expired
5. page accessed
6. matter viewed
7. document viewed
8. document exported
9. report viewed
10. settings viewed
11. admin area accessed
12. developer area accessed

## 10.3 Recommended Risk Flags

1. unusual login time
2. repeated failed login
3. export of sensitive records
4. access from unknown device
5. access to high-risk matter
6. admin setting change
7. permission change

## 10.4 Not For Current Implementation

Do not implement session tracking.

Do not modify authentication.

Do not create access log storage.

Status:
Future planning only.

---

## 11. Security Settings Planning Model

## 11.1 Recommended Future Security Settings

1. password policy
2. two-factor authentication
3. session timeout
4. login attempt limit
5. trusted devices
6. IP restriction
7. account lockout
8. password reset rules
9. audit retention
10. export restrictions
11. data download restrictions
12. admin approval for sensitive changes

## 11.2 Security Priority

Security settings should be designed before client portal, external sharing, payment gateway, or government integration work.

## 11.3 Not For Current Implementation

Do not alter security settings.

Do not implement 2FA.

Do not edit environment files.

Do not edit auth files.

Status:
Future planning only.

---

## 12. Firm Settings Planning Model

## 12.1 Recommended Future Firm Settings

1. firm name
2. branch office details
3. firm registration details
4. address
5. phone number
6. email
7. letterhead details
8. default currency
9. default timezone
10. default date format
11. matter numbering format
12. document numbering format

## 12.2 Not For Current Implementation

Do not create settings tables.

Do not wire firm settings to UI.

Do not generate documents from firm settings.

Status:
Future planning only.

---

## 13. Workflow Settings Planning Model

## 13.1 Recommended Future Workflow Settings

1. matter type list
2. intake stages
3. approval gates
4. required document rules
5. required authority rules
6. conflict check rules
7. court date rules
8. deadline reminder rules
9. matter closure rules
10. escalation rules

## 13.2 Not For Current Implementation

Do not change legal workflow logic.

Do not modify current routes.

Do not add workflow automation.

Status:
Future planning only.

---

## 14. Notification Settings Planning Model

## 14.1 Recommended Future Notification Settings

1. deadline reminders
2. court date reminders
3. client approval reminders
4. blocked filing alerts
5. missing document alerts
6. overdue task alerts
7. approval queue alerts
8. finance alerts
9. system health alerts
10. security alerts

## 14.2 Notification Channels

Future channels may include:

1. in-app notification
2. email
3. calendar reminder
4. SMS
5. WhatsApp
6. Slack / Teams

External notification channels are future-only.

## 14.3 Not For Current Implementation

Do not connect notifications to external systems.

Do not create messaging services.

Do not wire Gmail, Outlook, SMS, WhatsApp, Slack, or Teams.

Status:
Future planning only.

---

## 15. System Configuration Planning Model

## 15.1 Recommended Future System Areas

1. feature flags
2. environment status
3. module registry
4. failed checks detail
5. health checks
6. integration settings
7. backup settings
8. export settings
9. import settings
10. developer diagnostics

## 15.2 Not For Current Implementation

Do not edit server files.

Do not edit environment files.

Do not create diagnostics APIs.

Do not add feature flag enforcement.

Status:
Future planning only.

---

## 16. Risk Controls Before Any Future Implementation

Before any implementation of settings, permissions, audit logs, or security controls, require:

1. updated SSOT
2. dedicated implementation branch
3. source file impact list
4. database impact assessment
5. auth impact assessment
6. RBAC impact assessment
7. rollback plan
8. test plan
9. Page 3 lock verification
10. no unrelated source edits
11. commit and checkpoint tag after completion

---

## 17. Recommended Future Implementation Order

## Phase 14F-E1: Visual Settings Placeholders

Scope:

1. Add settings placeholder cards only.
2. Add Coming Soon labels.
3. Do not wire functionality.

## Phase 14F-E2: Settings Information Architecture

Scope:

1. Define settings pages.
2. Define routes.
3. Keep pages static.
4. No backend.

## Phase 14F-E3: Audit Log Readiness Plan

Scope:

1. Define audit event schema.
2. Define audit display requirements.
3. No database changes yet.

## Phase 14F-E4: RBAC Technical Design

Scope:

1. Design roles.
2. Design permissions.
3. Design enforcement points.
4. No implementation yet.

## Phase 14F-E5: Security Implementation Review

Scope:

1. Review auth.
2. Review sessions.
3. Review external access risks.
4. Create separate implementation approval.

---

## 18. Recommended Future Branches

Documentation branches:

1. docs/14f-settings-info-architecture
2. docs/14f-audit-log-readiness-plan
3. docs/14f-rbac-technical-design
4. docs/14f-security-implementation-review

Future implementation branch only after approval:

feature/14f-settings-permissions-placeholders

---

## 19. Do-Not-Implement-Yet List

Do not implement yet:

1. real RBAC
2. auth changes
3. login changes
4. user creation
5. permission filtering
6. backend route protection
7. database migrations
8. audit log tables
9. access log tables
10. security settings
11. 2FA
12. client portal access
13. external user access
14. payment security
15. government/court integration security
16. production settings changes

---

## 20. Acceptance Criteria

This planning branch is complete only when:

1. This file exists at:
   docs/phase-14/implementation-plan/PHASE_14F_SETTINGS_PERMISSIONS_AUDIT_PLAN_20260704.md

2. User account planning is documented.

3. Role and permission planning is documented.

4. Staff/user mapping is documented.

5. Audit log planning is documented.

6. Access log planning is documented.

7. Security settings planning is documented.

8. Firm, workflow, notification, and system configuration planning are documented.

9. Do-not-implement-yet restrictions are clear.

10. Page 3 locks are protected.

11. No source files are edited.

12. Git status shows only this documentation file changed before commit.

13. Branch is committed and pushed.

14. Checkpoint tag is created and pushed.

---

## 21. Safety Confirmation

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

## 22. Recommended Commit Message

Recommended commit message:

docs: add Phase 14F settings permissions audit plan

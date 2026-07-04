# PHASE 14F DASHBOARD / SIDEBAR GROUPING PLAN

Project:
Litigation 360 / LEOS

Repository:
edmundrulz/litigation-360-software

Branch:
docs/14f-dashboard-sidebar-grouping-plan

Date:
2026-07-04

Status:
DOCUMENTATION ONLY / DASHBOARD GROUPING PLAN ONLY / NO SOURCE EDITS

---

## 1. Purpose

This document defines the safe grouping plan for the LEOS / Litigation 360 main dashboard and future sidebar/navigation structure.

This phase does not authorize UI implementation.

The goal is to prepare a clean navigation grouping model before any source-code changes are made.

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

No implementation is authorized in this branch.

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

### Main SSOT Insert

Branch:

docs/14f-main-ssot-insert-20260704

Commit:

618bb2c docs: insert Phase 14F handover into main SSOT

File:

docs/phase-14/closeout/CURRENT_THREAD_FINAL_HANDOVER_20260704.md

Checkpoint tag:

checkpoint/phase-14f-main-ssot-insert-20260704

Status:

COMPLETE / PUSHED / TAGGED / CLEAN

---

## 4. Current Dashboard Structure

The current dashboard is organized around these visible areas:

1. Legal Operations Command Centre
2. Priority Actions
3. Today’s Tasks
4. Notifications & Alerts
5. Start Workflow
6. Active Legal Work
7. Completion
8. Admin
9. Future Planned Platform Modules

Current visible cards include:

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

## 5. Current Structural Problem

The current dashboard works as a legal workflow launcher, but it does not yet have a mature grouping structure.

Current issues:

1. Daily user work is mixed with system-wide command information.
2. Legal workflow cards are not separated from firm management cards.
3. Admin currently only exposes Staff.
4. Future planned modules are shown as a flat list.
5. Role-based views are mixed with feature modules.
6. AI, automation, integrations, reporting, and marketplace items are grouped together without hierarchy.
7. There is no clear sidebar-ready category structure yet.
8. There is no clear distinction between active modules, placeholders, future modules, and locked modules.

---

## 6. Recommended Grouping Model

The dashboard and future sidebar should be grouped into four major navigation layers.

---

## Layer 1: Daily Work

Purpose:

Give users immediate access to urgent work, assigned tasks, alerts, deadlines, approvals, and daily operating priorities.

Recommended cards:

1. Command Hub
2. My Work
3. Tasks
4. Notifications
5. Calendar & Deadline Centre

Recommended position:

Top of dashboard and top of sidebar.

Reason:

This layer should answer: What do I need to handle today?

Implementation status:

Placeholder planning only.

---

## Layer 2: Legal Operations

Purpose:

Organize the core legal workflow from enquiry intake through matter handling, documents, evidence, communications, court work, and completion.

Recommended cards:

1. Intake & Engagement
2. Clients & Parties
3. Matter Registry
4. Matter Workspace
5. Documents & Evidence
6. Communications Centre
7. Court Work
8. Review & Completion

Recommended position:

Immediately after Daily Work.

Reason:

This layer should answer: Where is the legal work being processed?

Implementation status:

Placeholder planning only.

---

## Layer 3: Firm Management

Purpose:

Support firm-level supervision, resource management, financial tracking, reporting, compliance, templates, knowledge, and operational standards.

Recommended cards:

1. Staff
2. Finance & Billing
3. Reports & Analytics
4. Risk, Compliance & Audit
5. Templates & Content Management
6. Knowledge Management

Recommended position:

After Legal Operations.

Reason:

This layer should answer: How is the firm being managed?

Implementation status:

Placeholder planning only.

---

## Layer 4: Platform Control

Purpose:

Control users, roles, permissions, system configuration, integrations, data management, diagnostics, developer support, and help resources.

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

Recommended position:

Bottom of sidebar and lower dashboard grouping.

Reason:

This layer should answer: How is the platform configured and maintained?

Implementation status:

Placeholder planning only.

---

## 7. Dashboard Grouping Recommendation

The main dashboard should eventually display cards in this order:

### 7.1 Daily Work

1. Command Hub
2. My Work
3. Tasks
4. Notifications
5. Calendar & Deadline Centre

### 7.2 Legal Operations

1. Intake & Engagement
2. Clients & Parties
3. Matter Registry
4. Matter Workspace
5. Documents & Evidence
6. Communications Centre
7. Court Work
8. Review & Completion

### 7.3 Firm Management

1. Staff
2. Finance & Billing
3. Reports & Analytics
4. Risk, Compliance & Audit
5. Templates & Content Management
6. Knowledge Management

### 7.4 Platform Control

1. Admin Settings
2. User Accounts
3. Roles & Permissions
4. System Configuration
5. System Health
6. Integrations
7. Data Management
8. Developer Centre
9. Help & Support

---

## 8. Sidebar Grouping Recommendation

A future sidebar should use collapsible sections.

Recommended sidebar structure:

1. Daily Work
   - Command Hub
   - My Work
   - Tasks
   - Notifications
   - Calendar & Deadlines

2. Legal Operations
   - Intake & Engagement
   - Clients & Parties
   - Matter Registry
   - Matter Workspace
   - Documents & Evidence
   - Communications
   - Court Work
   - Review & Completion

3. Firm Management
   - Staff
   - Finance & Billing
   - Reports & Analytics
   - Risk, Compliance & Audit
   - Templates
   - Knowledge Management

4. Platform Control
   - Admin Settings
   - User Accounts
   - Roles & Permissions
   - System Configuration
   - System Health
   - Integrations
   - Data Management
   - Developer Centre
   - Help & Support

---

## 9. Active vs Placeholder vs Future Classification

Each dashboard/sidebar item should be classified clearly.

### Active

Existing working or visible modules:

1. Preliminary Assessment & Triage
2. Matter Opening & Client Gate
3. Client Details / Authority & Conflict
4. Case / Matter Details
5. Matter Workspace
6. Court Dates
7. Documents & Evidence Readiness
8. Draft Engagement Preview
9. Staff

### Placeholder

Safe visual-only additions for future navigation:

1. My Work
2. Clients & Parties
3. Matter Registry
4. Calendar & Deadline Centre
5. Communications Centre
6. Risk, Compliance & Audit
7. Admin Settings
8. System Configuration
9. Help & Support

### Future

Advanced or later-stage modules:

1. Legal AI
2. Predictive Analytics
3. Marketplace
4. Autonomous Operations
5. Mobile App
6. Client Portal
7. Government Integrations
8. Live Court Filing
9. Payment Gateway
10. Real Document Generation

---

## 10. Implementation Boundaries For Future UI Work

A future implementation branch may add grouping and placeholders only after approval.

Allowed later:

1. Add visual section headings.
2. Add placeholder cards.
3. Add Coming Soon badges.
4. Group cards into Daily Work, Legal Operations, Firm Management, and Platform Control.
5. Preserve existing cards.
6. Preserve existing routes.
7. Preserve existing Page 3 locks.
8. Preserve existing backend behavior.
9. Preserve existing database state.

Not allowed without separate approval:

1. Backend connection
2. Database migration
3. Auth update
4. RBAC update
5. API route update
6. Court filing integration
7. Payment gateway setup
8. Client portal activation
9. AI automation
10. Predictive analytics
11. Mobile app implementation
12. Real document generation
13. Environment file edits
14. Server file edits

---

## 11. Recommended Future Implementation Branch

Recommended branch name:

feature/14f-dashboard-sidebar-grouping-placeholders

Recommended implementation scope:

1. Add dashboard grouping headings.
2. Add placeholder cards only.
3. Add Coming Soon indicators.
4. Keep current dashboard cards working.
5. Do not remove existing modules.
6. Do not wire backend.
7. Do not touch Page 3.
8. Do not modify database, auth, RBAC, API routes, or server files.

---

## 12. Acceptance Criteria

This planning branch is complete only when:

1. This file exists at:
   docs/phase-14/implementation-plan/PHASE_14F_DASHBOARD_SIDEBAR_GROUPING_PLAN_20260704.md

2. The four-layer grouping model is documented.

3. Dashboard grouping order is documented.

4. Sidebar grouping order is documented.

5. Active, placeholder, and future modules are classified.

6. Future implementation boundaries are documented.

7. Page 3 locks are protected.

8. No source files are edited.

9. Git status shows only this documentation file changed before commit.

10. Branch is committed and pushed.

11. Checkpoint tag is created and pushed.

---

## 13. Safety Confirmation

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

## 14. Recommended Commit Message

Recommended commit message:

docs: add Phase 14F dashboard sidebar grouping plan

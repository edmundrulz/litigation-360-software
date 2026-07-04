# Phase 14E UX Hardening Plan — 2026-07-04

Project:
Litigation 360 / LEOS

Branch:
docs/14e-ux-hardening-plan

Status:
DOCUMENTATION ONLY / PLANNING ONLY / NO SOURCE EDITS

Related Control Tracker:
docs/phase-14/closeout/PHASE_14E_MASTER_CLOSURE_TRACKER.md

Related Audit Report:
docs/phase-14/audit/visual-ux/FULL_INTERFACE_VISUAL_UX_AUDIT_REPORT_20260703.md

Related Audit Handover:
docs/phase-14/closeout/FULL_INTERFACE_VISUAL_UX_AUDIT_HANDOVER_20260704.md

Locked Baseline:
Page 3 Visual + Data Lock remains locked and must not be touched.

---

## 1. Purpose

This document converts the Full Interface Visual UX Audit into a conservative, risk-classified hardening plan.

This plan does not authorize source-code edits.

Its purpose is to decide what should be improved, in what order, and under what safety controls.

---

## 2. Operating Method

All UX hardening must follow the project method known as "N":

1. Audit first
2. Document before changing
3. Work on one isolated branch per item
4. Avoid broad edits
5. Protect already locked components
6. Make only targeted conservative changes
7. Verify before committing
8. Create or update lock files where needed
9. Create handover documentation
10. Commit with clear messages
11. Push only after clean verification
12. Tag major checkpoints only when appropriate
13. Maintain the master closure tracker
14. Never proceed while the current item is unclear, dirty, or unverified

---

## 3. Locked Areas

The following areas are locked and excluded from UX hardening unless a separate unlock branch is explicitly created and approved:

1. Page 3 Required / Complete / Missing counter
2. Page 3 alphabet filter structured control
3. Page 3 real percentage calculation

Do not touch these from any UX hardening branch.

---

## 4. Audit Findings Converted Into Workstreams

| Workstream | Finding | Risk | Recommendation | Source Edits Allowed Now? |
|---|---|---|---|---|
| UX-H1 | Cross-module visual consistency is weak | MEDIUM | Create page-level consistency improvements after mapping shared styles | NO |
| UX-H2 | Action hierarchy is not consistently clear | MEDIUM | Standardize primary, secondary, disabled, and navigation actions | NO |
| UX-H3 | Form density is high in critical workflows | HIGH | Reduce cognitive load through grouping and progressive disclosure only after specific review | NO |
| UX-H4 | Staff page is less polished than stronger modules | LOW / MEDIUM | First candidate for isolated low-risk hardening | NO |
| UX-H5 | Matter Intake Wizard uses different visual language | MEDIUM / HIGH | Audit inline styles and create controlled alignment plan | NO |
| UX-H6 | Planned modules and disabled cards need consistency protection | LOW | Preserve controlled disclosure while improving clarity | NO |
| UX-H7 | Empty, loading, and error states need consistency review | LOW | Documentation and copy standardization first | NO |
| UX-H8 | Tables, filters, counters, and badges need consistency review | MEDIUM | Map before changing because some areas may overlap with locked Page 3 logic | NO |

---

## 5. Recommended Rollout Order

### Step 1 — Documentation Alignment
Status:
CURRENT STEP

Actions:
1. Confirm audit report is present
2. Confirm audit handover is present
3. Confirm master tracker is present
4. Create this hardening plan
5. Commit and push documentation only

Risk:
LOW

Source edits:
NO

---

### Step 2 — Page and Component Risk Map
Recommended branch:
docs/14e-ux-page-component-risk-map

Actions:
1. Create a page-by-page map
2. Create a component-by-component map
3. Identify shared components
4. Identify CSS dependencies
5. Identify locked Page 3 overlap
6. Identify first safe implementation candidate

Risk:
LOW

Source edits:
NO

---

### Step 3 — First Low-Risk UX Hardening Candidate
Recommended branch:
fix/14e-staff-page-visual-alignment

Reason:
The audit identifies Staff page as less mature, and it is likely safer than touching shared data logic, Page 3, or the Matter Intake Wizard.

Risk:
LOW / MEDIUM

Source edits:
Only after user approval.

---

### Step 4 — Action Hierarchy Standardization
Recommended branch:
fix/14e-action-hierarchy-standardization

Actions:
1. Map all buttons first
2. Identify primary vs secondary vs navigation actions
3. Avoid changing workflows
4. Avoid changing data logic
5. Verify all pages visually

Risk:
MEDIUM

Source edits:
Only after separate approval.

---

### Step 5 — Cross-Module Visual Consistency
Recommended branch:
fix/14e-cross-module-visual-consistency

Actions:
1. Compare Clients, Cases, Deadlines, Documents, Staff, and Matter Intake Wizard
2. Identify reusable style patterns
3. Avoid large CSS refactors
4. Apply small consistency fixes only

Risk:
MEDIUM

Source edits:
Only after separate approval.

---

### Step 6 — Matter Intake Wizard Visual Alignment
Recommended branch:
fix/14e-matter-intake-wizard-visual-alignment

Actions:
1. Audit inline styles
2. Map layout differences
3. Avoid functional changes
4. Align visual language gradually

Risk:
MEDIUM / HIGH

Source edits:
Only after separate approval.

---

### Step 7 — Form Density Hardening
Recommended branch:
fix/14e-form-density-hardening

Actions:
1. Do not remove fields
2. Do not change validation logic
3. Do not change data capture requirements
4. Improve grouping, spacing, headings, and helper text only
5. Treat Clients page as high-risk because it is mature and protected

Risk:
HIGH

Source edits:
Only after separate approval.

---

## 6. Page-by-Page Initial Risk Map

| Page / Area | Current UX State | Risk | Recommended Action |
|---|---|---|---|
| Workspace shell | Strong foundation | MEDIUM | Preserve; only minor polish after mapping |
| Dashboard / module grid | Functional | MEDIUM | Improve hierarchy only after action map |
| Clients page | Mature but dense | HIGH | Do not touch first |
| Cases page | Mid-level polish | MEDIUM | Map before edits |
| Deadlines page | Mid-level polish | MEDIUM | Map before edits |
| Documents page | Mid-level polish | MEDIUM | Map before edits |
| Staff page | Less polished | LOW / MEDIUM | Best first implementation candidate |
| Matter Intake Wizard | Different visual language | MEDIUM / HIGH | Audit before edits |
| Page 3 locked elements | Locked | LOCKED | Do not touch |
| Page 4+ progress calculator | Preserved work | MEDIUM | Do not touch unless separately approved |

---

## 7. Component-Level Initial Risk Map

| Component / Pattern | Risk | Reason | Recommendation |
|---|---|---|---|
| Sidebar / topbar shell | MEDIUM | Shared globally | Preserve initially |
| Navigation buttons | MEDIUM | Shared user flow | Map first |
| Primary action buttons | MEDIUM | Affects workflow clarity | Standardize after audit |
| Disabled planned cards | LOW | Visual-only if handled carefully | Preserve controlled disclosure |
| Status badges | MEDIUM | May appear across modules | Map before edits |
| Tables | MEDIUM | May affect data display | Avoid logic changes |
| Forms | HIGH | May affect legal intake | Do not change first |
| Filters | MEDIUM / HIGH | May overlap locked Page 3 behavior | Avoid until mapped |
| Counters / percentages | HIGH / LOCKED where Page 3 | Data logic risk | Avoid unless approved |
| Inline wizard styles | MEDIUM / HIGH | Isolated but visually divergent | Audit first |

---

## 8. Conservative Implementation Rules

1. No source edits from this branch.
2. No bulk UI redesign.
3. No broad CSS refactor.
4. No backend edits.
5. No database edits.
6. No auth / RBAC edits.
7. No API route edits.
8. No server edits.
9. No production logic edits.
10. No Page 3 locked component edits.
11. One fix branch per approved item.
12. Commit only after verification.
13. Push only when working tree is clean.
14. Update handover after each completed item.

---

## 9. Validation Before Any Future Fix

Before any future fix branch starts, confirm:

1. Correct branch
2. Clean working tree
3. Specific page/component selected
4. Risk level assigned
5. Files to inspect listed
6. Files not to touch listed
7. Rollback path known
8. Verification method known
9. User approval given for source edits

---

## 10. Recommended First Implementation Candidate

Recommended first candidate:
Staff page visual alignment

Reason:
The audit identifies Staff page as less visually mature, and it is likely safer than editing protected Page 3 logic, dense Clients workflows, or shared shell behavior.

Proposed future branch:
fix/14e-staff-page-visual-alignment

Initial source-edit approval status:
NOT APPROVED

---

## 11. Final Recommendation

Do not begin implementation yet.

First complete this documentation branch by:

1. Creating this plan
2. Verifying documentation-only status
3. Committing the plan
4. Pushing the docs branch
5. Then starting a separate page/component risk map branch

Final status target for this branch:

DOCUMENTATION COMPLETE / COMMITTED / PUSHED / CLEAN

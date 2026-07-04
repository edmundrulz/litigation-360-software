# Phase 14E Staff Page Visual Prep Audit — 2026-07-04

Project:
Litigation 360 / LEOS

Branch:
docs/14e-staff-page-visual-prep

Status:
DOCUMENTATION ONLY / STAFF PAGE PREP ONLY / NO SOURCE EDITS

Related Risk Map:
docs/phase-14/risk/PHASE_14E_UX_PAGE_COMPONENT_RISK_MAP_20260704.md

Related UX Hardening Plan:
docs/phase-14/implementation-plan/PHASE_14E_UX_HARDENING_PLAN_20260704.md

Related Audit Report:
docs/phase-14/audit/visual-ux/FULL_INTERFACE_VISUAL_UX_AUDIT_REPORT_20260703.md

---

## 1. Purpose

This document prepares the Staff page for a possible future visual alignment pass.

This prep audit does not authorize source-code edits.

The purpose is to identify exactly what is present in Staff.jsx, what is visually weak, what must not be changed, and what a safe first implementation branch could target.

---

## 2. Source Files Inspected

Inspected:

1. frontend/src/pages/Staff.jsx
2. frontend/src/App.css

No files were edited.

---

## 3. Current Staff Page Structure

The Staff page currently includes:

1. Staff registry heading
2. Search input
3. Add Staff section
4. Full Name input
5. Role dropdown
6. Email input
7. Phone input
8. NRIC input
9. Add Staff button
10. Staff Members section
11. Staff table with columns:
   - Name
   - Role
   - Email
   - Phone

---

## 4. Technical Observations

Staff.jsx is approximately 255 lines.

The page uses basic React state and fetch calls for:

1. Loading staff records
2. Searching staff records
3. Adding a staff member

The visible JSX structure uses plain elements such as:

1. div
2. h2
3. h3
4. input
5. select
6. button
7. hr
8. table
9. thead
10. tbody
11. tr
12. td

No Staff-specific className structure was identified during the quick scan.

---

## 5. Visual UX Observations

The Staff page appears less mature than stronger modules because it currently lacks:

1. Dedicated Staff module wrapper
2. Structured page header
3. Summary or count card
4. Professional form card
5. Clear form grouping
6. Dedicated table wrapper
7. Empty state messaging
8. Error state messaging
9. Loading state messaging
10. Clear primary/secondary action hierarchy
11. Staff-specific styling hooks
12. Visual alignment with the stronger Clients module

---

## 6. Risk Assessment

Overall risk:
LOW / MEDIUM

Reason:

The Staff page appears to be a smaller and simpler module than the Clients page, Matter Intake Wizard, or locked Page 3 areas.

However, it still performs API calls and displays stored staff data, so future implementation must avoid changing behavior, endpoints, payloads, or data logic.

---

## 7. Do Not Change in Future Implementation

A future Staff page visual alignment branch must not change:

1. API endpoint:
   http://localhost:5000/api/staff

2. Fetch method behavior

3. POST payload structure

4. Existing form field names:
   - full_name
   - role
   - email
   - phone
   - nric

5. Filtering logic

6. Add Staff behavior

7. Staff table data mapping

8. Backend files

9. Database files

10. Auth / RBAC files

11. API routes

12. Server files

13. Locked Page 3 components

---

## 8. Safe Future Improvement Targets

A future implementation branch may safely consider:

1. Add a Staff page wrapper class
2. Add a professional module header
3. Place the add-staff form inside a card/panel
4. Group form fields into a stable layout
5. Add a staff count summary
6. Add a table wrapper for visual consistency
7. Add an empty state when no staff records are present
8. Improve button hierarchy visually
9. Add helper copy without changing validation or behavior
10. Align spacing, headings, and table presentation with existing module style

---

## 9. Unsafe or Deferred Targets

Do not include these in the first Staff visual alignment fix:

1. Edit staff function
2. Delete staff function
3. Role permission logic
4. Authentication / RBAC behavior
5. Backend validation
6. Database schema changes
7. API route changes
8. Staff invite workflow
9. Staff access control
10. Any Page 3 locked logic

---

## 10. Recommended Future Implementation Branch

Recommended branch:

fix/14e-staff-page-visual-alignment

Recommended scope:

Visual alignment only.

Allowed future file candidates:

1. frontend/src/pages/Staff.jsx
2. frontend/src/App.css

Source edit approval status:

NOT APPROVED YET

---

## 11. Verification Needed Before Future Implementation

Before any future source edit:

1. Confirm branch is clean
2. Create fix/14e-staff-page-visual-alignment
3. Confirm Page 3 lock checks still pass
4. Inspect Staff.jsx again
5. Inspect App.css target area
6. List exact intended edits
7. Confirm no backend/API/database/auth/RBAC/server files will be touched
8. Confirm rollback plan
9. Obtain explicit source-edit approval

---

## 12. Final Recommendation

The Staff page remains the best first UX hardening candidate.

Proceed only in this order:

1. Complete this prep audit
2. Commit and push this documentation branch
3. Checkpoint this branch
4. Then create the future implementation branch only after approval

Final target for this branch:

STAFF PAGE VISUAL PREP COMPLETE / COMMITTED / PUSHED / CLEAN

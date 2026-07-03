# PHASE 14E PAGE 4+ PROGRESS CALCULATOR SETUP

Project:
Litigation 360 / LEOS

Branch:
fix/14e-page4-plus-progress-calculators

Date:
2026-07-03

## Objective

Add real percentage completion/progress calculation to every page from Page 4 onwards until the final page.

## Non-Negotiable Rules

1. Do not modify locked Page 3 visual/data areas.
2. Do not alter Page 3 required counter logic.
3. Do not alter Page 3 alphabet filter logic.
4. Do not alter Page 3 accepted real percentage calculation except to reuse the same pattern if safe.
5. Do not merge or cherry-pick yet.
6. Do not edit backend, database, auth, API routes, RBAC, or production logic.
7. Use real completion data only.
8. Do not use fake, decorative, or hardcoded percentages.
9. Each page from Page 4 onwards must show:
   - required total
   - completed count
   - missing count
   - percentage complete
   - clear completion/progress label

## Required Formula

percentage = completed required items / total required items * 100

Rules:
- If total required items = 0, percentage must not crash.
- Percentage must be rounded consistently.
- 100% only when all required items are complete.
- Missing fields must reduce percentage.
- Optional fields must not falsely inflate required completion.

## Pages In Scope

Page 4 onwards until the final app page.

Known likely pages to check:
- Page 4
- Page 5
- Page 6
- Any later pages/components if present

## Acceptance Criteria

The task is accepted only when:

1. Every Page 4+ screen has a visible percentage/progress completion indicator.
2. Every Page 4+ calculator uses real page-specific required field/checklist data.
3. No Page 3 locked layout/control is changed.
4. No fake percentage values are introduced.
5. The frontend builds successfully.
6. A before/after implementation note is committed.
7. Final git status is clean.

## Verification Commands

git status
git diff --stat
npm --prefix frontend run build

## Final Status

Pending implementation.

# PHASE 14 TO PHASE 15 INTEGRATION PLAN

Project:
Litigation 360 / LEOS

Date:
2026-07-03

Planning Branch:
audit/phase-14-master-completion

Audit HEAD:
bb082b5

Main HEAD:
5711667

Phase 15 Target Candidate HEAD:
812a18f

Phase 14E Closure Branch HEAD:
165c49d

Page 4+ Progress Calculator Branch HEAD:
a704c55

---

## Purpose

Create a controlled, non-destructive integration plan before moving accepted Phase 14 work into the Phase 15 target branch.

This plan prevents accidental merging, duplicated work, Page 3 lock damage, or unsafe source changes.

---

## Current Phase 14 Status

PHASE 14:
PARTIALLY COMPLETE / INTEGRATION REQUIRED

PHASE 14E:
COMPLETE / CLOSED

PAGE 3 LOCKS:
LOCKED / PRESERVED

PAGE 4+ PROGRESS CALCULATORS:
IMPLEMENTED / BUILD VERIFIED / CLOSED

PHASE 15:
TARGET CANDIDATE EXISTS BUT INTEGRATION NOT YET PERFORMED

---

## Proposed Target Branch

Primary target candidate:

phase-15-mvp-legal-control-desk

Reason:
This appears to be the Phase 15 continuation branch and is the likely destination for accepted Phase 14 readiness work.

Final target must still be confirmed before merge or cherry-pick.

---

## Accepted Source Branches For Integration Review

### 1. control/phase-14e-closure-tracker

Purpose:
Phase 14E closure/control documentation and Page 3 lock handover evidence.

Status:
ACCEPTED FOR REVIEW

Integration type:
Documentation/control only, unless already contained.

Risk:
Low.

### 2. fix/14e-page4-plus-progress-calculators

Purpose:
Adds Page 4+ module-level completion/progress calculator support through App.jsx and documents the implementation.

Status:
ACCEPTED FOR REVIEW

Integration type:
Frontend App.jsx plus documentation.

Risk:
Medium, because it modifies frontend render logic.

Special note:
This is module-level progress calculation, not yet full field-level mapping.

---

## Branches Requiring Archive / Superseded Review

These branches should not be merged blindly:

- phase-14a-green-recovery-checkpoint
- phase-14a-recovery-clean-nav
- phase-14b-wizard-progress-foundation
- fix/14d-page2-progress-dedupe
- fix/14d-terminology-unification
- fix/14e-status-card-label-nowrap
- fix/14e-page3-client-directory-density
- control/phase-14-15-clickable-tracker
- control/phase-14-15-status-verification

Required action:
Review the classification matrix before deciding whether each is:

1. already included,
2. superseded,
3. useful but pending,
4. archive-only,
5. or unsafe to merge.

---

## Non-Negotiable Integration Rules

1. Do not integrate directly into main.
2. Do not merge into Phase 15 without a temporary integration branch.
3. Do not cherry-pick without checking diff first.
4. Do not modify Page 3 locked CSS or logic.
5. Do not modify backend, database, auth, RBAC, API routes, or server files.
6. Run build after every integration step.
7. Verify Page 3 lock hooks after every integration step.
8. Keep documentation commits separate from source commits where possible.

---

## Recommended Integration Branch

Create this branch from the Phase 15 target candidate:

integration/phase-14-into-phase-15-review

Command to create later:

git checkout phase-15-mvp-legal-control-desk
git status
git checkout -b integration/phase-14-into-phase-15-review

---

## Recommended Integration Sequence

### Step 1 — Create Integration Review Branch

Start from:

phase-15-mvp-legal-control-desk

Create:

integration/phase-14-into-phase-15-review

No source edits yet.

### Step 2 — Integrate Documentation / Control Work First

Candidate:

control/phase-14e-closure-tracker

Method:
Use cherry-pick or manual copy only after diff review.

Verification:
- git diff --stat
- git status
- npm --prefix frontend run build

### Step 3 — Integrate Page 4+ Progress Calculator Work

Candidate:

fix/14e-page4-plus-progress-calculators

Method:
Review diff first:

git diff phase-15-mvp-legal-control-desk..fix/14e-page4-plus-progress-calculators -- frontend/src/App.jsx

Then integrate only if the diff is safe.

Verification:
- npm --prefix frontend run build
- Page 3 lock checks
- Visual/manual app check for Page 3 and Page 4+ modules

### Step 4 — Do Not Integrate Old Branches Yet

Old Phase 14A / 14B / 14D branches must not be merged until classified as still-needed.

### Step 5 — Create Final Integration Handover

After accepted work is integrated and verified, create:

docs/phase-14/closeout/PHASE_14_TO_PHASE_15_INTEGRATION_HANDOVER_20260703.md

---

## Required Verification Commands

Before integration:

git branch --show-current
git status
git log --oneline -10
git diff phase-15-mvp-legal-control-desk..control/phase-14e-closure-tracker --stat
git diff phase-15-mvp-legal-control-desk..fix/14e-page4-plus-progress-calculators --stat

After each integration action:

git status
git diff --stat
npm --prefix frontend run build

Before final commit:

git status
npm --prefix frontend run build

---

## Rollback Method

If integration causes conflict, build failure, or Page 3 lock issue:

1. Stop immediately.
2. Do not continue merging.
3. Run:

git status

4. If mid-cherry-pick:

git cherry-pick --abort

5. If normal working changes:

git restore .
git clean -fd

6. Return to the last clean commit.

---

## Acceptance Criteria

Integration is accepted only when:

1. Integration branch is created from Phase 15.
2. Accepted Phase 14 work is integrated cleanly.
3. Build passes.
4. Page 3 locks pass.
5. Page 4+ progress calculator still renders.
6. No backend/server/auth/database files are changed.
7. Final handover file is created.
8. Working tree is clean.

---

## Current Decision

Do not merge yet.

Do not cherry-pick yet.

Next safe process:
Create the temporary integration review branch from Phase 15 and inspect diffs before applying anything.

---

## Final Status

READY FOR INTEGRATION REVIEW BRANCH CREATION.

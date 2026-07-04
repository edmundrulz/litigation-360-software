# VERSION CONTROL AND CHANGE MANAGEMENT PROTECTION POLICY

Project:
Litigation 360 / LEOS

Date:
2026-07-03

Applies To:
- development
- staging
- production
- integration branches
- audit branches
- release branches
- documentation/control branches

Status:
ACTIVE GOVERNANCE POLICY

---

## 1. Purpose

This policy protects completed work from accidental removal, deletion, overwrite, rollback, degradation, or unauthorized amendment.

The system must continue to evolve through additive, compatible, and approved development only.

The goal is:

1. Preserve all completed contributions.
2. Prevent silent undoing of working features.
3. Prevent deletion of committed documentation, source, hooks, audits, and handovers.
4. Require explicit authorization before destructive work.
5. Maintain a clear audit trail for every major change.
6. Keep Phase 14 / Phase 15 integration safe, reviewable, and reversible.

---

## 2. Core Principle

Existing working system elements are protected by default.

Future development must be:

- additive,
- compatible,
- documented,
- branch-isolated,
- build-verified,
- and lock-verified where applicable.

Removal is prohibited unless there is a confirmed error, conflict, duplicate, security risk, or explicit administrator-approved cleanup.

---

## 3. Immutable History Policy

### 3.1 Local Git Limitation

A local Git repository cannot provide absolute immutability because an administrator can technically run commands such as reset, rebase, force-push, or delete branches.

Therefore, immutability is enforced through:

1. protected branches,
2. protected tags,
3. release snapshots,
4. audit documentation,
5. backup bundles,
6. pre-commit / pre-push checks,
7. no-force-push policy,
8. no-history-rewrite policy.

### 3.2 Prohibited History Actions

The following are prohibited on protected branches:

- git reset --hard to an older commit
- git rebase that rewrites published history
- git push --force
- git push --force-with-lease
- deleting protected branches
- deleting protected tags
- squashing accepted historical commits without explicit approval
- replacing historical work with undocumented alternatives

### 3.3 Protected Branches

The following branch categories are protected:

- main
- production/*
- release/*
- staging/*
- phase-15-mvp-legal-control-desk
- integration/*
- control/*
- closeout/*
- audit/*

### 3.4 Protected Tags

Milestone tags must be created for completed states.

Recommended tag format:

vYYYY.MM.DD-phase-name-status

Examples:

- v2026.07.03-phase14e-closed
- v2026.07.03-page4plus-progress-integrated
- v2026.07.03-phase14-to-phase15-review

Tags must not be deleted or moved after creation.

---

## 4. Permission Model

Current administrator/developer:
- May create branches.
- May add features.
- May update documentation.
- May integrate approved work.
- May approve exceptional destructive work only when necessary.

Historical work:
- No role has standing permission to delete historical completed work.
- Deletion requires explicit exception approval.
- Rollback requires explicit reason and recovery plan.
- Rewrite requires explicit disaster-recovery justification.

Future multi-user model:
- Developer: may add/modify on feature branches.
- Reviewer: may approve integration.
- Release controller: may tag/release.
- Administrator: may authorize exceptional destructive action.
- No default role may delete protected history.

---

## 5. Permitted Actions

The following are permitted when relevant to system development:

1. Enhancement
2. Upgrade
3. Bug fix
4. Compatibility repair
5. UI improvement
6. New feature
7. New function
8. New component
9. New documentation
10. Test or audit improvement
11. Build improvement
12. Security hardening
13. Performance improvement
14. Accessibility improvement
15. Refactoring that does not remove working behavior

---

## 6. Prohibited Actions

The following are prohibited unless explicitly approved due to error/conflict:

1. Removing completed work
2. Deleting source files
3. Deleting documentation
4. Deleting audit files
5. Deleting handover files
6. Removing working UI elements
7. Removing working functions
8. Undoing completed commits
9. Reverting accepted work without approval
10. Overwriting stable work with unverified experiments
11. Reducing functionality
12. Breaking backward compatibility
13. Silently changing locked Page 3 areas
14. Removing verification hooks
15. Bypassing build or lock checks

---

## 7. Relevant Development vs Unauthorized Scope Creep

### Relevant To Developing And Building This System

A change is relevant if it directly supports:

- Litigation 360 / LEOS legal workflow
- client management
- case/matter management
- court dates
- documents/evidence
- legal control desk
- progress/completion tracking
- UI stability
- accessibility
- build/test reliability
- auditability
- security
- maintainability
- deployment readiness
- operational handover

### Unauthorized Scope Creep

A change is unauthorized scope creep if it:

- adds unrelated business domains,
- adds unrelated consumer app features,
- changes project direction without approval,
- modifies backend/auth/database without explicit scope,
- introduces external dependencies without approval,
- removes working features to simplify new work,
- changes architecture without a documented migration reason,
- bypasses existing Phase 14 / Phase 15 safety controls.

---

## 8. Branching Protocol

### 8.1 Stable Branches

Stable branches:

- main
- phase-15-mvp-legal-control-desk
- release/*
- production/*

Rules:

- No direct experimental work.
- No unreviewed changes.
- No force push.
- No deletion.

### 8.2 Integration Branches

Format:

integration/<source>-into-<target>-review

Purpose:

- combine accepted work safely,
- run checks,
- resolve conflicts,
- create handover.

Rules:

- no unrelated work,
- no destructive cleanup,
- build after integration,
- create integration notes.

### 8.3 Feature / Fix Branches

Format:

feature/<description>
fix/<phase>-<description>

Purpose:

- add or improve functionality.

Rules:

- branch from the correct current baseline,
- commit small changes,
- document scope,
- do not edit locked areas unless the branch purpose explicitly allows it.

### 8.4 Audit Branches

Format:

audit/<description>

Purpose:

- inspect, classify, and document only.

Rules:

- no source changes,
- no feature work,
- no merge/cherry-pick,
- documentation/control only.

### 8.5 Control Branches

Format:

control/<description>

Purpose:

- protect decisions,
- closeout,
- tracking,
- handovers.

Rules:

- no casual source edits,
- no merge unless integration plan approves.

---

## 9. Review Checkpoints

Before integration:

1. Confirm branch.
2. Confirm clean working tree.
3. Inspect diff.
4. Confirm files changed are within approved scope.
5. Confirm no protected deletion.
6. Confirm no Page 3 lock damage.
7. Confirm no backend/auth/database changes unless approved.

After integration:

1. Run build.
2. Run lock checks.
3. Review diff stat.
4. Create integration note.
5. Commit.
6. Confirm clean working tree.
7. Create handover.

---

## 10. Documentation Requirements For Enhancements

Every enhancement must document:

1. version/date,
2. branch,
3. purpose,
4. files changed,
5. behavior changed,
6. backward compatibility status,
7. build result,
8. test/verification commands,
9. known limitations,
10. rollback method.

---

## 11. Backward Compatibility Assessment

Each change must be classified:

- COMPATIBLE:
  adds or improves without breaking existing behavior.

- COMPATIBLE WITH LIMITATION:
  safe but has documented limitations.

- BREAKING CHANGE:
  requires explicit approval and migration note.

- DESTRUCTIVE CHANGE:
  prohibited unless approved due to error/conflict.

---

## 12. Deletion / Removal Exception Protocol

Deletion is allowed only when all are true:

1. The item is broken, duplicated, obsolete, unsafe, or conflicting.
2. The reason is documented.
3. The replacement or rollback path is documented.
4. The administrator explicitly approves.
5. The deletion is isolated in a branch.
6. Build passes after deletion.
7. A deletion audit note is committed.

Required deletion note path:

docs/governance/deletion-approvals/YYYYMMDD_<description>.md

---

## 13. Environment Consistency

Development, staging, and production must follow the same protection model:

- protected branches,
- version tags,
- release notes,
- no force-push,
- no silent rollback,
- no unapproved deletion,
- build verification,
- audit trail.

Production must only receive changes from verified release/integration branches.

---

## 14. Audit Trail Policy

Each meaningful change must leave evidence through:

1. Git commit history.
2. Commit message.
3. Audit note or implementation note.
4. Handover note where applicable.
5. Build/test output when relevant.
6. Version tag for milestone state.

Current single-developer note:
User identification and multi-user access logging are not yet required because the developer administrator is currently the sole operator.

Future multi-user requirement:
When multiple developers are added, enforce identity and activity logging through GitHub/GitLab branch protection, pull requests, required reviews, and audit logs.

---

## 15. Enforcement Tools

This repository includes local verification tools:

- tools/verify-no-protected-deletions.ps1
- tools/protection-pre-commit-check.ps1
- tools/create-protected-version-snapshot.ps1

These tools support, but do not replace, remote branch protection.

---

## 16. Current Protected Work

Current protected work includes:

- Page 3 required / complete / missing counter
- Page 3 alphabet filter structured control
- Page 3 real percentage calculation
- Phase 14E closure handovers
- Page 4+ progress calculator implementation and handover
- Phase 14 audit and integration planning documents
- Phase 15 legal control desk baseline
- Page 3 lock verification tools

---

## 17. Final Rule

Enhancement is allowed.

Deletion is blocked by default.

Rollback is blocked by default.

Overwrite is blocked by default.

Historical completed work is preserved unless the developer administrator explicitly approves an exception because of error, conflict, duplication, or safety.

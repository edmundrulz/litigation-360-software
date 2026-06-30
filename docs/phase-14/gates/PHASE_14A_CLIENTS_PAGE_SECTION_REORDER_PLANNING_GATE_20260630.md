# Litigation 360 / LEOS 360
# Phase 14A Clients Page Section Reorder Planning Gate

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 55445de

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Clients Page Section Reorder Planning Gate

This gate is planning-only.

No Clients.jsx reorder, JSX movement, CSS edit, component extraction, or implementation is approved by this gate.

## 2. Objective

Plan the full Clients page section reorder into the approved 10-section structure while preserving all existing fields, actions, state, validation, masking, draft behavior, search/filter behavior, table actions, and frontend-only scope.

## 3. Why This Gate Exists

The Clients page is large and fragile.

The first consolidation pass removed dead hidden UI and contradictory placeholder sections only.

The full 10-section reorder must be planned separately before implementation to avoid losing fields, actions, handlers, validation, masking, or directory behavior.

## 4. Target Future Section Order

1. Header
2. Client File Alert / Status
3. Client Summary Dashboard
4. Client Identity & Authority
5. Conflict, Independence & Risk
6. Contact Persons & Communication
7. Engagement, Scope & Fee Readiness
8. Documents & Evidence Readiness
9. Notes, Timeline & Audit Trail
10. Bottom Actions / Navigation

## 5. Approved Scope for This Gate

Approved now:

- Documentation planning only.
- Read-only section inventory.
- Mapping current Clients.jsx blocks to target section order.
- Identifying safe movement boundaries.
- Identifying no-move/high-risk areas.
- Defining implementation pass sequence.
- Defining browser QA checklist.

Not approved now:

- Editing Clients.jsx.
- Editing App.css.
- Editing App.jsx.
- Moving JSX blocks.
- Component extraction.
- Backend/database/API changes.
- Package/dependency changes.
- Production behavior.

## 6. Strict Blocked Scope

Do not touch:

- Backend
- Database
- API routes
- Auth
- RBAC
- Package files
- Server files
- Environment files
- Upload logic
- File storage
- PDF generation
- Browser print execution
- Print button implementation
- Email sending
- Export behavior
- Billing / payment
- Migrations
- Production deployment
- App.jsx
- Clients.jsx implementation under this planning gate
- App.css implementation under this planning gate

## 7. Planning Requirements

The planning blueprint must identify:

- Existing current section order.
- Current JSX landmarks or comments, if present.
- Blocks that can safely move.
- Blocks that must stay near their current handlers/state.
- Duplicate areas already removed in the first pass.
- Risk of breaking search/filter/table/profile actions.
- Risk of breaking draft save/restore.
- Risk of breaking validation/masking.
- Proposed implementation pass order.

## 8. Future Implementation Philosophy

If implementation is later approved:

- Move one section group at a time.
- Commit each successful pass separately.
- Do not reorder the entire 5900+ line page in one pass.
- Preserve all state and handler logic.
- Prefer visual grouping over logic rewrite.
- Do not extract components in the reorder lane.

## 9. Verification Commands

- git status --short
- git diff --check
- npm --prefix ".\frontend" run build
- git log -30 --oneline

## 10. Gate Approval Decision

APPROVED FOR PLANNING ONLY.

Next output should be:

PHASE_14A_CLIENTS_PAGE_SECTION_REORDER_PLANNING_BLUEPRINT_20260630.md

No implementation should begin until that blueprint is committed and a separate implementation gate is opened.

## 11. Git Status at Gate Creation

CLEAN

## 12. Recent Commit Chain

55445de docs(phase-14a): close clients page consolidation implementation
e124ca0 fix(phase-14a): clarify matter intake module metadata
3852f6f fix(phase-14a): remove repeated open status from matter intake badge
d64185c fix(phase-14a): simplify matter intake helper text
5cc3bcb fix(phase-14a): simplify matter intake stage label
ae162dd fix(phase-14a): hide duplicate module header for matter intake
d9cb9d7 fix(phase-14a): remove duplicate matter intake callout
d9fcd89 fix(phase-14a): remove duplicate matter intake step header
9bf60cb docs(phase-14a): open clients page consolidation implementation gate
3936b1c docs(phase-14a): remove trailing whitespace in clients consolidation audit blueprint
2ba6a86 docs(phase-14a): add clients page consolidation audit blueprint
5849506 docs(phase-14a): open clients page consolidation gate
1c6ade5 docs(phase-14a): refresh handover after proposal print styling
980bae3 docs(phase-14a): close proposal print styling implementation
224dd16 style(phase-14a): improve proposal read mode print styling
100cdf7 docs(phase-14a): open proposal print styling implementation gate
9396d59 docs(phase-14a): add proposal print styling planning blueprint
193ff4c docs(phase-14a): add proposal print styling planning blueprint
a4b0c07 docs(phase-14a): remove trailing whitespace in print styling blueprint
c5610b4 docs(phase-14a): add proposal print styling planning blueprint
da0f4ab docs(phase-14a): integrate ui housekeeping thread into main ssot
4326e8b docs(phase-14a): open workflow badge extraction planning gate
658c039 docs(phase-14a): open proposal print styling planning gate
593e2c9 docs(phase-14a): refresh handover after proposal read mode
0deb23b docs(phase-14a): close proposal read mode implementation
202c8d5 docs(phase-14a): refresh handover after proposal read mode and button standardization
7a12ad5 docs(phase-14a): close proposal read mode preview
c836537 docs(phase-14a): refresh handover after workflow label button standardization
633c87e docs(phase-14a): close workflow label and button standardization
de1d83f feat(phase-14a): standardize workflow labels and navigation buttons

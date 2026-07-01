# Litigation 360 / LEOS 360
# Phase 14A Clients Page Section Reorder Implementation Pass 2 Gate

Date: 2026-06-30
Branch:
phase-14a-green-recovery-checkpoint
HEAD:
5ed09f9

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Clients Page Section Reorder Implementation Pass 2 - Client Identity & Authority Grouping.

## 2. Prerequisite Confirmation

Pass 1 QA and closeout documents exist.

Pass 1 remains closed.

Full 10-section reorder remains blocked.

## 3. Objective

Pass 2 may group the Clients Page identity and authority-related content only.

The target section is:

Client Identity & Authority.

## 4. Approved Scope

Approved file:

- frontend/src/pages/Clients.jsx

Approved content area:

- Client basic identity fields.
- Client name/title fields.
- Client type/category/classification fields.
- Identification details.
- NRIC/passport/document identity references.
- Authority/representative fields if already present.
- Existing identity-related helper text if already present.

## 5. Strictly Blocked Scope

Do not touch:

- frontend/src/App.jsx
- frontend/src/App.css unless separately approved
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
- Billing or payment
- Migrations
- Production deployment
- Component extraction
- Full 10-section reorder
- Directory table movement
- Search/filter movement
- Draft save/restore movement
- Validation or masking rewrites

## 6. Implementation Rules

- Move one identity/authority group only.
- Do not change state shape.
- Do not rename handlers.
- Do not rename field keys.
- Do not remove fields.
- Do not invent new authority fields.
- Preserve all existing labels and inputs unless the move requires only wrapper/header alignment.
- Keep the diff small and reviewable.
- Build after the patch.

## 7. Required Local Map Before Patch

Before editing Clients.jsx, create a local map of identity, identification, client type, authority, representative, and documentation anchors.

The patch must target only exact anchors confirmed in that map.

## 8. Verification Commands

- git status --short
- git diff --name-only
- git diff --check
- npm frontend build

## 9. Gate Approval Decision

APPROVED FOR PASS 2 MAPPING AND CLIENTS-ONLY IDENTITY/AUTHORITY GROUPING.

No code movement should occur until the local map is reviewed.

## 10. Git Status at Gate Creation

CLEAN

## 11. Recent Commit Chain

5ed09f9 docs(phase-14a): close clients section reorder pass one
63cf9f3 refactor(phase-14a): align clients header alert dashboard
5fdd1cc refactor(phase-14a): standardize clients navigation orientation
6b61562 docs(phase-14a): open clients navigation orientation implementation gate
67ce554 docs(phase-14a): define global navigation orientation standard
c1ed7df docs(phase-14a): close corrective clients consolidation cleanup
d8eeb4b refactor(phase-14a): apply clients consolidation cleanup
a0423f4 docs(phase-14a): add clients section reorder pass one anchor digest
8d05b4d docs(phase-14a): map clients section reorder pass one
bce371c docs(phase-14a): open clients section reorder implementation gate
59fd58d docs(phase-14a): add clients page section reorder planning blueprint
3a5c9f9 docs(phase-14a): open clients page section reorder planning gate
55445de docs(phase-14a): close clients page consolidation implementation
e124ca0 fix(phase-14a): clarify matter intake module metadata
3852f6f fix(phase-14a): remove repeated open status from matter intake badge
d64185c fix(phase-14a): simplify matter intake helper text
5cc3bcb fix(phase-14a): simplify matter intake stage label
ae162dd fix(phase-14a): hide duplicate module header for matter intake
d9cb9d7 fix(phase-14a): remove duplicate matter intake callout
d9fcd89 fix(phase-14a): remove duplicate matter intake step header

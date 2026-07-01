# Litigation 360 / LEOS 360
# Phase 14A Clients Page Section Reorder Implementation Pass 4 Gate

Date: 2026-07-01
Branch:
phase-14a-green-recovery-checkpoint
HEAD:
25004f8

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Clients Page Section Reorder Implementation Pass 4 - Family / Marital / Dependents Details.

## 2. Prerequisite Confirmation

Pass 3 QA and closeout documents exist.

Pass 3 remains closed.

Full 10-section reorder remains blocked.

## 3. Objective

Pass 4 may align the existing Clients Page family, marital, and dependents section only.

The target section is:

Family / Marital / Dependents Details.

## 4. Approved Scope

Approved file:

- frontend/src/pages/Clients.jsx

Approved content area:

- Existing client-family-marital-details section.
- Existing marital status fields.
- Existing dependent status fields.
- Existing dependent count fields.
- Existing dependent notes fields.
- Existing family helper text if already present.

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
- Identity section changes
- Identification section changes
- Employment section changes
- Matter context section changes
- Address/contact/documentation section changes

## 6. Implementation Rules

- Work on one section group only.
- Do not change state shape.
- Do not rename handlers.
- Do not rename field keys.
- Do not remove fields.
- Do not invent spouse, child, guardian, divorce, custody, inheritance, or dependent fields.
- Preserve all existing labels and inputs unless wrapper/header wording alignment is required.
- Keep the diff small and reviewable.
- Build after the patch.

## 7. Required Local Map Before Patch

Before editing Clients.jsx, create a local map of family, marital, dependents, spouse, child, guardian, and related anchors.

The patch must target only exact anchors confirmed in that map.

## 8. Verification Commands

- git status --short
- git diff --name-only
- git diff --check
- npm frontend build

## 9. Gate Approval Decision

APPROVED FOR PASS 4 MAPPING AND CLIENTS-ONLY FAMILY / MARITAL ALIGNMENT.

No code movement should occur until the local map is reviewed.

## 10. Git Status at Gate Creation

CLEAN

## 11. Recent Commit Chain

25004f8 docs(phase-14a): close clients section reorder pass three
0c3956b refactor(phase-14a): align clients employment organisation section
ffaa780 docs(phase-14a): open clients section reorder pass three gate
c583c2c docs(phase-14a): close clients section reorder pass two
84d36b3 refactor(phase-14a): align clients identity authority section
612dc63 docs(phase-14a): open clients section reorder pass two gate
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

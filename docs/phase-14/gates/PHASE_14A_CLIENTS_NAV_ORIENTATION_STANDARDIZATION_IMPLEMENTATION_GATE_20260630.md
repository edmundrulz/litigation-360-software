# Litigation 360 / LEOS 360
# Phase 14A Clients Navigation / Orientation Standardization Implementation Gate

Date: 2026-06-30
Branch:
phase-14a-green-recovery-checkpoint
HEAD:
67ce554

## 1. Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Clients Navigation / Orientation Standardization Implementation.

Clients Page Section Reorder Implementation Pass 1 remains paused.

## 2. Objective

Apply the approved global navigation and orientation standard to the Clients Page before any Clients section reordering begins.

## 3. Approved Implementation Scope

Approved page:

- frontend/src/pages/Clients.jsx

Approved target elements:

- Orientation header
- Stage label
- Page title
- Helper sentence
- Step badge
- Previous Page button
- Home Main Page button
- Continue to Next Step button
- Go to Bottom or End of Page button

## 4. Required Clients Page Standard

The Clients Page must align to:

- Stage label: Stage 2 · Client Gate
- Page title: Client Search & Duplicate Detection or approved Clients page equivalent
- Helper text: Search first, then link an existing client or continue to new client details.
- Step badge: Step 2 of 6
- Navigation buttons: Previous Page, Home Main Page, Continue to Next Step, Go to Bottom or End of Page

## 5. Accessibility Requirements

- Buttons must be real button elements unless route navigation requires a link.
- Visible button text must be descriptive.
- Step indicator must be readable as text.
- Keyboard tab order must follow visual order.
- Color must not be the only indicator.
- Scroll utility must have clear text.

## 6. Strict Blocked Scope

Do not touch:

- frontend/src/App.jsx
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
- Full Clients section reorder
- Component extraction

## 7. Implementation Rules

- Use existing working page sample style.
- Do not invent a new design system.
- Do not rewrite all pages.
- Do not change Clients page state shape.
- Do not rename existing handlers.
- Do not move directory table, form sections, validation, masking, draft controls, or profile action panels.
- Keep patch small and reviewable.

## 8. Required Local Map Before Patch

Before editing Clients.jsx, generate a local map of current Clients header and navigation anchors.

The implementation patch must target only the exact anchors found in the map.

## 9. Verification Commands

- git status --short
- git diff --name-only
- git diff --check
- npm frontend build

## 10. Gate Approval Decision

APPROVED FOR CLIENTS PAGE NAVIGATION / ORIENTATION STANDARDIZATION ONLY.

Do not resume Clients section reorder until this lane is QA-closed.

## 11. Git Status at Gate Creation

CLEAN

## 12. Recent Commit Chain

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
9bf60cb docs(phase-14a): open clients page consolidation implementation gate
3936b1c docs(phase-14a): remove trailing whitespace in clients consolidation audit blueprint
2ba6a86 docs(phase-14a): add clients page consolidation audit blueprint
5849506 docs(phase-14a): open clients page consolidation gate

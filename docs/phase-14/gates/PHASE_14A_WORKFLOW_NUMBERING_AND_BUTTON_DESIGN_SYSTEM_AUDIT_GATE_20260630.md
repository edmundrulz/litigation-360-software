# Litigation 360 / LEOS 360
# Phase 14A Workflow Numbering and Button Design System Audit Gate

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: d330fe9

## Gate Decision

GATE OPENED.

Approved lane:

Phase 14A Workflow Numbering, Process Map and Button Design System Audit

This gate is audit and documentation first.

## Problem Statement

The current workflow label such as Step 1 / 6 or Stage 1 of 6 is misleading because the visible workflow is not actually starting at the true beginning, other pages do not consistently reference the same numbering, and the real process extends beyond six visible stages before final billing.

The current button system is inconsistent across pages and does not yet meet a unified professional design-system standard.

## Approved Scope

- Audit stage and step numbering.
- Audit cross-page workflow references.
- Map full end-to-end process through final billing.
- Define safer workflow naming standards.
- Define draft, review and final status indicators.
- Audit button styles and navigation controls.
- Define unified button component standards.
- Prepare phased rollout plan.

## Blocked Scope

- Backend changes
- Database changes
- API routes
- Auth changes
- RBAC changes
- Package files
- Server files
- Environment files
- Upload logic
- File storage
- PDF generation
- Browser print implementation
- Email sending
- Billing/payment implementation
- Migrations
- Production deployment

## Required Numbering Decision

Do not use Step 1 / 6, Stage 1 of 6, or any fixed total count until the full end-to-end workflow is confirmed.

Recommended replacement:

Phase 14A · Intake Workflow · Current Node: [Node Name] · [Status]

## Proposed End-to-End Process

00. Trigger / Source Event
01. Matter / Client Intake Opened
02. Client Identity & Authority Review
03. Conflict, Independence & Risk Review
04. Contact Persons & Communication Setup
05. Scope of Work & Action Items
06. Documents & Evidence Readiness
07. Scope & Exclusions Review
08. Fee Assumptions / Billing Basis
09. Proposal Preview
10. Proposal Read Mode Review
11. Internal Review / Approval Gate
12. Client Proposal / Engagement Draft Preparation
13. Engagement Terms Confirmation
14. Billing Readiness Review
15. Invoice Draft / Billing Instruction
16. Billing Approval Gate
17. Final Billing Issued
18. Payment / Collection Tracking
19. Matter Billing Closeout

## Button System Decision

Navigation buttons must be standardized into primary, secondary, tertiary, back, and destructive variants.

Only one primary action should appear in a navigation group.

Recommended navigation labels:

- Previous
- Home
- Continue
- Go to Bottom
- Return to Top

## QA Checklist

[ ] All Step 1 / 6 labels identified.
[ ] All Stage 1 of 6 labels identified.
[ ] All fixed /6 references identified.
[ ] Cross-page workflow references audited.
[ ] Full process map documented.
[ ] Draft/review/final badge standard defined.
[ ] All button variants catalogued.
[ ] Primary/secondary/tertiary button rules defined.
[ ] Accessibility target size and focus states documented.
[ ] Phased rollout plan created.
[ ] No backend/database/storage/PDF/email behavior added.
[ ] Build remains passing.

## Git Status at Gate Creation

CLEAN

## Recent Commit Chain

d330fe9 feat(phase-14a): add proposal read mode preview
3ac24ea docs(phase-14a): open proposal read mode implementation gate
0bc34e6 docs(phase-14a): add proposal print read mode planning blueprint
3b76782 docs(phase-14a): add proposal print read mode planning blueprint
b64af52 docs(phase-14a): open proposal print read mode planning gate
dad355a docs(phase-14a): open proposal print read mode planning gate
24177be docs(phase-14a): close scope and exclusions preview enhancement
8f7db07 docs(phase-14a): open scope and exclusions preview gate
efaedbc docs(phase-14a): preserve green recovery closeout handover
54a59e3 feat(phase-14a): add document checklist preview
1416763 fix(phase-14a): stabilize documents route key and labels
b4a1374 docs(phase-14a): add thread closeout audit and handover
0ded7e6 fix(phase-14a): stabilize intake gateway and matter intake navigation
aa9163d fix(clients): restore page hierarchy and remove duplicate content
65a1faa fix(phase-14a): finalize page navigation layout

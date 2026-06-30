# Litigation 360 / LEOS 360
# Phase 14A End-to-End Billing Workflow Map

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: da29a6b

## 1. Map Purpose

This document defines the proposed full journey from initial trigger through final billing closeout.

The map replaces misleading short-form numbering such as Step 1 / 6 with a broader workflow-node structure.

## 2. Proposed End-to-End Workflow

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

## 3. Decision Points

Key decision points:

- Is the client identity verified?
- Is authority to act confirmed?
- Are conflicts cleared?
- Are key documents available?
- Is scope included/excluded clear?
- Are billing assumptions clear?
- Is the proposal ready for internal review?
- Is the engagement ready to be issued?
- Is billing ready?
- Is invoice approval complete?
- Has final billing been issued?
- Has payment or collection status been tracked?

## 4. Handoffs

Potential handoffs:

- Intake owner to conflict/risk reviewer
- Conflict/risk reviewer to matter owner
- Matter owner to document/evidence reviewer
- Matter owner to proposal drafter
- Proposal drafter to internal approver
- Internal approver to engagement preparation
- Engagement confirmation to billing preparation
- Billing preparation to billing approver
- Billing approver to invoice issue
- Invoice issue to payment tracking

## 5. Approval Gates

Recommended approval gates:

Gate A - Intake Validity Gate
Gate B - Conflict / Independence Gate
Gate C - Documents & Evidence Readiness Gate
Gate D - Scope & Fee Readiness Gate
Gate E - Proposal Readiness Gate
Gate F - Engagement Approval Gate
Gate G - Billing Readiness Gate
Gate H - Final Billing Approval Gate

## 6. Recommended UI Naming

Use workflow node names rather than short counters.

Preferred pattern:

Current Node: [Node Name]

Optional secondary metadata:

Workflow Code: WF-05

Do not display fixed total counts until the complete process is approved.

## 7. Publication Decision

Do not publish the current incomplete numbering as final.

Safe publication state:

Internal Draft / Workflow Mapping In Progress.

## 8. Final Mapping Decision

The current workflow should be treated as a partial view inside a longer matter-to-billing journey.

Any future frontend implementation must use node names and status badges instead of Step 1 / 6.

## 9. Git Status at Map Creation

CLEAN

## 10. Recent Commit Chain

da29a6b docs(phase-14a): open workflow numbering and button design audit gate
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

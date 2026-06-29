# Litigation 360 / LEOS 360
# Phase 14A Fee-Estimation Model Planning Blueprint

Date: 2026-06-29
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: e595ef1 docs(phase-14): correct proposal preview enhancement closeout

## Purpose

Define the planning model for estimating consultation fees, professional work fees, disbursements, court/tribunal-related costs, approval thresholds, and escalation triggers for the future Client Intake & Discovery proposal workflow.

This is a planning document only.

## Fee Estimate Output Objectives

The future proposal should help the service provider explain:

1. what work is included
2. what work is excluded
3. what the estimated fee range is
4. what assumptions the estimate is based on
5. what disbursements may arise
6. what may cause fees to increase
7. when client approval is required
8. whether the fee is fixed, hourly, staged, retainer-based, or hybrid

## Core Fee Categories

### 1. Consultation Fee

- initial consultation
- extended consultation
- urgent consultation
- senior professional consultation
- specialist consultation

### 2. Professional Work Fee

- intake review
- document review
- chronology preparation
- legal / advisory research
- written advice
- strategy memo
- drafting
- negotiation
- filing / submission
- hearing / meeting preparation
- appearance / attendance
- follow-up reporting
- closeout / handover

### 3. Disbursement / Ancillary Costs

- filing fees
- search fees
- courier
- printing
- photocopying
- travel
- parking
- translation
- interpretation
- process server
- commissioner / notary
- expert witness
- valuation
- investigation
- research database
- document production

### 4. Court / Tribunal / Regulatory Cost Placeholders

- filing
- application / motion
- affidavit / witness statement
- hearing preparation
- attendance
- adjournment
- settlement recording
- appeal
- enforcement

## Complexity Factors

Each matter may be rated Low / Medium / High for:

- number of parties
- number of documents
- urgency
- amount at stake
- number of workstreams
- legal / technical difficulty
- evidence quality
- opponent complexity
- regulatory exposure
- cross-border issues
- seniority required
- client responsiveness risk

## Seniority / Resource Model

Future fee preview may estimate effort by:

- Partner / Principal
- Senior Associate / Senior Consultant
- Associate / Consultant
- Junior / Analyst
- Paralegal / Admin
- External Expert

## Proposed Fee Estimate Table

| Phase | Task | Role | Estimated Hours | Rate / Fixed Fee | Estimated Fee | Notes |
|---|---|---|---:|---:|---:|---|
| 1 | Intake review | | | | | |
| 2 | Document review | | | | | |
| 3 | Advice / strategy | | | | | |
| 4 | Drafting | | | | | |
| 5 | Negotiation / communication | | | | | |
| 6 | Filing / submission | | | | | |
| 7 | Attendance / hearing / meeting | | | | | |
| 8 | Follow-up / closeout | | | | | |

## Fee Model Options

- consultation-only
- hourly billing
- fixed fee
- capped fee
- stage-based fee
- monthly advisory retainer
- replenishing retainer
- hybrid fee
- success-linked component only where permitted

## Approval Thresholds

The future proposal should capture:

- maximum budget
- approval threshold
- disbursement approval threshold
- urgent spending authority
- who approves fee increases
- whether written approval is required

## Fee Escalation Triggers

Fees may change if:

- scope expands
- urgency increases
- new parties enter
- new documents are discovered
- facts change
- client delays cause rework
- multiple revisions are requested
- settlement fails
- court / tribunal / regulator action is required
- expert evidence becomes necessary
- emergency work is required

## Client-Facing Fee Explanation

The future proposal should explain:

- estimate is based on information currently provided
- estimate is not a guarantee unless expressly fixed
- excluded work will require separate approval
- disbursements may be billed separately
- urgent or expanded scope may increase fees
- client approval is required before crossing agreed thresholds

## Future UI Planning Ideas

- fee estimate preview card
- complexity rating selector
- task-by-task estimate table
- disbursement checklist
- fee escalation warning panel
- client approval threshold field
- proposal fee summary section

## Not Approved Yet

- automatic calculation engine
- backend fee storage
- invoice generation
- payment integration
- PDF export
- email sending
- production billing workflow

## Forbidden Areas

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure logic

## Recommended Next Step

Create Phase 14A Fee Preview Enhancement Gate.

Recommended lane:

Frontend-only fee preview enhancement using mock/local state only.

## Recent Commit Chain

```text
e595ef1 docs(phase-14): correct proposal preview enhancement closeout
ee4fe4d docs(phase-14): record proposal preview enhancement QA
5e815c4 docs(phase-14): select proposal output planning lane
60ea576 docs(phase-14): close client intake prototype shell
fec9e8f docs(phase-14): record client intake prototype shell QA
0b69dd2 fix(phase-14): remove duplicate client intake route import
cf6afe8 feat(phase-14): add client intake discovery prototype shell
d13d09d feat(phase-14): add client intake discovery prototype shell
2c14abb docs(phase-14): approve client intake frontend prototype gate
5d0f911 docs(phase-14): add client intake frontend file inspection
9381b5b docs(phase-14): add client intake frontend prototype execution plan
f087837 docs(phase-14): record client intake execution scope decision
efafca2 docs(phase-14): add client intake read-only discovery scope map
a5f1ee8 docs(phase-13): close client lifecycle and set next-phase gate
e346449 docs(phase-13): close client profile modernization
f114794 docs(phase-13): close Z4 validation intelligence
739ed1b docs(phase-13): record section completion status QA pass
d6efbb5 feat(clients): add section completion status
6716e4c docs(phase-13): record required field counter QA pass
ad60398 feat(clients): add existing required field counter
```

## Final Planning Status

Phase 14A Fee-Estimation Model Planning Blueprint: CREATED
Fee Estimation Implementation: NOT APPROVED
Backend / Database / Security Scope: NOT APPROVED
Production Rollout: BLOCKED

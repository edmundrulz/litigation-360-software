# Litigation 360 / LEOS 360
# Phase 14A Proposal-Output Planning Blueprint

Date: 2026-06-29
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: 60ea576 docs(phase-14): close client intake prototype shell

## Purpose

Define the structured proposal output that should eventually be generated from the Phase 14A Client Intake & Discovery workflow.

This is a planning document only.

No app implementation, backend persistence, database schema, PDF generation, API route, or production workflow is approved by this document.

## Proposal Output Objective

The proposal output should convert intake answers into a clear engagement proposal that both the service provider and prospective client can understand.

The output should explain:

1. who the client is
2. what the matter is about
3. what the client wants
4. what the client realistically needs
5. what work is recommended
6. what is excluded
7. what documents are required
8. what the risks and merits are
9. what deadlines or dependencies exist
10. what fee structure and estimate apply
11. what the client must do next

## Proposed Proposal Sections

### 1. Proposal Header

- proposal title
- client name
- matter type
- prepared by
- date
- proposal status
- validity period

### 2. Client and Matter Summary

- client identity
- client type
- industry or sector
- matter background
- current operational / dispute / advisory status
- urgency level
- key dates

### 3. Objectives and Desired Outcomes

- immediate needs
- short-term goals
- long-term outcomes
- priority ranking
- minimum acceptable outcome
- ideal outcome
- success criteria

### 4. Preliminary Merits, Value, and Risk Summary

- value at stake
- factual strengths
- factual weaknesses
- document strength
- evidence gaps
- likely opposition or blockers
- best-case outcome
- realistic-case outcome
- worst-case outcome
- cost-benefit comment

### 5. Recommended Scope of Work

The proposal should divide work into:

- essential / mandatory work
- important but flexible work
- aspirational / future-phase work
- excluded work

Possible work categories:

- consultation
- document review
- legal / advisory research
- written advice
- drafting
- negotiation
- filing / submission
- court / tribunal / regulatory attendance
- follow-up reporting
- closeout / handover

### 6. Deliverables

Each deliverable should include:

- deliverable name
- description
- owner
- expected output
- estimated timeline
- dependency
- fee estimate link

### 7. Timeline, Deadlines, and Dependencies

- hard deadlines
- soft deadlines
- statutory / regulatory / court deadlines
- client document deadlines
- approval deadlines
- sequential workstreams
- parallel workstreams
- blockers

### 8. Documents, Evidence, and Client Inputs Required

- agreements
- emails
- WhatsApp / SMS records
- invoices
- payment records
- company records
- photographs / videos
- reports
- court / tribunal / regulatory papers
- witness names
- expert records
- authority documents
- chronology

### 9. Fee Estimate Output

The proposal should show:

- consultation fee
- professional work fee
- estimated hours
- applicable rate or fixed fee
- retainer amount
- stage-based estimate
- court / tribunal / filing fees, if applicable
- disbursements
- expert costs
- travel / printing / translation / search fees
- approval thresholds
- fee escalation triggers

### 10. Fee Escalation and Revision Triggers

The proposal should warn that fees may change if:

- scope expands
- urgency increases
- new parties enter
- documents increase significantly
- facts change
- client delays cause rework
- settlement fails
- court / tribunal / regulator action becomes necessary
- external experts are required
- multiple revisions are requested

### 11. Exclusions

The proposal should clearly say what is not included, such as:

- litigation beyond stated stage
- appeals
- enforcement
- emergency work
- external expert fees
- government / filing fees
- translation
- document storage
- additional meetings
- unrelated matters

### 12. Client Responsibilities

- provide complete and accurate information
- provide documents by deadline
- identify all relevant parties
- disclose harmful facts
- approve strategy and fees promptly
- pay retainer / invoices
- respond to urgent requests
- preserve evidence

### 13. Engagement Conditions

Work should begin only after:

- conflict check is cleared
- engagement terms are accepted
- authority to instruct is confirmed
- retainer / deposit is paid, if required
- required initial documents are received

### 14. Communication and Reporting Plan

- preferred update channel
- update frequency
- decision-maker
- escalation contact
- invoice recipient
- formal notice channel

### 15. Recommended Next Steps

- approve proposal
- provide missing documents
- complete conflict check
- pay retainer
- schedule strategy meeting
- confirm scope
- defer / decline / refer out if unsuitable

## Proposal Output Data Map

Intake section to proposal section mapping:

- Client Background -> Client and Matter Summary
- Stakeholders -> Conflict Check and Communication Plan
- Needs and Outcomes -> Objectives and Desired Outcomes
- Merits and Value -> Preliminary Merits, Value, and Risk Summary
- Scope Items -> Recommended Scope of Work and Deliverables
- Dependencies and Deadlines -> Timeline and Dependencies
- Documents and Evidence -> Required Client Inputs
- Budget and Fees -> Fee Estimate Output
- Engagement Preferences -> Engagement Conditions
- Communication Preferences -> Reporting Plan

## Future Prototype Enhancement Ideas

These are planning ideas only:

- proposal preview tabs
- printable proposal view
- fee table preview
- risk summary card
- scope / exclusion comparison
- missing document checklist
- client responsibility checklist
- next-step recommendation panel

## Not Approved Yet

- real PDF export
- backend proposal storage
- database proposal table
- email sending
- digital signature
- client portal delivery
- real client/matter conversion
- document upload
- production rollout

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

Create a Phase 14A Proposal Preview Enhancement Gate.

Recommended next lane:

Frontend-only proposal preview enhancement using mock/local state only.

## Recent Commit Chain

```text
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
3913316 docs(phase-13): record static completion shell QA pass
6339220 feat(clients): add static completion status shell
1ceb325 docs(governance): record next-phase decision gate after Phase 13
```

## Final Planning Status

Phase 14A Proposal-Output Planning Blueprint: CREATED
Phase 14A Proposal Output Implementation: NOT APPROVED
Backend / Database / Security Scope: NOT APPROVED
Production Rollout: BLOCKED

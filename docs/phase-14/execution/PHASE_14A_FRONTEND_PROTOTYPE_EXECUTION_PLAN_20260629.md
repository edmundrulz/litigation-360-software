# Litigation 360 / LEOS 360
# Phase 14A Frontend Prototype Execution Plan

Date: 2026-06-29
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: f087837 docs(phase-14): record client intake execution scope decision

## Current Status

Phase 14A Client Intake & Discovery is approved for frontend-only prototype planning.

Implementation Status: NOT STARTED
Production Rollout Status: BLOCKED

## Selected Execution Lane

Option C: Frontend-only questionnaire prototype with mock/local state only.

## Purpose

Create a controlled frontend prototype plan for the future Client Intake & Discovery workflow before any code is edited.

The prototype should help validate:

- intake section layout
- guided questionnaire flow
- client requirements capture
- merits / value assessment
- scope and action mapping
- fee estimation structure
- proposal preview structure
- document and evidence checklist
- communication and engagement preferences

## Proposed Prototype User Flow

1. Open Client Intake & Discovery prototype.
2. Select prospective client type.
3. Capture background and context.
4. Capture stakeholders and decision-makers.
5. Capture client needs, wants, and outcomes.
6. Rank priorities.
7. Capture case / project merits and value.
8. Map requested scope of work.
9. Identify dependencies and deadlines.
10. Capture risks and fallback positions.
11. Capture documents and evidence required.
12. Capture budget and fee preferences.
13. Generate proposal preview using mock/local state.
14. Display summary but do not save to backend.

## Proposed UI Sections

1. Client Background
2. Stakeholders
3. Needs and Outcomes
4. Merits and Value
5. Scope of Work
6. Dependencies and Deadlines
7. Risks and Contingencies
8. Documents and Evidence
9. Budget and Fees
10. Engagement Preview
11. Communication Preferences
12. Proposal Preview

## Preferred Implementation Shape

Use new frontend-only files where possible instead of heavily modifying existing stable pages.

Preferred pattern:

- one new page or prototype component
- one mock/local state structure
- reusable section cards
- no backend calls
- no database writes
- no file uploads
- no real client/matter creation

## Candidate Frontend Files To Inspect Before Patch

Inspect only first:

- frontend/src/pages/Clients.jsx
- frontend/src/pages/Matters.jsx
- frontend/src/pages/Workspace.jsx
- frontend/src/components/
- frontend/src/index.css
- frontend/src/App.jsx

## Candidate Allowed Files For Future Patch

Exact allowed files must be confirmed after read-only file inspection.

Likely safe frontend-only candidates:

- frontend/src/pages/ClientIntakeDiscovery.jsx
- frontend/src/components/ClientIntakeDiscoveryPrototype.jsx
- frontend/src/components/ClientIntakeSectionCard.jsx
- frontend/src/components/ClientIntakeProposalPreview.jsx
- frontend/src/index.css
- frontend/src/App.jsx only if routing/navigation is required

## Forbidden Files

Do not modify:

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure logic

## Mock / Local State Structure

Prototype state may include:

- clientProfile
- matterBackground
- stakeholders
- objectives
- meritsAssessment
- scopeItems
- dependencies
- riskRegister
- documentChecklist
- feeEstimate
- engagementPreview
- communicationPreferences
- proposalPreview

## Browser QA Checklist For Future Prototype

- prototype page opens without crash
- each section renders
- section navigation works
- text inputs accept data
- dropdowns/selectors work
- mock/local state updates correctly
- proposal preview reflects entered values
- no backend/network save is attempted
- browser refresh does not imply saved data
- existing Clients, Matters, and Workspace pages still open
- build passes

## Rollback Plan

If future implementation fails:

1. Revert only the Phase 14A frontend prototype commit.
2. Do not touch prior Phase 13 closeout commits.
3. Do not touch backend/database/security files.
4. Keep planning documents unless they are factually wrong.

## Commit Strategy

Future implementation, if approved, should be split into small commits:

1. feat(phase-14): add client intake discovery prototype shell
2. feat(phase-14): add intake sections and mock state
3. feat(phase-14): add proposal preview
4. docs(phase-14): record client intake prototype QA

## Required Verification Commands

```powershell
git status --short
git diff --check
npm --prefix ".\frontend" run build
git status --short
git log -10 --oneline
```

## Recent Commit Chain

```text
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
87e77a8 docs(phase-13): update overall Phase 13 closeout SSOT
8a941b3 docs(phase-13): map client validation completion states
6da3c24 docs(phase-13): record keyboard framework QA pass
34a454d docs(phase-13): audit client validation sources
36b94fb docs(phase-13): record keyboard framework QA pass
9342d7f docs(phase-13): blueprint client validation completion intelligence
aa9c2b6 feat(app): add keyboard shortcut help framework
41feda5 docs(phase-13): close Z3 client profile modernization
```

## Final Execution Plan Decision

Phase 14A Frontend Prototype Execution Plan: CREATED
Phase 14A Implementation: NOT STARTED
Backend / Database / Security Scope: NOT APPROVED
Production Rollout: BLOCKED

## Next Recommended Step

Phase 14A frontend file inspection before implementation approval.

# Litigation 360 / LEOS 360
# Phase 14A Scope and Exclusions Preview Enhancement Gate

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: efaedbc

## Gate Decision

GATE OPENED.

Approved next lane:

Phase 14A Scope and Exclusions Preview Enhancement

## Objective

Improve proposal preview quality by allowing the Client Intake & Discovery prototype and Proposal Preview to show:

- Scope included
- Scope excluded
- Key assumptions
- Client responsibilities
- Internal proposal readiness notes

## Approved Scope

Frontend-only prototype work.

Approved files:

- frontend/src/components/ClientIntakeDiscoveryPrototype.jsx
- frontend/src/components/ClientIntakeProposalPreview.jsx

## Explicitly Blocked Scope

Do not touch:

- Backend
- Database
- API routes
- Auth
- RBAC
- Package files
- Server files
- Production deployment
- Upload logic
- File storage
- PDF generation
- Email sending
- Billing / payment
- Migrations
- Environment files

## Required UX Outcome

Client Intake & Discovery should include structured fields for:

- Scope Included
- Scope Excluded
- Key Assumptions
- Client Responsibilities
- Internal Proposal Notes

Proposal Preview should display a clean Scope & Exclusions summary block showing:

- Included scope summary
- Excluded scope summary
- Assumptions summary
- Client responsibility summary
- Draft Engagement Preview support note

## Implementation Standard

- Preserve existing document checklist behavior.
- Preserve existing Documents / Evidence Required text area.
- Use local/mock state only.
- Avoid backend/storage assumptions.
- Avoid upload controls.
- Avoid PDF/email/export behavior.
- Avoid broad/global replacements in App.jsx.
- Avoid touching unrelated pages.

## Verification Commands

Run before and after implementation:

- git status --short
- git diff --check
- npm --prefix ".\frontend" run build
- git log -12 --oneline

## Browser QA Checklist

[ ] Client intake prototype opens without crash.
[ ] Existing Risks & Documents section still renders.
[ ] Existing document checklist still works.
[ ] Scope Included field renders.
[ ] Scope Excluded field renders.
[ ] Assumptions field renders.
[ ] Client Responsibilities field renders.
[ ] Internal Proposal Notes field renders.
[ ] Proposal preview renders Scope & Exclusions section.
[ ] Proposal preview shows scope included summary.
[ ] Proposal preview shows scope excluded summary.
[ ] Proposal preview shows assumptions summary.
[ ] Proposal preview shows client responsibilities summary.
[ ] Proposal preview shows Draft Engagement Preview support note.
[ ] No upload control exists.
[ ] No backend/database/storage behavior exists.
[ ] Build passes.

## Known Non-Blocking Warning

The Vite chunk-size warning above 500 kB after minification remains non-blocking.

It must remain tracked only for a future performance/code-splitting lane.

## Gate Approval Decision

APPROVED TO PROCEED.

Proceed only with the scoped frontend-only implementation.

## Git Status at Gate Creation

CLEAN

## Recent Commit Chain

efaedbc docs(phase-14a): preserve green recovery closeout handover 54a59e3 feat(phase-14a): add document checklist preview 1416763 fix(phase-14a): stabilize documents route key and labels b4a1374 docs(phase-14a): add thread closeout audit and handover 0ded7e6 fix(phase-14a): stabilize intake gateway and matter intake navigation aa9163d fix(clients): restore page hierarchy and remove duplicate content 65a1faa fix(phase-14a): finalize page navigation layout e2c3988 chore(phase-14a): remove obsolete app backup artifact fdf917f fix(phase-14a): restore app workflow wording and page navigation 917ada9 fix(phase-14a): recover stage one and matter intake page updates 5711667 fix(phase-14a): repair client intake navigation syntax b7a5999 docs(phase-14): approve document checklist preview lane

# Litigation 360 / LEOS 360
# Phase 14A Proposal Print / Read Mode Planning Blueprint

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 3b76782

## 1. Planning Status

PLANNING BLUEPRINT CREATED.

This blueprint is documentation-only.

No implementation is approved by this document.

## 2. Objective

Plan a cleaner Proposal Print / Read Mode for the Client Intake Proposal Preview.

The goal is to improve proposal review quality before any future print, PDF, email, backend, or storage lane is considered.

## 3. Current Proposal Preview Capabilities

The current proposal preview already supports:

- Document checklist readiness.
- Available / partial / missing document counters.
- Missing / partial document category summary.
- Scope included.
- Scope excluded.
- Key assumptions.
- Client responsibilities.
- Internal proposal notes.
- Draft Engagement Preview support notes.

## 4. Target Read Mode Experience

The future read mode should provide:

- Cleaner read-only proposal presentation.
- Better section hierarchy.
- Less form-like visual noise.
- Clear separation between client-facing and internal-only content.
- Improved review readiness before Draft Engagement Preview.
- Optional future print-safe layout planning.

## 5. Proposed Read-Only Section Structure

1. Proposal Header
2. Client / Matter Summary
3. Intake Risk Summary
4. Document Checklist Readiness
5. Scope Included
6. Scope Excluded
7. Key Assumptions
8. Client Responsibilities
9. Internal Proposal Notes
10. Draft Engagement Preview Support Notes
11. Final Readiness Checklist

## 6. Client-Facing Content

Potential client-facing sections:

- Proposal Header
- Client / Matter Summary
- Scope Included
- Scope Excluded
- Key Assumptions
- Client Responsibilities
- Document Checklist Readiness, if appropriate

## 7. Internal-Only Content

Internal-only sections:

- Internal Proposal Notes
- Draft Engagement Preview Support Notes
- Internal risk review notes
- Missing / partial document readiness warnings
- Final readiness checklist

## 8. Strict Exclusions

This planning lane does not approve:

- PDF generation
- Browser print implementation
- Email sending
- Backend persistence
- Database changes
- API routes
- Auth changes
- RBAC changes
- Package/dependency changes
- Upload logic
- File storage
- Production deployment

## 9. Future Candidate Implementation Files

If separately approved later, likely candidate files are:

- frontend/src/components/ClientIntakeProposalPreview.jsx
- optional future frontend read-mode component

No code edits are approved by this planning blueprint.

## 10. Future Browser QA Checklist

[ ] Proposal preview opens without crash.
[ ] Existing checklist preview still renders.
[ ] Existing scope and exclusions preview still renders.
[ ] Read mode can be viewed without editing fields.
[ ] Client-facing sections are clearly separated.
[ ] Internal-only sections are clearly marked.
[ ] No PDF generation exists.
[ ] No email/export behavior exists.
[ ] No backend/database/storage behavior exists.
[ ] Build passes.

## 11. Risks and Controls

Risk: Accidentally introducing real print/PDF/export behavior.
Control: Keep this lane documentation-only unless a separate implementation gate is opened.

Risk: Mixing internal-only notes into client-facing output.
Control: Clearly label internal-only sections and require QA review.

Risk: Broad refactor destabilizes current preview.
Control: Future implementation must be minimal, frontend-only, and limited to approved files.

## 12. Recommendation

Recommended next step:

Open a separate frontend-only Proposal Read Mode Implementation Gate only if read-mode implementation is approved.

Do not implement PDF generation yet.

## 13. Git Status at Blueprint Creation

CLEAN

## 14. Recent Commit Chain

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
e2c3988 chore(phase-14a): remove obsolete app backup artifact
fdf917f fix(phase-14a): restore app workflow wording and page navigation
917ada9 fix(phase-14a): recover stage one and matter intake page updates

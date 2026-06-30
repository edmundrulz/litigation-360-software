# Litigation 360 / LEOS 360
# Phase 14A UI Housekeeping Main SSOT Integration

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: 4326e8b

## 1. Purpose

This document integrates the current UI housekeeping thread back into the main Phase 14A SSOT trail.

This thread covered frontend-only visual, layout, workflow-label, navigation-button, proposal-read-mode, and documentation-governance cleanup.

No backend, database, API, auth, RBAC, package, server, storage, PDF, email, billing implementation, migration, or production deployment work is approved by this integration.

## 2. Integration Decision

THREAD READY TO CLOSE AND MIGRATE BACK TO MAIN SSOT.

The current thread should not continue into another feature implementation lane.

Any future work must begin from the latest main handover / continuation SSOT and must open a separate gate first.

## 3. Thread Classification

Classification:

Phase 14A UI Housekeeping / Layout Standardization Track

Thread focus:

- Workflow label cleanup
- Fixed step-numbering removal
- Button/navigation standardization
- Proposal read-mode closeout
- End-to-end billing workflow mapping
- Button design system standard
- Main handover refresh
- Final SSOT integration

## 4. Main Outcomes Integrated

### 4.1 Workflow Numbering Correction

Misleading labels such as Step 1 of 6, Step 7, Stage 1 of 6, or fixed /6 workflow counters are no longer approved as final visible workflow labels.

Approved direction:

- Use node-based workflow labels.
- Use readiness/status badges.
- Do not imply a false total process count.
- Do not use fixed step totals until the full end-to-end journey is approved.

### 4.2 End-to-End Billing Workflow Map

The full process is now treated as a longer journey extending from trigger/intake through billing readiness, billing approval, final billing, payment tracking, and matter billing closeout.

The current frontend stages are only a partial view inside the larger matter-to-billing lifecycle.

### 4.3 Button Design System Standard

Navigation button labels and hierarchy have been standardized.

Final visible labels:

- Previous
- Home
- Continue
- Go to Bottom
- Return to Top

Final hierarchy:

- Previous = secondary / outline
- Home = secondary / neutral
- Continue = primary / filled
- Go to Bottom = tertiary / subtle
- Return to Top = tertiary / subtle

Only Continue should be the primary page-navigation action.

### 4.4 Proposal Read Mode

Proposal Read Mode Preview was implemented and closed as a frontend-only lane.

Important exclusions remain:

- No PDF generation
- No browser print implementation
- No email/export behavior
- No backend/database/storage behavior

### 4.5 Workflow Badge Component Extraction

Workflow Badge Component Extraction and Proposal Print Styling are not the same thing.

Decision:

- Workflow Badge Component Extraction = component / structure cleanup.
- Proposal Print Styling = layout / presentation / print-style planning.

Current recommendation:

- Defer Workflow Badge Component Extraction unless repeated badge markup becomes a real maintenance problem.
- If continuing UI housekeeping, next safer lane is Proposal Print Styling Planning Blueprint.

## 5. SSOT Documents Presence Check
- FOUND: .\docs\phase-14\handover\PHASE_14A_MAIN_HANDOVER_REFRESH_AFTER_PROPOSAL_READ_MODE_AND_BUTTON_STANDARDIZATION_20260630.md
- FOUND: .\docs\phase-14\qa\PHASE_14A_PROPOSAL_READ_MODE_QA_RECORD_20260630.md
- FOUND: .\docs\phase-14\closeout\PHASE_14A_PROPOSAL_READ_MODE_CLOSEOUT_SSOT_20260630.md
- FOUND: .\docs\phase-14\qa\PHASE_14A_WORKFLOW_LABEL_AND_BUTTON_STANDARDIZATION_QA_RECORD_20260630.md
- FOUND: .\docs\phase-14\closeout\PHASE_14A_WORKFLOW_LABEL_AND_BUTTON_STANDARDIZATION_CLOSEOUT_SSOT_20260630.md
- FOUND: .\docs\phase-14\audits\PHASE_14A_WORKFLOW_NUMBERING_AUDIT_RECORD_20260630.md
- FOUND: .\docs\phase-14\maps\PHASE_14A_END_TO_END_BILLING_WORKFLOW_MAP_20260630.md
- FOUND: .\docs\phase-14\standards\PHASE_14A_BUTTON_DESIGN_SYSTEM_STANDARD_20260630.md

## 6. Locked Scope Rules

The following remain blocked unless separately approved:

- Backend changes
- Database changes
- API route changes
- Auth changes
- RBAC changes
- Package/dependency changes
- Server changes
- Environment file changes
- Production deployment
- Upload/storage logic
- PDF generation
- Browser print implementation
- Email sending
- Export behavior
- Billing/payment implementation
- Migrations

## 7. Known Non-Blocking Warning

Vite may continue to report a chunk-size warning above 500 kB after minification.

Decision:

NON-BLOCKING.

This must remain reserved for a future Performance / Code-Splitting Planning Lane only.

## 8. Recommended Main SSOT Update

The main Phase 14A SSOT should now record this UI housekeeping thread as closed and integrated.

Main continuation note:

Phase 14A UI Housekeeping / Layout Standardization Track has completed workflow numbering audit, end-to-end billing workflow map, button design system standard, workflow-label/button implementation closeout, proposal-read-mode closeout, and final handover integration.

## 9. Recommended Next Lane, If Continuing Later

Primary next lane:

Phase 14A Proposal Print Styling Planning Blueprint

Scope:

- Planning only
- Visual/layout style only
- No PDF generation
- No browser print execution
- No export/email/storage/backend behavior

Deferred lane:

Phase 14A Full Workflow Badge Component Extraction Planning Blueprint

Reason for deferral:

Useful later for component architecture cleanup, but not necessary for the current styling/layout housekeeping closure.

## 10. Verification Commands for Final Closure

- git branch --show-current
- git status --short
- git diff --check
- npm --prefix ".\frontend" run build
- git log -25 --oneline

## 11. Git Status at Integration Creation

CLEAN

## 12. Recent Commit Chain

4326e8b docs(phase-14a): open workflow badge extraction planning gate
658c039 docs(phase-14a): open proposal print styling planning gate
593e2c9 docs(phase-14a): refresh handover after proposal read mode
0deb23b docs(phase-14a): close proposal read mode implementation
202c8d5 docs(phase-14a): refresh handover after proposal read mode and button standardization
7a12ad5 docs(phase-14a): close proposal read mode preview
c836537 docs(phase-14a): refresh handover after workflow label button standardization
633c87e docs(phase-14a): close workflow label and button standardization
de1d83f feat(phase-14a): standardize workflow labels and navigation buttons
6893f93 feat(phase-14a): standardize workflow labels and navigation buttons
611cb85 docs(phase-14a): open workflow label and button standardization gate
68ad7a3 docs(phase-14a): add workflow numbering and button design audit records
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

## 13. Final Integration Conclusion

This UI housekeeping thread is safe to close after this integration record and thread closeout record are committed.

Do not continue feature work in this thread.

Future work should begin from the main Phase 14A SSOT / latest handover document.

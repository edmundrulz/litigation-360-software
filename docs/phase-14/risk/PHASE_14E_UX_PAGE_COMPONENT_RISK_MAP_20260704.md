# Phase 14E UX Page and Component Risk Map — 2026-07-04

Project:
Litigation 360 / LEOS

Branch:
docs/14e-ux-page-component-risk-map

Status:
DOCUMENTATION ONLY / RISK MAP ONLY / NO SOURCE EDITS

Related UX Hardening Plan:
docs/phase-14/implementation-plan/PHASE_14E_UX_HARDENING_PLAN_20260704.md

Related Audit Report:
docs/phase-14/audit/visual-ux/FULL_INTERFACE_VISUAL_UX_AUDIT_REPORT_20260703.md

Related Audit Handover:
docs/phase-14/closeout/FULL_INTERFACE_VISUAL_UX_AUDIT_HANDOVER_20260704.md

Related Master Tracker:
docs/phase-14/closeout/PHASE_14E_MASTER_CLOSURE_TRACKER.md

---

## 1. Purpose

This document maps the remaining UX hardening work by page, component, risk level, and recommended next action.

This document does not authorize source-code edits.

The purpose is to identify the safest first implementation branch and prevent accidental changes to locked or high-risk areas.

---

## 2. Non-Negotiable Locked Areas

The following areas are locked and must not be modified:

1. Page 3 Required / Complete / Missing counter
2. Page 3 alphabet filter structured control
3. Page 3 real percentage calculation

Any change to those areas requires a separate unlock branch and explicit approval.

---

## 3. Risk Classification Rules

### LOW RISK

Applies when:

1. Documentation-only
2. Copy clarification only
3. Isolated visual polish
4. No shared component affected
5. No data logic affected
6. No backend, database, auth, RBAC, API, or server change
7. Easy rollback

### MEDIUM RISK

Applies when:

1. Shared CSS may be affected
2. Reusable component may be affected
3. Multiple pages may visually change
4. Existing workflow clarity may change
5. Requires visual comparison across pages
6. Requires careful manual verification

### HIGH RISK

Applies when:

1. Data calculation may be affected
2. Legal intake fields may be affected
3. Validation or required fields may be affected
4. Shared state may be affected
5. Locked Page 3 areas may be nearby
6. Court/legal deadline logic may be affected
7. Hard rollback or broad testing is required

### LOCKED

Applies when:

1. Area is already locked
2. Area has checkpoint tag protection
3. User has said not to touch again
4. Lock scripts protect the area
5. Handover document says do not modify

---

## 4. Page-Level Risk Map

| Page / Area | Current State | UX Issue | Risk Level | Source Edit Approval Now? | Recommended Action | Suggested Future Branch |
|---|---|---|---|---|---|---|
| Workspace shell | Strong enterprise/legal foundation | Needs preservation and minor consistency review | MEDIUM | NO | Map only; do not edit first | docs/14e-shell-action-map |
| Dashboard / module grid | Functional but action hierarchy may be uneven | Primary vs secondary actions need clearer hierarchy | MEDIUM | NO | Map button hierarchy first | docs/14e-dashboard-action-map |
| Clients page | Mature and dense | High cognitive load, protected workflow | HIGH | NO | Do not touch first | fix/14e-clients-density-hardening-later |
| Page 3 locked client areas | Locked | Already completed and protected | LOCKED | NO | Do not touch | unlock/page3-only-if-approved |
| Cases page | Mid-level polish | Needs alignment with stronger pages | MEDIUM | NO | Map before edit | docs/14e-cases-risk-map |
| Deadlines page | Mid-level polish | Legal deadline context makes careless edits risky | MEDIUM / HIGH | NO | Map deadline display and actions first | docs/14e-deadlines-risk-map |
| Documents page | Mid-level polish | Needs action and table consistency | MEDIUM | NO | Map document actions first | docs/14e-documents-risk-map |
| Staff page | Less polished than other modules | Best candidate for first isolated visual alignment | LOW / MEDIUM | NO | First implementation candidate after approval | fix/14e-staff-page-visual-alignment |
| Matter Intake Wizard | Different visual language | Inline styles and different UX pattern | MEDIUM / HIGH | NO | Audit inline style usage first | docs/14e-matter-intake-wizard-style-map |
| Page 4+ progress calculator | Preserved completed work | Should not be accidentally altered | MEDIUM | NO | Do not touch unless separately approved | fix/14e-page4-progress-only-if-approved |
| Planned / disabled modules | Protected disclosure pattern | Needs consistency but should remain disabled | LOW | NO | Copy and card consistency map | docs/14e-planned-module-card-map |
| Empty states | Not fully standardized | User guidance may be inconsistent | LOW | NO | Safe future copy/visual pass | fix/14e-empty-state-standardization |
| Loading states | Unknown consistency | May need global pattern check | LOW / MEDIUM | NO | Audit first | docs/14e-loading-state-map |
| Error states | Unknown consistency | Could affect trust and recovery | MEDIUM | NO | Audit first | docs/14e-error-state-map |
| Mobile / responsive views | Unknown from current closeout | Could affect multiple components | MEDIUM | NO | Visual audit before edits | docs/14e-responsive-risk-map |
| Print / export views | Unknown availability | Could affect output formatting | MEDIUM | NO | Audit before edits | docs/14e-print-export-risk-map |

---

## 5. Component-Level Risk Map

| Component / Pattern | Likely Scope | Risk Level | Reason | Recommended Action |
|---|---|---|---|---|
| Sidebar navigation | Global | MEDIUM | Shared across workspace | Preserve; map before edits |
| Topbar / header | Global | MEDIUM | Shared across pages | Preserve; map before edits |
| Workspace cards | Multiple pages | MEDIUM | May affect dashboard/module grid | Map first |
| Primary buttons | Multiple pages | MEDIUM | Action hierarchy issue | Create action hierarchy map |
| Secondary buttons | Multiple pages | MEDIUM | May confuse workflows | Standardize after map |
| Previous / Home / Next toolbar | Multiple pages | MEDIUM | Navigation flow control | Do not edit before mapping |
| Disabled cards | Dashboard/planned modules | LOW | Mostly visual/copy risk | Safe after copy map |
| Status badges | Multiple modules | MEDIUM | Could affect data interpretation | Map all badge meanings first |
| Tables | Cases/Documents/Staff/others | MEDIUM | Data display risk | Avoid logic changes |
| Search controls | Multiple modules | MEDIUM | Can affect filtering UX | Map before edits |
| Alphabet filters | Page 3 locked area nearby | LOCKED / HIGH | Page 3 alphabet filter is locked | Do not touch |
| Counters | Multiple pages | HIGH | Calculation/data display risk | Do not touch unless mapped |
| Percentages | Multiple pages | HIGH | Data calculation risk | Do not touch unless mapped |
| Forms | Clients/Wizard/others | HIGH | Legal data capture risk | Do not edit first |
| Helper text | Forms/workflows | LOW / MEDIUM | Copy can affect user interpretation | Safe only after review |
| Validation messages | Forms/workflows | HIGH | May affect legal intake behavior | Do not edit first |
| Modals | Unknown | MEDIUM | May affect workflows | Audit first |
| Empty states | Multiple modules | LOW | Usually visual/copy only | Good later candidate |
| Error states | Multiple modules | MEDIUM | Affects recovery and trust | Audit first |
| Loading states | Multiple modules | LOW / MEDIUM | Visual consistency issue | Audit first |
| Inline wizard styles | Matter Intake Wizard | MEDIUM / HIGH | Different visual language | Audit first |
| CSS utility classes | Global | MEDIUM / HIGH | Could affect many pages | Avoid broad refactor |
| Page 3 lock scripts/hooks | Tooling/control | LOCKED | Protection mechanism | Do not modify |

---

## 6. First Safe Implementation Candidate

Recommended first implementation candidate:

Staff page visual alignment

Reason:

1. Audit identified Staff page as less polished
2. Lower risk than Clients page
3. Lower risk than Page 3 locked logic
4. Lower risk than Matter Intake Wizard inline style alignment
5. Likely easier to verify visually
6. Suitable for isolated branch

Suggested branch:

fix/14e-staff-page-visual-alignment

Approval status:

NOT APPROVED YET

---

## 7. Items That Must Not Be First

Do not start implementation with:

1. Page 3 locked components
2. Clients page form density
3. Percentage or counter logic
4. Alphabet filters
5. Deadline calculation or legal deadline logic
6. Backend/API/database/auth/RBAC/server files
7. Global CSS refactor
8. Matter Intake Wizard inline style overhaul
9. Broad dashboard redesign

---

## 8. Recommended Rollout Sequence

### Step 1 — Complete This Risk Map

Status:
CURRENT STEP

Action:
Commit and push this document only.

---

### Step 2 — Create Staff Page Visual Alignment Prep

Branch:
docs/14e-staff-page-visual-prep

Purpose:
Inspect Staff page and identify exact visual gaps before edits.

No source edits.

---

### Step 3 — Staff Page Visual Alignment Implementation

Branch:
fix/14e-staff-page-visual-alignment

Purpose:
Perform the first controlled low/medium-risk UX hardening change.

Only after approval.

---

### Step 4 — Action Hierarchy Map

Branch:
docs/14e-action-hierarchy-map

Purpose:
Map all button/action patterns before standardization.

No source edits.

---

### Step 5 — Empty State / Planned Module Copy Alignment

Branch:
fix/14e-empty-planned-state-copy-alignment

Purpose:
Low-risk copy/visual consistency pass.

Only after approval.

---

### Step 6 — Medium-Risk Module Alignment

Branches to be created separately:

1. fix/14e-cases-visual-alignment
2. fix/14e-documents-visual-alignment
3. fix/14e-deadlines-visual-alignment

---

### Step 7 — High-Risk Areas Later

Do not start until lower-risk work is complete:

1. Clients form density hardening
2. Matter Intake Wizard visual alignment
3. Any counter/percentage/filter work
4. Any legal deadline display logic

---

## 9. Verification Needed Before Any Future Source Edit

Before any implementation branch:

1. git status must be clean
2. branch name must match exact task
3. files to inspect must be listed
4. files not to touch must be listed
5. risk level must be documented
6. rollback method must be documented
7. Page 3 lock protection must remain active
8. source edits must be explicitly approved
9. visual verification plan must be written
10. handover file must be planned

---

## 10. Final Recommendation

The safest next implementation path is:

1. Finish this risk map
2. Commit and push it
3. Create a Staff page visual prep branch
4. Inspect Staff page only
5. Then decide whether to approve the first source-edit branch

Final target status for this branch:

RISK MAP COMPLETE / COMMITTED / PUSHED / CLEAN

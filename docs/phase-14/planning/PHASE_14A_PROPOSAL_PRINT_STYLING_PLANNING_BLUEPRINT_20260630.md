# PHASE 14A PROPOSAL PRINT STYLING PLANNING BLUEPRINT (2026-06-30)

**Primary Thread / Integration SSOT:** `PHASE_14A_UI_HOUSEKEEPING_MAIN_SSOT_INTEGRATION_20260630.md`
**Lane-Specific Controlling Gate:** `PHASE_14A_PROPOSAL_PRINT_STYLING_PLANNING_GATE_20260630.md`
**Date:** June 30, 2026
**Status:** Planning only (documentation-only; no code changes)
**Scope Type:** Frontend print-style planning guidance only

---

## 0) Planning Guardrails (Non-Negotiable)

This blueprint is a documentation artifact only and does **not** authorize implementation.

The following are explicitly out of scope in this planning lane:

- Frontend component edits
- CSS edits
- Backend services
- Database schema/data/persistence
- API routes/controllers
- Auth / RBAC / permissions
- Package/dependency files
- Server files
- Environment files
- Upload or file storage logic
- PDF generation/export services
- Browser print execution / print button implementation
- Email/export sending workflows
- Billing/payment logic
- Migrations
- Production deployment/infrastructure

---

## 1) Current Proposal Read Mode Baseline

Current baseline from existing prototype behavior indicates:

1. A Proposal Preview exists and renders from local/frontend state.
2. A dedicated **Proposal Read Mode** section is present in the proposal preview flow.
3. Read-mode content includes:
   - Proposal header details
   - Client/matter summary
   - Intake risk summary
   - Checklist readiness summary
   - Scope & exclusions details
   - Internal notes and readiness checklist blocks
4. Existing fallback safety behavior is present for empty values, including “Not specified yet.” in read-mode contexts.
5. Existing proposal sections and checklist structures are already functional and should be preserved.

This planning gate assumes read-mode content structure exists and focuses only on future **styling design direction**, not behavior changes.

---

## 2) Target Print-Friendly Visual Experience

### Goal

Define a visual style that **reads like a clean printable brief** while still staying frontend-only and non-production for this phase.

### Experience Principles

- High readability and low visual noise
- Stable section rhythm from top to bottom
- Distinct separation between client-facing and internal-only content
- No interaction-first styling in print contexts
- Hover-heavy patterns should degrade gracefully
- Preserve prototype disclaimer and non-binding context

### Desired Outcome

A future styling implementation should make read mode easy to:

- review internally,
- discuss with stakeholders,
- and visually scan in print-preview-like contexts,

without introducing real print/export execution features.

---

## 3) Page Container and Width Planning

Recommended future print-style container characteristics:

- Centered content container with predictable width
- Suggested max content width: **760px to 900px**
- Avoid ultra-wide layouts for long-form text readability
- Keep side gutters generous enough for print margins
- Prevent clipped or overly compressed panels

Proposed approach:

- Define a dedicated “read-mode print-style shell” class
- Apply consistent width and horizontal padding
- Keep full responsiveness for smaller viewports

---

## 4) Proposal Header Styling Guidance

Header should communicate document identity clearly:

- Top metadata row: draft/prototype context + date/context tags
- Primary title: “Engagement Proposal Snapshot” / “Proposal Read Mode”
- Secondary summary lines:
  - client/entity
  - matter type
  - urgency
  - readiness indicator
- Persistent draft/prototype warning text nearby

Styling direction:

- Strong heading hierarchy
- Reduced decorative effects for print-safe clarity
- Clean top/bottom spacing to establish document opening rhythm

---

## 5) Section Title Hierarchy

Recommended hierarchy:

- **H2** for major read-mode title container
- **H3/H4** for section-level blocks, such as “Scope Included”
- Optional small uppercase metadata labels as subtle “kickers”
- Consistent numbering style if used
- Avoid misleading workflow numbering

Requirements:

- Titles should be visually consistent across all read-mode sections
- Avoid abrupt font/size variance between neighboring section headers

---

## 6) Client-Facing Section Styling

Client-facing sections should appear:

- neutral, clean, and professional
- visually open
- lighter emphasis than internal warning blocks
- easy to scan with short paragraphs and lists

Candidate visual cues:

- subtle border + mild background tint
- list spacing tuned for quick reading
- key-value rows with clear labels and values

These sections should avoid internal language styling signals.

---

## 7) Internal-Only Section Styling

Internal-only blocks must remain clearly distinct:

- Explicit “Internal Only” labeling
- Higher contrast boundary than client-facing cards
- Optional warning-tint background, low intensity only
- Non-client-safe notes grouped and visually isolated

Internal-only targets include:

- Internal Proposal Notes
- Draft Engagement Preview Support Notes
- Final Readiness Checklist

Goal: prevent accidental confusion between share-safe content and internal commentary.

---

## 8) Checklist Readiness Styling

Checklist section should support quick status scanning:

- Clear status chips/badges for:
  - Available
  - Partial
  - Missing
  - Not Applicable
- Readiness percentage prominently displayed but not overpowering
- Grouped summary counts and pending categories
- Notes panel remains legible and readable as paragraph text

Future styling should avoid dense table-like clutter when printed.

---

## 9) Scope and Exclusions Styling

Scope block should visually separate:

- Included Scope
- Excluded Scope
- Key Assumptions
- Client Responsibilities
- Internal Proposal Notes, with internal style treatment

Formatting guidance:

- Use short bullet/list presentation where possible
- Keep each subsection in consistent card style
- Preserve fallback text presentation, including “Not specified yet.”, with muted but readable style

---

## 10) Page-Break Guidance (Planning Only)

For future print-friendly CSS planning, without implementing print execution features in this gate:

- Avoid section splits where possible for:
  - section headings + immediate body
  - checklist summary cards
  - internal-only warning blocks
- Prefer keeping small critical groups together
- Permit large narrative sections to flow naturally

Potential future CSS direction, implementation gate only:

- consider break-inside avoidance for section cards
- consider page-break hints for heading groups

---

## 11) Print-Safe Typography

Typography recommendations:

- Primary body size target: **11pt–12pt equivalent** in print contexts
- Headings:
  - H2: prominent but compact
  - H3/H4: strong hierarchy without oversized display behavior
- Line-height:
  - body: approximately 1.4 to 1.6
  - headings: tighter than body but not cramped
- Favor high-contrast text colors over subtle low-contrast palettes

Avoid decorative fonts; use existing app-safe sans stack.

---

## 12) Print-Safe Spacing

Spacing recommendations:

- Consistent vertical rhythm between sections
- Compact but breathable card paddings
- Reduced excessive shadows and glow effects for print-friendliness
- Preserve readable separation for lists and paragraph blocks

Suggested spacing baseline for future implementation:

- section gap: 16–24px
- card padding: 12–18px
- heading-to-content gap: 6–12px

---

## 13) What Must Remain Excluded

Even in future styling work, these remain excluded unless separately approved:

- Backend persistence or write behavior
- Database changes
- API route changes
- Auth/RBAC changes
- Upload/storage behavior
- PDF generation
- Browser print execution or print button behavior
- Email/export sending
- Billing/payment logic
- Dependency/package modifications
- Production deployment logic

This lane is styling-planning only.

---

## 14) Future Candidate Files (If Separately Approved)

If a separate implementation gate is approved, likely candidate files include:

Primary:

- `frontend/src/components/ClientIntakeProposalPreview.jsx`

Possible styling surfaces:

- existing frontend stylesheet(s) already governing proposal preview/read-mode styles

Optional, only if genuinely required for class hooks:

- `frontend/src/components/ClientIntakeDiscoveryPrototype.jsx`, minimal/non-behavioral hook updates only

No backend/server/config files should be candidates.

---

## 15) Future Browser QA Checklist (For Separate Styling Implementation Gate)

### Functional Safety

- [ ] Proposal preview still renders without runtime errors
- [ ] Existing checklist preview still renders
- [ ] Existing scope & exclusions preview still renders
- [ ] Existing read-mode data remains unchanged

### Visual Print-Friendly Goals

- [ ] Read mode appears clean and print-friendly on desktop widths
- [ ] Section hierarchy is visually consistent
- [ ] Header block is clear and readable
- [ ] Client-facing vs internal-only sections are clearly differentiated
- [ ] Checklist statuses are easily scannable
- [ ] Scope/exclusions subsection rhythm is consistent

### Internal Controls

- [ ] Internal-only sections visibly marked and distinct
- [ ] Internal notes not visually blended into client-facing sections

### Accessibility and Resilience

- [ ] Contrast remains readable
- [ ] Long text wraps safely
- [ ] Mobile/responsive layout remains stable
- [ ] No dependence on hover-only signals for key information

### Exclusion Compliance

- [ ] No PDF generation
- [ ] No browser print execution feature/button
- [ ] No email/export behavior
- [ ] No backend/database/storage behavior changes
- [ ] Build passes

---

## 16) Risks and Controls

### Risk 1: Internal-only content appears too similar to client-facing sections

**Control:** Strong visual distinction and explicit labels for internal blocks.

### Risk 2: Styling regressions degrade existing proposal section readability

**Control:** Scope styling to read-mode-specific classes and run before/after UI verification.

### Risk 3: Over-styling introduces visual clutter in print-like contexts

**Control:** Favor minimal borders, restrained color usage, and reduced shadow intensity.

### Risk 4: Inadvertent expansion into blocked feature lanes, especially PDF/print/export behavior

**Control:** Enforce strict implementation gate boundaries and file list constraints.

### Risk 5: Mobile layout breakage from print-oriented spacing assumptions

**Control:** Include responsive checks in QA and use progressive breakpoint-safe adjustments.

---

## 17) Final Recommendation

**Recommendation:** Proceed to a separate frontend-only styling implementation gate with strict scope controls.

### Proceed Conditions

1. Explicit implementation approval limited to approved frontend file(s).
2. Styling-only scope with no behavior/system integration changes.
3. QA checklist agreed in advance, including exclusion checks.
4. Clear fallback handling preserved, including readable “Not specified yet.” presentation.

### If Conditions Are Not Met

Remain at planning status and defer implementation.

---

## Planning Outcome

This blueprint is complete as a planning artifact under the controlling SSOT.

No code, component, or CSS changes have been performed in this lane.

# Litigation 360 / LEOS 360
# Phase 14A Global Navigation / Orientation / Progress Standard

Date: 2026-06-30
Branch:
phase-14a-green-recovery-checkpoint
HEAD:
c1ed7df

## 1. Standardization Decision

APPROVED STANDARD DEFINED.

This standard must be used before Clients Page section reordering resumes.

## 2. Global Orientation Header Standard

Every guided workflow page should use the following orientation pattern:

- Top-left stage/phase text.
- Main page title directly below the stage/phase text.
- One short helper sentence below the title.
- Top-right step badge.

Approved wording format:

- Stage label: Stage X · Stage Name
- Step badge: Step X of Y
- Title: page-specific, action-oriented.
- Helper sentence: one line explaining what the user should do next.

## 3. Approved Visual Placement

- Stage/title/helper block: top-left.
- Step badge: top-right.
- Navigation controls: directly below the header panel.
- Previous/Home/Next buttons: first navigation row.
- Bottom button: second centered row.

## 4. Approved Navigation Button Text

Use these labels exactly:

- ← Previous Page
- Home Main Page
- Continue to Next Step →
- Go to Bottom/End of Page ↓

## 5. Approved Button Behavior

- Previous Page: return to previous guided workflow page.
- Home Main Page: return to main dashboard/root module page.
- Continue to Next Step: advance to the next workflow step.
- Go to Bottom/End of Page: scroll to the bottom/end of current page.

## 6. Approved Progress Standard

Primary standard:

- Step badge: Step X of Y.

Secondary standard where actual completion data exists:

- Required-field counter or completion status may appear below the header.
- Completion percentage must only be shown if it is calculated from actual required fields.
- Static or fake percentage indicators are not allowed.

## 7. Color / Style Standard

Use the existing working sample as the benchmark:

- White rounded header panel.
- Soft border.
- Stage/helper text in muted slate/blue-gray.
- Main title in dark text.
- Step badge as rounded green pill.
- Navigation panel as white rounded panel below header.
- Buttons full-width within their grid cells.

Do not introduce a new color system during Phase 14A.

## 8. Accessibility Standard

Required:

- Buttons must be real button elements unless navigation requires a route link.
- Button text must be visible and descriptive.
- Step indicator must be readable as text, not only visual styling.
- Header hierarchy should use logical heading order.
- Keyboard tab order should follow visual order: Previous, Home, Next, Bottom.
- Color must not be the only indicator of progress or state.
- All scroll utility buttons must have clear labels.

## 9. Clients Page Immediate Standard

Before Clients Page section reorder resumes, Clients Page must align with:

- Stage 2 · Client Gate
- Client Search & Duplicate Detection or approved Clients page title
- Step 2 of 6
- The four approved navigation controls
- No duplicate or conflicting step indicators
- No fake/static completion percentage

## 10. Implementation Rule

Apply to Clients Page first only.

Do not apply a broad all-page rewrite.

Other pages require separate review or page-by-page controlled implementation.

## 11. Success Metrics

- Clients Page shows the approved orientation header.
- Clients Page shows one consistent step badge.
- Clients Page shows the approved four navigation controls.
- Existing Clients behavior remains unchanged.
- Build passes.
- git diff --check passes.
- No backend/App.jsx/package changes unless separately approved.

## 12. Next Required Gate

PHASE_14A_CLIENTS_NAV_ORIENTATION_STANDARDIZATION_IMPLEMENTATION_GATE_20260630.md

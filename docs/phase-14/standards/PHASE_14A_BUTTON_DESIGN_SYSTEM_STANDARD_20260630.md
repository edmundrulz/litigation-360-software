# Litigation 360 / LEOS 360
# Phase 14A Button Design System Standard

Date: 2026-06-30
Branch: phase-14a-green-recovery-checkpoint
HEAD: da29a6b

## 1. Standard Purpose

This document defines a unified button and navigation-control standard for Phase 14A.

The current UI shows inconsistent button shapes, borders, sizing, hierarchy, and labels. This standard must be approved before implementation.

## 2. Design Principles

Buttons must be:

- Consistent
- Accessible
- Clearly labelled
- Visually calm
- Easy to scan
- Easy to activate
- Predictable across pages

## 3. Accessibility Baseline

Baseline requirements:

- Use real button elements for actions.
- Provide visible focus states.
- Maintain sufficient target size.
- Maintain readable labels.
- Avoid relying on color alone.
- Preserve keyboard accessibility.
- Keep DOM order aligned with visual order.

## 4. Button Variants

Primary button:

- Use for the main forward action only.
- Example: Continue

Secondary button:

- Use for neutral navigation.
- Example: Home

Tertiary button:

- Use for low-priority page movement.
- Example: Go to Bottom or Return to Top

Back button:

- Use for reverse navigation.
- Example: Previous

Destructive button:

- Use only for irreversible actions.
- Not used in the current page navigation set.

## 5. Navigation Label Standard

Use short, predictable labels:

- Previous
- Home
- Continue
- Go to Bottom
- Return to Top

Avoid long labels:

- Previous Page
- Home Main Page
- Continue to Next Step
- Go to Bottom/End of Page

## 6. Visual Standard

Recommended values:

- Height: 44px minimum preferred
- Border radius: 10px to 12px
- Font weight: 600
- Horizontal padding: 16px to 24px
- Gap: 12px to 16px
- Border width: consistent across all outline buttons
- One primary action per navigation group

## 7. Interaction States

Each button variant must define:

- Default state
- Hover state
- Active/pressed state
- Focus-visible state
- Disabled state
- Loading state, only when future async behavior exists

## 8. Emotional / Cognitive Design Standard

Buttons should reduce anxiety and improve confidence.

Rules:

- Forward action should feel confident but not aggressive.
- Back/Home actions should feel safe and reversible.
- Jump actions should feel lightweight.
- Destructive actions must be visually distinct and rare.
- Do not make every button look equally important.

## 9. Proposed Navigation Layout

Top navigation:

Previous | Home | Continue
Go to Bottom

Bottom navigation:

Previous | Home | Continue
Return to Top

Recommended hierarchy:

- Previous = secondary outline
- Home = secondary neutral
- Continue = primary filled
- Go to Bottom = tertiary subtle
- Return to Top = tertiary subtle

## 10. Implementation Rule

No implementation is approved by this standard alone.

After this document is committed, open a frontend-only implementation gate before editing components or CSS.

## 11. Future QA Checklist

[ ] All navigation buttons use the same component pattern.
[ ] Only one primary button exists per navigation group.
[ ] Button labels are short and consistent.
[ ] Hover states are consistent.
[ ] Focus-visible state is clearly visible.
[ ] Disabled state is clearly distinct.
[ ] Button height and spacing are consistent.
[ ] Mobile layout stacks safely.
[ ] No backend/database/storage/PDF/email behavior added.
[ ] Build passes.

## 12. Git Status at Standard Creation

CLEAN

## 13. Recent Commit Chain

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

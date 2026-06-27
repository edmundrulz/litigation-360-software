# Litigation 360 / LEOS 360
# Phase 13B.3D Keyboard And Accessibility QA Plan

Date: 2026-06-27

## Objective

Validate the App Menu overlay keyboard, focus, accessibility, and interaction behaviour after Phase 13B.3A to 13B.3C.

## Scope

Frontend QA only.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## QA Checklist

### Menu Opening

- App Menu trigger is reachable from visible sidebar
- App Menu opens using mouse click
- App Menu opens using keyboard focus + Enter
- App Menu opens using keyboard focus + Space
- Search field receives focus after menu opens

### Closing Behaviour

- Escape closes menu
- Backdrop click closes menu
- Focus returns to App Menu trigger after close
- Existing sidebar buttons remain usable after close

### Keyboard Navigation

- ArrowDown moves through menu rows
- ArrowUp moves through menu rows
- Enter activates focused menu row
- Space activates focused menu row
- File submenu expands using keyboard
- File / Open can be reached and opened
- File / Save can be reached and opened
- File / Import can be reached and opened
- File / Export can be reached and opened

### Form Accessibility

- Submit Query / Request panel opens
- Category selector is keyboard reachable
- Priority selector is keyboard reachable
- Subject field is keyboard reachable
- Description field is keyboard reachable
- Attachment field is keyboard reachable
- Submit button is keyboard reachable
- Validation errors are visible

### Overlay And Focus Safety

- Body page does not scroll behind overlay
- Overlay remains visually solid
- Backdrop appears behind overlay
- No menu content is clipped
- Mobile/full-screen layout remains usable
- No focus dead-end observed
- No keyboard trap requiring browser refresh

### ARIA / Semantics

- App Menu trigger uses dialog popup semantics
- Menu overlay uses dialog semantics
- Overlay has accessible label
- Validation errors use alert behaviour
- Live-region announcement does not visually disrupt layout

## Expected Result

Phase 13B.3D should PASS if keyboard operation, closing behaviour, focus return, and form accessibility are usable without visual or interaction defects.

## Status

Phase 13B.3D QA Plan: READY
Browser QA: PENDING


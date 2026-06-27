# Litigation 360 / LEOS 360
# Phase 13E.4Z-Z3-H Pre-Submission Review Blueprint

Date: 2026-06-27

## Status

Phase 13E.4Z-Z3-H: PRE-SUBMISSION REVIEW BLUEPRINT

## Objective

Design the final professional review layer for the full Clients profile workflow before a client profile is created, saved, or accepted as ready for matter onboarding.

This phase is documentation/control only.

No frontend code is changed in this phase.

## Current Context

Completed client-profile modernization layers include:

- protected client search gate
- no-match redirect to full Advanced Client Directory / Manual Management
- full profile field registry
- CSS-first section card shell
- explicit section heading wrappers
- static client profile summary rail
- section anchor / jump-link patch
- no-match full profile redirect patch

The Advanced Client Directory / Manual Management pathway is now the authoritative full profile creation pathway.

## Purpose Of Pre-Submission Review

The pre-submission review layer should give users a final professional checkpoint before saving or creating a client profile.

It should help users confirm:

- required fields are complete
- identity information is coherent
- contact details are complete
- communication preferences are captured
- address and service location details are captured
- document verification status is captured
- internal remarks and pending information are visible
- backend/local fallback status is understood
- duplicate review context has not been bypassed
- the profile is ready for save or further correction

## Non-Negotiable Preservation Rule

The pre-submission review must not replace the original Clients form.

It must not remove, relax, bypass, rename unsafely, or alter:

- original fields
- required markers
- validation rules
- field labels
- help text
- save behaviour
- reset behaviour
- draft behaviour
- backend/API payloads
- local fallback behaviour
- directory/table behaviour
- manual client selection
- Matter Intake bridge
- Return to Matter Intake action

## Recommended UX Pattern

The review layer should be presented as a final review panel near the existing create/save actions.

Recommended pattern:

1. User completes full profile form.
2. User sees a Pre-Submission Review panel.
3. Panel summarizes major profile categories.
4. Panel highlights review-sensitive categories.
5. User can return to sections using existing jump links.
6. User uses existing save/create actions only.

The first implementation should be informational and non-destructive.

## Review Categories

### 1. Identity Review

Display a compact summary of:

- client name
- organisation name, where applicable
- client type
- identification reference
- date of birth or registration context, where applicable

Purpose:

- ensure user confirms the correct person/entity before saving

### 2. Contact Review

Display a compact summary of:

- phone
- email
- WhatsApp / preferred communication method
- communication notes or restrictions, where available

Purpose:

- reduce incomplete contact profiles

### 3. Address / Service Location Review

Display a compact summary of:

- address
- postcode / city / state / country
- service location
- correspondence location, where available

Purpose:

- reduce service and correspondence mistakes

### 4. Matter / Source Context Review

Display a compact summary of:

- matter origin
- client source
- referral source
- prior firm / takeover context, where available
- value indicators, where available

Purpose:

- preserve business development and matter-opening context

### 5. Documentation Verification Review

Display a compact summary of:

- identification document status
- verification status
- pending document reason
- document notes
- internal verification comments

Purpose:

- prevent profiles being treated as complete when documentation is pending

### 6. Internal Remarks / Pending Information Review

Display a compact summary of:

- internal remarks
- missing information
- pending follow-up items
- unresolved profile warnings

Purpose:

- keep operational risk visible before save

## Review Status Language

Use professional, non-alarming wording:

- Complete
- Review Required
- Pending
- Not Provided
- Backend Check Required
- Local Fallback Active
- Verify Before Saving

Do not rely on colour alone.

## Implementation Strategy For Next Code Phase

Next code phase:

Phase 13E.4Z-Z3-I — Pre-Submission Review Panel Patch

Strict scope:

- frontend/src/pages/Clients.jsx
- frontend/src/App.css
- docs/phase-13
- docs/qa/phase-13

First patch should be static or minimally computed from already available form state.

Allowed:

- add a review panel near existing save/create controls
- display values already held in the existing Clients form state
- add visual status chips
- add section jump links if existing anchors are available
- add CSS only within scoped class names
- preserve all existing save/create/clear/draft handlers

Not allowed:

- create a second save flow
- duplicate backend calls
- change API payloads
- alter validation logic
- mark incomplete profiles as complete
- remove original fields
- move fields between sections
- add backend/database/auth/RBAC/package changes

## Recommended Scoped Class Names

Use:

- client-profile-review-panel
- client-profile-review-header
- client-profile-review-grid
- client-profile-review-card
- client-profile-review-kicker
- client-profile-review-title
- client-profile-review-value
- client-profile-review-status
- client-profile-review-warning
- client-profile-review-actions

Avoid generic names:

- review
- card
- panel
- status
- summary

## Accessibility Requirements

The review panel should support:

- semantic section heading
- clear status text
- readable contrast
- keyboard-safe jump links
- no colour-only indicators
- stable tab order
- responsive layout
- screen-reader-friendly labels where possible

## QA Criteria For Future Patch

The future pre-submission review patch must verify:

- Clients page opens
- Advanced Client Directory / Manual Management remains visible
- Client Registration / Full Client Profile remains visible
- full original profile form remains visible
- pre-submission review panel appears
- review panel does not replace the original form
- review panel does not hide original fields
- existing create/save/clear/draft controls remain visible
- existing validation remains active
- backend warning remains visible
- local fallback warning remains visible
- Return to Matter Intake remains functional
- section jump links remain functional
- no white screen
- no browser console red runtime error
- production build passes

## GitHub Review Decision

GitHub review is optional before the code patch.

Recommended checkpoint:

- after Z3-H blueprint commit
- before Z3-I code patch if a second review is desired
- after Z3-I local build and browser QA passes

## Status

Phase 13E.4Z-Z3-H: READY FOR VERIFICATION AND COMMIT

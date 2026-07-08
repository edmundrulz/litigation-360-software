# Protected Interdependencies During Phase 01–14 Closure

This closure branch is documentation-only.

## Protected Frontend Areas

Do not edit:
- frontend/src/App.css
- frontend/src/pages/Cases.jsx
- frontend/src/pages/Deadlines.jsx
- frontend/src/pages/MatterIntakeWizard.jsx
- App menu
- navigation overlays
- label visibility
- menu stacking
- close button behavior
- active frontend layouts

## Protected System Areas

Do not edit:
- backend
- database
- migrations
- auth
- RBAC
- API routes
- production configuration
- deployment configuration

## Parallel Development Boundary

Active development may continue separately on:
phase-15-mvp-legal-control-desk

This closure branch must not:
- merge from active development
- apply stashes
- delete files
- modify frontend source
- modify backend source
- rewrite history

## Safe Closure Scope

Allowed:
- documentation
- audit matrix
- closure checklist
- evidence index
- risk register
- decision log

Not allowed:
- source-code changes
- frontend UI edits
- deletion
- migration
- stash application
- dependency upgrades

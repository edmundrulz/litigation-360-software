# PROTECTED WORK REGISTER

Project:
Litigation 360 / LEOS

Date:
2026-07-03

Status:
ACTIVE REGISTER

---

## Purpose

This register identifies work that must not be removed, deleted, overwritten, rolled back, or degraded without explicit approval.

---

## Protected Categories

### 1. Page 3 Locked Work

Protected:

- Page 3 required / complete / missing counter
- Page 3 alphabet filter structured control
- Page 3 real percentage calculation
- Page 3 related lock verification scripts
- Page 3 lock handover documentation

Verification:

- tools/verify-page3-required-counter-lock.ps1
- tools/verify-page3-alphabet-filter-lock.ps1
- tools/verify-page3-real-percentage-lock.ps1

### 2. Page 4+ Progress Calculator Work

Protected:

- Page 4+ progress calculator helper
- Page 4+ progress card component
- Page 4+ ModuleFrame integration
- Page 4+ setup, implementation, integration, and handover notes

Known limitation:
Currently module-level. Future field-level upgrade must be additive and backward compatible.

### 3. Audit / Closeout / Handover Documentation

Protected:

- docs/phase-14/audit/
- docs/phase-14/closeout/
- docs/phase-14/integration/
- docs/phase-14/implementation/
- docs/governance/

### 4. Source Baseline

Protected:

- frontend/src/App.jsx
- frontend/src/App.css
- frontend/src/pages/Clients.jsx

Protection note:
These files may be enhanced, but working sections must not be removed or overwritten without approved reason.

### 5. Tooling

Protected:

- tools/
- lock scripts
- protection scripts
- verification scripts

---

## Protected Branches

- main
- phase-15-mvp-legal-control-desk
- integration/phase-14-into-phase-15-review
- control/phase-14e-closure-tracker
- fix/14e-page4-plus-progress-calculators
- audit/phase-14-master-completion

---

## Default Rule

If unsure whether a change is destructive, treat it as destructive and stop for review.

---

## Approved Change Direction

Allowed:

- add
- enhance
- improve
- document
- verify
- refactor safely
- upgrade compatibly

Blocked by default:

- delete
- remove
- rollback
- overwrite
- degrade
- bypass
- undo

---

## Current Status

ACTIVE.

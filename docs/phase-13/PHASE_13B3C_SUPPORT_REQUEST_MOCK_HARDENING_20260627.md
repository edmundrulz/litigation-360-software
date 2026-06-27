# Litigation 360 / LEOS 360
# Phase 13B.3C Support Request Mock Hardening

Date: 2026-06-27

## Objective

Improve the Submit Query / Request panel while keeping it frontend-only.

## Improvements

- Added clearer category and priority fields
- Added validation for subject and description length
- Added optional contact email validation
- Added attachment count limit
- Added total attachment size limit
- Added clearer mock ticket reference
- Added frontend-only diagnostics notice
- Added clearer error display
- Hardened mock support API response

## Safety Scope

Frontend-only.

No backend files changed.
No database files changed.
No auth/RBAC files changed.
No API route files changed.
No server files changed.
No package files changed.
No production infrastructure files changed.

## Required QA

- Submit Query / Request opens
- Empty/short form shows validation errors
- Valid form shows mock confirmation
- Mock reference ID appears
- Attachment list appears when files are selected
- Remove attachment works
- Too many/oversized attachments are blocked by validation
- No backend/API/server request is made
- File action panels from Phase 13B.3A still work
- Settings/System/About panels from Phase 13B.3B still work
- Build passes

## Status

Phase 13B.3C: READY FOR BUILD VERIFICATION
Browser QA: PENDING


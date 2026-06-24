# Backup and Recovery SOP

Date: 14 June 2026

## Backup Rule
Backup before every code, database, RBAC, route, or configuration change.

## Recovery Rule
Restore from the most recent known-good backup only after confirming the failure source.

## Pre-Change Checklist

- Backend status checked
- Database file located
- Target files backed up
- Change approved
- Rollback path confirmed

## Post-Change Checklist

- Backend starts
- Status endpoint responds
- Route audit passes
- No unexpected errors
- Backup retained

## Emergency Rollback
Copy the backed-up file over the modified file, restart backend, and verify status endpoint.

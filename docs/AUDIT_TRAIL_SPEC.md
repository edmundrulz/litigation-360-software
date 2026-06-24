# Audit Trail Specification

Date: 14 June 2026

## Required Audit Events

- LOGIN
- LOGOUT
- CREATE_CLIENT
- UPDATE_CLIENT
- DELETE_CLIENT
- CREATE_MATTER
- UPDATE_MATTER
- DELETE_MATTER
- CREATE_DOCUMENT
- DELETE_DOCUMENT
- CREATE_USER
- DELETE_USER
- ROLE_CHANGE
- PERMISSION_CHANGE
- REPORT_EXPORT
- BACKUP_CREATED
- BACKUP_RESTORED

## Required Fields

- timestamp
- user_id
- user_email
- action
- entity_type
- entity_id
- old_value
- new_value
- ip_address
- status

## Status
Phase 6B blueprint.

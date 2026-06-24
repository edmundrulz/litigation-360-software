@echo off
setlocal

echo ==========================================
echo PHASE 6 SAFE DOCUMENTATION CREATOR
echo No code changes. No deletion. No overwrite.
echo ==========================================

mkdir docs 2>nul

if not exist docs\RBAC_PERMISSION_MATRIX.md (
echo Creating RBAC_PERMISSION_MATRIX.md
(
echo # RBAC Permission Matrix
echo.
echo Date: 14 June 2026
echo.
echo ## Purpose
echo Documents role access expectations for Litigation 360.
echo.
echo ## Roles
echo.
echo ^| Role ^| Clients ^| Matters ^| Documents ^| Deadlines ^| Staff ^| Users ^| Billing ^|
echo ^|---^|---^|---^|---^|---^|---^|---^|---^|
echo ^| Administrator ^| Full ^| Full ^| Full ^| Full ^| Full ^| Full ^| Full ^|
echo ^| Managing Partner ^| Full ^| Full ^| Full ^| Full ^| Full ^| View ^| Full ^|
echo ^| Senior Lawyer ^| Assigned ^| Assigned ^| Assigned ^| Assigned ^| View ^| None ^| Limited ^|
echo ^| Junior Lawyer ^| Assigned ^| Assigned ^| Assigned ^| Assigned ^| None ^| None ^| None ^|
echo ^| Clerk ^| View ^| Assigned ^| Assigned ^| Assigned ^| None ^| None ^| None ^|
echo.
echo ## Status
echo Draft matrix for Phase 6A closeout and Phase 7 testing.
) > docs\RBAC_PERMISSION_MATRIX.md
) else (
echo SKIPPED existing RBAC_PERMISSION_MATRIX.md
)

if not exist docs\AUDIT_TRAIL_SPEC.md (
echo Creating AUDIT_TRAIL_SPEC.md
(
echo # Audit Trail Specification
echo.
echo Date: 14 June 2026
echo.
echo ## Required Audit Events
echo.
echo - LOGIN
echo - LOGOUT
echo - CREATE_CLIENT
echo - UPDATE_CLIENT
echo - DELETE_CLIENT
echo - CREATE_MATTER
echo - UPDATE_MATTER
echo - DELETE_MATTER
echo - CREATE_DOCUMENT
echo - DELETE_DOCUMENT
echo - CREATE_USER
echo - DELETE_USER
echo - ROLE_CHANGE
echo - PERMISSION_CHANGE
echo - REPORT_EXPORT
echo - BACKUP_CREATED
echo - BACKUP_RESTORED
echo.
echo ## Required Fields
echo.
echo - timestamp
echo - user_id
echo - user_email
echo - action
echo - entity_type
echo - entity_id
echo - old_value
echo - new_value
echo - ip_address
echo - status
echo.
echo ## Status
echo Phase 6B blueprint.
) > docs\AUDIT_TRAIL_SPEC.md
) else (
echo SKIPPED existing AUDIT_TRAIL_SPEC.md
)

if not exist docs\ROUTE_SECURITY_MATRIX.md (
echo Creating ROUTE_SECURITY_MATRIX.md
(
echo # Route Security Matrix
echo.
echo Date: 14 June 2026
echo.
echo ## Classification
echo.
echo PUBLIC = safe operational health/status route
echo AUTHENTICATED = logged-in user required
echo ROLE_PROTECTED = specific role required
echo ADMIN_ONLY = administrator only
echo.
echo ## Current Review Targets
echo.
echo - clients
echo - staff
echo - cases
echo - matters
echo - documents
echo - deadlines
echo - invoices
echo - timeEntries
echo - users
echo - dashboard
echo - monitor
echo - scheduler
echo - integrityScanner
echo - autoHeal
echo - auditLogs
echo - errors
echo.
echo ## Phase 7 Use
echo This file becomes the route security testing checklist.
) > docs\ROUTE_SECURITY_MATRIX.md
) else (
echo SKIPPED existing ROUTE_SECURITY_MATRIX.md
)

if not exist docs\BACKUP_RECOVERY_SOP.md (
echo Creating BACKUP_RECOVERY_SOP.md
(
echo # Backup and Recovery SOP
echo.
echo Date: 14 June 2026
echo.
echo ## Backup Rule
echo Backup before every code, database, RBAC, route, or configuration change.
echo.
echo ## Recovery Rule
echo Restore from the most recent known-good backup only after confirming the failure source.
echo.
echo ## Pre-Change Checklist
echo.
echo - Backend status checked
echo - Database file located
echo - Target files backed up
echo - Change approved
echo - Rollback path confirmed
echo.
echo ## Post-Change Checklist
echo.
echo - Backend starts
echo - Status endpoint responds
echo - Route audit passes
echo - No unexpected errors
echo - Backup retained
echo.
echo ## Emergency Rollback
echo Copy the backed-up file over the modified file, restart backend, and verify status endpoint.
) > docs\BACKUP_RECOVERY_SOP.md
) else (
echo SKIPPED existing BACKUP_RECOVERY_SOP.md
)

echo.
echo VERIFYING DOCUMENTS
dir docs\RBAC_PERMISSION_MATRIX.md
dir docs\AUDIT_TRAIL_SPEC.md
dir docs\ROUTE_SECURITY_MATRIX.md
dir docs\BACKUP_RECOVERY_SOP.md

echo.
echo DONE. Documentation-only milestone created.
pause
endlocal
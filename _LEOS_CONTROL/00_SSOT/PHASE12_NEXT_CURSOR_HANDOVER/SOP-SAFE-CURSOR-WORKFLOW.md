# SOP: SAFE CURSOR WORKFLOW

Generated at:
2026-06-23 12:23:24 +08:00

## Mandatory Workflow

1. Read MASTER-SSOT-CURSOR-HANDOVER.md.
2. Confirm project root.
3. Inspect only.
4. List exact files involved.
5. Classify target as safe, conditional, or locked.
6. Propose smallest safe plan.
7. State risk level.
8. Create backup before overwriting existing files.
9. Make one controlled change.
10. Run verification.
11. Record result in audit log.
12. Update status.
13. Stop before moving to higher-risk work.

## Safe Command Style

Use PowerShell first.

Preferred pattern:
- Test-Path before reading or writing
- New-Item -ItemType Directory -Force for folders
- Copy-Item for backups
- Set-Content for generated text files
- Add-Content for logs

Forbidden without explicit approval:
- Remove-Item -Recurse -Force
- Changing server ports
- Editing .env files
- Editing authentication
- Editing database migrations
- Editing RBAC
- Editing API route logic

# Litigation 360 Copilot Instructions

You are assisting with Litigation 360, a legal practice operating system.

Rules:
- Do not bypass RBAC.
- Do not bypass audit logging.
- Do not remove tenant isolation.
- Do not hard-delete legal data unless explicitly instructed.
- Prefer soft delete.
- Do not expose secrets.
- Do not edit unrelated files.
- Do not create duplicate modules.
- Every protected route must check authentication and authorization.
- Every sensitive action must be audited.
- Every new feature must include error handling.
- Every database change must include migration and rollback notes.
- Prioritise reliability over fancy UI.

# LEOS 360 - G7-A Security Threat Model

Status: Engineering threat model; release acceptance remains separate.

## Protected assets
Authentication credentials/tokens, sessions/revocation state, role/permission
decisions, migration/schema integrity, restricted legal information, and audit
correlation evidence.

## Principal threats
1. Authentication bypass or weak startup configuration.
2. Token/session replay after logout or revocation.
3. Brute-force login attempts.
4. Client-side authorization treated as authoritative.
5. Silent or uncontrolled schema mutation.
6. Untraceable API errors/events.
7. Sensitive data or credentials entering source/evidence.
8. Privilege escalation through incomplete route enforcement.

## G7-A mitigations
Fail-closed runtime configuration, login throttling, server sessions/revocation,
server RBAC, governed migrations, request IDs on responses/errors, regression
testing, and evidence preservation.

## Residual debt
Backend project ESLint configuration is absent and remains separately tracked
tooling debt. Repository-wide frontend lint debt is also carried separately.
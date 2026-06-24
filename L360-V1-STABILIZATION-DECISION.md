# LITIGATION 360 V1 STABILIZATION DECISION

## Decision

For V1 stabilization, Litigation 360 will use:

SQLite as the official working database.

## Reason

The active working routes use:

backend/src/database.js
backend/litigation360.db
better-sqlite3

The PostgreSQL / Sequelize layer is treated as future or legacy until formally rebuilt.

## Current Priority

Fix and stabilize:

1. Clients
2. Cases / Matters
3. Deadlines
4. Documents
5. Staff

## Security Note

L360_LOCAL_DEV_BYPASS=true is allowed for local development only.

Not approved for production.

## Do Not Do

- Do not continue PostgreSQL repair now
- Do not start Phase 11
- Do not delete folders
- Do not refactor database architecture
- Do not mix SQLite and PostgreSQL in the same V1 workflow

# LEOS 360 - G7-A Migration Architecture and Runbook

Status: Engineering runbook; no authoritative DB migration is authorized here.

## Architecture
Governed migration controls:
- `backend/src/database/migrate.js`
- `backend/src/database/migrationRunner.js`
- `backend/src/migrations/governed/001_core_auth.sql`
- `backend/src/migrations/governed/002_adaptive_auth.sql`

## Procedure
1. Verify environment/database identity.
2. Confirm approved migration sequence/version/checksum.
3. Establish governed backup/recovery capability.
4. Execute only through the governed migration mechanism.
5. Capture command, exit code, schema/version and database evidence.
6. Verify application/integrity checks.
7. HOLD on checksum mismatch, unexpected schema, or unauthorized environment.
8. Record change/release evidence.

No silent startup schema mutation or manual bypass of migration records.
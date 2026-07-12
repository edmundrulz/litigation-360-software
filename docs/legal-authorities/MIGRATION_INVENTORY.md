# Migration Inventory

## 025 — Legal Authorities Foundation
File: `backend/src/migrations/025_legal_authorities_foundation.sql`

Creates only `legal_*` objects:
- `legal_sources`
- `legal_authority_types`
- `legal_jurisdictions`
- `legal_institutions`
- `legal_authorities`
- `legal_authority_versions`
- `legal_authority_hierarchy`
- `legal_authority_relationships`
- `legal_source_verifications`
- `legal_licence_controls`
- `legal_authority_audit_events`
- Supporting indexes

The migration is additive and idempotent. It contains no `DROP`, destructive rename or data deletion. It has passed two consecutive executions against an in-memory database while preserving a pre-existing test table.

## Application rule
Migration 025 has **not** been applied to `backend/litigation360.db`. Before an approved application: stop writes, create and verify a database backup/checksum, run migration against a disposable copy, inspect foreign-key and table integrity, then obtain the designated approval.

## Rollback
Prefer restoring the verified pre-migration backup. If a schema-only rollback is approved, disable the feature and route first, export audit evidence, confirm no external references, then remove only the listed `legal_*` objects in reverse dependency order.

# LA-01 / LA-02 Implementation Inventory

## Runtime changes
- Additive SQLite migration `025_legal_authorities_foundation.sql` (created but not applied to the live database).
- Ten reviewed source-registry seed records with scraping and full-text storage disabled.
- Configurable authority-type taxonomy seeds.
- Fail-closed JWT/RBAC middleware dedicated to Legal Authorities.
- Read-only summary, source and taxonomy APIs; restricted foundation seed and source-update APIs.
- Server-side URL, enumeration and acquisition-safety validation.
- Separate lazy-loaded React module with source registry, taxonomy, responsive cards and guarded administration actions.
- Main navigation entry: **Legal Authorities**.

## Verification
- Migration idempotency and preservation tests use SQLite `:memory:` only.
- Seed integrity and source-safety tests.
- Source-update validation tests.
- Existing Legal Glossary remains a separate feature and data set.

## Explicit exclusions
No scraping, bulk ingestion, commercial full-text copying, live database migration, production deployment, search-cluster installation, AI legal conclusions or restricted court-record acquisition.

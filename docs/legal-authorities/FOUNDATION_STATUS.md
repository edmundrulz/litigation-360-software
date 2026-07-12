# Legal Authorities Documentation Foundation Status

## Purpose and scope

This document records the governing baseline shared by the Legal Authorities architecture, data, source, licensing, ingestion, search, AI, security, operations, administration, user, rollback, testing, risk, permission, and acceptance documents. It applies to the Malaysia-first foundation phase and resolves terminology or status ambiguity across the documentation set.

Audience: product owners, legal-knowledge administrators, security reviewers, developers, testers, and release approvers.

Responsible module: LEOS 360 Legal Authorities & Knowledge Platform.

## Current implementation status

The documentation describes an approved design baseline and separately identifies runtime files that are still uncommitted implementation work. SQLite remains the operational database for the foundation phase. PostgreSQL migration is not part of this checkpoint. Migration 025 has not been executed against the live operational database.

This checkpoint does not assert that legal-content ingestion is complete, that any commercial provider is integrated, or that a production Legal Authorities service has been deployed.

## Authority and content hierarchy

Official and verified legal authorities outrank AI summaries, internal commentary, and secondary material. AI output is not authoritative law or legal advice. AI-generated derivative material must remain separately labelled, reviewable, attributable to its supporting sources, and incapable of overwriting verified authority text or status.

Historical legal versions must never be overwritten. Corrections and updates create traceable versions with review and audit evidence.

Restricted, confidential, or sealed court material must not enter normal search, normal indexes, or unrestricted exports.

## Source classifications

The canonical source classifications are:

1. Official public source.
2. Official authenticated source.
3. Professional secondary source.
4. Licensed commercial source.
5. Internal firm knowledge.
6. AI-generated derivative material.

"Official" means issued or maintained by the competent public institution. "Licensed" means use is governed by express contractual or subscription rights. "Internal" means firm-controlled material subject to access permissions. "AI-generated" means derivative assistance that remains visibly separate from authoritative records.

Commercial sources are metadata/deep-link or licensed-API only. They are not freely copyable. No source is assumed to provide an API, bulk download, republication right, or full-text storage right without verification. No unrestricted scraping is authorized.

## Security, licensing, and recovery implications

Access remains fail-closed, role-controlled, auditable, and bounded by source and licence controls. Credentials, subscription tokens, restricted documents, and sealed material must not be embedded in documentation or normal search content.

This checkpoint changes documentation only. It does not modify a database, run a migration, install a package, ingest content, or activate an external integration. Reversal, after owner approval, is by reverting the documentation commit; it does not require a database rollback.

## Non-goals

- Executing migration 025 or changing a live database.
- Migrating SQLite to PostgreSQL.
- Scraping or downloading legal content.
- Copying commercial full text without verified permission.
- Claiming exhaustive, current, or legally authoritative coverage.
- Treating AI output as controlling law.
- Implementing runtime APIs, authentication, UI, search infrastructure, or deployment in this checkpoint.

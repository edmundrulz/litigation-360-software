# Litigation 360 Master Consolidation Matrix

Generated: 06/21/2026 09:48:53

## Purpose

This matrix classifies project components into:

- KEEP
- MERGE
- ARCHIVE
- REFACTOR
- REMOVE

## Routes

| Category | Action | Reason |
|---|---|---|
| Core legal routes | KEEP | Required runtime modules |
| Enterprise routes | KEEP | Required governance/operations modules |
| Dashboard/monitoring routes | KEEP | Required operational visibility |
| .doctor-backup files | ARCHIVE LATER | Backup artifacts inside runtime folder |
| backup-before files | ARCHIVE LATER | Historical safety files inside runtime folder |
| POSTGRES_BACKUP_DO_NOT_DELETE files | REVIEW THEN ARCHIVE | Migration backup artifact |

## Utilities

| Utility Type | Action | Reason |
|---|---|---|
| client identity | KEEP | Core Phase 9 legal engine |
| conflict engine | KEEP | Core legal risk engine |
| deadline calculator | KEEP | Court operations engine |
| matter intake | KEEP | Matter opening workflow |
| matter numbering | KEEP | Numbering control |
| task automation | KEEP | Operational workflow support |
| workflow conveyor | KEEP | Matter workflow support |
| logger/error/audit utilities | KEEP | System safety and audit |

## Services

| Area | Action | Reason |
|---|---|---|
| autoHealService | KEEP | Existing service layer |
| legal engines currently in utils | REFACTOR LATER | Service layer is underdeveloped |
| route business logic | REVIEW | May need extraction into services |

## Tests

| Test Type | Action | Reason |
|---|---|---|
| Legal engine tests | KEEP | Core verification |
| Security tests | KEEP | Regression baseline |
| CRUD smoke tests | KEEP | Baseline integrity |
| Licensing/commercialisation tests | KEEP | Commercial readiness |

## Documentation

| Area | Action | Reason |
|---|---|---|
| MASTER-HANDBOOK | KEEP | Enterprise reference |
| MASTER-SYSTEM | KEEP | Governance framework |
| Historical reconstruction | KEEP + COMPLETE | Early phase traceability |
| Duplicate/old reports | REVIEW | May be archived after certification |

## Next Safe Action

Do not delete anything yet.

Next phase should be:

Phase 10ZZD.1 - Backup Route Archive Validation

Only after:
- dependency check
- route registration check
- tests pass

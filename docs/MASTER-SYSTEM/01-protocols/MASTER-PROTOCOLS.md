# Master Protocols

## Development Protocol

Before any change:
1. Identify affected files.
2. Identify affected routes.
3. Identify affected database tables.
4. Identify affected tests.
5. Create backup or snapshot.
6. Run existing tests.
7. Apply change.
8. Run verification.
9. Generate report.

## No Blind Change Rule

Do not modify production files without:
- backup
- validation command
- rollback plan
- test result

## Completion Rule

A phase is complete only when:
- files exist
- routes exist
- tests exist
- documentation exists
- verification passes
- report is generated

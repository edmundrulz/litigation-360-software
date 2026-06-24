# Phase 10ZZD.1 Checks And Balances

## Required Checks

- Backup file list generated
- Dependency validation generated
- Route registration validation generated
- Classification generated
- Archive matrix generated
- Live status generated
- Handover generated

## Red Flags

- File name contains DO_NOT_DELETE
- File is imported in backend source
- File is registered in index.js or server.js
- File has same size as active runtime route
- File belongs to database migration or PostgreSQL fallback

# Phase 10ZZD Checks And Balances

## Required Checks

- Route inventory generated
- Utility inventory generated
- Service inventory generated
- Test inventory generated
- Backup file inventory generated
- Runtime process snapshot generated
- Consolidation matrix generated
- Handover generated

## Red Flags

- .doctor-backup inside backend/src/routes
- backup-before files inside backend/src/routes
- POSTGRES_BACKUP files inside runtime folders
- only one service file
- duplicate route naming
- old phase text files inside route folder
- generated reports left in root

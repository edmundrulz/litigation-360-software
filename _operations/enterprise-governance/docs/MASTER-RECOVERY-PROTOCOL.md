# Master Recovery Protocol

## Recovery Source
Use Phase 10P Backup Recovery and _operations snapshots.

## Recovery Steps
1. STOP-L360.bat
2. Confirm node.exe processes are stopped if required.
3. Restore database/package/config files from snapshot.
4. npm install only if package files changed.
5. START-L360-CLEAN.bat
6. Validate monitoring, environment, release, scoring, gatekeeper.

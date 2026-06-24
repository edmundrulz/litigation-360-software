# L360 V1 SQLITE ROUTE REPAIR

Date: 06/21/2026 20:38:12

Decision:
V1 uses SQLite/better-sqlite3 as the working database.

Patched:
- auth.js
- roleMiddleware.js
- matters.js
- deadlines.js
- documents.js

Backups:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\BACKUP_BEFORE_V1_SQLITE_ROUTE_REPAIR_20260621-203812

Reason:
Clients already work on SQLite.
Cases table exists in SQLite.
Matters PostgreSQL route failed because relation "Matters" does not exist.
V1 now treats Matters as Cases until a future PostgreSQL migration is formally designed.

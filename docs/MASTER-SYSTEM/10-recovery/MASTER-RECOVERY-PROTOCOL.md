# Master Recovery Protocol

## Recovery Steps

1. Stop backend.
2. Stop frontend.
3. Restore latest backup.
4. Verify package files.
5. Restart backend.
6. Restart frontend.
7. Run health checks.
8. Run regression tests.

## Protected Recovery Rule

Never overwrite SQLite production database without copied test database.

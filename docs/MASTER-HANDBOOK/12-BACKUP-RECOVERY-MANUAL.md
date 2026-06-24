# 12 Backup and Recovery Manual

## Purpose
Defines how Litigation 360 is protected and restored after failure.

## Backup Targets
- frontend\src\App.jsx
- frontend\src\App.css
- backend\src\index.js
- backend\litigation360.db
- docs
- scripts
- _operations

## Recovery Rule
Do not modify critical files unless a timestamped backup exists.

## Rollback Rule
If build fails, restore the previous working file from _operations phase backups.

## Disaster Recovery Minimum
A recovery point must include application files, database file, documentation, scripts, and latest reports.

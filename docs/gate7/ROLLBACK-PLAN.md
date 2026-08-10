# LEOS 360 - G7-A Rollback Plan

Status: Controlled rollback guidance.

## Pre-commit failure
IMPLEMENT-20 restores `backend/src/index.js` from the fixed pre-transaction HEAD
and removes only files created by IMPLEMENT-20. It then verifies target status.

No `git clean`, `reset --hard`, history rewrite, or force push is authorized.

## Post-commit reversal
A later reversal requires separate authority and should use:

`git revert --no-edit <IMPLEMENT-20-COMMIT>`

## Database
IMPLEMENT-20 performs no authoritative database migration.
# ROLLBACK PLAN TEMPLATE

Change ID:
Deployment Date:
Released By:
Approved By:

## What Changed

## Files Changed

## Database Changed

## Config Changed

## How To Disable Feature

## Git Rollback Command

git log --oneline
git revert COMMIT_ID
git push origin main

## Emergency Rollback Command

git checkout main
git reset --hard LAST_STABLE_COMMIT_ID
git push --force-with-lease origin main

## Database Rollback

Backup File:
Restore Command:

## Rollback Approval

Approved By:
Date:
Reason:

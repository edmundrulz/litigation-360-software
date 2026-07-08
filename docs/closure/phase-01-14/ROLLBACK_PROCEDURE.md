# Phase 01–14 Closure Rollback Procedure

## If unexpected issues occur

1. Stop work immediately.
2. Do not commit additional changes.
3. Run:

git status -sb

4. If only closure documentation files were created and you want to discard them:

git restore --staged .
git restore .

5. If a commit was already created but not pushed:

git reset --soft HEAD~1

or, to discard the commit and files:

git reset --hard HEAD~1

6. If the branch is no longer needed:

cd C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
git worktree remove --force C:\l360-wt\closure
git branch -D docs/phase-01-14-final-closure-20260708

## Important

Do not touch development worktrees.
Do not apply stash.
Do not delete active source files.
Do not merge into Phase 15 without review.

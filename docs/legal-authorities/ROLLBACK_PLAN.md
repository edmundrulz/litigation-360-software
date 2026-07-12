# Rollback Plan
Disable the feature; remove the isolated route; stop writes; preserve audits; restore the verified pre-migration backup if applied; remove only reviewed `legal_*` objects after reference checks. Never use `git reset --hard`, `git clean` or broad deletion.

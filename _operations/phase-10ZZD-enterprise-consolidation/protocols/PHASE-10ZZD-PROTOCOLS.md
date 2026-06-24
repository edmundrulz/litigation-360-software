# Phase 10ZZD Protocols

## Protocol 1 - Audit Before Action
Do not move, delete, rename, or refactor until inventory evidence exists.

## Protocol 2 - Runtime Protection
The following folders are protected:

- backend
- frontend
- node_modules
- .git
- data
- configs
- tests
- docs
- _operations

## Protocol 3 - Backup File Rule
Backup files found inside runtime folders must first be listed, reviewed, then moved only by a separate approved archive script.

## Protocol 4 - Service Refactor Rule
Utilities must not be blindly moved into services.
Each service refactor requires:

- source utility identified
- dependent route identified
- test identified
- rollback plan
- before/after test result

## Protocol 5 - Completion Rule
No consolidation item is complete unless it has:

- evidence
- classification
- action
- risk rating
- verification method

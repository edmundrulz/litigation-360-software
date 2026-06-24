# Phase 10ZZD.1 Protocols

## Protocol 1 - Validate Before Archive
No backup-like file may be moved until dependency checks and route-registration checks are complete.

## Protocol 2 - Runtime Protection
Protected folders:

- backend
- frontend
- tests
- docs
- _operations
- data
- configs
- node_modules
- .git

## Protocol 3 - Archive Candidate Rule
A file is only an archive candidate when:

1. It is backup-like.
2. It is not imported by runtime code.
3. It is not registered as a route.
4. Tests pass after validation.

## Protocol 4 - No Delete Rule
This phase never deletes anything.

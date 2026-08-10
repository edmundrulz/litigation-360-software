# LEOS 360 - G7-A Test Matrix

Status: Engineering verification matrix.

| Area | Evidence |
|---|---|
| Backend targeted G7-A tests | Previously PASS, native ExitCode 0 |
| Backend full tests | Previously PASS, native ExitCode 0 |
| Frontend production build | Previously PASS, native ExitCode 0 |
| Frontend changed-file lint | Previously PASS, native ExitCode 0 |
| Existing backend changed JS syntax | 20/20 previously PASS |
| Request-ID middleware syntax | `node --check` in IMPLEMENT-20 |
| Request-ID unit tests | Targeted Jest execution in IMPLEMENT-20 |
| Backend regression | Full backend test execution in IMPLEMENT-20 |
| Git whitespace/errors | `git diff --check` |
| Secret heuristic | IMPLEMENT-20 touched files |
| Target preservation | Clean after successful commit |
| Primary boundary | Verified before and after |
| Protected DB | Hash preserved; no migration |

Test success supports an engineering candidate only; it is not Gate 7, legal,
security, compliance, release, or production acceptance.
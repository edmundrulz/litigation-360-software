# 04 Protocols, Checks and Verification

## Mandatory Working Standard
Every phase must include:

1. Objective
2. Exact file and folder path
3. Backup protocol
4. Deployment script
5. Rollback script
6. Verification command
7. Expected output
8. Testing checklist
9. PASS/FAIL criteria
10. Next action only after verification

## No-Go Rules
- No assumptions
- No vague instructions
- No risky regex patching
- No file replacement without backup
- No phase closure without verification
- No fake-live planned modules

## Verification Levels
Level 1 File verification
Level 2 Build verification
Level 3 Backend verification
Level 4 Frontend verification
Level 5 User acceptance testing
Level 6 Documentation record

## Phase Completion Rule
A phase is PASS only when build, backend, frontend, user test, rollback, and documentation are complete.

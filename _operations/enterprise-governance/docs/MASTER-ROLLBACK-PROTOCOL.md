# Master Rollback Protocol

## Rollback Rule
Every deployment script must back up modified files into its phase backup folder.

## Rollback Procedure
1. Stop backend and frontend.
2. Locate relevant _operations phase backup.
3. Copy .bak file back to original path.
4. Restart backend.
5. Run validation endpoint.
6. Run gatekeeper approval check.

## Never Roll Back Blindly
Always confirm:
- Which file changed
- Which route was mounted
- Which validation failed

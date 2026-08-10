# LEOS 360 - G7-A Security Remediation Implementation

Status: Implementation evidence.

## Existing core hardening
Core hardening commit:
`70dfe294af18c055c8fb5aca3985e933cebd4649`

Independent review established an exact 25-path hardening boundary.

## IMPLEMENT-20 bounded successor
This transaction closes the remaining demonstrated request-correlation gap:
- `backend/src/middleware/requestId.js`
- `backend/src/middleware/requestId.test.js`
- registration in `backend/src/index.js`

Behaviour:
- constrain/validate inbound `X-Request-ID`;
- generate UUID when absent/invalid;
- expose ID on `req.requestId` and `res.locals.requestId`;
- return `X-Request-ID`;
- inject `requestId` into object JSON errors unless already present;
- do not change successful JSON response bodies.

## Exclusions
No merge, push, deployment, authoritative DB migration, Vite lifecycle change,
Legal Dispatch, or primary-branch mutation is authorized.
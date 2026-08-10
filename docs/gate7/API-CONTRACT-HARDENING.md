# LEOS 360 - G7-A API Contract Hardening

Status: Engineering contract.

## Request ID
Inbound header: `X-Request-ID`.

A supplied value is retained only when non-empty after trimming, not more than
128 characters, and limited to letters, digits, `.`, `_`, `:`, and `-`.
Otherwise the server generates a UUID.

Server state:
- `req.requestId`
- `res.locals.requestId`

Outbound header:
- `X-Request-ID: <request-id>`

For status codes >= 400, object JSON payloads receive `requestId` when one is
not already present. Successful JSON bodies are not changed.

A client-provided request ID is correlation metadata only and grants no
identity, authentication, role, permission, or trusted-device status.

Backend ESLint project configuration remains separately tracked tooling debt.
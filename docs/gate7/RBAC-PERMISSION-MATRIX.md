# LEOS 360 - G7-A RBAC Permission Matrix

Status: Controlled implementation mapping.

Code-authoritative RBAC definitions remain in:
- `backend/src/security/rbac.js`
- `backend/src/middleware/roleMiddleware.js`
- protected route enforcement points.

| Control | Authority | Expectation |
|---|---|---|
| Authentication | Server | Establish trusted identity before protected action |
| Role resolution | Server | Derive role from trusted server identity/session |
| Permission decision | Server | Enforce role/permission server-side |
| Direct API access | Server | UI visibility never substitutes for API authorization |
| Denied operation | Server | Reject without performing protected action |
| Logout/revocation | Server | Revoked session/token cannot remain authorization basis |
| Request correlation | Server | Request ID supports traceable denied/error requests |

Role/permission names are not invented by this document; implementation is the
source of truth.
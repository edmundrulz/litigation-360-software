# LEOS 360 - G7-A Architecture Baseline

Status: Controlled engineering evidence; not Gate 7 acceptance.

## Baseline
- Target branch: `codex/g7a-core-hardening-20260809`
- Pre-IMPLEMENT-20 hardening HEAD: `70dfe294af18c055c8fb5aca3985e933cebd4649`
- Verified hardening boundary: 25 changed paths.
- Primary protected working state remains outside this transaction.

## Security architecture
G7-A is server-authoritative and includes:
- fail-closed runtime configuration;
- governed migration execution;
- authentication token/session management;
- login throttling;
- RBAC enforcement;
- adaptive authentication;
- request correlation through a server-issued or validated request ID.

## Request lifecycle
Requests receive a request ID before application route handling. A valid inbound
`X-Request-ID` may be retained; absent or invalid identifiers are replaced by a
server-generated UUID. The ID is returned in `X-Request-ID`. JSON error responses
receive `requestId` when their payload does not already contain it.

## Constraints
This document does not claim Gate 7/G7-A acceptance, ISO certification,
production release, deployment, or legal acceptance.
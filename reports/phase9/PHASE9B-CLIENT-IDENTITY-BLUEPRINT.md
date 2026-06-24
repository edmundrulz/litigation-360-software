# Phase 9B Master Client Identity Engine Blueprint

Status: Commencing

## Objective
Prevent duplicate client creation and identify related existing client records before new client creation.

## Matching Fields
- Client name
- NRIC
- Passport number
- Company registration number
- Email
- Mobile number
- Existing matters
- Closed matters

## Match Ratings
- EXACT_MATCH
- LIKELY_MATCH
- POSSIBLE_MATCH
- NO_MATCH

## System Actions
- Block confirmed duplicate
- Flag likely duplicate
- Allow override with reason
- Log identity check result
- Prepare future merge engine support

## Target Files
- backend\src\utils\clientIdentityEngine.js
- backend\src\routes\clientIdentity.js
- tests\client-identity.test.js

## API Targets
GET /api/client-identity/check
POST /api/client-identity/check

## Exit Criteria
Phase 9B is complete when the system can check client identity matches and classify duplicate risk.

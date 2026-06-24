# Phase 10ZZG.4 — Feature Override API Hardening SOP

## Purpose

This phase hardens manual feature override controls.

Feature overrides allow the owner or super admin to unlock a specific feature for a specific user, even if the user's firm subscription plan normally does not include that feature.

This must be tightly controlled because overrides can bypass normal commercial subscription limits.

---

# Feature Override Rules

## Allowed

- Grant one feature to one user.
- Revoke one feature from one user.
- List all overrides.
- List overrides by firm.
- List overrides by firm and user.
- Check if one override is active.

## Not Allowed

- Grant invalid feature keys.
- Revoke Ground Zero privileges.
- Let normal users grant overrides.
- Let standard admins revoke overrides.
- Make undocumented manual JSON edits after API control is active.

---

# Required Parameters

## Grant Feature Override

Endpoint:

POST /test/admin/owner/feature/grant

Required body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "userId": "USER_STARTER",
  "featureKey": "LEGAL_AI"
}

---

## Revoke Feature Override

Endpoint:

POST /test/admin/owner/feature/revoke

Required body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "userId": "USER_STARTER",
  "featureKey": "LEGAL_AI"
}

---

## List Overrides

Endpoint:

GET /test/admin/owner/feature/list

Optional query parameters:

firmId  
userId  

Examples:

/test/admin/owner/feature/list

/test/admin/owner/feature/list?firmId=FIRM_STARTER_SAMPLE

/test/admin/owner/feature/list?firmId=FIRM_STARTER_SAMPLE&userId=USER_STARTER

---

## Override Status

Endpoint:

GET /test/admin/owner/feature/status?firmId=FIRM_STARTER_SAMPLE&userId=USER_STARTER&featureKey=LEGAL_AI

Required query parameters:

firmId  
userId  
featureKey  

---

# Permission Matrix

| Action | Admin | Super Admin | Owner |
|---|---|---|---|
| List overrides | Yes | Yes | Yes |
| Check status | Yes | Yes | Yes |
| Grant override | No | Yes | Yes |
| Revoke override | No | No | Yes |

---

# Validation Rules

Every feature override request must check:

1. Admin role.
2. Approval matrix.
3. Safety lock.
4. Required parameters.
5. Valid feature key in backend/licensing/features.json.
6. Audit log entry.
7. Result confirmation.

---

# Expected Failure Codes

| Scenario | Error |
|---|---|
| Missing featureKey | MISSING_REQUIRED_PARAMETERS |
| Invalid featureKey | INVALID_FEATURE_KEY |
| Normal user grants override | ACTION_NOT_APPROVED |
| Super admin revokes override | ACTION_NOT_APPROVED |
| Ground Zero revoke attempt | GROUND_ZERO_PROTECTED |

---

# Ground Zero Rule

Ground Zero access is not an override.

Ground Zero is permanent founding-client entitlement.

Do not use revoke override to reduce Ground Zero access.

---

# Checks & Balances

Before marking complete:

1. Grant valid feature override.
2. List override.
3. Check status active.
4. Revoke override as owner.
5. Check status inactive.
6. Attempt invalid feature key.
7. Attempt normal user grant.
8. Attempt super admin revoke.
9. Attempt Ground Zero revoke.
10. Confirm audit log records all events.

---

# Completion Rule

Phase 10ZZG.4 is complete only when all live tests produce the expected results.

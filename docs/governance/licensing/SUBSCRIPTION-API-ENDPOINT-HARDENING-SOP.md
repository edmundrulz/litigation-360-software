# Phase 10ZZG.3 — Subscription API Endpoint Hardening SOP

## Purpose

This phase hardens admin subscription API endpoints.

It adds:

- Approval matrix enforcement
- Ground Zero safety lock enforcement
- Required parameter validation
- Subscription plan validation
- Trial day validation
- Stronger action audit logging

---

# Protected Endpoints

| Endpoint | Required Control |
|---|---|
| /subscription/set-plan | Approval + validation |
| /subscription/downgrade | Owner-only + safety lock |
| /subscription/suspend | Owner-only + safety lock |
| /subscription/activate | Approval + validation |
| /trial/start | Approval + trial day validation |
| /feature/grant | Approval + validation |

---

# Parameters

## Set Plan

Required:

- firmId
- plan

Allowed plans:

- STARTER
- PROFESSIONAL
- BUSINESS
- ENTERPRISE
- GROUND_ZERO

---

## Downgrade

Required:

- firmId
- plan

Ground Zero must be blocked.

---

## Suspend

Required:

- firmId

Ground Zero must be blocked.

---

## Start Trial

Required:

- firmId

Optional:

- days

Allowed days:

1 to 90

---

## Grant Feature Override

Required:

- firmId
- userId
- featureKey

---

# Checks & Balances

Every protected endpoint must pass:

1. Role approval
2. Safety lock
3. Required parameter validation
4. Business rule validation
5. Admin audit logging
6. Result verification

---

# Failure Rules

If missing parameter:

400 MISSING_REQUIRED_PARAMETERS

If invalid plan:

400 INVALID_PLAN

If invalid trial days:

400 INVALID_TRIAL_DAYS

If unapproved role:

403 ACTION_NOT_APPROVED

If Ground Zero restricted action:

403 GROUND_ZERO_PROTECTED

---

# Completion Rule

This phase is complete when live endpoint tests confirm:

- Valid actions succeed
- Invalid actions fail safely
- Ground Zero remains protected
- Audit log records actions

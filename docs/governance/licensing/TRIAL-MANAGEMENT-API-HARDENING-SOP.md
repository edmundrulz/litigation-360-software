# Phase 10ZZG.5 — Trial Management API Hardening SOP

## Purpose

This phase hardens trial lifecycle management.

It allows authorised admins to:

- Start trial
- End trial
- Check trial status
- List all trials
- Refresh expired trials
- Audit trial actions

---

# Trial Control Rule

Trial access is temporary.

Ground Zero access is permanent.

Do not confuse trial access with Ground Zero founding-client access.

Ground Zero must never be trial-expired, feature-limited, suspended, downgraded, or billing-locked.

---

# API Endpoints

## Start Trial

POST /test/admin/owner/trial/start

Required body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "days": 30
}

Allowed days:

1 to 90

---

## End Trial

POST /test/admin/owner/trial/end

Required body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "reason": "TEST_END"
}

Owner only.

Ground Zero blocked.

---

## Trial Status

GET /test/admin/owner/trial/status?firmId=FIRM_STARTER_SAMPLE

Returns:

- trial_active
- trial_expired
- trial_start
- trial_end
- days_remaining
- trial_status

---

## Trial List

GET /test/admin/owner/trial/list

Returns all active trial records.

---

## Refresh Expiries

POST /test/admin/owner/trial/refresh-expiries

Checks all trials and expires any trial past trial_end.

---

# Permission Matrix

| Action | Admin | Super Admin | Owner |
|---|---|---|---|
| Start trial | No | Yes | Yes |
| End trial | No | No | Yes |
| View trial status | Yes | Yes | Yes |
| List trials | Yes | Yes | Yes |
| Refresh expiries | No | No | Yes |

---

# Parameters

## firmId

Required for:

- start trial
- end trial
- status

Example:

FIRM_STARTER_SAMPLE

---

## days

Optional for start trial.

Default:

30

Allowed:

1 to 90

---

## reason

Optional for end trial.

Default:

ADMIN_ENDED

---

# Checks & Balances

Before starting a trial:

1. Confirm firm ID.
2. Confirm firm is not Ground Zero.
3. Confirm days between 1 and 90.
4. Confirm admin role is Super Admin or Owner.
5. Start trial.
6. Write audit log.
7. Check trial status.

Before ending a trial:

1. Confirm firm ID.
2. Confirm firm is not Ground Zero.
3. Confirm role is Owner.
4. End trial.
5. Write audit log.
6. Confirm trial_active false.
7. Confirm trial_expired true.

---

# Failure Codes

| Scenario | Expected Error |
|---|---|
| Missing firmId | MISSING_REQUIRED_PARAMETERS |
| Invalid days | INVALID_TRIAL_DAYS |
| Normal user start trial | ACTION_NOT_APPROVED |
| Super admin end trial | ACTION_NOT_APPROVED |
| Ground Zero end trial | GROUND_ZERO_PROTECTED |

---

# Completion Rule

Phase 10ZZG.5 is complete only when live tests confirm:

- Start trial passes.
- Status shows active.
- List shows trial.
- Invalid days fail.
- Normal user blocked.
- Super admin end blocked.
- Owner end passes.
- Status shows ended.
- Ground Zero end blocked.

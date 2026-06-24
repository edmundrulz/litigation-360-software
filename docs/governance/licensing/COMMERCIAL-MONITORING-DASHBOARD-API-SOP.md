# Phase 10ZZG.6 — Commercial Monitoring Dashboard API SOP

## Purpose

This phase creates live admin API endpoints for commercial monitoring.

It monitors:

- Active clients
- Suspended clients
- Paid clients
- Exempt clients
- Active trials
- Expired trials
- Feature overrides
- Audit activity
- Ground Zero protection

---

# API Endpoints

Base test path:

http://localhost:5061/test/admin/owner

## Dashboard

GET /dashboard

Shows commercial summary.

## Clients

GET /clients

Shows firm subscription records.

## Trials

GET /trials

Shows trial records.

## Feature Overrides

GET /feature-overrides

Shows manual feature unlocks.

## Audit Summary

GET /audit-summary

Shows audit count and recent audit entries.

## Commercial Health

GET /commercial-health

Shows overall commercial monitoring status.

---

# Access Rules

All endpoints require admin access.

Allowed:

- OWNER
- SUPER_ADMIN
- ADMIN

Blocked:

- LAWYER
- CLERK
- NORMAL USER

---

# Ground Zero Rule

Ground Zero must always show as:

FULL_ACCESS_UNLIMITED

Ground Zero must not be counted as suspended, expired, downgraded, or billing-locked.

---

# Checks & Balances

Before completion:

1. Dashboard endpoint returns success.
2. Clients endpoint returns firms.
3. Trials endpoint returns trial records.
4. Feature override endpoint returns override records.
5. Audit summary endpoint returns audit count.
6. Commercial health endpoint returns OPERATIONAL.
7. Normal user access is blocked.
8. Monitoring JSON file exists.
9. Audit logs are updated.
10. Server runs on port 5061.

---

# Completion Rule

Phase 10ZZG.6 is complete only after live API tests return expected results.

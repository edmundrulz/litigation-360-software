# Phase 10ZZD — Feature Exclusivity, Subscription Locking & Ground Zero Unlimited Access

## Purpose

This phase controls which Litigation 360 features are visible, hidden, locked, unlocked, trial-enabled or subscription-enabled.

The system must support:

1. Full unlimited access for Ground Zero founding client.
2. Subscription-based feature visibility for all other firms.
3. Manual feature overrides by system owner.
4. Trial-based temporary unlocking.
5. Invisible locked features until enabled.
6. Future upgrade and downgrade automation.

---

# Ground Zero Rule

The founding client, being the developer's father's firm, receives:

- Full access
- No subscription restriction
- No usage limit
- No feature lock
- No module limitation
- No AI limitation
- No beta restriction
- No trial expiry
- No billing lock

This client is classified as:

UNLIMITED_FOUNDING_CLIENT

---

# Other Customer Rule

All other customers are restricted by:

1. Subscription plan
2. Payment status
3. Trial status
4. Role permission
5. Manual override
6. Feature status

---

# Feature Visibility Rule

If customer is Ground Zero:

SHOW EVERYTHING

If customer is trial user:

SHOW TRIAL FEATURES

If customer is paid subscriber:

SHOW ONLY SUBSCRIBED FEATURES

If customer has no access:

HIDE FEATURE COMPLETELY

---

# Subscription Plans

## Starter

Basic daily legal operations.

## Professional

Operational law firm workflow.

## Business

Advanced law firm automation.

## Enterprise

Full command centre, AI, integrations and autonomous operations.

---

# Mandatory Control Principle

Frontend hiding is NOT enough.

Every feature must be protected at:

1. Frontend display level
2. Backend route level
3. API permission level
4. Database entitlement level
5. Audit log level

---

# Access Decision Order

1. Is this Ground Zero client?
2. Is there a manual owner override?
3. Is trial active?
4. Is subscription active?
5. Does plan include this feature?
6. Does user role allow it?
7. If yes, grant access.
8. If no, hide or block access.

---

# Final Rule

Ground Zero gets everything.

Everyone else gets only what they subscribe to, can afford, need, or are manually granted.

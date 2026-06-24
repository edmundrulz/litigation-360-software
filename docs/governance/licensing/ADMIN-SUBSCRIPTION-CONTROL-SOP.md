# Phase 10ZZF — Admin Subscription Control Panel SOP

## Purpose

This phase allows the system owner to control firm access without manually editing backend routes.

The admin control layer manages:

- Subscription upgrades
- Subscription downgrades
- Trial activation
- Manual feature unlocks
- Firm suspension
- Firm reactivation
- Ground Zero protection

---

# Golden Rule

Ground Zero can never be downgraded, suspended, limited, trial-expired, or locked.

Ground Zero always receives full access.

---

# Supported Plans

- STARTER
- PROFESSIONAL
- BUSINESS
- ENTERPRISE
- GROUND_ZERO

---

# Control Files

backend/admin/firm-subscriptions.json  
backend/admin/feature-overrides.json  
backend/admin/trial-controls.json  
backend/admin/admin-actions-audit.log  

---

# Required Admin Checks

Before changing any customer access:

1. Confirm firm ID.
2. Confirm current plan.
3. Confirm requested plan.
4. Confirm billing status.
5. Confirm whether firm is Ground Zero.
6. Confirm if trial is active.
7. Confirm if manual override exists.
8. Log action.
9. Verify access after update.

---

# Protection Rules

If firm is Ground Zero:

- Do not downgrade.
- Do not suspend.
- Do not expire trial.
- Do not lock features.
- Do not apply payment restriction.

If firm is normal customer:

- Allow upgrade.
- Allow downgrade.
- Allow suspension.
- Allow trial activation.
- Allow manual feature overrides.

---

# Testing Protocol

Test the following:

1. Ground Zero downgrade attempt must fail safely.
2. Starter upgrade to Professional must update plan.
3. Firm suspension must update status.
4. Firm activation must restore status.
5. Manual feature override must be recorded.
6. Trial activation must create trial dates.
7. Audit log must record all admin actions.

---

# Final Rule

The admin control system is the master control room for subscription access.

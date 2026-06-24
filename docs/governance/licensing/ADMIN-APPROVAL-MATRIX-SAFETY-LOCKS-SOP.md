# Phase 10ZZG.2 — Admin Approval Matrix & Action Safety Locks SOP

## Purpose

This phase prevents dangerous admin mistakes.

It controls:

- Who may upgrade customers
- Who may downgrade customers
- Who may suspend customers
- Who may start trials
- Who may revoke access
- Which firms are permanently protected

---

# Approval Matrix

| Action | Admin | Super Admin | Owner |
|---|---|---|---|
| View health | Yes | Yes | Yes |
| Start trial | No | Yes | Yes |
| Upgrade plan | No | Yes | Yes |
| Downgrade plan | No | No | Yes |
| Suspend firm | No | No | Yes |
| Activate firm | No | Yes | Yes |
| Grant override | No | Yes | Yes |
| Revoke override | No | No | Yes |
| Ground Zero change | No | No | Yes |

---

# Ground Zero Safety Rule

FIRM_GROUND_ZERO must never be:

- Downgraded
- Suspended
- Trial expired
- Billing locked
- Feature restricted
- Usage limited

---

# Created Files

backend/admin/approval-matrix.json  
backend/admin/safety-locks.json  
backend/middleware/requireApproval.js  
backend/middleware/safetyLock.js  

---

# Required Protocol

Every high-risk admin route must use both:

requireApproval("ACTION_NAME")

and:

safetyLock("ACTION_NAME")

---

# Checks & Balances

Before any admin change:

1. Confirm admin role.
2. Confirm action is allowed.
3. Confirm target firm is not protected.
4. Confirm request parameters are present.
5. Execute action.
6. Write audit log.
7. Verify resulting firm state.
8. Confirm Ground Zero remains unlimited.

---

# Completion Rule

This phase is complete when:

- Approval matrix exists.
- Safety locks exist.
- Middleware exists.
- Ground Zero protection exists.
- Verification script passes.

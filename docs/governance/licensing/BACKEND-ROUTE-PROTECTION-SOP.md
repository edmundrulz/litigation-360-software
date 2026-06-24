# Phase 10ZZE — Backend Route Protection SOP

## Purpose

Frontend feature hiding is not enough.

A user may still attempt to directly access backend APIs, routes, URLs or endpoints.

This phase protects every premium, locked, trial, role-based and subscription-based feature at backend level.

---

# Core Principle

Every protected backend route must check:

1. Is the client Ground Zero?
2. Is there a manual user override?
3. Is trial access active?
4. Is the firm subscribed to the required plan?
5. If yes, allow.
6. If no, block with 403.

---

# Ground Zero Rule

Father's firm has:

- Full access
- No usage restriction
- No feature lock
- No trial expiry
- No subscription downgrade
- No AI limitation
- No user limitation
- No route block

Ground Zero must always pass route protection.

---

# Standard Customer Rule

All other customers must pass subscription entitlement checks.

If they are not subscribed, the route must return:

403 FEATURE_LOCKED

---

# Required Middleware

File:

backend/middleware/requireFeature.js

Usage:

requireFeature("LEGAL_AI")

Example:

router.get("/legal-ai", requireFeature("LEGAL_AI"), controllerFunction)

---

# Protected Modules

The following must be protected:

- Tasks
- Notifications
- Court Navigation
- Reports
- Lawyer View
- Clerk View
- Admin View
- Finance View
- Partner View
- Legal AI
- Knowledge Management
- Predictive Analytics
- Executive Command Centre
- Workflow Automation
- Government Integrations
- Client Portal
- Mobile App
- Autonomous Operations
- Marketplace

---

# Audit Logging

Every feature access attempt must be logged.

Audit file:

backend/audit/feature-access-audit.log

Each log must include:

- Timestamp
- User ID
- Firm ID
- Firm name
- Feature requested
- Subscription plan
- Access granted true/false
- Reason

---

# Access Reasons

Allowed reasons:

- GROUND_ZERO_FULL_ACCESS
- MANUAL_USER_OVERRIDE
- ACTIVE_TRIAL
- SUBSCRIPTION_PLAN_ALLOWED

Blocked reason:

- FEATURE_NOT_INCLUDED_IN_PLAN

---

# Security Protocol

Do not rely only on frontend controls.

Feature control must exist in:

1. Frontend visibility
2. Backend route middleware
3. API controller checks
4. Database entitlement checks
5. Audit logs
6. Admin monitoring
7. Test scripts

---

# Testing Protocol

## Test 1 — Ground Zero

Route:

/test/ground-zero/legal-ai

Expected:

200 OK

Reason:

GROUND_ZERO_FULL_ACCESS

---

## Test 2 — Starter blocked from Legal AI

Route:

/test/starter/legal-ai

Expected:

403 FEATURE_LOCKED

Reason:

FEATURE_NOT_INCLUDED_IN_PLAN

---

## Test 3 — Trial user allowed Legal AI

Route:

/test/trial/legal-ai

Expected:

200 OK

Reason:

ACTIVE_TRIAL

---

## Test 4 — Starter allowed Tasks

Route:

/test/starter/tasks

Expected:

200 OK

Reason:

SUBSCRIPTION_PLAN_ALLOWED

---

# Implementation Rule

Every new route must use:

requireFeature("FEATURE_KEY")

No premium route may be created without this middleware.

---

# Checks and Balances

Before activating a new module:

1. Confirm feature key exists in features.json.
2. Confirm plan mapping exists in plans.json.
3. Confirm backend route uses requireFeature().
4. Confirm frontend uses featureAccess.js.
5. Confirm Ground Zero receives access.
6. Confirm unpaid plan is blocked.
7. Confirm audit log records both allowed and denied access.
8. Confirm no hardcoded bypass exists except Ground Zero.
9. Confirm test server passes.
10. Confirm governance document updated.

---

# Failure Handling

If a customer is wrongly blocked:

1. Check firm subscription_plan.
2. Check plans.json.
3. Check trial_active and trial_expired.
4. Check user feature_overrides.
5. Check firm license_type.
6. Check audit log reason.
7. Correct entitlement.
8. Retest route.

---

# Final Rule

Frontend hides.

Backend blocks.

Audit records.

Ground Zero bypasses all restrictions.

Everyone else follows subscription entitlement.

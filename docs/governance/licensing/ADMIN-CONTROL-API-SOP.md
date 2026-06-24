# Phase 10ZZG.1 — Admin API Framework SOP

## Purpose

This phase creates backend API routes for controlling subscriptions, trials, firm activation, firm suspension, and manual feature overrides.

This converts the admin subscription control files from manual JSON-based control into API-based control.

---

# Core Rule

The API must never allow ordinary users to control subscriptions.

Only the following roles may use admin API routes:

- OWNER
- SUPER_ADMIN
- ADMIN for read-only or limited operations

High-risk actions require:

- OWNER
- SUPER_ADMIN

---

# Protected Admin Actions

## Super Admin Required

- Set firm plan
- Downgrade firm
- Upgrade firm
- Suspend firm
- Activate firm
- Start trial
- Grant feature override

## Admin Allowed

- Health check
- Future read-only dashboard access

---

# Ground Zero Protection

Ground Zero must never be:

- Downgraded
- Suspended
- Feature locked
- Trial expired
- Billing locked

Any attempt must be safely blocked or ignored.

---

# Created Files

backend/routes/admin-control-routes.js  
backend/middleware/requireAdmin.js  
backend/middleware/requireSuperAdmin.js  
backend/middleware/adminAudit.js  
backend/middleware/mockAdminContext.js  
tests/licensing/phase-10zzg-admin-api-test-server.js  
monitoring/commercialisation/admin-api-dashboard.json  

---

# API Routes

## Health

GET /test/admin/owner/health

Expected:

200 OK

---

## Set Plan

POST /test/admin/owner/subscription/set-plan

Body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "plan": "PROFESSIONAL"
}

Expected:

success true

---

## Suspend Firm

POST /test/admin/owner/subscription/suspend

Body:

{
  "firmId": "FIRM_STARTER_SAMPLE"
}

Expected:

success true

---

## Activate Firm

POST /test/admin/owner/subscription/activate

Body:

{
  "firmId": "FIRM_STARTER_SAMPLE"
}

Expected:

success true

---

## Start Trial

POST /test/admin/owner/trial/start

Body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "days": 30
}

Expected:

success true

---

## Grant Feature Override

POST /test/admin/owner/feature/grant

Body:

{
  "firmId": "FIRM_STARTER_SAMPLE",
  "userId": "USER_STARTER",
  "featureKey": "LEGAL_AI"
}

Expected:

success true

---

# Checks and Balances

Before marking this phase complete:

1. Server starts on port 5060.
2. Owner health endpoint returns success.
3. Normal user health endpoint returns 403.
4. Starter firm can upgrade to Professional.
5. Starter firm can be suspended.
6. Starter firm can be reactivated.
7. Trial can be started.
8. Feature override can be granted.
9. Audit log records every action.
10. Ground Zero remains protected.

---

# Audit File

backend/admin/admin-actions-audit.log

Every admin API action must be logged.

---

# Final Rule

Admin API controls the commercial switchboard.

No customer-facing commercial feature should be changed manually once this API layer is operational.

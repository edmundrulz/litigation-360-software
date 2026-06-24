# LITIGATION 360 LEOS
# MATTER DETAILS IMPLEMENTATION PROTOCOL

Version:
12.0B-MATTER-PROTOCOL

Status:
ACTIVE

Application Code Change:
NOT YET AUTHORISED BY THIS DOCUMENT

---

# 1. OBJECTIVE

Prepare the Matter Details page for safe implementation.

This protocol governs how the current Create Case page should eventually be upgraded into the Matter Details page.

---

# 2. SAFE SEQUENCE

Step 1:
Create documentation and governance pack.

Step 2:
Run read-only discovery of existing files, routes, and APIs.

Step 3:
Identify actual frontend file path.

Step 4:
Identify actual backend route path.

Step 5:
Identify actual database table or data model.

Step 6:
Create pre-change backup.

Step 7:
Implement Matter Details changes.

Step 8:
Run frontend verification.

Step 9:
Run backend verification.

Step 10:
Run workflow verification.

Step 11:
Record results.

Step 12:
Only then consider the Matter Details step complete.

---

# 3. CURRENT PHASE 12.0B LIMIT

This phase is limited to:

- Documentation
- Protocols
- Parameters
- Blueprints
- Prompts
- Checklists
- Read-only discovery
- Live monitoring setup
- Verification setup
- Testing setup

This phase does not modify application code.

---

# 4. REQUIRED BEFORE CODE CHANGE

Before editing any frontend or backend code, the following must exist:

[ ] Matter Details Blueprint
[ ] Matter Details Parameters
[ ] Matter Details Test Plan
[ ] Matter Details Verification Checklist
[ ] Matter Details Rollback Plan
[ ] Actual frontend file path identified
[ ] Actual backend file path identified
[ ] Actual route path identified
[ ] Actual data model identified
[ ] Pre-change backup created
[ ] Similar documents checked
[ ] Similar scripts checked
[ ] Approval recorded

---

# 5. PROHIBITED DURING THIS PHASE

Do not:

- Delete code
- Rename application files
- Move application folders
- Refactor unrelated components
- Change database schema
- Activate Phase 11 features
- Add AI
- Add billing
- Add marketplace
- Add client portal
- Add Google Maps
- Remove existing routes
- Remove existing modules
- Modify production data

---

# 6. APPROVED CHANGE TARGET LATER

When authorised later, the expected UI change is:

From:

Create Case
Case Title
Select Client
Create
Title | Status | Actions

To:

Matter Details
Create New Matter
Matter Title
Linked Client
Matter Type
Matter Status
Description
Create Matter
Save & Continue to Deadline Details
Matter Title | Client | Type | Status | Actions

---

END OF MATTER DETAILS IMPLEMENTATION PROTOCOL
# LITIGATION 360 LEOS
# MATTER DETAILS TEST PLAN

Version:
12.0B-MATTER-TEST-PLAN

Status:
ACTIVE

---

# 1. TEST OBJECTIVE

Verify that Matter Details works as the correct second step after Client Profile Details and before Deadline Details.

---

# 2. TEST SCOPE

In scope:

- Matter Details page title
- Create New Matter form
- Linked Client selector
- Matter Type selector
- Matter Status selector
- Matter Description
- Existing Matters table
- Matter actions
- Save and continue workflow
- Client-to-matter relationship

Out of scope for first version:

- AI
- Billing
- Google Maps
- Court navigation
- Client portal
- Advanced analytics
- Digital twin
- Marketplace

---

# 3. MANUAL UI TESTS

Test 001:
Open Matter Details page.

Expected:
Page title shows Matter Details.

PASS Evidence:
Screenshot or note with URL/path.

---

Test 002:
Verify Create New Matter form exists.

Expected:
Fields visible:
Matter Title
Linked Client
Matter Type
Matter Status
Description

---

Test 003:
Create matter with valid client.

Expected:
Matter is created and displayed in table.

---

Test 004:
Create matter without title.

Expected:
System blocks submission.

---

Test 005:
Create matter without client.

Expected:
System blocks submission.

---

Test 006:
Create matter with default status.

Expected:
Status defaults to Open.

---

Test 007:
Click Save & Continue to Deadline Details.

Expected:
User continues to Deadline Details without returning to Home.

---

Test 008:
Verify existing Client Profile page still works.

Expected:
No regression.

---

# 4. API TESTS

Only perform API tests after backend route is identified.

Required checks:

[ ] Create Matter API works
[ ] List Matters API works
[ ] Matter linked to Client ID
[ ] Invalid client is rejected
[ ] Missing title is rejected
[ ] Missing status is rejected
[ ] Error response is readable
[ ] Audit/logging behavior reviewed

---

# 5. REGRESSION TESTS

Verify no breakage in:

[ ] Client Profile Details
[ ] Existing Client List
[ ] Existing Case/Matter List
[ ] Dashboard navigation
[ ] Deadline page
[ ] Document page

---

# 6. PASS CRITERIA

Matter Details passes when:

[ ] UI loads
[ ] Valid matter can be created
[ ] Matter links to client
[ ] Matter appears in table
[ ] Validation blocks incomplete submission
[ ] Save & Continue works
[ ] Existing client profile remains working
[ ] No unrelated module breaks
[ ] Evidence recorded

---

# 7. FAIL CRITERIA

Matter Details fails when:

[ ] Page does not load
[ ] Matter cannot be created
[ ] Matter does not link to client
[ ] Invalid matter is accepted
[ ] Save & Continue fails
[ ] Existing client profile breaks
[ ] Existing routes break
[ ] No evidence is recorded

---

END OF MATTER DETAILS TEST PLAN
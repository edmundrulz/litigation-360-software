# LITIGATION 360 LEOS
# MATTER DETAILS MASTER BLUEPRINT

Version:
12.0B-MATTER-BLUEPRINT

Status:
ACTIVE BLUEPRINT

Phase:
PHASE 12.0B

Implementation Status:
DOCUMENTATION AND READ-ONLY DISCOVERY ONLY

Application Code Change:
NOT YET AUTHORISED

---

# 1. PURPOSE

The Matter Details page is the second major step after the near-complete Client Profile Details page.

It replaces the overly simple "Create Case" structure:

Create Case
Case Title
Select Client
Create
Title | Status | Actions

with a governed legal matter structure:

Matter Details
Create New Matter
Matter Title
Linked Client
Matter Type
Matter Status
Description
Create Matter
Save & Continue to Deadline Details
Existing Matters

---

# 2. CORE DESIGN DECISION

Matter is the parent legal file.

Case is a court-specific or litigation-specific expression of a Matter.

Correct hierarchy:

Client
↓
Matter
↓
Court Case / Deadline / Document / Task / Billing / Notes

Therefore:

"Create Case" should become "Create Matter".

"Case Title" should become "Matter Title".

"Select Client" should become "Linked Client".

---

# 3. APPROVED WORKFLOW POSITION

The approved workflow is:

Client Profile Details
↓
Matter Details
↓
Deadline Details
↓
Document Details
↓
Review
↓
Save & Submit

Forbidden workflow:

Client
↓
Back Home
↓
Matter
↓
Back Home
↓
Deadline
↓
Back Home
↓
Document
↓
Back Home

---

# 4. PAGE TITLE STRUCTURE

Main page title:

Matter Details

Form section title:

Create New Matter

Table section title:

Existing Matters

---

# 5. MINIMUM SAFE FIRST VERSION

The first implementation should include only the fields necessary for stable workflow continuation.

Required first-version fields:

1. Matter Title
2. Linked Client
3. Matter Type
4. Matter Status
5. Description

Primary buttons:

1. Create Matter
2. Save & Continue to Deadline Details

---

# 6. FUTURE FIELDS NOT YET REQUIRED

Do not add these until the basic Matter Details workflow is stable:

- Court name
- Court case number
- Judge
- Opposing party
- Opposing lawyer
- Lawyer in charge
- Clerk in charge
- Billing type
- Matter value
- Google Maps
- AI summary
- Predictive analytics
- Document automation
- Client portal integration

---

# 7. MATTER TYPE OPTIONS

Allowed Matter Type options:

- Litigation
- Advisory
- Contract
- Debt Recovery
- Conveyancing
- Employment
- Family
- Criminal
- Corporate
- General
- Other

Default:

General

---

# 8. MATTER STATUS OPTIONS

Allowed Matter Status options:

- Draft
- Open
- Active
- Pending Client
- Pending Court
- On Hold
- Closed
- Archived

Default:

Open

---

# 9. PRIORITY OPTIONS

Allowed Priority options for future enhancement:

- Low
- Normal
- High
- Urgent
- Critical

Default:

Normal

Priority is optional for first version.

---

# 10. TABLE STRUCTURE

Replace:

Title | Status | Actions

with:

Matter Title | Client | Type | Status | Actions

Future enhanced table:

Matter No. | Matter Title | Client Name | Matter Type | Status | Responsible Person | Next Deadline | Actions

---

# 11. ACTIONS COLUMN

Minimum actions:

- View
- Edit
- Add Deadline
- Add Document
- Archive

Do not add Delete as the primary action.

Deletion should be restricted and governed.

Archive is safer than Delete.

---

# 12. DATA CONTRACT

Recommended Matter object:

{
  "id": "system-generated",
  "matterTitle": "string, required",
  "clientId": "string or number, required",
  "clientName": "string, derived/display",
  "matterType": "string, required",
  "status": "string, required",
  "description": "string, optional",
  "createdAt": "datetime",
  "updatedAt": "datetime"
}

Future optional fields:

{
  "matterNumber": "string",
  "priority": "string",
  "assignedLawyer": "string",
  "assignedClerk": "string",
  "openDate": "date",
  "courtRelated": "boolean",
  "courtName": "string",
  "courtCaseNumber": "string",
  "nextDeadline": "date"
}

---

# 13. VALIDATION RULES

Matter Title:

Required.
Minimum length: 3 characters.
Maximum length: 150 characters.

Linked Client:

Required.
Must refer to an existing client.

Matter Type:

Required.
Must match approved options.

Matter Status:

Required.
Default: Open.

Description:

Optional.
Maximum length: 2000 characters.

---

# 14. PASS CRITERIA

The Matter Details implementation may pass only when:

[ ] Page title displays "Matter Details"
[ ] Form section displays "Create New Matter"
[ ] Matter Title field exists
[ ] Linked Client selector exists
[ ] Matter Type selector exists
[ ] Matter Status selector exists
[ ] Description field exists
[ ] Create Matter button exists
[ ] Save & Continue to Deadline Details button exists
[ ] Existing Matters table exists
[ ] Table shows Matter Title, Client, Type, Status, Actions
[ ] View action exists
[ ] Edit action exists
[ ] Add Deadline action exists
[ ] Add Document action exists
[ ] Archive action exists
[ ] Created matter links to selected client
[ ] Matter can be listed after creation
[ ] No duplicate standalone intake workflow is created
[ ] No Client → Home → Matter → Home flow is introduced
[ ] No Phase 11 feature is introduced
[ ] No AI feature is introduced
[ ] No production deployment is performed

---

# 15. FAIL CRITERIA

The Matter Details implementation fails if:

[ ] It still says Create Case as the main legal file
[ ] It does not link to a client
[ ] It creates a matter without a title
[ ] It creates a matter without status
[ ] It creates a matter without type
[ ] It breaks the Client Profile page
[ ] It breaks existing case/matter listing
[ ] It deletes records
[ ] It removes routes
[ ] It requires manual database editing
[ ] It introduces fake-live modules
[ ] It jumps to Phase 11 features
[ ] It bypasses governance

---

END OF MATTER DETAILS MASTER BLUEPRINT
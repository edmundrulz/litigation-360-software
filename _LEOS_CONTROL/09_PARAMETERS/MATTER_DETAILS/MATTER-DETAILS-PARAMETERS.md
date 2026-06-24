# LITIGATION 360 LEOS
# MATTER DETAILS PARAMETERS

Version:
12.0B-MATTER-PARAMETERS

Status:
ACTIVE

---

# 1. FIELD PARAMETERS

Field:
matterTitle

Label:
Matter Title

Required:
YES

Type:
Text

Minimum Length:
3

Maximum Length:
150

Default:
None

---

Field:
clientId

Label:
Linked Client

Required:
YES

Type:
Dropdown / Select

Source:
Existing clients

Default:
If arriving from Client Profile, use current client.

---

Field:
matterType

Label:
Matter Type

Required:
YES

Type:
Dropdown

Allowed Values:
Litigation
Advisory
Contract
Debt Recovery
Conveyancing
Employment
Family
Criminal
Corporate
General
Other

Default:
General

---

Field:
status

Label:
Matter Status

Required:
YES

Type:
Dropdown

Allowed Values:
Draft
Open
Active
Pending Client
Pending Court
On Hold
Closed
Archived

Default:
Open

---

Field:
description

Label:
Description / Matter Summary

Required:
NO

Type:
Long Text

Maximum Length:
2000

Default:
Blank

---

# 2. TABLE PARAMETERS

Minimum columns:

Matter Title
Client
Type
Status
Actions

Future columns:

Matter No.
Opened Date
Responsible Person
Next Deadline

---

# 3. ACTION PARAMETERS

Allowed first-version actions:

View
Edit
Add Deadline
Add Document
Archive

Restricted actions:

Delete

Delete must not be exposed as a normal primary action until governance, RBAC, audit trail and recovery policy are approved.

---

# 4. ROUTING PARAMETERS

Approved forward route:

Client Profile Details
↓
Matter Details
↓
Deadline Details

Matter Details should support:

Save only
Save and continue

---

# 5. GOVERNANCE PARAMETERS

Risk Classification:

MEDIUM

Reason:

Matter Details affects forms, validation, frontend workflow, linked client data and downstream deadline/document workflow.

Required Controls:

Change Request
Impact Assessment
Backup
Test Plan
Rollback Plan
Documentation Update
Monitoring
Verification
Approval

---

END OF MATTER DETAILS PARAMETERS
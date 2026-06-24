# User Roles & Permissions
**Litigation 360 - Role-Based Access Control System**

---

## 👥 User Role Hierarchy

### 1. Attorney (Senior User)
**Scope:** Full firm access by default

**Permissions:**
- ✅ Create matters
- ✅ Assign staff
- ✅ Manage clients
- ✅ Create invoices
- ✅ Access billing reports
- ✅ View trust account
- ✅ Manage user accounts
- ✅ Configure integrations
- ✅ View all communications
- ✅ Access all documents
- ✅ Create/edit templates
- ✅ Set billing rates
- ✅ Approve time entries (if manager)
- ✅ View profitability reports

**Default Matter Access:** All matters by assignment or firm-wide

**Dashboard Shows:**
- Open cases
- Active matters
- Upcoming deadlines
- Time tracking
- Billable hours (personal)
- Revenue metrics
- Client pipeline

---

### 2. Paralegal / Legal Assistant
**Scope:** Assigned matters and cases

**Permissions:**
- ✅ View assigned matters
- ✅ Create/edit documents (in assigned matters)
- ✅ Track time (own entries)
- ✅ File documents
- ✅ Communicate with clients (supervised)
- ✅ Track discovery
- ✅ Manage tasks
- ✅ Create notes
- ❌ Create matters
- ❌ Delete matters
- ❌ Create invoices
- ❌ Access other staff time entries
- ❌ View firm financials
- ❌ Manage users

**Matter Access:** Only assigned matters (read/write)

**Dashboard Shows:**
- Assigned matters
- Upcoming tasks
- Time entries (own)
- Communications
- Documents in assigned cases
- Matter deadlines

---

### 3. Billing / Accounting Staff
**Scope:** Billing and financial data

**Permissions:**
- ✅ View all time entries
- ✅ Create invoices
- ✅ Process payments
- ✅ Manage trust account
- ✅ Generate billing reports
- ✅ Approve/reject time entries
- ✅ Manage rate tables
- ✅ Access financial statements
- ✅ View AR (accounts receivable)
- ✅ Generate collection reports
- ❌ View case details (limited)
- ❌ Create matters
- ❌ Edit matter information
- ❌ Access confidential documents
- ❌ Manage users

**Matter Access:** Financial data only (read-only)

**Dashboard Shows:**
- Invoice status
- Accounts receivable
- Time entry summary
- Payment received
- Trust account balance
- Collection metrics
- Financial reports

---

### 4. Administrative / Firm Manager
**Scope:** System administration and firm configuration

**Permissions:**
- ✅ Manage all users
- ✅ Create user accounts
- ✅ Reset passwords
- ✅ Assign roles
- ✅ Configure firm settings
- ✅ Manage integrations
- ✅ Configure templates
- ✅ View audit logs
- ✅ Generate reports
- ✅ Manage backups
- ✅ Configure billing rules
- ✅ Set rate tables
- ✅ Access all firm data
- ❌ Cannot be sole user with firm access
- ❌ Requires backup admin

**Matter Access:** All matters (read/write admin)

**Dashboard Shows:**
- User management
- System health
- Integration status
- Audit logs
- Firm configuration
- Backup status
- System alerts

---

### 5. Client (Portal User)
**Scope:** Own case information only

**Permissions:**
- ✅ View own matters
- ✅ View assigned documents
- ✅ Download documents
- ✅ Send messages to attorney
- ✅ View invoices
- ✅ Pay invoices
- ✅ View case timeline
- ✅ View upcoming appointments
- ✅ Upload documents (if permitted)
- ❌ View other clients' matters
- ❌ Edit case information
- ❌ Access billing details (other than invoices)
- ❌ Delete documents
- ❌ View communications between attorneys

**Matter Access:** Assigned client matters only (limited read)

**Portal Shows:**
- My Cases
- My Documents
- My Messages
- My Invoices
- Upcoming Appointments
- Case Timeline
- Payment Methods

---

### 6. Co-Counsel / External Partner
**Scope:** Specific matter only (temporary)

**Permissions:**
- ✅ View assigned matter
- ✅ View matter documents
- ✅ Communicate within matter
- ✅ Create documents (if permitted)
- ✅ Track time (for billing)
- ❌ View other matters
- ❌ View client information (outside matter)
- ❌ Access firm settings
- ❌ View other staff
- ❌ Access billing/trust account

**Matter Access:** Single assigned matter (read/write as configured)

**Portal Shows:**
- Assigned Matter
- Matter Documents
- Communications
- Time Tracking
- Matter Timeline

---

## 🔐 Permission Matrix

| Action | Attorney | Paralegal | Billing | Admin | Client | Co-Counsel |
|--------|----------|-----------|---------|-------|--------|------------|
| Create Matter | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Edit Matter | ✅ | ⚠️* | ❌ | ✅ | ❌ | ❌ |
| Delete Matter | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| View Documents | ✅ | ✅ | ❌ | ✅ | ✅** | ✅ |
| Upload Documents | ✅ | ✅ | ❌ | ✅ | ⚠️** | ✅** |
| Create Invoice | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Process Payment | ⚠️ | ❌ | ✅ | ✅ | ✅ | ❌ |
| View Trust Account | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Create Time Entry | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ |
| Approve Time Entry | ✅** | ❌ | ✅ | ✅ | ❌ | ❌ |
| Send Message | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |
| View Communications | ✅ | ✅** | ⚠️ | ✅ | ✅** | ✅** |
| Manage Users | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| View Financials | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ |
| Generate Reports | ✅ | ⚠️ | ✅ | ✅ | ❌ | ❌ |
| Configure Settings | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Manage Integrations | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Audit Logs | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

*⚠️ = Conditional (specific limitations)*
***= Limited access or matter-specific*

---

## 🎯 Matter-Level Permissions

### Matter Access Types

**1. Owner**
- Created the matter
- Full permissions by default
- Can grant/revoke access to others

**2. Manager**
- Assigned by owner
- Can manage: time entries, documents, communications
- Can assign tasks
- Can generate matter reports

**3. Contributor**
- Can view matter
- Can create documents
- Can track time
- Can view communications
- Cannot modify matter settings

**4. Viewer**
- Read-only access
- Can view: documents, timeline, communications
- Cannot modify anything

**5. None**
- No access

---

## 📋 Document-Level Permissions

### Document Access Control

```
Default: Matter-level access
Override: Document-specific permissions

Options:
├── Private (Owner only)
├── Matter Team (All matter staff)
├── Firm (All firm users)
├── Client (Client portal)
├── Co-Counsel (External partner)
└── Public Link (Shared via URL)
```

**Permissions Per Document:**
- View
- Download
- Print
- Annotate
- Edit
- Share
- Delete

---

## 🔑 API Access Control

### API Key Permissions

**Use Cases:**
- Third-party integrations
- Mobile app authentication
- Bulk operations

**Scope Configuration:**
```
- read:matters
- read:documents
- write:matters
- write:documents
- read:billing
- write:billing
- read:communications
- write:communications
```

**Rate Limiting by API Key:**
- Standard: 1,000 req/min
- Premium: 5,000 req/min
- Enterprise: Custom

---

## 🚨 Special Access Cases

### Firm Administrator - Additional Controls

**Can:**
- Override any user permission temporarily
- Audit any user's actions
- Force password resets
- Suspend user accounts
- View all communications (with logging)
- Access data escrow (emergency recovery)

**Cannot:**
- Decrypt encrypted end-to-end communications
- Access without audit trail logging
- Bypass two-factor authentication (own account)

---

## 📊 Permission Auditing

**All Permission Changes Logged:**
- Who changed it
- When
- What changed
- Reason (if provided)
- IP address

**Audit Trail Retained:** 7 years (compliance)

---

**Last Updated:** June 8, 2026
# API Endpoints Specification
**Litigation 360 - REST API Reference**

---

## Authentication Endpoints

### POST /auth/register
Register new user account
```
Request:
{
  "email": "attorney@firm.com",
  "password": "SecurePassword123!",
  "first_name": "John",
  "last_name": "Doe",
  "firm_id": "uuid"
}

Response: 201 Created
{
  "id": "uuid",
  "email": "attorney@firm.com",
  "token": "jwt_token"
}
```

### POST /auth/login
Authenticate user
```
Request:
{
  "email": "attorney@firm.com",
  "password": "SecurePassword123!"
}

Response: 200 OK
{
  "id": "uuid",
  "email": "attorney@firm.com",
  "token": "jwt_token",
  "refresh_token": "refresh_token"
}
```

### POST /auth/mfa/enable
Enable multi-factor authentication

### POST /auth/mfa/verify
Verify MFA code

---

## Client Endpoints

### GET /clients
List all clients
```
Query Params: page=1&limit=50&search=text

Response: 200 OK
{
  "data": [...],
  "page": 1,
  "limit": 50,
  "total": 250
}
```

### POST /clients
Create new client

### GET /clients/{id}
Get client details

### PUT /clients/{id}
Update client information

### DELETE /clients/{id}
Delete client (archive)

---

## Matter Endpoints

### GET /matters
List all matters (with filters)

### POST /matters
Create new matter

### GET /matters/{id}
Get matter details including related data

### PUT /matters/{id}
Update matter information

### GET /matters/{id}/timeline
Get matter timeline with events

### POST /matters/{id}/close
Close matter

---

## Document Endpoints

### GET /documents
List documents (with pagination)

### POST /documents
Upload new document

### GET /documents/{id}
Retrieve document

### GET /documents/{id}/download
Download document file

### PUT /documents/{id}
Update document metadata

### DELETE /documents/{id}
Delete document (archive)

### POST /documents/{id}/share
Share document with user/client

---

## Time Entry Endpoints

### GET /time-entries
List time entries (with filters)

### POST /time-entries
Create time entry
```
Request:
{
  "matter_id": "uuid",
  "date_worked": "2026-06-08",
  "hours_worked": 2.5,
  "billable": true,
  "utbms_code": "1000",
  "description": "Legal research"
}

Response: 201 Created
```

### PUT /time-entries/{id}
Update time entry

### DELETE /time-entries/{id}
Delete time entry

### POST /time-entries/{id}/approve
Approve time entry

### GET /time-entries/summary
Get time summary by matter/user

---

## Invoice Endpoints

### GET /invoices
List invoices (with filters)

### POST /invoices
Create invoice
```
Request:
{
  "matter_id": "uuid",
  "invoice_date": "2026-06-08",
  "due_date": "2026-07-08",
  "include_time_entries": true,
  "include_expenses": true
}

Response: 201 Created
```

### GET /invoices/{id}
Get invoice details

### PUT /invoices/{id}
Update invoice

### POST /invoices/{id}/send
Send invoice to client

### GET /invoices/{id}/pdf
Generate and download invoice PDF

### POST /invoices/{id}/mark-paid
Mark invoice as paid

---

## Trust Account Endpoints

### GET /trust-account/balance
Get current trust account balance

### GET /trust-account/transactions
List trust account transactions

### POST /trust-account/deposit
Record trust account deposit

### POST /trust-account/withdrawal
Record trust account withdrawal

### GET /trust-account/reconciliation
Get reconciliation report

---

## Communication Endpoints

### GET /communications
List communications for matter

### POST /communications
Send message

### GET /communications/{id}
Get message details

### PUT /communications/{id}/read
Mark message as read

---

## Reporting Endpoints

### GET /reports/financial
Generate financial report

### GET /reports/matter/{id}
Get matter report

### GET /reports/user/{id}
Get user productivity report

### GET /reports/billing
Get billing report

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "Validation error",
  "details": {
    "email": "Invalid email format"
  }
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Token expired"
}
```

### 403 Forbidden
```json
{
  "error": "Forbidden",
  "message": "You do not have permission to access this resource"
}
```

### 404 Not Found
```json
{
  "error": "Not found",
  "resource": "Matter"
}
```

---

**Last Updated:** June 8, 2026
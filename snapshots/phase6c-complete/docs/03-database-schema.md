# Database Schema
**Litigation 360 - PostgreSQL Schema Design**

---

## Core Entity Relationships

```
Firm (1) ──→ (Many) Users
    ↓
    └─→ (Many) Clients
        ↓
        └─→ (Many) Matters
            ├─→ (Many) Documents
            ├─→ (Many) TimeEntries
            ├─→ (Many) Invoices
            ├─→ (Many) Communications
            └─→ (Many) Tasks
```

---

## Core Tables

### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    firm_id UUID NOT NULL REFERENCES firms(id),
    role VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    mfa_enabled BOOLEAN DEFAULT false,
    mfa_secret VARCHAR(255) NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_firm_id ON users(firm_id);
```

### Firms Table
```sql
CREATE TABLE firms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    phone VARCHAR(20),
    website VARCHAR(255),
    billing_email VARCHAR(255),
    trust_account_name VARCHAR(255),
    trust_account_number VARCHAR(50),
    bank_routing_number VARCHAR(9),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Clients Table
```sql
CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firm_id UUID NOT NULL REFERENCES firms(id),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    company_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    alternate_phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(2),
    billing_zip VARCHAR(10),
    client_type ENUM ('individual', 'corporate'),
    referred_by_id UUID REFERENCES clients(id),
    communication_preference VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clients_firm_id ON clients(firm_id);
CREATE INDEX idx_clients_email ON clients(email);
```

### Matters Table
```sql
CREATE TABLE matters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firm_id UUID NOT NULL REFERENCES firms(id),
    client_id UUID NOT NULL REFERENCES clients(id),
    matter_number VARCHAR(50) UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'open',
    practice_area VARCHAR(100),
    sub_practice_area VARCHAR(100),
    case_type VARCHAR(100),
    filing_date DATE,
    statute_of_limitations DATE,
    primary_attorney_id UUID REFERENCES users(id),
    secondary_attorney_id UUID REFERENCES users(id),
    paralegal_id UUID REFERENCES users(id),
    billing_type VARCHAR(50),
    hourly_rate DECIMAL(10,2),
    flat_fee DECIMAL(12,2),
    contingency_percentage DECIMAL(5,2),
    retainer_amount DECIMAL(12,2),
    budget DECIMAL(12,2),
    opposing_party_name VARCHAR(255),
    opposing_counsel_name VARCHAR(255),
    opposing_counsel_email VARCHAR(255),
    judge_name VARCHAR(255),
    court_name VARCHAR(255),
    case_number VARCHAR(50),
    jurisdiction VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_matters_firm_id ON matters(firm_id);
CREATE INDEX idx_matters_client_id ON matters(client_id);
CREATE INDEX idx_matters_status ON matters(status);
```

### Documents Table
```sql
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matter_id UUID NOT NULL REFERENCES matters(id),
    filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500),
    file_size BIGINT,
    mime_type VARCHAR(50),
    uploaded_by_id UUID NOT NULL REFERENCES users(id),
    document_type VARCHAR(100),
    category VARCHAR(100),
    confidentiality_level VARCHAR(50),
    s3_key VARCHAR(500),
    s3_bucket VARCHAR(255),
    content_hash VARCHAR(64),
    version_number INT DEFAULT 1,
    parent_document_id UUID REFERENCES documents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_matter_id ON documents(matter_id);
CREATE INDEX idx_documents_s3_key ON documents(s3_key);
```

### Time Entries Table
```sql
CREATE TABLE time_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matter_id UUID NOT NULL REFERENCES matters(id),
    user_id UUID NOT NULL REFERENCES users(id),
    date_worked DATE NOT NULL,
    hours_worked DECIMAL(6,2) NOT NULL,
    minutes_worked INT NOT NULL,
    billable BOOLEAN DEFAULT true,
    billing_rate DECIMAL(10,2),
    total_billing_amount DECIMAL(12,2),
    utbms_code VARCHAR(10),
    task_category VARCHAR(100),
    description TEXT,
    status VARCHAR(50) DEFAULT 'draft',
    approved_by_id UUID REFERENCES users(id),
    approved_at TIMESTAMP,
    invoice_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_time_entries_matter_id ON time_entries(matter_id);
CREATE INDEX idx_time_entries_user_id ON time_entries(user_id);
CREATE INDEX idx_time_entries_date_worked ON time_entries(date_worked);
```

### Invoices Table
```sql
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matter_id UUID NOT NULL REFERENCES matters(id),
    firm_id UUID NOT NULL REFERENCES firms(id),
    client_id UUID NOT NULL REFERENCES clients(id),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    subtotal DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2),
    total_amount DECIMAL(12,2) NOT NULL,
    paid_amount DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'draft',
    sent_date TIMESTAMP,
    paid_date TIMESTAMP,
    description TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoices_matter_id ON invoices(matter_id);
CREATE INDEX idx_invoices_invoice_number ON invoices(invoice_number);
CREATE INDEX idx_invoices_status ON invoices(status);
```

### Trust Account Table
```sql
CREATE TABLE trust_account (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firm_id UUID NOT NULL REFERENCES firms(id),
    matter_id UUID REFERENCES matters(id),
    transaction_type VARCHAR(50),
    amount DECIMAL(12,2) NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    bank_reference VARCHAR(100),
    status VARCHAR(50) DEFAULT 'posted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_trust_account_firm_id ON trust_account(firm_id);
CREATE INDEX idx_trust_account_matter_id ON trust_account(matter_id);
CREATE INDEX idx_trust_account_transaction_date ON trust_account(transaction_date);
```

### Communications Table
```sql
CREATE TABLE communications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matter_id UUID NOT NULL REFERENCES matters(id),
    from_user_id UUID REFERENCES users(id),
    from_contact_id UUID REFERENCES clients(id),
    to_user_id UUID REFERENCES users(id),
    to_contact_id UUID REFERENCES clients(id),
    communication_type VARCHAR(50),
    subject VARCHAR(255),
    body TEXT,
    status VARCHAR(50),
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_communications_matter_id ON communications(matter_id);
CREATE INDEX idx_communications_from_user_id ON communications(from_user_id);
CREATE INDEX idx_communications_to_user_id ON communications(to_user_id);
```

### Tasks Table
```sql
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    matter_id UUID NOT NULL REFERENCES matters(id),
    assigned_to_id UUID NOT NULL REFERENCES users(id),
    assigned_by_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'open',
    priority VARCHAR(50),
    due_date DATE,
    due_time TIME,
    completion_date TIMESTAMP,
    linked_document_id UUID REFERENCES documents(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tasks_matter_id ON tasks(matter_id);
CREATE INDEX idx_tasks_assigned_to_id ON tasks(assigned_to_id);
CREATE INDEX idx_tasks_status ON tasks(status);
```

---

## Optimization Strategies

### Indexing Strategy
- Primary keys (UUID)
- Foreign key relationships
- Frequently filtered columns (status, dates)
- Full-text search columns (description, body)

### Partitioning
```sql
-- Partition time_entries by date_worked
CREATE TABLE time_entries_2026_q1 PARTITION OF time_entries
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');
```

### View Creation
```sql
CREATE VIEW open_matters AS
    SELECT * FROM matters WHERE status = 'open';

CREATE VIEW billable_hours_summary AS
    SELECT matter_id, SUM(hours_worked) as total_hours,
           SUM(total_billing_amount) as total_billed
    FROM time_entries
    WHERE billable = true
    GROUP BY matter_id;
```

---

**Last Updated:** June 8, 2026
# Phase 8A Final Database Inventory

Database: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\litigation360.db

## Table Row Counts

| Table | Rows |
|---|---:|
| audit_logs | 16 |
| automation_consumers | 0 |
| automation_dead_letters | 2 |
| automation_event_history | 30 |
| automation_events | 14 |
| automation_retry_rules | 0 |
| backup_history | 0 |
| case_assignments | 0 |
| cases | 0 |
| clients | 1 |
| deadlines | 0 |
| documents | 0 |
| matter_number_sequences | 3 |
| permissions | 42 |
| reminders | 0 |
| role_permissions | 82 |
| roles | 8 |
| security_events | 7 |
| staff | 2 |
| system_settings | 0 |
| users | 1 |

## Full Table Schemas

### audit_logs

```sql
CREATE TABLE audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_email TEXT,
    action TEXT NOT NULL,
    entity_type TEXT,
    entity_id TEXT,
    old_value TEXT,
    new_value TEXT,
    ip_address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| user_email | TEXT | 0 |  | 0 |
| action | TEXT | 1 |  | 0 |
| entity_type | TEXT | 0 |  | 0 |
| entity_id | TEXT | 0 |  | 0 |
| old_value | TEXT | 0 |  | 0 |
| new_value | TEXT | 0 |  | 0 |
| ip_address | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### automation_consumers

```sql
CREATE TABLE automation_consumers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  consumer_name TEXT NOT NULL UNIQUE,
  event_type TEXT NOT NULL,
  target_module TEXT NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
  priority TEXT NOT NULL DEFAULT 'NORMAL',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| consumer_name | TEXT | 1 |  | 0 |
| event_type | TEXT | 1 |  | 0 |
| target_module | TEXT | 1 |  | 0 |
| is_active | INTEGER | 1 | 1 | 0 |
| priority | TEXT | 1 | 'NORMAL' | 0 |
| created_at | TEXT | 1 | CURRENT_TIMESTAMP | 0 |

### automation_dead_letters

```sql
CREATE TABLE automation_dead_letters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  source_module TEXT NOT NULL,
  payload_json TEXT,
  failure_reason TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TEXT,
  resolved_by TEXT,
  resolution_notes TEXT
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| event_id | TEXT | 1 |  | 0 |
| event_type | TEXT | 1 |  | 0 |
| source_module | TEXT | 1 |  | 0 |
| payload_json | TEXT | 0 |  | 0 |
| failure_reason | TEXT | 1 |  | 0 |
| retry_count | INTEGER | 1 | 0 | 0 |
| created_at | TEXT | 1 | CURRENT_TIMESTAMP | 0 |
| resolved_at | TEXT | 0 |  | 0 |
| resolved_by | TEXT | 0 |  | 0 |
| resolution_notes | TEXT | 0 |  | 0 |

### automation_event_history

```sql
CREATE TABLE automation_event_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL,
  old_status TEXT,
  new_status TEXT NOT NULL,
  action TEXT NOT NULL,
  message TEXT,
  created_by TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| event_id | TEXT | 1 |  | 0 |
| old_status | TEXT | 0 |  | 0 |
| new_status | TEXT | 1 |  | 0 |
| action | TEXT | 1 |  | 0 |
| message | TEXT | 0 |  | 0 |
| created_by | TEXT | 0 |  | 0 |
| created_at | TEXT | 1 | CURRENT_TIMESTAMP | 0 |

### automation_events

```sql
CREATE TABLE automation_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL UNIQUE,
  event_type TEXT NOT NULL,
  source_module TEXT NOT NULL,
  source_record_id TEXT,
  priority TEXT NOT NULL DEFAULT 'NORMAL',
  payload_json TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING',
  retry_count INTEGER NOT NULL DEFAULT 0,
  max_retries INTEGER NOT NULL DEFAULT 3,
  correlation_id TEXT,
  created_by TEXT,
  failure_reason TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT,
  processed_at TEXT
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| event_id | TEXT | 1 |  | 0 |
| event_type | TEXT | 1 |  | 0 |
| source_module | TEXT | 1 |  | 0 |
| source_record_id | TEXT | 0 |  | 0 |
| priority | TEXT | 1 | 'NORMAL' | 0 |
| payload_json | TEXT | 1 |  | 0 |
| status | TEXT | 1 | 'PENDING' | 0 |
| retry_count | INTEGER | 1 | 0 | 0 |
| max_retries | INTEGER | 1 | 3 | 0 |
| correlation_id | TEXT | 0 |  | 0 |
| created_by | TEXT | 0 |  | 0 |
| failure_reason | TEXT | 0 |  | 0 |
| created_at | TEXT | 1 | CURRENT_TIMESTAMP | 0 |
| updated_at | TEXT | 0 |  | 0 |
| processed_at | TEXT | 0 |  | 0 |

### automation_retry_rules

```sql
CREATE TABLE automation_retry_rules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_type TEXT NOT NULL UNIQUE,
  max_retries INTEGER NOT NULL DEFAULT 3,
  retry_delay_seconds INTEGER NOT NULL DEFAULT 60,
  escalation_required INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| event_type | TEXT | 1 |  | 0 |
| max_retries | INTEGER | 1 | 3 | 0 |
| retry_delay_seconds | INTEGER | 1 | 60 | 0 |
| escalation_required | INTEGER | 1 | 0 | 0 |
| created_at | TEXT | 1 | CURRENT_TIMESTAMP | 0 |

### backup_history

```sql
CREATE TABLE backup_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_file TEXT,
    backup_type TEXT,
    backup_size TEXT,
    backup_status TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| backup_file | TEXT | 0 |  | 0 |
| backup_type | TEXT | 0 |  | 0 |
| backup_size | TEXT | 0 |  | 0 |
| backup_status | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### case_assignments

```sql
CREATE TABLE case_assignments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    case_id INTEGER,
    staff_id INTEGER,
    assignment_role TEXT,
    assigned_by TEXT,
    assigned_date DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| case_id | INTEGER | 0 |  | 0 |
| staff_id | INTEGER | 0 |  | 0 |
| assignment_role | TEXT | 0 |  | 0 |
| assigned_by | TEXT | 0 |  | 0 |
| assigned_date | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### cases

```sql
CREATE TABLE cases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    case_number TEXT UNIQUE,
    title TEXT NOT NULL,
    client_id INTEGER,
    status TEXT DEFAULT 'Active',
    description TEXT,
    opened_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, assigned_staff_id INTEGER,
    FOREIGN KEY (client_id) REFERENCES clients(id)
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| case_number | TEXT | 0 |  | 0 |
| title | TEXT | 1 |  | 0 |
| client_id | INTEGER | 0 |  | 0 |
| status | TEXT | 0 | 'Active' | 0 |
| description | TEXT | 0 |  | 0 |
| opened_date | DATE | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |
| assigned_staff_id | INTEGER | 0 |  | 0 |

### clients

```sql
CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| full_name | TEXT | 1 |  | 0 |
| email | TEXT | 0 |  | 0 |
| phone | TEXT | 0 |  | 0 |
| address | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### deadlines

```sql
CREATE TABLE deadlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    case_id INTEGER,
    title TEXT NOT NULL,
    deadline_date DATE NOT NULL,
    reminder_days INTEGER DEFAULT 7,
    notes TEXT,
    is_complete INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(id)
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| case_id | INTEGER | 0 |  | 0 |
| title | TEXT | 1 |  | 0 |
| deadline_date | DATE | 1 |  | 0 |
| reminder_days | INTEGER | 0 | 7 | 0 |
| notes | TEXT | 0 |  | 0 |
| is_complete | INTEGER | 0 | 0 | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### documents

```sql
CREATE TABLE documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    case_id INTEGER,
    file_name TEXT NOT NULL,
    file_path TEXT,
    document_type TEXT,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(id)
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| case_id | INTEGER | 0 |  | 0 |
| file_name | TEXT | 1 |  | 0 |
| file_path | TEXT | 0 |  | 0 |
| document_type | TEXT | 0 |  | 0 |
| uploaded_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### matter_number_sequences

```sql
CREATE TABLE matter_number_sequences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  year INTEGER NOT NULL,
  department_code TEXT NOT NULL,
  last_number INTEGER NOT NULL DEFAULT 0,
  prefix TEXT NOT NULL DEFAULT 'MAT',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(year, department_code)
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| year | INTEGER | 1 |  | 0 |
| department_code | TEXT | 1 |  | 0 |
| last_number | INTEGER | 1 | 0 | 0 |
| prefix | TEXT | 1 | 'MAT' | 0 |
| created_at | TEXT | 0 | CURRENT_TIMESTAMP | 0 |
| updated_at | TEXT | 0 | CURRENT_TIMESTAMP | 0 |

### permissions

```sql
CREATE TABLE permissions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| code | TEXT | 1 |  | 0 |
| description | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### reminders

```sql
CREATE TABLE reminders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    reminder_date DATE NOT NULL,
    case_id INTEGER,
    is_sent INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| title | TEXT | 1 |  | 0 |
| reminder_date | DATE | 1 |  | 0 |
| case_id | INTEGER | 0 |  | 0 |
| is_sent | INTEGER | 0 | 0 | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### role_permissions

```sql
CREATE TABLE role_permissions (
    role_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id)
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| role_id | INTEGER | 1 |  | 1 |
| permission_id | INTEGER | 1 |  | 2 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### roles

```sql
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| name | TEXT | 1 |  | 0 |
| description | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### security_events

```sql
CREATE TABLE security_events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT,
    event_type TEXT,
    ip_address TEXT,
    details TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| email | TEXT | 0 |  | 0 |
| event_type | TEXT | 0 |  | 0 |
| ip_address | TEXT | 0 |  | 0 |
| details | TEXT | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |

### staff

```sql
CREATE TABLE staff (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    nric TEXT UNIQUE,
    email TEXT UNIQUE,
    phone TEXT,
    role TEXT NOT NULL,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
, workload INTEGER DEFAULT 0)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| full_name | TEXT | 1 |  | 0 |
| nric | TEXT | 0 |  | 0 |
| email | TEXT | 0 |  | 0 |
| phone | TEXT | 0 |  | 0 |
| role | TEXT | 1 |  | 0 |
| is_active | INTEGER | 0 | 1 | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |
| workload | INTEGER | 0 | 0 | 0 |

### system_settings

```sql
CREATE TABLE system_settings (
    key TEXT PRIMARY KEY,
    value TEXT
)
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| key | TEXT | 0 |  | 1 |
| value | TEXT | 0 |  | 0 |

### users

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'legal_assistant_clerk',
    staff_id INTEGER,
    is_active INTEGER DEFAULT 1,
    last_login DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, role_id INTEGER,
    FOREIGN KEY (staff_id) REFERENCES staff(id)
  )
```

| Column | Type | Not Null | Default | PK |
|---|---|---:|---|---:|
| id | INTEGER | 0 |  | 1 |
| email | TEXT | 1 |  | 0 |
| password_hash | TEXT | 1 |  | 0 |
| full_name | TEXT | 1 |  | 0 |
| role | TEXT | 1 | 'legal_assistant_clerk' | 0 |
| staff_id | INTEGER | 0 |  | 0 |
| is_active | INTEGER | 0 | 1 | 0 |
| last_login | DATETIME | 0 |  | 0 |
| created_at | DATETIME | 0 | CURRENT_TIMESTAMP | 0 |
| role_id | INTEGER | 0 |  | 0 |


## Safety Confirmation

- Readonly database access only
- No insert
- No update
- No delete
- No migration

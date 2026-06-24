# Technical Architecture
**Litigation 360 - System Design & Technical Specifications**

---

## 📐 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          CLIENT LAYER                            │
├──────────────────┬──────────────────┬──────────────────┐
│   ANDROID APP    │  WINDOWS APP     │   WEB BROWSER    │
│   (Kotlin)       │   (Electron)     │   (Progressive   │
│                  │   (React/Vue)    │    Web App)       │
└──────────┬───────┴─────────┬────────┴────────┬─────────┘
           │                 │                  │
           └─────────────────┼──────────────────┘
                             │ (HTTPS/TLS 1.3+)
                             ▼
        ┌────────────────────────────────────────┐
        │   API GATEWAY / LOAD BALANCER          │
        │   (AWS ALB or Azure Load Balancer)     │
        └────────────────┬───────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
    │ Auth    │   │ Case    │   │Billing  │
    │Service  │   │Service  │   │Service  │
    └────┬────┘   └────┬────┘   └────┬────┘
         │             │             │
    ┌────▼──────────────▼─────────────▼────┐
    │   MICROSERVICES LAYER (Node.js)      │
    │  ┌────────────────────────────────┐  │
    │  │ - Document Service             │  │
    │  │ - Communication Service         │  │
    │  │ - Time Tracking Service         │  │
    │  │ - Trust Account Service         │  │
    │  │ - Reporting Service             │  │
    │  │ - Integration Service           │  │
    │  └────────────────────────────────┘  │
    └────┬──────────────────────────────────┘
         │
    ┌────▼──────────────┬──────────────┐
    │                   │              │
┌───▼──────┐    ┌───────▼────┐   ┌────▼─────┐
│PostgreSQL│    │    Redis   │   │ File     │
│Database  │    │  (Caching) │   │Storage(S3)
└──────────┘    └────────────┘   └──────────┘
```

---

## 🏗️ Architecture Layers

### 1. Presentation Layer

#### Android App
**Framework:** Kotlin + Android Jetpack
**Architecture:** MVVM (Model-View-ViewModel)
- UI Layer (Composables)
- ViewModel Layer (state management)
- Data Layer (Repository pattern)
- Local Database: Room
- Networking: Retrofit + OkHttp

**Key Components:**
- Authentication UI
- Case Management UI
- Time Tracking UI
- Document Viewer
- Client Portal Access

#### Windows Desktop App
**Framework:** Electron + React/Vue.js
**Architecture:** React/Vue component tree
- Electron Main Process
- Electron Renderer Process
- React/Vue Components
- Redux/Vuex State Management
- Local Storage: IndexedDB

**Key Features:**
- Native window management
- System tray integration
- File system access
- Clipboard integration
- Native notifications

#### Web Portal
**Framework:** React/Vue.js (same as Windows)
**Architecture:** SPA (Single Page Application)
- Progressive Web App (PWA)
- Service Workers (offline support)
- Local Storage caching
- Mobile responsive design

---

### 2. API Gateway & Load Balancing

**Technology:** AWS Application Load Balancer (ALB)
- Health checks (every 30 seconds)
- Auto-scaling (based on CPU/memory)
- SSL/TLS termination
- Request routing by path
- DDoS protection (AWS Shield)

**Rate Limiting:**
```
Per-user: 1000 requests/minute
Per-IP: 5000 requests/minute
Burst: 50 requests/second
```

---

### 3. Authentication & Authorization

#### JWT-Based Authentication
```
Flow:
1. User enters credentials
2. Backend validates (bcrypt hashing)
3. Backend issues JWT token (valid 24 hours)
4. Client stores token (secure storage)
5. Client sends token in Authorization header
6. Backend validates token signature & expiry
7. Token refresh endpoint (valid 7 days)
```

**Token Structure:**
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "user_id": "123",
    "firm_id": "456",
    "role": "attorney",
    "permissions": ["read:matters", "write:bills"],
    "iat": 1234567890,
    "exp": 1234654290
  },
  "signature": "..."
}
```

#### Multi-Factor Authentication (MFA)
- Time-based One-Time Password (TOTP)
- SMS-based OTP
- Backup codes
- Biometric (Android fingerprint/face)
- Windows Hello

#### Role-Based Access Control (RBAC)
```
Roles:
├── Attorney
├── Paralegal
├── Billing Staff
├── Admin
├── Client (Portal)
└── Co-Counsel

Permissions: Read, Create, Edit, Delete, Share
Scope: Firm, Matter, Document
```

---

### 4. Microservices Layer

#### Service Architecture

**1. User & Auth Service**
- User management
- Authentication
- Authorization
- Session management
- MFA

**2. Firm & Organization Service**
- Firm configuration
- User roles & permissions
- Billing settings
- Integrations
- Workflows

**3. Client Management Service**
- Client profiles
- Contact information
- Client communications
- Client history
- Referral tracking

**4. Matter Service (Core)**
- Matter creation & management
- Matter status tracking
- Matter templates
- Matter stages
- Matter timeline

**5. Document Service**
- Document upload/download
- Document versioning
- OCR processing
- Full-text search
- Document sharing
- E-signature

**6. Discovery Service**
- Discovery planning
- Request management
- Production tracking
- Privilege log
- Document coding

**7. Time & Expense Service**
- Time entry
- Timer functionality
- Expense tracking
- Rate management
- Utilization calculation

**8. Billing Service**
- Invoice generation
- Invoice status
- Billing arrangements (hourly, flat, contingency)
- Payment processing
- Collections

**9. Trust Account Service**
- Trust account transactions
- IOLTA compliance
- Reconciliation
- Fund tracking
- Disbursement

**10. Communication Service**
- Email handling
- SMS/messaging
- In-app messaging
- Call logging
- Communication logs

**11. Reporting Service**
- Financial reports
- Matter reports
- User reports
- Custom reports
- Report scheduling

**12. Integration Service**
- Third-party API management
- Oauth/token management
- Webhook management
- Sync orchestration

**13. AI/ML Service**
- Document classification
- Information extraction
- Predictive analytics
- NLP processing

---

### 5. Data Layer

#### Database Schema (PostgreSQL)

```sql
-- Core Tables
users
├── id (UUID)
├── email
├── password_hash
├── name
├── firm_id (FK)
├── role
├── mfa_enabled
├── created_at
└── updated_at

firms
├── id (UUID)
├── name
├── address
├── billing_settings
├── integrations
└── updated_at

clients
├── id (UUID)
├── firm_id (FK)
├── name
├── email
├── phone
├── address
├── type (individual/corporate)
├── communication_preferences
└── updated_at

matters
├── id (UUID)
├── firm_id (FK)
├── client_id (FK)
├── attorney_id (FK)
├── title
├── status
├── practice_area
├── billing_type
├── retainer_amount
├── budget
├── created_at
└── updated_at

documents
├── id (UUID)
├── matter_id (FK)
├── filename
├── file_path (S3)
├── file_size
├── mime_type
├── uploaded_by (FK user_id)
├── created_at
├── updated_at
└── content_hash

time_entries
├── id (UUID)
├── user_id (FK)
├── matter_id (FK)
├── duration (minutes)
├── billable (boolean)
├── utbms_code
├── description
├── created_at
└── updated_at

invoices
├── id (UUID)
├── matter_id (FK)
├── client_id (FK)
├── invoice_number
├── amount
├── status
├── due_date
├── created_at
└── updated_at

trust_account
├── id (UUID)
├── firm_id (FK)
├── transaction_id (UUID)
├── type (deposit/withdrawal)
├── amount
├── matter_id (FK)
├── description
├── created_at
└── updated_at

messages
├── id (UUID)
├── sender_id (FK)
├── recipient_id (FK)
├── matter_id (FK)
├── content
├── read
├── created_at
└── updated_at
```

#### Database Optimization
- Indexing strategy (B-tree for most columns, Full-text for search)
- Partitioning (by date for large tables)
- Query optimization
- Caching layer (Redis)
- Read replicas for reporting queries

---

### 6. Caching Layer (Redis)

**Cache Strategy:**
```
Cache-Aside Pattern:
1. Check Redis
2. If miss, query database
3. Store in Redis (TTL: 1 hour)
4. Return to client

Session Storage:
- JWT tokens: Redis (TTL: 24 hours)
- Refresh tokens: Redis (TTL: 7 days)
- User sessions: Redis

Rate Limiting:
- Per-user counters: Redis
- IP-based counters: Redis
```

**Cached Data:**
- User permissions
- Firm settings
- Matter data (frequently accessed)
- Client data
- Rate tables
- Integration configs

---

### 7. File Storage (AWS S3)

**Structure:**
```
litigation-360-prod/
├── firms/{firm_id}/
│   ├── matters/{matter_id}/
│   │   ├── documents/
│   │   ├── communications/
│   │   └── reports/
│   ├── backups/
│   └── archived/
```

**Policies:**
- Encryption: AES-256 (server-side)
- Versioning: Enabled (30-day retention)
- Lifecycle: Transition to Glacier after 90 days
- Access: IAM role (no public access)
- Logging: CloudTrail

---

### 8. Message Queue (RabbitMQ/Kafka)

**Async Tasks:**
```
Events:
├── User Events
│   ├── user.created
│   ├── user.login
│   └── user.logout
├── Matter Events
│   ├── matter.created
│   ├── matter.updated
│   └── matter.closed
├── Document Events
│   ├── document.uploaded
│   ├── document.processed
│   └── document.deleted
├── Billing Events
│   ├── invoice.generated
│   ├── invoice.sent
│   └── payment.received
└── Communication Events
    ├── email.sent
    ├── sms.sent
    └── message.read

Subscribers:
├── Email Service (sends emails)
├── Notification Service (push notifications)
├── Analytics Service (event logging)
├── Audit Service (compliance logging)
└── Integration Service (third-party syncs)
```

---

## 🔐 Security Architecture

### Encryption Strategy

**Data at Rest:**
- Application-level encryption (before storage)
- AWS KMS for key management
- TDE (Transparent Data Encryption) on database
- Database column-level encryption for sensitive data

**Data in Transit:**
- TLS 1.3+ (minimum)
- Certificate pinning (mobile apps)
- Perfect forward secrecy (PFS)

**Sensitive Data:**
```
Encrypted Fields:
- Passwords (bcrypt + salt)
- SSN/tax ID
- Bank account info
- Credit card data (not stored; processed via Stripe)
- Attorney-client communications
- Work product documents
```

### API Security

**Input Validation:**
- Schema validation (JSON Schema)
- Type checking
- Length validation
- SQL injection prevention (parameterized queries)
- XSS prevention (HTML escaping)

**Rate Limiting:**
- Per-user: 1000 req/min
- Per-IP: 5000 req/min
- Per-endpoint: Custom limits

**CORS Policy:**
```
Allowed Origins:
- https://litigation360.com
- https://*.litigation360.com
- https://app.litigation360.com

Methods: GET, POST, PUT, DELETE, PATCH
Headers: Content-Type, Authorization
Credentials: true
Max Age: 86400
```

### Infrastructure Security

**Network:**
- VPC (private subnets for backend)
- Security groups (firewall rules)
- NAT Gateway (outbound traffic)
- VPN access (team)

**Monitoring:**
- CloudWatch (AWS monitoring)
- CloudTrail (audit logging)
- VPC Flow Logs (network monitoring)
- GuardDuty (threat detection)

---

## 📊 Deployment Architecture

### Development Environment
```
Developer Laptop:
├── Docker Compose (local)
│   ├── Backend container
│   ├── PostgreSQL container
│   ├── Redis container
│   └── S3 mock (LocalStack)
├── Android Emulator
├── Electron dev server
└── Test DB
```

### Staging Environment
```
AWS:
├── ECS Cluster (backend services)
├── RDS PostgreSQL (read/write)
├── ElastiCache Redis
├── S3 buckets
├── CloudFront CDN
├── ALB
└── CloudWatch monitoring
```

### Production Environment
```
AWS Multi-Region:
├── Primary Region (US-East-1)
│   ├── ECS Fargate (auto-scaling)
│   ├── RDS Multi-AZ (failover)
│   ├── ElastiCache Cluster
│   ├── S3 (replicated)
│   └── CloudFront (content delivery)
└── Secondary Region (standby)
    └── RDS read replica (for failover)

Disaster Recovery:
- RTO (Recovery Time Objective): 1 hour
- RPO (Recovery Point Objective): 15 minutes
- Automated backups: Every 6 hours
- Test failover: Monthly
```

---

## 📱 Mobile-Specific Architecture

### Android App Architecture
```
Presentation Layer
├── Activities
├── Fragments
├── Composables (Jetpack Compose)
└── ViewModels

Domain Layer
├── Use Cases
├── Repositories (interfaces)
└── Entities

Data Layer
├── Local Database (Room)
├── Remote API (Retrofit)
├── Repositories (implementations)
└── Data Sources
```

### Offline-First Strategy
```
1. All data cached locally (Room Database)
2. Changes queued when offline
3. Sync when online
4. Conflict resolution (last-write-wins)
5. Background sync (WorkManager)
```

### Real-Time Sync
```
Android ← → Backend

1. Client makes change
2. Change sent to backend (HTTP POST)
3. Backend processes & stores
4. Backend broadcasts to other devices (WebSocket)
5. Other devices receive update (WebSocket listener)
6. Local DB updated
7. UI refreshed

Sync Time Target: <2 seconds
```

---

## 🔄 Integration Architecture

### API Gateway Pattern
```
Mobile/Desktop → API Gateway
                    ↓
        Route based on path:
        ├── /auth/* → Auth Service
        ├── /matters/* → Matter Service
        ├── /documents/* → Document Service
        ├── /billing/* → Billing Service
        └── /reporting/* → Reporting Service
```

### Third-Party Integrations
```
Integration Manager Service:
├── OAuth token storage (encrypted)
├── Webhook handlers
├── Scheduled sync jobs
├── Rate limit management
└── Error handling & retries

Supported Integrations:
├── Outlook Calendar (OAuth 2.0)
├── Gmail (OAuth 2.0)
├── Google Calendar
├── Dropbox
├── Google Drive
├── OneDrive
├── QuickBooks
├── Stripe
├── Twilio
└── Zoom
```

---

## 📈 Performance Targets

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| API Response Time (p95) | <100ms | TBD | 🔴 |
| Database Query Time | <50ms | TBD | 🔴 |
| Page Load Time (web) | <2s | TBD | 🔴 |
| Mobile App Load Time | <3s | TBD | 🔴 |
| Sync Time (cross-device) | <2s | TBD | 🔴 |
| System Uptime | 99.9% | TBD | 🔴 |
| Concurrent Users (single region) | 10,000 | TBD | 🔴 |

---

## 🛠️ Development Tools & Tech Stack

| Component | Technology | Alternative |
|-----------|------------|-------------|
| Backend | Node.js 18+ | Python 3.9+ |
| Backend Framework | Express.js | FastAPI |
| Database | PostgreSQL 14+ | - |
| Cache | Redis 7+ | Memcached |
| File Storage | AWS S3 | Azure Blob |
| Mobile | Kotlin + Jetpack | Flutter |
| Desktop | Electron + React | Tauri |
| Container | Docker | Podman |
| Orchestration | Docker Compose (dev) → ECS (prod) | Kubernetes |
| CI/CD | GitHub Actions | GitLab CI |
| Monitoring | CloudWatch | DataDog |
| Logging | ELK Stack | CloudWatch Logs |

---

## 📋 Deployment Checklist

- [ ] Infrastructure provisioned (VPC, subnets, security groups)
- [ ] Database configured (RDS, backups enabled)
- [ ] Caching layer set up (ElastiCache)
- [ ] File storage configured (S3, replication)
- [ ] API Gateway configured (ALB, SSL)
- [ ] CI/CD pipeline configured (GitHub Actions)
- [ ] Monitoring & alerting set up (CloudWatch)
- [ ] Backup strategy implemented
- [ ] Disaster recovery tested
- [ ] Security audit completed
- [ ] Load testing completed
- [ ] Compliance verification (GDPR, HIPAA, SOC 2)

---

**Last Updated:** June 8, 2026  
**Status:** Architecture Phase  
**Next:** Implementation Planning

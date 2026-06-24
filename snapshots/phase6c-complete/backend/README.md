# Litigation 360 - Backend API

## Setup

### Prerequisites
- Node.js 18+
- PostgreSQL 14+
- Redis 7+

### Installation

```bash
cd backend
npm install
```

### Configuration

```bash
cp .env.example .env
# Edit .env with your configuration
```

### Database Setup

```bash
# Create database
createdb litigation_360

# Run migrations
npm run db:migrate

# Seed with sample data (optional)
npm run db:seed
```

### Running

**Development:**
```bash
npm run dev
```

**Production:**
```bash
npm start
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user

### Clients
- `GET /api/clients` - List clients
- `POST /api/clients` - Create client
- `GET /api/clients/:id` - Get client details
- `PUT /api/clients/:id` - Update client

### Matters
- `GET /api/matters` - List matters
- `POST /api/matters` - Create matter
- `GET /api/matters/:id` - Get matter details
- `PUT /api/matters/:id` - Update matter

### Time Entries
- `GET /api/time-entries` - List time entries
- `POST /api/time-entries` - Create time entry

### Invoices
- `GET /api/invoices` - List invoices
- `POST /api/invoices` - Create invoice

### Documents
- `GET /api/documents` - List documents
- `POST /api/documents` - Upload document

## Testing

```bash
npm test
npm run test:coverage
```

## Project Structure

```
src/
├── index.js           # App entry point
├── models/            # Database models
├── routes/            # API routes
├── middleware/        # Express middleware
├── services/          # Business logic
├── utils/             # Utilities
└── tests/             # Test files
```

## Documentation

See [../docs/04-api-endpoints.md](../docs/04-api-endpoints.md) for complete API documentation.

# Adaptive Authentication Integration

The adaptive authentication module has been added beside the existing login system. It does not replace `/api/auth/login` yet.

## Installed Files

- `configs/auth-policy.json`
- `backend/src/services/adaptiveAuthService.js`
- `backend/src/routes/adaptiveAuth.js`
- `backend/src/migrations/024_adaptive_auth.sql`
- `frontend/src/pages/SecurityAccessConsole.jsx`
- `frontend/src/pages/SecurityAccessConsole.css`

## Backend Endpoint

After the route is registered in `backend/src/index.js`, the new base path is:

```text
/api/adaptive-auth
```

Important endpoints:

- `GET /api/adaptive-auth/security-display`
- `POST /api/adaptive-auth/start`
- `POST /api/adaptive-auth/challenge`
- `GET /api/adaptive-auth/sessions`
- `POST /api/adaptive-auth/sessions/:sessionId/force-logout`

## Suggested Rollout

1. Keep the existing `/api/auth/login` route active.
2. Pilot `/api/adaptive-auth/start` with admins and test users.
3. Confirm login plans, risk scores, challenge records, and audit records.
4. Route the production login UI through adaptive auth after pilot approval.
5. Lock admin monitoring endpoints behind existing RBAC middleware before production exposure.

## Manual Route Registration

Add this line in `backend/src/index.js` near the existing auth route:

```js
app.use("/api/adaptive-auth", require("./routes/adaptiveAuth"));
```

## Commands

From the project root:

```powershell
cd C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
npm test
npm start
```

From another terminal for the frontend:

```powershell
cd C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
npm run dev
```


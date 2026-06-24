# 07 Operations Manual

## Daily Startup
1. Start backend.
2. Start frontend.
3. Open Vite URL.
4. Run health checks.
5. Confirm dashboard loads.

## Daily Shutdown
1. Stop frontend dev server.
2. Stop backend server.
3. Confirm no unwanted node process remains.

## Health Checks
curl.exe http://localhost:5000/api/health
curl.exe http://localhost:5000/api/enterprise/monitoring/health
curl.exe http://localhost:5000/api/enterprise/deployment-centre/health

## Build Check
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend
npm run build

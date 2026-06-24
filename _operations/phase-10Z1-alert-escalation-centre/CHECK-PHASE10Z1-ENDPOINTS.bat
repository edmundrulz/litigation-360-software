@echo off
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
echo Checking Phase 10Z.1 alert endpoints...
echo.
curl http://localhost:5100/api/enterprise/alerts/health
echo.
curl http://localhost:5100/api/enterprise/alerts/metrics
echo.
curl http://localhost:5100/api/enterprise/alerts/dashboard
echo.
pause

@echo off
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
curl.exe http://localhost:5000/api/health
curl.exe http://localhost:5000/api/enterprise/monitoring/health
curl.exe http://localhost:5000/api/enterprise/deployment-centre/health
pause

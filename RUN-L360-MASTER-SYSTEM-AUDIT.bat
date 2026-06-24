@echo off
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
powershell -ExecutionPolicy Bypass -File scripts\master-system\RUN-MASTER-AUDIT.ps1
powershell -ExecutionPolicy Bypass -File scripts\master-system\RUN-LIVE-STATUS-SNAPSHOT.ps1
pause

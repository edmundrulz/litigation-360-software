@echo off
set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set REPORTDIR=%%ROOT%%\_operations\phase-10ZG-dashboard-framework\reports
mkdir "%%REPORTDIR%%" >nul 2>&1
set REPORT=%%REPORTDIR%%\VERIFY-PHASE-10ZG-REPORT.txt
echo PHASE 10ZG VERIFICATION REPORT > "%%REPORT%%"
echo Date: %Fri 19/06/2026% %17:19:01.27% >> "%%REPORT%%"
cd /d "%%ROOT%%\frontend"
call npm run build >> "%%REPORT%%" 2>&1
if errorlevel 1 goto FAIL
cd /d "%%ROOT%%"
curl.exe -s http://localhost:5000/api/health >> "%%REPORT%%" 2>&1
if errorlevel 1 goto FAIL
curl.exe -s http://localhost:5000/api/enterprise/monitoring/health >> "%%REPORT%%" 2>&1
if errorlevel 1 goto FAIL
curl.exe -s http://localhost:5000/api/enterprise/deployment-centre/health >> "%%REPORT%%" 2>&1
if errorlevel 1 goto FAIL
echo PHASE 10ZG VERIFICATION: PASS
echo PHASE 10ZG VERIFICATION: PASS >> "%%REPORT%%"
pause
exit /b 0
:FAIL
echo PHASE 10ZG VERIFICATION: FAIL
echo PHASE 10ZG VERIFICATION: FAIL >> "%%REPORT%%"
echo Check report:
echo %%REPORT%%
pause
exit /b 1

@echo off
title Litigation 360 Status Checker

echo ===============================
echo LITIGATION 360 STATUS CHECK
echo ===============================
echo.

echo Checking backend health...
powershell -NoProfile -Command "try { (Invoke-RestMethod 'http://localhost:5000/api/health') | ConvertTo-Json -Depth 5 } catch { Write-Host 'BACKEND HEALTH FAILED'; Write-Host $_.Exception.Message }"

echo.
echo Checking dashboard API...
powershell -NoProfile -Command "try { (Invoke-RestMethod 'http://localhost:5000/api/dashboard') | ConvertTo-Json -Depth 10 } catch { Write-Host 'DASHBOARD API FAILED'; Write-Host $_.Exception.Message }"

echo.
echo Checking port 5000...
netstat -ano | findstr :5000

echo.
echo Checking port 5173...
netstat -ano | findstr :5173

echo.
echo Running backend tests...
npm test

echo.
echo DONE.
pause
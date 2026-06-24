@echo off
title Litigation 360 Backend - Safe Start
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
echo Checking backend port 5000...
netstat -ano | findstr :5000
if %0%==0 (
  echo.
  echo Backend already appears to be running on port 5000.
  echo Do NOT start another backend copy.
  echo.
  pause
  exit /b 0
)
echo Starting backend...
npm start
pause

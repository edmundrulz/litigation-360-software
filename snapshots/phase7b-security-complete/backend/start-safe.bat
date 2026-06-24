@echo off
title Litigation 360 Backend Safe Start

cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend

echo Checking Port 5000...

for /f "tokens=5" %%P in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    echo Killing existing process on Port 5000 - PID %%P
    taskkill /F /PID %%P
)

timeout /t 2 >nul

echo Starting Backend...
npm run dev

pause
@echo off
set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\nodejs;%PATH%
title Litigation 360 Backend Safe Dev

cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend

echo Closing old backend on port 5000...

for /f "tokens=5" %%P in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    echo Killing PID %%P
    taskkill /F /PID %%P
)

timeout /t 2 >nul

echo Starting backend safely...
npm run dev

pause
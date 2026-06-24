@echo off
title Start Litigation 360
echo Starting Litigation 360 Backend...
start "L360 Backend" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && npm start"
timeout /t 3 /nobreak
echo Starting Litigation 360 Frontend...
start "L360 Frontend" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend && npm run dev -- --host 127.0.0.1 --port 5173"
timeout /t 3 /nobreak
start http://127.0.0.1:5173/
echo Litigation 360 startup triggered.
pause

@echo off
title Litigation 360 ECC Dashboard Launcher
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
start "ECC Scanner" cmd /k RUN_L360_ECC_SCANNER.bat
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\LITIGATION360_LIVE_DASHBOARD"
start "" "http://localhost:8787/"
python -m http.server 8787

@echo off
title Litigation 360 ECC v2 Scanner
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

:loop
node tools\l360-ecc-v2-scanner.js
timeout /t 60 /nobreak
goto loop
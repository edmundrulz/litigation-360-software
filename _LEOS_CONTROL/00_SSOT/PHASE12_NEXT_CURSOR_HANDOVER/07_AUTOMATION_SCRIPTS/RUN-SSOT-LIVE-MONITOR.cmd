@echo off
title Litigation 360 SSOT Live Monitor
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0RUN-SSOT-LIVE-MONITOR.ps1" -Continuous -DelaySeconds 10
pause

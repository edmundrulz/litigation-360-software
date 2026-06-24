@echo off
title Stop Litigation 360

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

taskkill /F /IM node.exe

echo All Node backend/frontend processes stopped.
pause
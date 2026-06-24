@echo off
title Litigation 360 Live Monitor
echo ============================================
echo Litigation 360 Live Progress Monitor
echo ============================================
echo.
:loop
cls
echo Litigation 360 Live Monitor
echo Time: %Thu 18/06/2026% % 8:30:40.23%
echo.
echo Checking backend...
curl -s http://localhost:5100/api/health
echo.
echo.
echo Checking dashboard...
curl -s http://localhost:5100/api/dashboard/health
echo.
echo.
timeout /t 10 >nul
goto loop

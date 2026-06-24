@echo off
title Litigation 360 Test Runner
echo Running Litigation 360 test checks...
echo.
cd /d "%%~dp0..\.."
echo Checking backend health...
curl http://localhost:5100/api/health
echo.
echo Checking matter number preview...
curl http://localhost:5100/api/matter-number/preview
echo.
echo Checking workflow templates...
curl http://localhost:5100/api/workflow/templates
echo.
pause

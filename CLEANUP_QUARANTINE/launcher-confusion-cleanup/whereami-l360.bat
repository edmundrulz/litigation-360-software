@echo off
title ⚖ L360 LOCATION CHECK
color 1F

echo ==================================================
echo        ⚖ LITIGATION 360 LOCATION CHECK
echo ==================================================
echo.
echo Current folder:
cd
echo.
echo Expected root:
echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
echo.
echo Git branch:
git branch --show-current 2>nul
echo.
echo Package files nearby:
dir package.json /b 2>nul
echo.
echo ==================================================
pause
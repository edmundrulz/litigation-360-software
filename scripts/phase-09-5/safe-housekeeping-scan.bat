@echo off
set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set OPS=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations
set REPORTS=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports
echo.
echo ============================================
echo Litigation 360 Safe Housekeeping Scan
echo ============================================
if not exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software" echo Current folder OK
mkdir "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations" 2>nul
mkdir "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports" 2>nul
echo Creating folder tree report...
tree "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software" /F /A > "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\folder-tree-SAFE-SCAN.txt"
echo Creating full file inventory...
dir "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software" /S /B > "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\file-inventory-SAFE-SCAN.txt"
echo Creating size report...
dir "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software" /S > "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\size-report-SAFE-SCAN.txt"
echo Creating project structure check...
echo === NODE PROJECT STRUCTURE CHECK === > "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\project-structure-check-SAFE-SCAN.txt"
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package.json" echo FOUND: package.json >> "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\project-structure-check-SAFE-SCAN.txt"
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\server.js" echo FOUND: server.js >> "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\project-structure-check-SAFE-SCAN.txt"
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\src" echo FOUND: src folder >> "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\project-structure-check-SAFE-SCAN.txt"
if exist "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\node_modules" echo FOUND: node_modules >> "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports\project-structure-check-SAFE-SCAN.txt"
echo.
echo Scan completed successfully.
echo Reports created in:
echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\housekeeping-reports
pause

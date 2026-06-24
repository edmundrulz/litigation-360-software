@echo off
title Fix and Start Litigation 360 Dashboard
cd /d "%~dp0"

echo Current folder:
echo %cd%
echo.

if not exist "index.html" (
    echo ERROR: index.html is missing in this folder.
    echo.
    echo You are probably not inside:
    echo LITIGATION360_LIVE_DASHBOARD
    echo.
    pause
    exit
)

if not exist "data\project_status.json" (
    echo ERROR: data\project_status.json is missing.
    echo Creating missing data file...
    mkdir data 2>nul

    (
    echo {
    echo   "project": "Litigation 360 Enterprise Platform",
    echo   "status": "Operational Development",
    echo   "overall_progress": 68,
    echo   "health_score": 100,
    echo   "integrity_score": 100,
    echo   "current_phase": "Phase 10A - AI Knowledge and Legal Intelligence Expansion",
    echo   "modules": [
    echo     {"name":"Core Platform","progress":85,"status":"Operational"},
    echo     {"name":"Client Management","progress":80,"status":"Operational"},
    echo     {"name":"Matter Management","progress":75,"status":"In Progress"},
    echo     {"name":"AI Knowledge Center","progress":40,"status":"Newly Integrated"},
    echo     {"name":"AI Legal Drafting Engine","progress":35,"status":"Newly Integrated"},
    echo     {"name":"Deadline Intelligence","progress":55,"status":"In Progress"},
    echo     {"name":"Executive Dashboard","progress":45,"status":"In Progress"}
    echo   ]
    echo }
    ) > "data\project_status.json"
)

echo Starting dashboard at:
echo http://localhost:8787/
echo.

start "" "http://localhost:8787/"

python -m http.server 8787

pause
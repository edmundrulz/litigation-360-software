@echo off
set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.jsx.before-10ZG" "%ROOT%\frontend\src\App.jsx"
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.css.before-10ZG" "%ROOT%\frontend\src\App.css"
cd /d "%ROOT%\frontend"
npm run build
pause

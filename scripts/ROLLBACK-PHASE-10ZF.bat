@echo off
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
copy "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZF-navigation-module-menu\backups\App.jsx.before-10ZF" "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.jsx"
copy "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZF-navigation-module-menu\backups\App.css.before-10ZF" "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css"
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"
npm run build
pause

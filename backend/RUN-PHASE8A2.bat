@echo off
title Litigation 360 - Phase 8A.2

cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend

echo.
echo =====================================
echo Phase 8A.2 SQLite Inventory
echo =====================================
echo.

node -e "const Database=require('better-sqlite3');const db=new Database('litigation360.db',{readonly:true});const tables=db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name").all();console.log('TABLES FOUND:');tables.forEach(t=>console.log('-',t.name));db.close();"

echo.
pause

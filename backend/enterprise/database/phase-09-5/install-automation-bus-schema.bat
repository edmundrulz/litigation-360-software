@echo off
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
echo ============================================
echo Automation Bus Schema Installer
echo ============================================

if not exist "backend\enterprise\database\phase-09-5\automation-bus-schema.sql" (
  echo ERROR: Schema file missing.
  pause
  exit /b 1
)

if not exist "backend\litigation360.db" (
  echo ERROR: Database file missing: backend\litigation360.db
  pause
  exit /b 1
)

echo Schema file found.
echo Database file found.

node -e "const fs=require('fs'); const sqlite3=require('sqlite3').verbose(); const schema=fs.readFileSync('backend/enterprise/database/phase-09-5/automation-bus-schema.sql','utf8'); const db=new sqlite3.Database('backend/litigation360.db'); db.exec(schema,(err)=>{ if(err){ console.error('SCHEMA INSTALL FAILED:',err.message); process.exit(1); } console.log('SCHEMA INSTALL SUCCESS'); db.all(\"SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'automation_%' ORDER BY name\",[],(e,rows)=>{ if(e){ console.error(e.message); process.exit(1); } console.log('AUTOMATION TABLES FOUND:', rows.map(r=>r.name).join(', ')); db.close(); }); });"

echo Installer completed.
pause

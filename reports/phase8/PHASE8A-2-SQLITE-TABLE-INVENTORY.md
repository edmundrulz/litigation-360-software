@echo off

cd /d C:\\Users\\jep\_edmundrulz\\litigation-360-workspace\\litigation-360-software\\backend



echo Creating Phase 8A table inventory script...



(

echo const fs = require('fs'^);

echo const path = require('path'^);

echo const Database = require('better-sqlite3'^);

echo const backendDir = process.cwd(^);

echo const rootDir = path.dirname(backendDir^);

echo const dbPath = path.join(backendDir, 'litigation360.db'^);

echo const reportDir = path.join(rootDir, 'reports', 'phase8'^);

echo const reportPath = path.join(reportDir, 'PHASE8A-2-SQLITE-TABLE-INVENTORY.md'^);

echo fs.mkdirSync(reportDir, { recursive: true }^);

echo let md = '# Phase 8A.2 SQLite Table Inventory\\n\\n';

echo md += 'Database: ' + dbPath + '\\n\\n';

echo const db = new Database(dbPath, { readonly: true, fileMustExist: true }^);

echo const tables = db.prepare("SELECT name, sql FROM sqlite\_master WHERE type='table' AND name NOT LIKE 'sqlite\_%%' ORDER BY name"^).all(^);

echo for (const t of tables^) {

echo   const count = db.prepare('SELECT COUNT(\*) AS c FROM "' + t.name + '"'^).get(^).c;

echo   md += '## ' + t.name + '\\n\\n';

echo   md += 'Rows: ' + count + '\\n\\n';

echo   md += '```sql\\n' + t.sql + '\\n```\\n\\n';

echo }

echo db.close(^);

echo fs.writeFileSync(reportPath, md^);

echo console.log('CREATED: ' + reportPath^);

) > PHASE8A-2-SQLITE-TABLE-INVENTORY.js



node PHASE8A-2-SQLITE-TABLE-INVENTORY.js



notepad C:\\Users\\jep\_edmundrulz\\litigation-360-workspace\\litigation-360-software\\reports\\phase8\\PHASE8A-2-SQLITE-TABLE-INVENTORY.md



pause


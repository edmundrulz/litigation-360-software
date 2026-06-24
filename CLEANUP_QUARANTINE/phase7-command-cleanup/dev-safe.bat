echo Running Backend Doctor...
node tools\backend-doctor.js

echo Creating SQLite Backup...
node tools\backup-sqlite.js

echo Starting backend safely...
npm run dev

pause
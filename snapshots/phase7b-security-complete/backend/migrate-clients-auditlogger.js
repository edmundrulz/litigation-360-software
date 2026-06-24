const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'clients.js');
const backupDir = path.join(__dirname, 'backup', `clients-auditlogger-migration-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'clients.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (code.includes("require('../utils/auditLogger')")) {
  console.log('clients.js already uses auditLogger.js. No change needed.');
  process.exit(0);
}

code = code.replace(
  "const auditLog = require('../utils/logger');",
  "const auditLog = require('../utils/auditLogger');"
);

fs.writeFileSync(file, code, 'utf8');

console.log('Clients audit migration complete.');
console.log('Backup saved to:', backupDir);
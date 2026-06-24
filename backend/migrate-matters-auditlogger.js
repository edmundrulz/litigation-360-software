const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'matters.js');
const backupDir = path.join(__dirname, 'backup', `matters-auditlogger-migration-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'matters.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (!code.includes("const auditLog = require('../utils/auditLogger');")) {
  code = code.replace(
    "const logger = require('../utils/logger');",
    "const logger = require('../utils/logger');\nconst auditLog = require('../utils/auditLogger');"
  );
}

code = code.replaceAll("    logger({", "    auditLog({");

fs.writeFileSync(file, code, 'utf8');

console.log('Matters audit migration complete.');
console.log('Backup saved to:', backupDir);
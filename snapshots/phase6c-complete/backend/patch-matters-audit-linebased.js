const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'matters.js');
const backupDir = path.join(__dirname, 'backup', `matters-audit-linebased-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'matters.js.bak'));

let lines = fs.readFileSync(file, 'utf8').split(/\r?\n/);

if (!lines.join('\n').includes("action: 'CREATE_MATTER'")) {
  const idx = lines.findIndex(line => line.includes('logger.info(`Matter created:'));
  if (idx !== -1) {
    lines.splice(idx, 0,
`    logger({
      userEmail: req.user && req.user.email ? req.user.email : 'system',
      action: 'CREATE_MATTER',
      entityType: 'MATTER',
      entityId: String(matter.id),
      oldValue: null,
      newValue: matter,
      ipAddress: req.ip
    });
`);
  }
}

if (!lines.join('\n').includes("action: 'UPDATE_MATTER'")) {
  const updateIdx = lines.findIndex(line => line.includes('await matter.update(req.body);'));
  if (updateIdx !== -1) {
    lines.splice(updateIdx, 0, `    const oldMatter = matter.toJSON ? matter.toJSON() : matter;`);
  }

  const infoIdx = lines.findIndex(line => line.includes('logger.info(`Matter updated:'));
  if (infoIdx !== -1) {
    lines.splice(infoIdx, 0,
`    logger({
      userEmail: req.user && req.user.email ? req.user.email : 'system',
      action: 'UPDATE_MATTER',
      entityType: 'MATTER',
      entityId: String(matter.id),
      oldValue: oldMatter,
      newValue: matter,
      ipAddress: req.ip
    });
`);
  }
}

fs.writeFileSync(file, lines.join('\n'), 'utf8');

console.log('Matters audit line-based patch complete.');
console.log('Backup saved to:', backupDir);
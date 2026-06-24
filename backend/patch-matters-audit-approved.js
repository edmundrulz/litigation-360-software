const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'matters.js');
const backupDir = path.join(__dirname, 'backup', `matters-audit-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'matters.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (!code.includes("action: 'CREATE_MATTER'")) {
  code = code.replace(
`    logger.info(\`Matter created: \${matter.id}\`);
    res.status(201).json(matter);`,
`    logger({
      userEmail: req.user && req.user.email ? req.user.email : 'system',
      action: 'CREATE_MATTER',
      entityType: 'MATTER',
      entityId: String(matter.id),
      oldValue: null,
      newValue: matter,
      ipAddress: req.ip
    });

    logger.info(\`Matter created: \${matter.id}\`);
    res.status(201).json(matter);`
  );
}

if (!code.includes("action: 'UPDATE_MATTER'")) {
  code = code.replace(
`    await matter.update(req.body);
    logger.info(\`Matter updated: \${matter.id}\`);
    res.json(matter);`,
`    const oldMatter = matter.toJSON ? matter.toJSON() : matter;

    await matter.update(req.body);

    logger({
      userEmail: req.user && req.user.email ? req.user.email : 'system',
      action: 'UPDATE_MATTER',
      entityType: 'MATTER',
      entityId: String(matter.id),
      oldValue: oldMatter,
      newValue: matter,
      ipAddress: req.ip
    });

    logger.info(\`Matter updated: \${matter.id}\`);
    res.json(matter);`
  );
}

fs.writeFileSync(file, code, 'utf8');

console.log('Matters audit patch complete.');
console.log('Backup saved to:', backupDir);
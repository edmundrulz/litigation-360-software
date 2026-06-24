const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'clients.js');
const backupDir = path.join(__dirname, 'backup', `delete-client-exact-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'clients.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (code.includes("action: 'DELETE_CLIENT'")) {
  console.log('DELETE_CLIENT audit already exists. No changes made.');
  process.exit(0);
}

const before = "    db.prepare('DELETE FROM clients WHERE id = ?').run(req.params.id);\n    res.json({ success: true });";

const after = `    const existingClient = db.prepare('SELECT * FROM clients WHERE id = ?').get(req.params.id);

    if (!existingClient) {
      return res.status(404).json({ error: 'Client not found' });
    }

    auditLog({
      userEmail: 'system',
      action: 'DELETE_CLIENT',
      entityType: 'CLIENT',
      entityId: req.params.id,
      oldValue: existingClient,
      newValue: null,
      ipAddress: req.ip
    });

    db.prepare('DELETE FROM clients WHERE id = ?').run(req.params.id);
    res.json({ success: true });`;

if (!code.includes(before)) {
  console.error('Exact delete block not found. No changes made.');
  process.exit(1);
}

code = code.replace(before, after);
fs.writeFileSync(file, code, 'utf8');

console.log('DELETE_CLIENT exact patch complete.');
console.log('Backup saved to:', backupDir);
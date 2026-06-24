const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'clients.js');
const backupDir = path.join(__dirname, 'backup', `client-audit-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'clients.js.bak'));

let code = fs.readFileSync(file, 'utf8');

if (!code.includes("action: 'UPDATE_CLIENT'")) {
  const insertBeforeDelete = `
// PUT update client
router.put("/:id", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const existingClient = db.prepare('SELECT * FROM clients WHERE id = ?').get(req.params.id);

    if (!existingClient) {
      return res.status(404).json({ error: 'Client not found' });
    }

    const { full_name, email, phone, address } = req.body;

    db.prepare(
      'UPDATE clients SET full_name = ?, email = ?, phone = ?, address = ? WHERE id = ?'
    ).run(full_name, email, phone, address, req.params.id);

    auditLog({
      userEmail: 'system',
      action: 'UPDATE_CLIENT',
      entityType: 'CLIENT',
      entityId: req.params.id,
      oldValue: existingClient,
      newValue: {
        full_name,
        email,
        phone,
        address
      },
      ipAddress: req.ip
    });

    res.json({
      id: req.params.id,
      full_name,
      email,
      phone,
      address
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

`;

  code = code.replace('// DELETE client', insertBeforeDelete + '// DELETE client');
}

if (!code.includes("action: 'DELETE_CLIENT'")) {
  code = code.replace(
`  try {
    db.prepare('DELETE FROM clients WHERE id = ?').run(req.params.id);
    res.json({ success: true });`,
`  try {
    const existingClient = db.prepare('SELECT * FROM clients WHERE id = ?').get(req.params.id);

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
    res.json({ success: true });`
  );
}

fs.writeFileSync(file, code, 'utf8');

console.log('Client audit patch complete.');
console.log('Backup saved to:', backupDir);
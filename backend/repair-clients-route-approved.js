const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, 'src', 'routes', 'clients.js');
const backupDir = path.join(__dirname, 'backup', `repair-clients-${new Date().toISOString().replace(/[:.]/g, '-')}`);

fs.mkdirSync(backupDir, { recursive: true });
fs.copyFileSync(file, path.join(backupDir, 'clients.js.broken.bak'));

const fixed = `const auditLog = require('../utils/logger');
const express = require("express");
const { requireRole } = require("../middleware/roleMiddleware");
const router = express.Router();
const db = require('../database');

// GET all clients
router.get('/', (req, res) => {
  try {
    const clients = db.prepare('SELECT * FROM clients ORDER BY created_at DESC').all();
    res.json(clients);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST create client
router.post("/", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const { full_name, email, phone, address } = req.body;

    const result = db.prepare(
      'INSERT INTO clients (full_name, email, phone, address) VALUES (?, ?, ?, ?)'
    ).run(full_name, email, phone, address);

    auditLog({
      userEmail: 'system',
      action: 'CREATE_CLIENT',
      entityType: 'CLIENT',
      entityId: result.lastInsertRowid,
      newValue: {
        full_name,
        email,
        phone,
        address
      },
      ipAddress: req.ip
    });

    res.json({
      id: result.lastInsertRowid,
      full_name,
      email,
      phone,
      address
    });

  } catch (error) {
    res.status(500).json({
      error: error.message
    });
  }
});

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

// DELETE client
router.delete("/:id", requireRole("admin", "Administrator"), (req, res) => {
  try {
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
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
`;

fs.writeFileSync(file, fixed, 'utf8');

console.log('clients.js repaired safely.');
console.log('Broken version backed up to:', backupDir);
const auditLog = require('../utils/logger');
const express = require('express');
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
router.post('/', (req, res) => {
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

// DELETE client
router.delete('/:id', (req, res) => {
  try {
    db.prepare('DELETE FROM clients WHERE id = ?').run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
const express = require('express');
const router = express.Router();
const db = require('../database');
const { requireRole } = require('../middleware/roleMiddleware');

// GET all audit logs - ADMIN ONLY
router.get('/', requireRole('admin', 'Administrator'), (req, res) => {
  try {
    const logs = db.prepare(`
      SELECT *
      FROM audit_logs
      ORDER BY created_at DESC
    `).all();

    res.json(logs);
  } catch (error) {
    res.status(500).json({
      error: error.message
    });
  }
});

module.exports = router;
const express = require("express");
const { requireRole } = require("../middleware/roleMiddleware");
const router = express.Router();
const db = require('../database');
const auditLog = require('../utils/auditLogger');

// GET all deadlines
router.get('/', (req, res) => {
  try {
    const deadlines = db.prepare('SELECT * FROM deadlines ORDER BY deadline_date ASC').all();
    res.json(deadlines);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST create deadline
router.post("/", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    const result = db.prepare(
      'INSERT INTO deadlines (title, deadline_date, case_id, reminder_days, notes) VALUES (?, ?, ?, ?, ?)'
    ).run(title, deadline_date, case_id, reminder_days, notes);

    const newDeadline = {
      id: result.lastInsertRowid,
      title,
      deadline_date,
      case_id,
      reminder_days,
      notes
    };

    auditLog({
      userEmail: 'system',
      action: 'CREATE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(result.lastInsertRowid),
      oldValue: null,
      newValue: newDeadline,
      ipAddress: req.ip
    });

    res.json({ id: result.lastInsertRowid });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PUT update deadline
router.put("/:id", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const existingDeadline = db.prepare('SELECT * FROM deadlines WHERE id = ?').get(req.params.id);

    if (!existingDeadline) {
      return res.status(404).json({ error: 'Deadline not found' });
    }

    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    db.prepare(
      'UPDATE deadlines SET title = ?, deadline_date = ?, case_id = ?, reminder_days = ?, notes = ? WHERE id = ?'
    ).run(title, deadline_date, case_id, reminder_days, notes, req.params.id);

    const updatedDeadline = {
      id: req.params.id,
      title,
      deadline_date,
      case_id,
      reminder_days,
      notes
    };

    auditLog({
      userEmail: 'system',
      action: 'UPDATE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(req.params.id),
      oldValue: existingDeadline,
      newValue: updatedDeadline,
      ipAddress: req.ip
    });

    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE deadline
router.delete("/:id", requireRole("admin", "Administrator"), (req, res) => {
  try {
    const existingDeadline = db.prepare('SELECT * FROM deadlines WHERE id = ?').get(req.params.id);

    if (!existingDeadline) {
      return res.status(404).json({ error: 'Deadline not found' });
    }

    auditLog({
      userEmail: 'system',
      action: 'DELETE_DEADLINE',
      entityType: 'DEADLINE',
      entityId: String(req.params.id),
      oldValue: existingDeadline,
      newValue: null,
      ipAddress: req.ip
    });

    db.prepare('DELETE FROM deadlines WHERE id = ?').run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

const express = require('express');
const router = express.Router();
const db = require('../database');

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
router.post('/', (req, res) => {
  try {
    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    const result = db.prepare(
      'INSERT INTO deadlines (title, deadline_date, case_id, reminder_days, notes) VALUES (?, ?, ?, ?, ?)'
    ).run(title, deadline_date, case_id, reminder_days, notes);
    res.json({ id: result.lastInsertRowid });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// PUT update deadline
router.put('/:id', (req, res) => {
  try {
    const { title, deadline_date, case_id, reminder_days, notes } = req.body;
    db.prepare(
      'UPDATE deadlines SET title = ?, deadline_date = ?, case_id = ?, reminder_days = ?, notes = ? WHERE id = ?'
    ).run(title, deadline_date, case_id, reminder_days, notes, req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE deadline
router.delete('/:id', (req, res) => {
  try {
    db.prepare('DELETE FROM deadlines WHERE id = ?').run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
const express = require('express');
const router = express.Router();
const db = require('../database');

// GET all documents
router.get('/', (req, res) => {
  try {
    const documents = db.prepare('SELECT * FROM documents ORDER BY uploaded_at DESC').all();
    res.json(documents);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST create document
router.post('/', (req, res) => {
  try {
    const { file_name, case_id, document_type } = req.body;
    const result = db.prepare(
      'INSERT INTO documents (file_name, case_id, document_type) VALUES (?, ?, ?)'
    ).run(file_name, case_id, document_type);
    res.json({ id: result.lastInsertRowid });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE document
router.delete('/:id', (req, res) => {
  try {
    db.prepare('DELETE FROM documents WHERE id = ?').run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
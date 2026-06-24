const express = require("express");
const { requireRole } = require("../middleware/roleMiddleware");
const router = express.Router();
const db = require('../database');
const auditLog = require('../utils/auditLogger');

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
router.post("/", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const { file_name, case_id, document_type } = req.body;
    const result = db.prepare(
      'INSERT INTO documents (file_name, case_id, document_type) VALUES (?, ?, ?)'
    ).run(file_name, case_id, document_type);

    const newDocument = {
      id: result.lastInsertRowid,
      file_name,
      case_id,
      document_type
    };

    auditLog({
      userEmail: 'system',
      action: 'CREATE_DOCUMENT',
      entityType: 'DOCUMENT',
      entityId: String(result.lastInsertRowid),
      oldValue: null,
      newValue: newDocument,
      ipAddress: req.ip
    });

    res.json({ id: result.lastInsertRowid });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// DELETE document
router.delete("/:id", requireRole("admin", "Administrator"), (req, res) => {
  try {
    const existingDocument = db.prepare('SELECT * FROM documents WHERE id = ?').get(req.params.id);

    if (!existingDocument) {
      return res.status(404).json({ error: 'Document not found' });
    }

    auditLog({
      userEmail: 'system',
      action: 'DELETE_DOCUMENT',
      entityType: 'DOCUMENT',
      entityId: String(req.params.id),
      oldValue: existingDocument,
      newValue: null,
      ipAddress: req.ip
    });

    db.prepare('DELETE FROM documents WHERE id = ?').run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

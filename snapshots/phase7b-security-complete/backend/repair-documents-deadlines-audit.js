const fs = require('fs');
const path = require('path');

function backup(filePath, label) {
  const backupDir = path.join(__dirname, 'backup', `${label}-${new Date().toISOString().replace(/[:.]/g, '-')}`);
  fs.mkdirSync(backupDir, { recursive: true });
  fs.copyFileSync(filePath, path.join(backupDir, path.basename(filePath) + '.bak'));
  console.log(`Backup saved to: ${backupDir}`);
}

const documentsFile = path.join(__dirname, 'src', 'routes', 'documents.js');
backup(documentsFile, 'documents-audit-repair');

const documentsFixed = `const express = require("express");
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
`;

fs.writeFileSync(documentsFile, documentsFixed, 'utf8');

const deadlinesFile = path.join(__dirname, 'src', 'routes', 'deadlines.js');
backup(deadlinesFile, 'deadlines-audit-repair');

const deadlinesFixed = `const express = require("express");
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
`;

fs.writeFileSync(deadlinesFile, deadlinesFixed, 'utf8');

console.log('Documents and deadlines audit repair complete.');
const express = require("express");
const router = express.Router();
const db = require("../database");
const authMiddleware = require("../middleware/auth");
const { requireRole } = require("../middleware/roleMiddleware");

router.get("/", (req, res) => {
  try {
    const documents = db.prepare("SELECT * FROM documents ORDER BY uploaded_at DESC").all();
    res.json(documents);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/", authMiddleware, requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const body = req.body || {};
    const file_name = body.file_name || body.fileName || body.name || body.title || "Untitled Document";
    const file_path = body.file_path || body.filePath || "";
    const case_id = body.case_id || body.caseId || body.matterId || null;
    const document_type = body.document_type || body.documentType || body.type || "General";

    const result = db.prepare(`
      INSERT INTO documents (case_id, file_name, file_path, document_type)
      VALUES (?, ?, ?, ?)
    `).run(case_id, file_name, file_path, document_type);

    const row = db.prepare("SELECT * FROM documents WHERE id = ?").get(result.lastInsertRowid);
    res.status(201).json(row);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.delete("/:id", authMiddleware, requireRole("admin", "Administrator"), (req, res) => {
  try {
    db.prepare("DELETE FROM documents WHERE id = ?").run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

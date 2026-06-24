const express = require("express");
const router = express.Router();
const db = require("../database");
const authMiddleware = require("../middleware/auth");
const { requireRole } = require("../middleware/roleMiddleware");

function toMatter(row) {
  return {
    id: row.id,
    matterNumber: row.case_number,
    caseNumber: row.case_number,
    title: row.title,
    description: row.description,
    status: row.status,
    clientId: row.client_id,
    client_id: row.client_id,
    openedDate: row.opened_date,
    opened_date: row.opened_date,
    createdAt: row.created_at,
    updatedAt: row.created_at
  };
}

router.get("/", authMiddleware, (req, res) => {
  try {
    const rows = db.prepare("SELECT * FROM cases ORDER BY created_at DESC").all();
    const data = rows.map(toMatter);
    res.json({
      data,
      pagination: {
        page: 1,
        limit: data.length,
        total: data.length
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/", authMiddleware, requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const body = req.body || {};
    const case_number = body.case_number || body.caseNumber || body.matterNumber || null;
    const title = body.title || body.matterTitle || "Untitled Matter";
    const client_id = body.client_id || body.clientId || null;
    const status = body.status || "Active";
    const description = body.description || "";
    const opened_date = body.opened_date || body.openedDate || body.filingDate || null;

    const result = db.prepare(`
      INSERT INTO cases (case_number, title, client_id, status, description, opened_date)
      VALUES (?, ?, ?, ?, ?, ?)
    `).run(case_number, title, client_id, status, description, opened_date);

    const row = db.prepare("SELECT * FROM cases WHERE id = ?").get(result.lastInsertRowid);
    res.status(201).json(toMatter(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get("/:id", authMiddleware, (req, res) => {
  try {
    const row = db.prepare("SELECT * FROM cases WHERE id = ?").get(req.params.id);
    if (!row) return res.status(404).json({ error: "Matter not found" });
    res.json(toMatter(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put("/:id", authMiddleware, requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const body = req.body || {};
    db.prepare(`
      UPDATE cases
      SET case_number = ?, title = ?, client_id = ?, status = ?, description = ?, opened_date = ?
      WHERE id = ?
    `).run(
      body.case_number || body.caseNumber || body.matterNumber || null,
      body.title || body.matterTitle || "Untitled Matter",
      body.client_id || body.clientId || null,
      body.status || "Active",
      body.description || "",
      body.opened_date || body.openedDate || body.filingDate || null,
      req.params.id
    );

    const row = db.prepare("SELECT * FROM cases WHERE id = ?").get(req.params.id);
    res.json(toMatter(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.delete("/:id", authMiddleware, requireRole("admin", "Administrator"), (req, res) => {
  try {
    db.prepare("DELETE FROM cases WHERE id = ?").run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

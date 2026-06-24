const express = require("express");
const router = express.Router();
const db = require("../database");
const authMiddleware = require("../middleware/auth");
const { requireRole } = require("../middleware/roleMiddleware");

router.get("/", (req, res) => {
  try {
    const deadlines = db.prepare("SELECT * FROM deadlines ORDER BY deadline_date ASC").all();
    res.json(deadlines);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/", authMiddleware, requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const body = req.body || {};
    const title = body.title || "Untitled Deadline";
    const deadline_date = body.deadline_date || body.deadlineDate || body.date || null;
    const case_id = body.case_id || body.caseId || body.matterId || null;
    const reminder_days = body.reminder_days || body.reminderDays || 7;
    const notes = body.notes || "";

    if (!deadline_date) {
      return res.status(400).json({ error: "deadline_date is required" });
    }

    const result = db.prepare(`
      INSERT INTO deadlines (title, deadline_date, case_id, reminder_days, notes)
      VALUES (?, ?, ?, ?, ?)
    `).run(title, deadline_date, case_id, reminder_days, notes);

    const row = db.prepare("SELECT * FROM deadlines WHERE id = ?").get(result.lastInsertRowid);
    res.status(201).json(row);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.put("/:id", authMiddleware, requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {
  try {
    const body = req.body || {};
    db.prepare(`
      UPDATE deadlines
      SET title = ?, deadline_date = ?, case_id = ?, reminder_days = ?, notes = ?
      WHERE id = ?
    `).run(
      body.title || "Untitled Deadline",
      body.deadline_date || body.deadlineDate || body.date || null,
      body.case_id || body.caseId || body.matterId || null,
      body.reminder_days || body.reminderDays || 7,
      body.notes || "",
      req.params.id
    );

    const row = db.prepare("SELECT * FROM deadlines WHERE id = ?").get(req.params.id);
    res.json(row);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.delete("/:id", authMiddleware, requireRole("admin", "Administrator"), (req, res) => {
  try {
    db.prepare("DELETE FROM deadlines WHERE id = ?").run(req.params.id);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

const express = require("express");
const crypto = require("crypto");
const db = require("../database");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

function safeJson(value) {
  return JSON.stringify(value || {});
}

function parseJson(value) {
  try {
    return value ? JSON.parse(value) : {};
  } catch {
    return {};
  }
}

function formatDraft(row) {
  if (!row) return null;

  return {
    id: row.id,
    draft_guid: row.draft_guid,
    current_step: row.current_step,
    status: row.status,
    client_data: parseJson(row.client_data),
    case_data: parseJson(row.case_data),
    deadline_data: parseJson(row.deadline_data),
    document_data: parseJson(row.document_data),
    review_data: parseJson(row.review_data),
    created_at: row.created_at,
    updated_at: row.updated_at
  };
}

// CREATE NEW DRAFT
router.post("/draft", authMiddleware, (req, res) => {
  try {
    const draftGuid = crypto.randomUUID();

    db.prepare(`
      INSERT INTO matter_intake_drafts (draft_guid, current_step, status)
      VALUES (?, 1, 'draft')
    `).run(draftGuid);

    const row = db.prepare(`
      SELECT * FROM matter_intake_drafts WHERE draft_guid = ?
    `).get(draftGuid);

    res.status(201).json(formatDraft(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET DRAFT
router.get("/draft/:draftGuid", authMiddleware, (req, res) => {
  try {
    const row = db.prepare(`
      SELECT * FROM matter_intake_drafts WHERE draft_guid = ?
    `).get(req.params.draftGuid);

    if (!row) return res.status(404).json({ error: "Draft not found" });

    res.json(formatDraft(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// SAVE STEP
router.post("/draft/:draftGuid/step/:step", authMiddleware, (req, res) => {
  try {
    const step = Number(req.params.step);
    const body = req.body || {};

    const columnMap = {
      1: "client_data",
      2: "case_data",
      3: "deadline_data",
      4: "document_data",
      5: "review_data"
    };

    const column = columnMap[step];
    if (!column) return res.status(400).json({ error: "Invalid step" });

    db.prepare(`
      UPDATE matter_intake_drafts
      SET ${column} = ?, current_step = ?, updated_at = CURRENT_TIMESTAMP
      WHERE draft_guid = ?
    `).run(safeJson(body), step, req.params.draftGuid);

    const row = db.prepare(`
      SELECT * FROM matter_intake_drafts WHERE draft_guid = ?
    `).get(req.params.draftGuid);

    res.json(formatDraft(row));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// FINAL SUBMIT: commits Client -> Case -> Deadline -> Document
router.post("/draft/:draftGuid/submit", authMiddleware, (req, res) => {
  try {
    const row = db.prepare(`
      SELECT * FROM matter_intake_drafts WHERE draft_guid = ?
    `).get(req.params.draftGuid);

    if (!row) return res.status(404).json({ error: "Draft not found" });

    const client = parseJson(row.client_data);
    const caseData = parseJson(row.case_data);
    const deadline = parseJson(row.deadline_data);
    const document = parseJson(row.document_data);

    const tx = db.transaction(() => {
      const clientResult = db.prepare(`
        INSERT INTO clients (full_name, email, phone, address)
        VALUES (?, ?, ?, ?)
      `).run(
        client.full_name || client.fullName || "Unnamed Client",
        client.email || "",
        client.phone || "",
        client.address || ""
      );

      const clientId = clientResult.lastInsertRowid;

      const caseResult = db.prepare(`
        INSERT INTO cases (case_number, title, client_id, status, description, opened_date)
        VALUES (?, ?, ?, ?, ?, ?)
      `).run(
        caseData.case_number || caseData.caseNumber || null,
        caseData.title || "Untitled Case",
        clientId,
        caseData.status || "Active",
        caseData.description || "",
        caseData.opened_date || caseData.openedDate || null
      );

      const caseId = caseResult.lastInsertRowid;

      let deadlineId = null;
      if (deadline.title || deadline.deadline_date || deadline.deadlineDate) {
        const deadlineResult = db.prepare(`
          INSERT INTO deadlines (case_id, title, deadline_date, reminder_days, notes)
          VALUES (?, ?, ?, ?, ?)
        `).run(
          caseId,
          deadline.title || "Untitled Deadline",
          deadline.deadline_date || deadline.deadlineDate,
          deadline.reminder_days || deadline.reminderDays || 7,
          deadline.notes || ""
        );
        deadlineId = deadlineResult.lastInsertRowid;
      }

      let documentId = null;
      if (document.file_name || document.fileName || document.title) {
        const documentResult = db.prepare(`
          INSERT INTO documents (case_id, file_name, file_path, document_type)
          VALUES (?, ?, ?, ?)
        `).run(
          caseId,
          document.file_name || document.fileName || document.title || "Untitled Document",
          document.file_path || document.filePath || "",
          document.document_type || document.documentType || "General"
        );
        documentId = documentResult.lastInsertRowid;
      }

      db.prepare(`
        UPDATE matter_intake_drafts
        SET status = 'submitted', updated_at = CURRENT_TIMESTAMP
        WHERE draft_guid = ?
      `).run(req.params.draftGuid);

      return { clientId, caseId, deadlineId, documentId };
    });

    const result = tx();

    res.json({
      success: true,
      message: "Matter intake submitted successfully",
      result
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

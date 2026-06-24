const express = require("express");
const { requireRole } = require("../middleware/roleMiddleware");
const router = express.Router();
const db = require('../database');
const auditLog = require('../utils/auditLogger');


// ========================================
// GET ALL CASES
// ========================================

router.get('/', (req, res) => {
  try {

    const cases = db.prepare(`
      SELECT *
      FROM cases
      ORDER BY created_at DESC
    `).all();

    res.json(cases);

  } catch (error) {
    console.error('GET CASES ERROR:', error);

    res.status(500).json({
      error: error.message
    });
  }
});


// ========================================
// CREATE CASE (HARDENED + TRANSACTION SAFE)
// ========================================

router.post("/", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {

  const body = req.body || {};

  const {
    case_number,
    title,
    client_id,
    status,
    description,
    opened_date
  } = body;

  // ===============================
  // VALIDATION
  // ===============================
  const missingFields = [];

  if (!title) missingFields.push('title');
  if (!client_id) missingFields.push('client_id');

  if (missingFields.length > 0) {
    return res.status(400).json({
      error: 'Missing required fields',
      missingFields,
      received: body
    });
  }

  const transaction = db.transaction(() => {

    // ===============================
    // DUPLICATE CHECK
    // ===============================
    if (case_number) {
      const existingCase = db.prepare(`
        SELECT id FROM cases WHERE case_number = ?
      `).get(case_number);

      if (existingCase) {
        throw new Error('DUPLICATE_CASE');
      }
    }

    // ===============================
    // INSERT CASE
    // ===============================
    const result = db.prepare(`
      INSERT INTO cases
      (
        case_number,
        title,
        client_id,
        status,
        description,
        opened_date
      )
      VALUES
      (?, ?, ?, ?, ?, ?)
    `).run(
      case_number || null,
      title,
      client_id,
      status || 'NEW',
      description || '',
      opened_date || null
    );

    return result.lastInsertRowid;
  });

  try {

    const caseId = transaction();

    auditLog({
      userEmail: 'system',
      action: 'CREATE_CASE',
      entityType: 'CASE',
      entityId: caseId,
      newValue: {
        case_number,
        title,
        client_id
      },
      ipAddress: req.ip
    });

    res.json({
      success: true,
      id: caseId
    });

  } catch (error) {

    console.error('CREATE CASE ERROR:', error);

    if (error.message === 'DUPLICATE_CASE') {
      return res.status(409).json({
        error: 'Possible duplicate case detected'
      });
    }

    res.status(500).json({
      error: error.message
    });
  }
});


// ========================================
// UPDATE CASE (SAFE)
// ========================================

router.put("/:id", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {

  try {

    const body = req.body || {};

    const {
      case_number,
      title,
      client_id,
      status,
      description,
      opened_date
    } = body;

    db.prepare(`
      UPDATE cases
      SET
        case_number = ?,
        title = ?,
        client_id = ?,
        status = ?,
        description = ?,
        opened_date = ?
      WHERE id = ?
    `).run(
      case_number,
      title,
      client_id,
      status,
      description,
      opened_date,
      req.params.id
    );

    auditLog({
      userEmail: 'system',
      action: 'UPDATE_CASE',
      entityType: 'CASE',
      entityId: req.params.id,
      newValue: { case_number, title, status },
      ipAddress: req.ip
    });

    res.json({ success: true });

  } catch (error) {
    console.error('UPDATE CASE ERROR:', error);

    res.status(500).json({ error: error.message });
  }
});


// ========================================
// DELETE CASE
// ========================================

router.delete("/:id", requireRole("admin", "Administrator"), (req, res) => {

  try {

    db.prepare(`
      DELETE FROM cases WHERE id = ?
    `).run(req.params.id);

    auditLog({
      userEmail: 'system',
      action: 'DELETE_CASE',
      entityType: 'CASE',
      entityId: req.params.id,
      ipAddress: req.ip
    });

    res.json({ success: true });

  } catch (error) {
    console.error('DELETE CASE ERROR:', error);

    res.status(500).json({ error: error.message });
  }
});


// ========================================
// ASSIGN CASE TO STAFF (HARDENED)
// ========================================

router.post("/assign", requireRole("admin", "Administrator", "manager", "Manager"), (req, res) => {

  const body = req.body || {};

  const { case_id, staff_id } = body;

  if (!case_id || !staff_id) {
    return res.status(400).json({
      error: 'case_id and staff_id are required',
      received: body
    });
  }

  const transaction = db.transaction(() => {

    // Assign case
    db.prepare(`
      UPDATE cases
      SET assigned_staff_id = ?
      WHERE id = ?
    `).run(staff_id, case_id);

    // Increment workload safely
    db.prepare(`
      UPDATE staff
      SET workload = COALESCE(workload, 0) + 1
      WHERE id = ?
    `).run(staff_id);
  });

  try {

    transaction();

    auditLog({
      userEmail: 'system',
      action: 'ASSIGN_CASE',
      entityType: 'CASE',
      entityId: case_id,
      newValue: { assigned_staff_id: staff_id },
      ipAddress: req.ip
    });

    res.json({
      success: true,
      message: 'Case assigned successfully'
    });

  } catch (error) {

    console.error('ASSIGN CASE ERROR:', error);

    res.status(500).json({
      error: error.message
    });
  }
});


module.exports = router;
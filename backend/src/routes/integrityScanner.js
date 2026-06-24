const { requireRole } = require("../middleware/roleMiddleware");
const express = require("express");
const router = express.Router();
const db = require("../database");

router.get("/", requireRole("admin", "Administrator"), (req, res) => {

  const issues = [];

  try {

    // ===================================
    // CASES WITH MISSING CLIENTS
    // ===================================

    const orphanCases = db.prepare(`
      SELECT c.id, c.title
      FROM cases c
      LEFT JOIN clients cl
      ON c.client_id = cl.id
      WHERE c.client_id IS NOT NULL
      AND cl.id IS NULL
    `).all();

    orphanCases.forEach(item => {
      issues.push({
        severity: "HIGH",
        type: "ORPHAN_CASE",
        message: `Case ${item.id} missing client`
      });
    });

    // ===================================
    // BROKEN ASSIGNMENTS
    // ===================================

    const brokenAssignments = db.prepare(`
      SELECT ca.id
      FROM case_assignments ca
      LEFT JOIN staff s
      ON ca.staff_id = s.id
      WHERE s.id IS NULL
    `).all();

    brokenAssignments.forEach(item => {
      issues.push({
        severity: "HIGH",
        type: "BROKEN_ASSIGNMENT",
        message: `Assignment ${item.id} missing staff`
      });
    });

    // ===================================
    // INVALID STATUS
    // ===================================

    const invalidStatuses = db.prepare(`
      SELECT id,status
      FROM cases
      WHERE status NOT IN
      ('NEW','OPEN','ACTIVE','CLOSED')
    `).all();

    invalidStatuses.forEach(item => {
      issues.push({
        severity: "MEDIUM",
        type: "INVALID_STATUS",
        message: `Case ${item.id} has invalid status ${item.status}`
      });
    });

    // ===================================
    // EMPTY TITLES
    // ===================================

    const emptyTitles = db.prepare(`
      SELECT id
      FROM cases
      WHERE title IS NULL
      OR TRIM(title)=''
    `).all();

    emptyTitles.forEach(item => {
      issues.push({
        severity: "HIGH",
        type: "EMPTY_TITLE",
        message: `Case ${item.id} missing title`
      });
    });

    // ===================================
    // DUPLICATE CLIENT EMAILS
    // ===================================

    const duplicateEmails = db.prepare(`
      SELECT email, COUNT(*) count
      FROM clients
      WHERE email IS NOT NULL
      AND email <> ''
      GROUP BY email
      HAVING COUNT(*) > 1
    `).all();

    duplicateEmails.forEach(item => {
      issues.push({
        severity: "LOW",
        type: "DUPLICATE_EMAIL",
        message: `Duplicate email found: ${item.email}`
      });
    });

    // ===================================
    // HEALTH SCORE
    // ===================================

    let score = 100;

    score -= issues.length * 10;

    if (score < 0) {
      score = 0;
    }

    let status = "HEALTHY";

    if (score < 50) {
      status = "CRITICAL";
    }
    else if (score < 80) {
      status = "WARNING";
    }

    return res.json({
      status,
      score,
      total_issues: issues.length,
      issues,
      scanned_at: new Date().toISOString()
    });

  }
  catch (err) {

    return res.status(500).json({
      status: "CRITICAL",
      error: err.message
    });

  }

});

module.exports = router;
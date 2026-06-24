const { requireRole } = require("../middleware/roleMiddleware");
const express = require("express");
const router = express.Router();
const db = require("../database");

// helper
function checkTable(name) {
  try {
    db.prepare(`SELECT 1 FROM ${name} LIMIT 1`).get();
    return { table: name, status: "OK" };
  } catch (err) {
    return { table: name, status: "MISSING_OR_BROKEN", error: err.message };
  }
}

router.get("/", requireRole("admin", "Administrator"), (req, res) => {
  try {

    console.log("🧠 SYSTEM DIAGNOSTIC RUN INITIATED");

    // 1. CORE DB CHECK
    const dbCheck = db.prepare("SELECT 1").get();

    // 2. TABLE CHECKS
    const tables = ["cases", "clients", "staff", "case_assignments"];
    const tableStatus = tables.map(checkTable);

    // 3. API HEALTH SNAPSHOT
    const health = {
      database: dbCheck ? "CONNECTED" : "FAILED",
      uptime: process.uptime(),
      timestamp: new Date().toISOString()
    };

    // 4. ISSUE DETECTION
    const issues = [];
// ======================
// INTEGRITY CHECKS
// ======================

const orphanCases = db.prepare(`
  SELECT c.id
  FROM cases c
  LEFT JOIN clients cl
    ON c.client_id = cl.id
  WHERE c.client_id IS NOT NULL
    AND cl.id IS NULL
`).all();

if (orphanCases.length > 0) {

  issues.push({
    type: "DATA_INTEGRITY",
    severity: "CRITICAL",
    message: `${orphanCases.length} case(s) linked to missing clients`
  });

}

// ======================
// ASSIGNMENT → STAFF CHECK
// ======================

const orphanStaffAssignments = db.prepare(`
  SELECT ca.id
  FROM case_assignments ca
  LEFT JOIN staff s
    ON ca.staff_id = s.id
  WHERE s.id IS NULL
`).all();

if (orphanStaffAssignments.length > 0) {

  issues.push({
    type: "DATA_INTEGRITY",
    severity: "CRITICAL",
    message:
      `${orphanStaffAssignments.length} assignment(s) linked to missing staff`
  });

}

// ======================
// ASSIGNMENT -> CASE CHECK
// ======================

const orphanCaseAssignments = db.prepare(`
  SELECT ca.id
  FROM case_assignments ca
  LEFT JOIN cases c
    ON ca.case_id = c.id
  WHERE c.id IS NULL
`).all();

if (orphanCaseAssignments.length > 0) {

  issues.push({
    type: "DATA_INTEGRITY",
    severity: "CRITICAL",
    message:
      `${orphanCaseAssignments.length} assignment(s) linked to missing cases`
  });

}

// ======================
// DUPLICATE ASSIGNMENTS
// ======================

const duplicateAssignments = db.prepare(`
  SELECT
    case_id,
    staff_id,
    COUNT(*) AS total
  FROM case_assignments
  GROUP BY case_id, staff_id
  HAVING COUNT(*) > 1
`).all();

if (duplicateAssignments.length > 0) {

  issues.push({
    type: "DATA_INTEGRITY",
    severity: "HIGH",
    message:
      `${duplicateAssignments.length} duplicate assignment group(s) detected`
  });

}

    tableStatus.forEach(t => {
      if (t.status !== "OK") {
        issues.push({
          type: "DATABASE",
          severity: "HIGH",
          message: `Problem detected in table: ${t.table}`
        });
      }
    });

// ======================    
// 5. SYSTEM SCORE
// ======================

let score = 100;

// deduct points for detected issues
score -= (issues.length * 15);

if (score < 0) {
  score = 0;
}

// determine health level
let statusLevel = "HEALTHY";

if (score < 50) {
  statusLevel = "CRITICAL";
} else if (score < 80) {
  statusLevel = "WARNING";
}
    // 6. RESPONSE
    res.json({
      system_status: statusLevel,
      score,
      health,
      tables: tableStatus,
      issues,
      recommendation:
        issues.length > 0
          ? "Investigate failing modules immediately"
          : "System stable",
      scan_time: new Date().toISOString()
    });

  } catch (err) {
    console.error("❌ SYSTEM DIAGNOSTIC FAILED:", err);

    res.status(500).json({
      system_status: "CRITICAL",
      error: err.message
    });
  }
});

module.exports = router;
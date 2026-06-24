const { requireRole } = require("../middleware/roleMiddleware");
const express = require("express");
const router = express.Router();
const db = require("../database");

const { getErrors } = require("../utils/errorBus");
const { getSchedulerStats } = require("../jobs/systemScheduler");

router.get("/", requireRole("admin", "Administrator"), (req, res) => {
  try {
    const errors = getErrors();
    const scheduler = getSchedulerStats();

    const totalCases = db.prepare("SELECT COUNT(*) AS total FROM cases").get().total;
    const totalClients = db.prepare("SELECT COUNT(*) AS total FROM clients").get().total;
    const totalStaff = db.prepare("SELECT COUNT(*) AS total FROM staff").get().total;
    const totalAssignments = db.prepare("SELECT COUNT(*) AS total FROM case_assignments").get().total;

    const openCases = db.prepare(`
      SELECT COUNT(*) AS total
      FROM cases
      WHERE status IS NULL
         OR status IN ('NEW', 'OPEN', 'ACTIVE')
    `).get().total;

    const closedCases = db.prepare(`
      SELECT COUNT(*) AS total
      FROM cases
      WHERE status = 'CLOSED'
    `).get().total;

    const integrityIssues = [];

    const orphanCases = db.prepare(`
      SELECT c.id
      FROM cases c
      LEFT JOIN clients cl ON c.client_id = cl.id
      WHERE c.client_id IS NOT NULL
        AND cl.id IS NULL
    `).all();

    if (orphanCases.length > 0) {
      integrityIssues.push({
        type: "ORPHAN_CASES",
        count: orphanCases.length
      });
    }

    const errorCount = errors.length;
    const integrityScore = Math.max(0, 100 - integrityIssues.length * 15);
    const healthScore = Math.max(0, 100 - errorCount * 5 - integrityIssues.length * 10);

    let systemStatus = "HEALTHY";

    if (healthScore < 50) {
      systemStatus = "CRITICAL";
    } else if (healthScore < 80) {
      systemStatus = "WARNING";
    }

    res.json({
      system: {
        status: systemStatus,
        healthScore,
        integrityScore,
        uptimeSeconds: process.uptime(),
        memoryMb: Math.round(process.memoryUsage().heapUsed / 1024 / 1024)
      },
      counts: {
        totalCases,
        openCases,
        closedCases,
        totalClients,
        totalStaff,
        totalAssignments
      },
      errors: {
        total: errorCount,
        latest: errors.length > 0 ? errors[errors.length - 1] : null
      },
      integrity: {
        totalIssues: integrityIssues.length,
        issues: integrityIssues
      },
      scheduler,
      progress: {
        backendFoundation: 95,
        databaseLayer: 95,
        monitoringLayer: 90,
        integrityLayer: 90,
        autoHealLayer: 80,
        operationsDashboard: 25,
        securityLayer: 10,
        aiLayer: 0
      },
      timestamp: new Date().toISOString()
    });

  } catch (err) {
    res.status(500).json({
      error: err.message
    });
  }
});

module.exports = router;
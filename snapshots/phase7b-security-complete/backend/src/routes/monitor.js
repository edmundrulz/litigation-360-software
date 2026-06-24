const { requireRole } = require("../middleware/roleMiddleware");
const express = require("express");
const router = express.Router();

const { getErrors } = require("../utils/errorBus");

// LIVE SYSTEM SNAPSHOT
router.get("/", requireRole("admin", "Administrator"), (req, res) => {

  const uptime = process.uptime();
  const memory = process.memoryUsage();

  const errors = getErrors();

  const criticalErrors = errors.filter(e => e.severity === "HIGH");

  let status = "HEALTHY";

  if (criticalErrors.length > 5) status = "DEGRADED";
  if (criticalErrors.length > 20) status = "CRITICAL";

  res.json({
    status,
    uptime,
    memory: {
      rss: memory.rss,
      heapUsed: memory.heapUsed,
      heapTotal: memory.heapTotal
    },
    errorCount: errors.length,
    criticalCount: criticalErrors.length,
    lastErrors: errors.slice(-10),
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
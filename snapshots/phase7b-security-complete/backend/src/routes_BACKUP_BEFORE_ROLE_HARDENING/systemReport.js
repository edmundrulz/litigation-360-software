const express = require("express");
const router = express.Router();

const { getErrors } = require("../utils/errorBus");

router.get("/", async (req, res) => {

  try {

    const errors = getErrors();

    const report = {
      timestamp: new Date().toISOString(),

      system: {
        status: "ONLINE",
        uptime_seconds: process.uptime(),
        memory_usage_mb:
          Math.round(process.memoryUsage().heapUsed / 1024 / 1024)
      },

      errors: {
        total: errors.length,
        last_error:
          errors.length > 0
            ? errors[errors.length - 1]
            : null
      },

      health_score:
        errors.length === 0
          ? 100
          : Math.max(0, 100 - (errors.length * 5))
    };

    res.json(report);

  } catch (err) {

    res.status(500).json({
      error: err.message
    });

  }

});

module.exports = router;
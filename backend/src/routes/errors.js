const express = require("express");
const { requireRole } = require("../middleware/roleMiddleware");
const router = express.Router();

const { getErrors, clearErrors } = require("../utils/errorBus");

/* =====================================================
   GET ALL RECENT ERRORS (LIVE DEBUG VIEW)
===================================================== */
router.get("/", requireRole("admin", "Administrator"), (req, res) => {
  try {
    const errors = getErrors();

    res.json({
      success: true,
      count: errors.length,
      errors
    });

  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Failed to retrieve errors",
      error: err.message
    });
  }
});

/* =====================================================
   CLEAR ERROR MEMORY (ADMIN ONLY TOOL)
===================================================== */
router.delete("/clear", requireRole("admin", "Administrator"), (req, res) => {
  try {
    clearErrors();

    res.json({
      success: true,
      message: "Error log cleared"
    });

  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Failed to clear errors",
      error: err.message
    });
  }
});

module.exports = router;

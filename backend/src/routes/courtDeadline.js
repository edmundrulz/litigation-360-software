const express = require("express");
const { calculateDeadline, DEADLINE_RULES } = require("../utils/courtDeadlineCalculator");

const router = express.Router();

router.get("/rules", (req, res) => {
  res.json({
    success: true,
    rules: DEADLINE_RULES
  });
});

router.post("/calculate", (req, res) => {
  const result = calculateDeadline(req.body || {});

  if (!result.success) {
    return res.status(400).json(result);
  }

  res.json(result);
});

module.exports = router;
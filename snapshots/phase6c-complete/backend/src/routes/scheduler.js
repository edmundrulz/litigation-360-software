const express = require("express");
const router = express.Router();

const {
  getSchedulerStats
} = require("../jobs/systemScheduler");

router.get("/", (req, res) => {
  res.json({
    status: "RUNNING",
    ...getSchedulerStats()
  });
});

module.exports = router;
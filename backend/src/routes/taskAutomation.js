const express = require("express");
const { generateTasksForStage } = require("../utils/taskAutomationEngine");

const router = express.Router();

router.post("/generate", (req, res) => {
  const stage = req.body.stage || "INTAKE";
  const tasks = generateTasksForStage(stage);

  res.json({
    success: true,
    stage: String(stage).toUpperCase(),
    taskCount: tasks.length,
    tasks
  });
});

module.exports = router;
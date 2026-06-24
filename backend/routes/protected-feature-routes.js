const express = require("express");
const router = express.Router();
const { requireFeature } = require("../middleware/requireFeature");

router.get("/tasks", requireFeature("TASKS"), function (req, res) {
  res.json({
    success: true,
    module: "Tasks",
    message: "Tasks module access granted."
  });
});

router.get("/reports", requireFeature("REPORTS"), function (req, res) {
  res.json({
    success: true,
    module: "Reports",
    message: "Reports module access granted."
  });
});

router.get("/legal-ai", requireFeature("LEGAL_AI"), function (req, res) {
  res.json({
    success: true,
    module: "Legal AI",
    message: "Legal AI access granted."
  });
});

router.get("/executive-command-centre", requireFeature("EXECUTIVE_COMMAND_CENTRE"), function (req, res) {
  res.json({
    success: true,
    module: "Executive Command Centre",
    message: "Executive Command Centre access granted."
  });
});

router.get("/government-integrations", requireFeature("GOVERNMENT_INTEGRATIONS"), function (req, res) {
  res.json({
    success: true,
    module: "Government Integrations",
    message: "Government Integrations access granted."
  });
});

module.exports = router;

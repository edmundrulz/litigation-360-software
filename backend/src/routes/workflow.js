const express = require("express");
const {
  WORKFLOWS,
  getWorkflowPreview
} = require("../utils/workflowConveyor");

const router = express.Router();

router.get("/templates", (req, res) => {
  res.json({
    success: true,
    templates: WORKFLOWS
  });
});

router.post("/preview", (req, res) => {
  const departmentCode = String(req.body.departmentCode || "").toUpperCase();

  const preview = getWorkflowPreview(departmentCode);

  res.json({
    success: preview.valid,
    departmentCode,
    preview
  });
});

module.exports = router;
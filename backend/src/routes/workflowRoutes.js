const express = require("express");
const router = express.Router();

const {
  createWorkflow,
  startWorkflow,
  completeCurrentStep,
  failWorkflow,
  getWorkflowById,
  getWorkflows,
  getWorkflowMetrics,
  getWorkflowHealth,
  getWorkflowTemplates
} = require("../automation/workflowEngine");

router.get("/health", (req, res) => {
  res.json(getWorkflowHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getWorkflowMetrics());
});

router.get("/templates", (req, res) => {
  res.json({
    templates: getWorkflowTemplates(),
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const status = req.query.status || null;
  const workflowType = req.query.workflowType || null;

  res.json({
    workflows: getWorkflows({ limit, status, workflowType }),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const workflow = getWorkflowById(req.params.id);

  if (!workflow) {
    return res.status(404).json({
      ok: false,
      error: "Workflow not found"
    });
  }

  res.json({
    ok: true,
    workflow
  });
});

router.post("/create", (req, res) => {
  try {
    const workflow = createWorkflow(req.body || {});
    res.status(201).json({
      ok: true,
      workflow
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/start", async (req, res) => {
  const result = await startWorkflow(req.params.id);
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/complete-step", async (req, res) => {
  const result = await completeCurrentStep(req.params.id, req.body?.note || "Step completed from API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/fail", (req, res) => {
  const result = failWorkflow(req.params.id, req.body?.error || "Workflow failed from API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/new-client-intake", async (req, res) => {
  const workflow = createWorkflow({
    workflowType: "NEW_CLIENT_INTAKE",
    title: "Phase 10D Test Client Intake",
    payload: {
      test: true,
      clientName: "Phase 10D Test Client"
    },
    context: {
      source: "PHASE_10D_TEST"
    }
  });

  await startWorkflow(workflow.id);
  await completeCurrentStep(workflow.id, "Validation step 1 completed");

  res.json({
    ok: true,
    workflow: getWorkflowById(workflow.id)
  });
});

module.exports = router;

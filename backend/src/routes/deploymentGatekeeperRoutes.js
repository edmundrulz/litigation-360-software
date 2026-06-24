const express = require("express");
const router = express.Router();

const {
  evaluateDeploymentGate,
  approveDeployment,
  rejectDeployment,
  getGatekeeperReport,
  getGatekeeperStatus,
  getGatekeeperApproval,
  getGatekeeperBlockers,
  getGatekeeperWarnings,
  getGatekeeperHealth,
  getGatekeeperMetrics,
  testRejectionLogic
} = require("../automation/deploymentGatekeeperEngine");

router.get("/health", (req, res) => res.json(getGatekeeperHealth()));
router.get("/metrics", (req, res) => res.json(getGatekeeperMetrics()));
router.get("/status", (req, res) => res.json(getGatekeeperStatus()));
router.get("/approval", (req, res) => res.json(getGatekeeperApproval()));
router.get("/blockers", (req, res) => res.json(getGatekeeperBlockers()));
router.get("/warnings", (req, res) => res.json(getGatekeeperWarnings()));
router.get("/report", (req, res) => res.json(getGatekeeperReport()));
router.get("/evaluate", (req, res) => res.json(evaluateDeploymentGate()));
router.get("/test/rejection", (req, res) => res.json(testRejectionLogic()));
router.get("/test/approval", (req, res) => res.json(approveDeployment({ approver: "PHASE_10X6_TEST", note: "Test approval flow" })));

router.post("/approve", (req, res) => {
  const result = approveDeployment({
    approver: req.body?.approver || "API",
    note: req.body?.note || "Deployment approval requested through API"
  });
  res.status(result.deploymentApproved ? 200 : 409).json(result);
});

router.post("/reject", (req, res) => {
  const result = rejectDeployment({
    rejectedBy: req.body?.rejectedBy || "API",
    reason: req.body?.reason || "Deployment rejected through API"
  });
  res.status(200).json(result);
});

module.exports = router;

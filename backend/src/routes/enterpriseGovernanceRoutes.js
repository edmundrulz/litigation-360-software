const express = require("express");
const router = express.Router();

const {
  createApprovalRequest,
  approveRequest,
  rejectRequest,
  generateEvidenceRecord,
  runComplianceCheck,
  getApprovals,
  getEvidence,
  getComplianceAlerts,
  getPolicyViolations,
  getGovernanceDashboard,
  getGovernanceHealth,
  getGovernanceMetrics,
  getPolicies
} = require("../automation/enterpriseGovernanceEngine");

router.get("/health", (req, res) => res.json(getGovernanceHealth()));
router.get("/metrics", (req, res) => res.json(getGovernanceMetrics()));
router.get("/dashboard", (req, res) => res.json(getGovernanceDashboard()));
router.get("/policies", (req, res) => res.json({ policies: getPolicies(), timestamp: new Date().toISOString() }));
router.get("/approvals", (req, res) => res.json({ approvals: getApprovals({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.post("/approvals", (req, res) => {
  try { res.status(201).json({ ok: true, approval: createApprovalRequest(req.body || {}) }); }
  catch (err) { res.status(400).json({ ok: false, error: err.message }); }
});
router.post("/approvals/:id/approve", (req, res) => res.json(approveRequest(req.params.id, req.body || {})));
router.post("/approvals/:id/reject", (req, res) => res.json(rejectRequest(req.params.id, req.body || {})));
router.get("/evidence", (req, res) => res.json({ evidence: getEvidence(), timestamp: new Date().toISOString() }));
router.post("/evidence", (req, res) => {
  try { res.status(201).json({ ok: true, evidence: generateEvidenceRecord(req.body || {}) }); }
  catch (err) { res.status(400).json({ ok: false, error: err.message }); }
});
router.get("/compliance", (req, res) => res.json({ alerts: getComplianceAlerts({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.post("/compliance/run", (req, res) => res.json(runComplianceCheck()));
router.get("/violations", (req, res) => res.json({ violations: getPolicyViolations({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/test/approval", (req, res) => {
  const approval = createApprovalRequest({
    approvalType: "MATTER_CLOSURE",
    title: "Phase 10N Test Matter Closure Approval",
    requestedBy: "PHASE_10N_TEST",
    matterId: "MATTER-PHASE-10N-TEST",
    reason: "Validation approval request"
  });
  const approved = approveRequest(approval.id, { approvedBy: "PHASE_10N_TEST_APPROVER", note: "Validation approval granted" });
  res.json({ ok: true, approval, approved });
});

module.exports = router;

const crypto = require("crypto");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow, getWorkflows } = require("./workflowEngine");
const { getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");
const { getAutonomousHealth, getEscalations } = require("./autonomousOperationsEngine");

const approvals = [];
const evidenceRecords = [];
const complianceAlerts = [];
const policyViolations = [];

const governanceMetrics = {
  approvalsCreated: 0,
  approvalsApproved: 0,
  approvalsRejected: 0,
  evidenceGenerated: 0,
  complianceChecksRun: 0,
  complianceAlertsCreated: 0,
  policyViolationsCreated: 0,
  governanceDashboardsGenerated: 0,
  lastGeneratedAt: null
};

const GOVERNANCE_POLICIES = [
  {
    id: "POL-MATTER-CLOSURE-APPROVAL",
    name: "Matter closure requires approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "MATTER_CLOSURE"
  },
  {
    id: "POL-INVOICE-APPROVAL",
    name: "Invoice release requires approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "INVOICE_RELEASE"
  },
  {
    id: "POL-PERMISSION-CHANGE-APPROVAL",
    name: "User permission changes require approval",
    severity: "HIGH",
    enabled: true,
    appliesTo: "PERMISSION_CHANGE"
  },
  {
    id: "POL-CONFLICT-CHECK-REQUIRED",
    name: "New matters require conflict check",
    severity: "HIGH",
    enabled: true,
    appliesTo: "MATTER_OPENING"
  },
  {
    id: "POL-COURT-PREP-REQUIRED",
    name: "Court dates require preparation workflow",
    severity: "MEDIUM",
    enabled: true,
    appliesTo: "COURT_DATE"
  }
];

function now() {
  return new Date().toISOString();
}

function hashEvidence(payload) {
  return crypto.createHash("sha256").update(JSON.stringify(payload)).digest("hex");
}

function createApprovalRequest({
  approvalType,
  title,
  requestedBy = "SYSTEM",
  matterId = null,
  reason = null,
  payload = {},
  requiredApproverRole = "PARTNER"
} = {}) {
  if (!approvalType) throw new Error("approvalType is required");
  if (!title) throw new Error("title is required");

  const approval = {
    id: `APR-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    approvalType,
    title,
    requestedBy,
    matterId,
    reason,
    payload,
    requiredApproverRole,
    status: "PENDING",
    requestedAt: now(),
    decidedAt: null,
    decidedBy: null,
    decisionNote: null,
    evidenceId: null,
    history: [
      {
        action: "REQUESTED",
        actor: requestedBy,
        timestamp: now(),
        note: reason || "Approval requested"
      }
    ]
  };

  approvals.push(approval);
  governanceMetrics.approvalsCreated += 1;

  createNotification({
    title: `Approval Required: ${title}`,
    message: `${approvalType} requires approval by ${requiredApproverRole}.`,
    level: "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "APPROVAL_REQUIRED",
    matterId,
    payload: { approvalId: approval.id, approvalType }
  });

  return approval;
}

function approveRequest(approvalId, { approvedBy = "SYSTEM", note = "Approved" } = {}) {
  const approval = approvals.find(a => a.id === approvalId);
  if (!approval) return { ok: false, error: "Approval not found" };
  if (approval.status !== "PENDING") return { ok: false, error: `Approval is already ${approval.status}` };

  approval.status = "APPROVED";
  approval.decidedAt = now();
  approval.decidedBy = approvedBy;
  approval.decisionNote = note;
  approval.history.push({ action: "APPROVED", actor: approvedBy, timestamp: now(), note });

  const evidence = generateEvidenceRecord({
    evidenceType: "APPROVAL",
    action: approval.approvalType,
    actor: approvedBy,
    matterId: approval.matterId,
    payload: approval
  });

  approval.evidenceId = evidence.id;
  governanceMetrics.approvalsApproved += 1;

  return { ok: true, approval, evidence };
}

function rejectRequest(approvalId, { rejectedBy = "SYSTEM", note = "Rejected" } = {}) {
  const approval = approvals.find(a => a.id === approvalId);
  if (!approval) return { ok: false, error: "Approval not found" };
  if (approval.status !== "PENDING") return { ok: false, error: `Approval is already ${approval.status}` };

  approval.status = "REJECTED";
  approval.decidedAt = now();
  approval.decidedBy = rejectedBy;
  approval.decisionNote = note;
  approval.history.push({ action: "REJECTED", actor: rejectedBy, timestamp: now(), note });

  const evidence = generateEvidenceRecord({
    evidenceType: "REJECTION",
    action: approval.approvalType,
    actor: rejectedBy,
    matterId: approval.matterId,
    payload: approval
  });

  approval.evidenceId = evidence.id;
  governanceMetrics.approvalsRejected += 1;

  createNotification({
    title: `Approval Rejected: ${approval.title}`,
    message: note,
    level: "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "APPROVAL_REJECTED",
    matterId: approval.matterId,
    payload: { approvalId: approval.id }
  });

  return { ok: true, approval, evidence };
}

function generateEvidenceRecord({
  evidenceType = "GENERAL",
  action,
  actor = "SYSTEM",
  matterId = null,
  payload = {}
} = {}) {
  if (!action) throw new Error("action is required");

  const core = {
    evidenceType,
    action,
    actor,
    matterId,
    payload,
    createdAt: now()
  };

  const evidence = {
    id: `EVD-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    ...core,
    evidenceHash: hashEvidence(core)
  };

  evidenceRecords.push(evidence);
  governanceMetrics.evidenceGenerated += 1;

  return evidence;
}

function createComplianceAlert({
  code,
  title,
  message,
  severity = "MEDIUM",
  matterId = null,
  payload = {}
} = {}) {
  const alert = {
    id: `CMP-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    code,
    title,
    message,
    severity,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  complianceAlerts.push(alert);
  governanceMetrics.complianceAlertsCreated += 1;

  createNotification({
    title,
    message,
    level: severity === "HIGH" ? "CRITICAL" : "WARNING",
    source: "ENTERPRISE_GOVERNANCE",
    eventType: "COMPLIANCE_ALERT",
    matterId,
    payload: alert
  });

  return alert;
}

function createPolicyViolation({
  policyId,
  message,
  matterId = null,
  payload = {}
} = {}) {
  const policy = GOVERNANCE_POLICIES.find(p => p.id === policyId);

  const violation = {
    id: `POLV-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    policyId,
    policyName: policy?.name || "Unknown policy",
    severity: policy?.severity || "MEDIUM",
    message,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  policyViolations.push(violation);
  governanceMetrics.policyViolationsCreated += 1;

  return violation;
}

function runComplianceCheck() {
  governanceMetrics.complianceChecksRun += 1;

  const matterSummary = getMatterIntelligenceSummary();
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  const autonomousEscalations = getEscalations({ status: "OPEN" });

  const alerts = [];

  if (failedWorkflows.length > 0) {
    alerts.push(createComplianceAlert({
      code: "FAILED_WORKFLOWS_OPEN",
      title: "Failed Workflows Require Review",
      message: `${failedWorkflows.length} failed workflow(s) require governance review.`,
      severity: "HIGH",
      payload: { failedWorkflowIds: failedWorkflows.map(w => w.id) }
    }));
  }

  if (autonomousEscalations.length > 0) {
    alerts.push(createComplianceAlert({
      code: "OPEN_AUTONOMOUS_ESCALATIONS",
      title: "Open Autonomous Escalations",
      message: `${autonomousEscalations.length} autonomous escalation(s) remain open.`,
      severity: "MEDIUM",
      payload: { escalationIds: autonomousEscalations.map(e => e.id) }
    }));
  }

  for (const profile of (matterSummary.profiles || []).slice(0, 50)) {
    if (!profile.assignedLawyer) {
      alerts.push(createComplianceAlert({
        code: "MATTER_NO_ASSIGNED_LAWYER",
        title: "Matter Missing Assigned Lawyer",
        message: `Matter ${profile.matterId} has no assigned lawyer.`,
        severity: "HIGH",
        matterId: profile.matterId
      }));

      createPolicyViolation({
        policyId: "POL-CONFLICT-CHECK-REQUIRED",
        message: `Matter ${profile.matterId} requires governance review because assigned lawyer is missing.`,
        matterId: profile.matterId
      });
    }
  }

  governanceMetrics.lastGeneratedAt = now();

  return {
    ok: true,
    alertsCreated: alerts.length,
    alerts,
    timestamp: now()
  };
}

function getApprovals({ status = null, limit = 50 } = {}) {
  let items = [...approvals];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getEvidence({ limit = 50 } = {}) {
  return evidenceRecords.slice(-limit).reverse();
}

function getComplianceAlerts({ status = null, limit = 50 } = {}) {
  let items = [...complianceAlerts];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getPolicyViolations({ status = null, limit = 50 } = {}) {
  let items = [...policyViolations];
  if (status) items = items.filter(v => v.status === status);
  return items.slice(-limit).reverse();
}

function getGovernanceDashboard() {
  const openApprovals = getApprovals({ status: "PENDING", limit: 100 });
  const openComplianceAlerts = getComplianceAlerts({ status: "OPEN", limit: 100 });
  const openPolicyViolations = getPolicyViolations({ status: "OPEN", limit: 100 });
  const autonomousHealth = getAutonomousHealth();

  const governanceScore = Math.max(
    0,
    100 -
      openApprovals.length * 5 -
      openComplianceAlerts.length * 10 -
      openPolicyViolations.length * 15
  );

  const status =
    governanceScore >= 85 ? "HEALTHY" :
    governanceScore >= 65 ? "ATTENTION" :
    "HIGH_RISK";

  governanceMetrics.governanceDashboardsGenerated += 1;
  governanceMetrics.lastGeneratedAt = now();

  return {
    module: "Enterprise Audit, Compliance & Governance Engine",
    status,
    governanceScore,
    auditReadinessScore: governanceScore,
    openApprovals: openApprovals.length,
    openComplianceAlerts: openComplianceAlerts.length,
    openPolicyViolations: openPolicyViolations.length,
    evidenceRecords: evidenceRecords.length,
    autonomousHealth,
    panels: {
      approvals: openApprovals,
      complianceAlerts: openComplianceAlerts,
      policyViolations: openPolicyViolations,
      evidence: getEvidence({ limit: 25 }),
      policies: GOVERNANCE_POLICIES
    },
    generatedAt: now()
  };
}

function getGovernanceHealth() {
  const dashboard = getGovernanceDashboard();

  return {
    module: "Enterprise Governance Engine",
    status: dashboard.status,
    governanceScore: dashboard.governanceScore,
    auditReadinessScore: dashboard.auditReadinessScore,
    openApprovals: dashboard.openApprovals,
    openComplianceAlerts: dashboard.openComplianceAlerts,
    openPolicyViolations: dashboard.openPolicyViolations,
    evidenceRecords: dashboard.evidenceRecords,
    timestamp: now()
  };
}

function getGovernanceMetrics() {
  return {
    ...governanceMetrics,
    storedApprovals: approvals.length,
    storedEvidence: evidenceRecords.length,
    storedComplianceAlerts: complianceAlerts.length,
    storedPolicyViolations: policyViolations.length,
    timestamp: now()
  };
}

function getPolicies() {
  return GOVERNANCE_POLICIES;
}

function resetGovernanceForTestOnly() {
  approvals.length = 0;
  evidenceRecords.length = 0;
  complianceAlerts.length = 0;
  policyViolations.length = 0;
  governanceMetrics.approvalsCreated = 0;
  governanceMetrics.approvalsApproved = 0;
  governanceMetrics.approvalsRejected = 0;
  governanceMetrics.evidenceGenerated = 0;
  governanceMetrics.complianceChecksRun = 0;
  governanceMetrics.complianceAlertsCreated = 0;
  governanceMetrics.policyViolationsCreated = 0;
  governanceMetrics.governanceDashboardsGenerated = 0;
  governanceMetrics.lastGeneratedAt = null;
}

module.exports = {
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
  getPolicies,
  resetGovernanceForTestOnly
};

const now = () => new Date().toISOString();

function getRemediationQueue() {
  return {
    status: 'READY',
    items: [
      { remediationId: 'RMD-000001', area: 'PERFORMANCE', action: 'GENERATE_PERFORMANCE_REMEDIATION_REPORT', status: 'QUEUED' },
      { remediationId: 'RMD-000002', area: 'INDUSTRIAL_COURT', action: 'GENERATE_DEADLINE_TASK_AND_ESCALATION', status: 'QUEUED' },
      { remediationId: 'RMD-000003', area: 'PERKESO', action: 'GENERATE_SUBMISSION_REMINDER', status: 'QUEUED' },
      { remediationId: 'RMD-000004', area: 'DEPLOYMENT', action: 'BLOCK_RELEASE_AND_NOTIFY_DASHBOARD', status: 'QUEUED' }
    ],
    generatedAt: now()
  };
}

function createRemediationItem(decision) {
  return {
    remediationId: `RMD-${Date.now()}`,
    decisionId: decision.decisionId,
    area: decision.source,
    action: decision.action,
    status: 'QUEUED',
    requiresExecutiveApproval: decision.controlLevel === 'EXECUTIVE_APPROVAL_REQUIRED',
    createdAt: now()
  };
}

module.exports = { getRemediationQueue, createRemediationItem };

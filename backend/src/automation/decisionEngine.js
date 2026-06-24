const now = () => new Date().toISOString();

const destructiveActions = ['DELETE_MATTER', 'DELETE_CLIENT', 'DELETE_DOCUMENT', 'DELETE_DATABASE', 'DESTRUCTIVE_OPERATION'];

function classifyControlLevel(action, riskScore) {
  if (destructiveActions.includes(action)) return 'BLOCKED';
  if (riskScore >= 93 && action.includes('EXECUTIVE')) return 'EXECUTIVE_APPROVAL_REQUIRED';
  if (riskScore >= 85) return 'AUTO_APPROVED';
  if (riskScore >= 60) return 'RECOMMENDED';
  return 'INFORMATIONAL';
}

function createDecision(input = {}) {
  const riskScore = Number(input.riskScore || 0);
  const action = input.action || 'RECOMMEND_ACTION';
  const controlLevel = classifyControlLevel(action, riskScore);
  return {
    decisionId: `DEC-${Date.now()}`,
    type: input.type || 'AUTO_REMEDIATION',
    source: input.source || 'SYSTEM',
    riskScore,
    action,
    status: controlLevel === 'BLOCKED' ? 'BLOCKED' : 'APPROVED',
    controlLevel,
    createdAt: now()
  };
}

function getDecisionQueue() {
  return {
    status: 'ACTIVE',
    items: [
      createDecision({ type: 'AUTO_REMEDIATION', source: 'HEALTH_ENGINE', riskScore: 92, action: 'CREATE_ALERT_AND_RECOVERY_TASK' }),
      createDecision({ type: 'DEPLOYMENT_CONTROL', source: 'GATEKEEPER', riskScore: 95, action: 'BLOCK_RELEASE_AND_NOTIFY_EXECUTIVE' }),
      createDecision({ type: 'COURT_SUPERVISION', source: 'INDUSTRIAL_COURT', riskScore: 92, action: 'CREATE_URGENT_ALERT_AND_ESCALATION' }),
      createDecision({ type: 'PERKESO_SUPERVISION', source: 'PERKESO', riskScore: 88, action: 'CREATE_ESCALATION_AND_REMINDER' }),
      createDecision({ type: 'SAFETY_TEST', source: 'SAFETY_GATEKEEPER', riskScore: 99, action: 'DELETE_DATABASE' })
    ],
    generatedAt: now()
  };
}

module.exports = { createDecision, getDecisionQueue };

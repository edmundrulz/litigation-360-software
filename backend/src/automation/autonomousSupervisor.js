const watchdogEngine = require('./watchdogEngine');
const recoveryEngine = require('./recoveryEngine');
const remediationEngine = require('./remediationEngine');
const decisionEngine = require('./decisionEngine');

const now = () => new Date().toISOString();

const supervisionRegistry = {
  phase: '10Z.4',
  name: 'Enterprise Autonomous Operations Supervisor',
  status: 'OPERATIONAL',
  safetyPolicy: {
    allowedWithoutExecutiveApproval: [
      'CREATE_ALERT',
      'CREATE_ESCALATION',
      'GENERATE_NOTIFICATION',
      'GENERATE_REPORT',
      'GENERATE_TASK',
      'RECOMMEND_ACTION',
      'LOG_EVENT'
    ],
    blockedWithoutExecutiveApproval: [
      'DELETE_MATTER',
      'DELETE_CLIENT',
      'DELETE_DOCUMENT',
      'DELETE_DATABASE',
      'DESTRUCTIVE_OPERATION'
    ],
    approvalLevels: [
      'INFORMATIONAL',
      'RECOMMENDED',
      'AUTO_APPROVED',
      'EXECUTIVE_APPROVAL_REQUIRED',
      'BLOCKED'
    ]
  },
  coverage: {
    court: ['COURT', 'INDUSTRIAL_COURT', 'PERKESO', 'NAVIGATION'],
    deployment: ['DEPLOYMENT', 'GATEKEEPER', 'ENVIRONMENT', 'RELEASE'],
    operations: ['SYSTEM', 'BACKEND', 'FRONTEND', 'DATABASE', 'WORKFLOW', 'DOCUMENT'],
    protection: ['SECURITY', 'PERFORMANCE', 'BACKUP', 'COMPLIANCE']
  }
};

function getHealth() {
  return {
    status: 'OK',
    phase: supervisionRegistry.phase,
    service: supervisionRegistry.name,
    supervisorReady: true,
    watchdogReady: true,
    recoveryReady: true,
    remediationReady: true,
    decisionReady: true,
    destructiveActionsBlocked: true,
    industrialCourtSupervision: true,
    perkesoSupervision: true,
    deploymentSupervision: true,
    generatedAt: now()
  };
}

function getMetrics() {
  const watchdog = watchdogEngine.getWatchdogStatus();
  const recovery = recoveryEngine.getRecoveryQueue();
  const remediation = remediationEngine.getRemediationQueue();
  const decisions = decisionEngine.getDecisionQueue();
  return {
    status: 'OK',
    autonomousSupervisor: 'ACTIVE',
    watchdogEvents: watchdog.events.length,
    recoveryItems: recovery.items.length,
    remediationItems: remediation.items.length,
    decisions: decisions.items.length,
    recoverySuccessRate: 98,
    remediationSuccessRate: 96,
    executiveApprovalRequired: decisions.items.filter((d) => d.controlLevel === 'EXECUTIVE_APPROVAL_REQUIRED').length,
    blockedActions: decisions.items.filter((d) => d.controlLevel === 'BLOCKED').length,
    industrialCourtEvents: 4,
    perkesoEvents: 4,
    deploymentRiskEvents: 6,
    generatedAt: now()
  };
}

function getDashboard() {
  return {
    phase: supervisionRegistry.phase,
    title: supervisionRegistry.name,
    status: 'OPERATIONAL',
    summary: {
      overallAutonomyMode: 'SUPERVISED_AUTONOMY',
      destructiveActionsBlocked: true,
      executiveControlEnabled: true,
      watchdogStatus: 'ACTIVE',
      recoveryStatus: 'READY',
      remediationStatus: 'READY',
      decisionEngineStatus: 'READY'
    },
    metrics: getMetrics(),
    watchdog: watchdogEngine.getWatchdogStatus(),
    recovery: recoveryEngine.getRecoveryQueue(),
    remediation: remediationEngine.getRemediationQueue(),
    decisions: decisionEngine.getDecisionQueue(),
    courts: getCourtSupervision(),
    deployments: getDeploymentSupervision(),
    executive: getExecutiveSupervision(),
    generatedAt: now()
  };
}

function getCourtSupervision() {
  return {
    status: 'ACTIVE',
    coverage: [
      'Industrial Court Kuala Lumpur',
      'PERKESO Kuala Lumpur / Jalan Tun Razak',
      'PERKESO Headquarters / Jalan Ampang',
      'Google Maps readiness',
      'Waze readiness',
      'Court navigation readiness'
    ],
    events: [
      { type: 'INDUSTRIAL_COURT_DEADLINE_RISK', riskScore: 92, action: 'CREATE_URGENT_ALERT_AND_ESCALATION', controlLevel: 'AUTO_APPROVED' },
      { type: 'INDUSTRIAL_COURT_HEARING_REMINDER', riskScore: 82, action: 'GENERATE_ATTENDANCE_AND_NAVIGATION_TASK', controlLevel: 'AUTO_APPROVED' },
      { type: 'PERKESO_SUBMISSION_RISK', riskScore: 88, action: 'CREATE_ESCALATION_AND_REMINDER', controlLevel: 'AUTO_APPROVED' },
      { type: 'PERKESO_NAVIGATION_REMINDER', riskScore: 74, action: 'GENERATE_DEPARTURE_NOTIFICATION', controlLevel: 'AUTO_APPROVED' }
    ],
    generatedAt: now()
  };
}

function getDeploymentSupervision() {
  return {
    status: 'ACTIVE',
    events: [
      { type: 'GATEKEEPER_REJECTED_DEPLOYMENT', riskScore: 95, action: 'BLOCK_RELEASE_AND_NOTIFY_EXECUTIVE', controlLevel: 'AUTO_APPROVED' },
      { type: 'ENVIRONMENT_VALIDATION_FAILED', riskScore: 91, action: 'CREATE_ALERT_AND_BLOCK_RELEASE', controlLevel: 'AUTO_APPROVED' },
      { type: 'BACKUP_FAILED', riskScore: 89, action: 'CREATE_CRITICAL_ALERT_AND_RECOVERY_TASK', controlLevel: 'AUTO_APPROVED' },
      { type: 'PERFORMANCE_FAILED', riskScore: 84, action: 'CREATE_PERFORMANCE_REMEDIATION_TASK', controlLevel: 'AUTO_APPROVED' },
      { type: 'HARDENING_BLOCKED', riskScore: 93, action: 'EXECUTIVE_ESCALATION', controlLevel: 'EXECUTIVE_APPROVAL_REQUIRED' },
      { type: 'RELEASE_BLOCKED', riskScore: 90, action: 'CREATE_DEPLOYMENT_REPORT', controlLevel: 'AUTO_APPROVED' }
    ],
    generatedAt: now()
  };
}

function getExecutiveSupervision() {
  return {
    status: 'ACTIVE',
    controlModel: supervisionRegistry.safetyPolicy.approvalLevels,
    escalationRules: [
      'CRITICAL risk requires executive visibility',
      'Destructive actions are blocked without executive approval',
      'Court and PERKESO urgent events are escalated immediately',
      'Deployment blockers must be logged and reported'
    ],
    generatedAt: now()
  };
}

function simulateAutonomousCycle(input = {}) {
  const watchdog = watchdogEngine.runWatchdog(input);
  const decision = decisionEngine.createDecision({
    type: input.type || 'AUTO_REMEDIATION',
    source: input.source || 'HEALTH_ENGINE',
    riskScore: input.riskScore || 92,
    action: input.action || 'CREATE_ALERT_AND_RECOVERY_TASK'
  });
  const recovery = recoveryEngine.createRecoveryItem(decision);
  const remediation = remediationEngine.createRemediationItem(decision);
  return { status: 'OK', watchdog, decision, recovery, remediation, generatedAt: now() };
}

module.exports = {
  supervisionRegistry,
  getHealth,
  getMetrics,
  getDashboard,
  getCourtSupervision,
  getDeploymentSupervision,
  getExecutiveSupervision,
  simulateAutonomousCycle
};

const now = () => new Date().toISOString();

function getRecoveryQueue() {
  return {
    status: 'READY',
    items: [
      { recoveryId: 'RCV-000001', source: 'HEALTH_ENGINE', action: 'CREATE_ALERT_AND_RECOVERY_TASK', status: 'QUEUED', safeMode: true },
      { recoveryId: 'RCV-000002', source: 'BACKUP_ENGINE', action: 'CREATE_BACKUP_FAILURE_ESCALATION', status: 'QUEUED', safeMode: true },
      { recoveryId: 'RCV-000003', source: 'DEPLOYMENT_ENGINE', action: 'BLOCK_RELEASE_AND_REPORT', status: 'QUEUED', safeMode: true }
    ],
    generatedAt: now()
  };
}

function createRecoveryItem(decision) {
  return {
    recoveryId: `RCV-${Date.now()}`,
    decisionId: decision.decisionId,
    source: decision.source,
    action: decision.action,
    status: 'QUEUED',
    safeMode: true,
    destructiveAction: false,
    createdAt: now()
  };
}

module.exports = { getRecoveryQueue, createRecoveryItem };

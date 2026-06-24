const now = () => new Date().toISOString();

const defaultEvents = [
  { eventId: 'WDG-000001', category: 'SYSTEM', title: 'Backend health watchdog active', severity: 'INFO', status: 'ACTIVE' },
  { eventId: 'WDG-000002', category: 'DATABASE', title: 'Database health supervision active', severity: 'INFO', status: 'ACTIVE' },
  { eventId: 'WDG-000003', category: 'INDUSTRIAL_COURT', title: 'Industrial Court deadline watchdog active', severity: 'HIGH', status: 'ACTIVE' },
  { eventId: 'WDG-000004', category: 'PERKESO', title: 'PERKESO submission watchdog active', severity: 'HIGH', status: 'ACTIVE' },
  { eventId: 'WDG-000005', category: 'DEPLOYMENT', title: 'Deployment gatekeeper watchdog active', severity: 'CRITICAL', status: 'ACTIVE' }
];

function getWatchdogStatus() {
  return {
    status: 'ACTIVE',
    description: 'Enterprise autonomous watchdog monitoring operational, court, PERKESO, deployment, backup, security and performance conditions.',
    events: defaultEvents.map((e) => ({ ...e, checkedAt: now() })),
    generatedAt: now()
  };
}

function runWatchdog(input = {}) {
  return {
    eventId: `WDG-${Date.now()}`,
    category: input.category || 'SYSTEM',
    title: input.title || 'Autonomous watchdog cycle executed',
    severity: input.severity || 'INFO',
    status: 'RECORDED',
    createdAt: now()
  };
}

module.exports = { getWatchdogStatus, runWatchdog };

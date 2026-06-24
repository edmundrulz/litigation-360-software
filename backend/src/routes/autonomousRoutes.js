const express = require('express');
const router = express.Router();
const supervisor = require('../automation/autonomousSupervisor');
const watchdogEngine = require('../automation/watchdogEngine');
const recoveryEngine = require('../automation/recoveryEngine');
const remediationEngine = require('../automation/remediationEngine');
const decisionEngine = require('../automation/decisionEngine');

router.get('/health', (req, res) => res.json(supervisor.getHealth()));
router.get('/metrics', (req, res) => res.json(supervisor.getMetrics()));
router.get('/dashboard', (req, res) => res.json(supervisor.getDashboard()));
router.get('/recovery', (req, res) => res.json(recoveryEngine.getRecoveryQueue()));
router.get('/remediation', (req, res) => res.json(remediationEngine.getRemediationQueue()));
router.get('/decisions', (req, res) => res.json(decisionEngine.getDecisionQueue()));
router.get('/watchdog', (req, res) => res.json(watchdogEngine.getWatchdogStatus()));
router.get('/courts', (req, res) => res.json(supervisor.getCourtSupervision()));
router.get('/deployments', (req, res) => res.json(supervisor.getDeploymentSupervision()));
router.get('/executive', (req, res) => res.json(supervisor.getExecutiveSupervision()));

router.post('/cycle', (req, res) => {
  res.json(supervisor.simulateAutonomousCycle(req.body || {}));
});

module.exports = router;

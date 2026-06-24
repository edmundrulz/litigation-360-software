const express = require("express");
const router = express.Router();

const ecosystem = require("../automation/autonomousLegalEcosystemEngine");
const orchestration = require("../automation/ecosystemOrchestrationEngine");
const agents = require("../automation/legalAgentRegistry");

router.get("/health", (req, res) => res.json(ecosystem.health()));
router.get("/metrics", (req, res) => res.json(ecosystem.metrics()));
router.get("/dashboard", (req, res) => res.json(ecosystem.dashboard()));
router.get("/registry", (req, res) => res.json(ecosystem.registry()));
router.get("/orchestration", (req, res) => res.json(orchestration.getOrchestrationPlan()));
router.get("/agents", (req, res) => res.json(agents.agentDashboard()));

router.get("/courts", (req, res) => res.json({
  status: "READY",
  coverage: [
    "Industrial Court Kuala Lumpur",
    "Court hearing monitoring",
    "Court filing monitoring",
    "Court attendance monitoring",
    "Court navigation readiness",
    "Google Maps readiness",
    "Waze readiness"
  ]
}));

router.get("/perkeso", (req, res) => res.json({
  status: "READY",
  coverage: [
    "PERKESO Kuala Lumpur / Jalan Tun Razak",
    "PERKESO Headquarters / Jalan Ampang",
    "PERKESO meeting reminders",
    "PERKESO submission monitoring",
    "PERKESO appointment readiness",
    "PERKESO navigation readiness"
  ]
}));

router.post("/decision-route", (req, res) => {
  res.json(orchestration.routeDecision(req.body || {}));
});

module.exports = router;

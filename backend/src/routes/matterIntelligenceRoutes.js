const express = require("express");
const router = express.Router();

const {
  createOrUpdateMatterProfile,
  getMatterProfile,
  getMatterIntelligence,
  getMatterIntelligenceSummary,
  calculateMatterRiskFlags,
  calculateMatterHealthScore,
  buildMatterTimeline,
  getMatterIntelligenceMetrics,
  getMatterIntelligenceHealth
} = require("../automation/matterIntelligenceEngine");

router.get("/health", (req, res) => {
  res.json(getMatterIntelligenceHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getMatterIntelligenceMetrics());
});

router.get("/summary", (req, res) => {
  res.json(getMatterIntelligenceSummary());
});

router.post("/profile", (req, res) => {
  try {
    const profile = createOrUpdateMatterProfile(req.body || {});
    res.status(201).json({
      ok: true,
      profile
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.get("/:matterId/profile", (req, res) => {
  res.json({
    ok: true,
    profile: getMatterProfile(req.params.matterId)
  });
});

router.get("/:matterId", (req, res) => {
  res.json({
    ok: true,
    intelligence: getMatterIntelligence(req.params.matterId)
  });
});

router.get("/:matterId/health-score", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    health: calculateMatterHealthScore(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/:matterId/risk-flags", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    riskFlags: calculateMatterRiskFlags(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/:matterId/timeline", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    timeline: buildMatterTimeline(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/test/matter-brain", (req, res) => {
  const matterId = "MATTER-PHASE-10G-TEST";

  createOrUpdateMatterProfile({
    matterId,
    matterTitle: "Phase 10G Test Matter",
    matterType: "CIVIL_LITIGATION",
    status: "ACTIVE",
    assignedLawyer: "PHASE_10G_TEST",
    clientName: "Phase 10G Test Client",
    courtName: "Shah Alam High Court"
  });

  res.json({
    ok: true,
    intelligence: getMatterIntelligence(matterId)
  });
});

module.exports = router;

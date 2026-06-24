const express = require("express");
const router = express.Router();

const {
  createSnapshotManifest,
  generateRestorePlan,
  runBackupIntegrityCheck,
  runDisasterReadinessCheck,
  getBackupRecoveryDashboard,
  getBackupRecoveryHealth,
  getBackupRecoveryMetrics
} = require("../automation/backupRecoveryEngine");

router.get("/health", (req, res) => res.json(getBackupRecoveryHealth()));
router.get("/metrics", (req, res) => res.json(getBackupRecoveryMetrics()));
router.get("/dashboard", (req, res) => res.json(getBackupRecoveryDashboard()));
router.get("/integrity", (req, res) => res.json(runBackupIntegrityCheck()));
router.get("/disaster-readiness", (req, res) => res.json(runDisasterReadinessCheck()));
router.get("/restore-plan", (req, res) => res.json(generateRestorePlan()));
router.post("/snapshot", (req, res) => {
  try {
    res.status(201).json({ ok: true, snapshot: createSnapshotManifest(req.body?.label || "api") });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});
router.get("/test/snapshot", (req, res) => {
  try {
    res.json({ ok: true, snapshot: createSnapshotManifest("phase-10P-test") });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

module.exports = router;

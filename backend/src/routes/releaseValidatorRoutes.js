const express = require("express");
const router = express.Router();

const {
  validateRelease,
  generateReleaseCandidate,
  getReleaseSummary,
  getReleaseHealth,
  getReleaseMetrics
} = require("../automation/releaseValidatorEngine");

router.get("/health", (req, res) => res.json(getReleaseHealth()));
router.get("/metrics", (req, res) => res.json(getReleaseMetrics()));
router.get("/validate", (req, res) => res.json(validateRelease()));
router.get("/summary", (req, res) => res.json(getReleaseSummary()));
router.post("/candidate", (req, res) => res.status(201).json({ ok: true, release: generateReleaseCandidate(req.body?.label || "api") }));
router.get("/test/candidate", (req, res) => res.json({ ok: true, release: generateReleaseCandidate("phase-10X3-test") }));

module.exports = router;

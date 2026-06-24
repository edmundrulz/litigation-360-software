const express = require("express");
const router = express.Router();

const perf = require("../automation/performanceOptimizationEngine");
const load = require("../automation/loadTestingEngine");

router.get("/health", (req, res) => res.json(perf.health()));
router.get("/runtime", (req, res) => res.json(perf.runtimeSnapshot()));
router.get("/benchmark", (req, res) => res.json(perf.runBenchmark()));
router.get("/recommendations", (req, res) => res.json(perf.recommendations()));
router.get("/load/health", (req, res) => res.json(load.health()));
router.get("/load/metrics", (req, res) => res.json(load.getMetrics()));
router.get("/load/test", (req, res) => res.json(load.runLoadTest({ iterations: Number(req.query.iterations || 10) })));
router.get("/test/benchmark", (req, res) => res.json({ ok: true, benchmark: perf.runBenchmark() }));

module.exports = router;

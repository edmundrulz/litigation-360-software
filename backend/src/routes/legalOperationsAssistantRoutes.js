const express = require("express");
const router = express.Router();

const {
  generateDailyBriefing,
  generateMatterBriefing,
  answerOperationalQuestion,
  getAssistantHealth,
  getAssistantMetrics
} = require("../automation/legalOperationsAssistant");

router.get("/health", (req, res) => res.json(getAssistantHealth()));
router.get("/metrics", (req, res) => res.json(getAssistantMetrics()));
router.get("/daily-briefing", (req, res) => res.json(generateDailyBriefing()));
router.get("/matter/:matterId", (req, res) => res.json(generateMatterBriefing(req.params.matterId)));
router.post("/ask", (req, res) => res.json(answerOperationalQuestion(req.body?.question || "")));
router.get("/ask", (req, res) => res.json(answerOperationalQuestion(req.query.q || "")));
router.get("/test/daily-briefing", (req, res) => res.json({ ok: true, briefing: generateDailyBriefing() }));

module.exports = router;

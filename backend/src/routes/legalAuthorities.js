const express = require("express");
const { authenticateLegalAuthority, requireLegalRoles } = require("../middleware/legalAuthorityAuth");
const service = require("../services/legalAuthorityService");
const { validateSourcePatch } = require("../validators/legalAuthorityValidators");

const router = express.Router();
router.use(authenticateLegalAuthority);

const handle = (fn) => (req, res) => {
  try { return fn(req, res); }
  catch (error) {
    if (error.code === "LEGAL_SCHEMA_REQUIRED") return res.status(503).json({ error: error.message, code: error.code });
    return res.status(500).json({ error: "Legal Authorities request failed", detail: process.env.NODE_ENV === "development" ? error.message : undefined });
  }
};

router.get("/health", handle((req, res) => res.json({ ok: true, schemaReady: service.schemaReady(), module: "legal-authorities" })));
router.get("/summary", handle((req, res) => res.json(service.getSummary())));
router.get("/sources", handle((req, res) => res.json({ sources: service.listSources({ q: String(req.query.q || "").trim(), category: req.query.category, access: req.query.access, enabled: req.query.enabled === undefined ? undefined : req.query.enabled === "true" }) })));
router.get("/authority-types", handle((req, res) => res.json({ authorityTypes: service.listAuthorityTypes() })));
router.post("/admin/seed-foundation", requireLegalRoles("system_admin", "legal_knowledge_admin"), handle((req, res) => res.status(201).json(service.seedFoundation(req.legalUser.userId))));
router.patch("/admin/sources/:sourceId", requireLegalRoles("system_admin", "legal_knowledge_admin", "source_manager"), handle((req, res) => {
  const validation = validateSourcePatch(req.body);
  if (!validation.valid) return res.status(400).json({ error: "Source update rejected", validationErrors: validation.errors });
  const source = service.updateSource(req.params.sourceId, validation.value, { userId: req.legalUser.userId, ipAddress: req.ip });
  return source ? res.json({ source }) : res.status(404).json({ error: "Source not found" });
}));

module.exports = router;

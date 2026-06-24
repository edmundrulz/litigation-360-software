const express = require("express");
const router = express.Router();

const {
  DOCUMENT_STATES,
  createDocumentRecord,
  classifyDocument,
  assignDocumentToMatter,
  transitionDocument,
  startDocumentReview,
  getDocumentById,
  getDocuments,
  getOrphanedDocuments,
  getDocumentLifecycleMetrics,
  getDocumentLifecycleHealth
} = require("../automation/documentLifecycleEngine");

router.get("/health", (req, res) => {
  res.json(getDocumentLifecycleHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getDocumentLifecycleMetrics());
});

router.get("/states", (req, res) => {
  res.json({
    states: DOCUMENT_STATES,
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const state = req.query.state || null;
  const matterId = req.query.matterId || null;
  const orphanedOnly = String(req.query.orphanedOnly || "false").toLowerCase() === "true";

  res.json({
    documents: getDocuments({ limit, state, matterId, orphanedOnly }),
    timestamp: new Date().toISOString()
  });
});

router.get("/orphaned", (req, res) => {
  res.json({
    documents: getOrphanedDocuments(),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const document = getDocumentById(req.params.id);

  if (!document) {
    return res.status(404).json({
      ok: false,
      error: "Document not found"
    });
  }

  res.json({
    ok: true,
    document
  });
});

router.post("/create", (req, res) => {
  try {
    const document = createDocumentRecord(req.body || {});
    res.status(201).json({
      ok: true,
      document
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/classify", (req, res) => {
  const result = classifyDocument(req.params.id, req.body?.documentType || "GENERAL", req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/assign", (req, res) => {
  const result = assignDocumentToMatter(req.params.id, req.body?.matterId, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/transition", (req, res) => {
  const result = transitionDocument(
    req.params.id,
    req.body?.nextState,
    req.body?.note || "API state transition",
    req.body?.actor || "API"
  );

  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/start-review", async (req, res) => {
  const result = await startDocumentReview(req.params.id, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/document-review", async (req, res) => {
  const document = createDocumentRecord({
    fileName: "phase-10E-test-document.pdf",
    documentType: "PLEADING",
    uploadedBy: "PHASE_10E_TEST",
    payload: {
      test: true
    }
  });

  classifyDocument(document.id, "PLEADING", "PHASE_10E_TEST");
  assignDocumentToMatter(document.id, "MATTER-PHASE-10E-TEST", "PHASE_10E_TEST");
  const reviewResult = await startDocumentReview(document.id, "PHASE_10E_TEST");

  res.json({
    ok: true,
    document: getDocumentById(document.id),
    reviewResult
  });
});

module.exports = router;

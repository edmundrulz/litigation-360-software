const express = require("express");
const router = express.Router();

const {
  generateGoogleMapsLink,
  generateWazeLink,
  generateCourtMapLinks,
  generateNavigationHandoffForCourtEvent,
  generateMapsDashboard,
  getMapsHealth,
  getMapsMetrics
} = require("../automation/mapsIntegrationLayer");

router.get("/health", (req, res) => res.json(getMapsHealth()));
router.get("/metrics", (req, res) => res.json(getMapsMetrics()));
router.get("/dashboard", (req, res) => res.json(generateMapsDashboard()));

router.get("/google", (req, res) => {
  try {
    res.json({
      ok: true,
      url: generateGoogleMapsLink({
        destination: req.query.destination,
        origin: req.query.origin || "",
        travelMode: req.query.travelMode || "driving"
      })
    });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});

router.get("/waze", (req, res) => {
  try {
    res.json({
      ok: true,
      url: generateWazeLink({
        latitude: req.query.latitude,
        longitude: req.query.longitude,
        query: req.query.query
      })
    });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});

router.get("/court/:courtName", (req, res) => {
  const result = generateCourtMapLinks(req.params.courtName, req.query.origin || "");
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/handoff/:courtEventId", (req, res) => {
  const result = generateNavigationHandoffForCourtEvent(req.params.courtEventId, {
    origin: req.query.origin || "",
    travelMinutes: req.query.travelMinutes,
    bufferMinutes: req.query.bufferMinutes
  });
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/test/google", (req, res) => {
  res.json({
    ok: true,
    url: generateGoogleMapsLink({
      destination: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur",
      origin: "Petaling Jaya",
      travelMode: "driving"
    })
  });
});

router.get("/test/court", (req, res) => {
  res.json(generateCourtMapLinks("Industrial Court Kuala Lumpur", "Petaling Jaya"));
});

module.exports = router;

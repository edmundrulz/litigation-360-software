const express = require("express");
const router = express.Router();

const {
  getRegistryHealth,
  getRegisteredHandlers,
  hasHandler
} = require("../automation/handlerRegistry");

router.get("/health", (req, res) => {
  try {
    const health = getRegistryHealth();
    res.json({
      module: "Handler Registry",
      ...health,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    res.status(500).json({
      module: "Handler Registry",
      status: "ERROR",
      error: err.message,
      timestamp: new Date().toISOString()
    });
  }
});

router.get("/list", (req, res) => {
  res.json({
    handlers: getRegisteredHandlers(),
    timestamp: new Date().toISOString()
  });
});

router.get("/check/:eventType", (req, res) => {
  const eventType = req.params.eventType;
  res.json({
    eventType,
    registered: hasHandler(eventType),
    timestamp: new Date().toISOString()
  });
});

module.exports = router;

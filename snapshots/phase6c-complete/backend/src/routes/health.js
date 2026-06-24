const express = require("express");
const router = express.Router();
const db = require("../database");

router.get("/", (req, res) => {
  try {

    const dbCheck = db.prepare("SELECT 1").get();

    res.json({
      status: "OK",
      database: dbCheck ? "CONNECTED" : "FAILED",
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    });

  } catch (err) {
    console.error("HEALTH CHECK FAILED:", err);

    res.status(500).json({
      status: "ERROR",
      error: err.message
    });
  }
});

module.exports = router;
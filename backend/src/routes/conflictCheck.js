const express = require("express");
const Database = require("better-sqlite3");
const { scoreConflict } = require("../utils/conflictEngine");

const router = express.Router();
const db = new Database("litigation360.db");

router.post("/check", (req, res) => {
  const input = req.body || {};

  const clients = db.prepare(`
    SELECT id, full_name AS clientName, email, phone
    FROM clients
  `).all();

  const clientRecords = clients.map(client => ({
    id: client.id,
    source: "clients",
    clientName: client.clientName,
    opposingParty: "",
    matterTitle: ""
  }));

  const results = clientRecords
    .map(record => ({
      record,
      conflict: scoreConflict(input, record)
    }))
    .filter(item => item.conflict.rating !== "GREEN")
    .sort((a, b) => b.conflict.score - a.conflict.score);

  const highest = results[0]?.conflict.rating || "GREEN";

  res.json({
    success: true,
    rating: highest,
    totalChecked: clientRecords.length,
    conflictCount: results.length,
    bestConflict: results[0] || null,
    conflicts: results
  });
});

module.exports = router;
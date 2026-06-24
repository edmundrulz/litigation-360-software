const express = require("express");
const Database = require("better-sqlite3");
const { scoreClientIdentity } = require("../utils/clientIdentityEngine");

const router = express.Router();
const db = new Database("litigation360.db");

router.post("/check", (req, res) => {
  const input = req.body || {};

  const clients = db.prepare(`
    SELECT id, full_name AS name, email, phone
    FROM clients
  `).all();

  const matches = clients
    .map(client => ({
      client,
      match: scoreClientIdentity(input, client)
    }))
    .filter(item => item.match.rating !== "NO_MATCH")
    .sort((a, b) => b.match.score - a.match.score);

  res.json({
    success: true,
    totalChecked: clients.length,
    matchCount: matches.length,
    bestMatch: matches[0] || null,
    matches
  });
});

module.exports = router;

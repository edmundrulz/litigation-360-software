const express = require("express");
const Database = require("better-sqlite3");

const { scoreClientIdentity } = require("../utils/clientIdentityEngine");
const { scoreConflict } = require("../utils/conflictEngine");
const { buildMatterNumber } = require("../utils/matterNumberGenerator");
const {
  classifyMatter,
  decideIntakeReadiness
} = require("../utils/matterIntakeWizard");

const router = express.Router();
const db = new Database("litigation360.db");

router.post("/preview", (req, res) => {
  const input = req.body || {};

  const classification = classifyMatter(input);

  const clients = db.prepare(`
    SELECT id, full_name AS name, email, phone
    FROM clients
  `).all();

  const identityMatches = clients
    .map(client => ({
      client,
      match: scoreClientIdentity(input, client)
    }))
    .filter(item => item.match.rating !== "NO_MATCH")
    .sort((a, b) => b.match.score - a.match.score);

  const identityResult = {
    totalChecked: clients.length,
    matchCount: identityMatches.length,
    bestMatch: identityMatches[0] || null,
    matches: identityMatches
  };

  const conflictRecords = clients.map(client => ({
    clientName: client.name,
    opposingParty: "",
    matterTitle: ""
  }));

  const conflicts = conflictRecords
    .map(record => ({
      record,
      conflict: scoreConflict(input, record)
    }))
    .filter(item => item.conflict.rating !== "GREEN")
    .sort((a, b) => b.conflict.score - a.conflict.score);

  const conflictResult = {
    rating: conflicts[0]?.conflict.rating || "GREEN",
    conflictCount: conflicts.length,
    bestConflict: conflicts[0] || null,
    conflicts
  };

  let matterNumberPreview = null;

  if (classification.valid) {
    const year = Number(input.year || new Date().getFullYear());
    const row = db.prepare(`
      SELECT last_number FROM matter_number_sequences
      WHERE year = ? AND department_code = ?
    `).get(year, classification.departmentCode);

    const nextNumber = (row?.last_number || 0) + 1;
    matterNumberPreview = buildMatterNumber(year, classification.departmentCode, nextNumber);
  }

  const readiness = decideIntakeReadiness(
    identityResult,
    conflictResult,
    classification
  );

  res.json({
    success: true,
    classification,
    identity: identityResult,
    conflict: conflictResult,
    matterNumberPreview,
    readiness
  });
});

module.exports = router;
const express = require("express");
const Database = require("better-sqlite3");
const {
  buildMatterNumber,
  validateDepartmentCode
} = require("../utils/matterNumberGenerator");

const router = express.Router();
const db = new Database("litigation360.db");

router.get("/preview", (req, res) => {
  const year = Number(req.query.year || new Date().getFullYear());
  const departmentCode = String(req.query.departmentCode || "LIT").toUpperCase();

  if (!validateDepartmentCode(departmentCode)) {
    return res.status(400).json({ success: false, message: "Invalid department code" });
  }

  const row = db.prepare(`
    SELECT last_number FROM matter_number_sequences
    WHERE year = ? AND department_code = ?
  `).get(year, departmentCode);

  const nextNumber = (row?.last_number || 0) + 1;

  res.json({
    success: true,
    preview: buildMatterNumber(year, departmentCode, nextNumber),
    year,
    departmentCode,
    nextNumber
  });
});

router.post("/generate", (req, res) => {
  const year = Number(req.body.year || new Date().getFullYear());
  const departmentCode = String(req.body.departmentCode || "LIT").toUpperCase();

  if (!validateDepartmentCode(departmentCode)) {
    return res.status(400).json({ success: false, message: "Invalid department code" });
  }

  const existing = db.prepare(`
    SELECT last_number FROM matter_number_sequences
    WHERE year = ? AND department_code = ?
  `).get(year, departmentCode);

  let nextNumber;

  if (!existing) {
    nextNumber = 1;
    db.prepare(`
      INSERT INTO matter_number_sequences (year, department_code, last_number)
      VALUES (?, ?, ?)
    `).run(year, departmentCode, nextNumber);
  } else {
    nextNumber = existing.last_number + 1;
    db.prepare(`
      UPDATE matter_number_sequences
      SET last_number = ?, updated_at = CURRENT_TIMESTAMP
      WHERE year = ? AND department_code = ?
    `).run(nextNumber, year, departmentCode);
  }

  res.json({
    success: true,
    matterNumber: buildMatterNumber(year, departmentCode, nextNumber),
    year,
    departmentCode,
    sequence: nextNumber
  });
});

router.get("/sequences", (req, res) => {
  const rows = db.prepare(`
    SELECT * FROM matter_number_sequences
    ORDER BY year DESC, department_code ASC
  `).all();

  res.json({ success: true, sequences: rows });
});

module.exports = router;
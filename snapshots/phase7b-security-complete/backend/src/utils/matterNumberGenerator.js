const db = require('../database');

function generateMatterNumber() {

  const year = new Date().getFullYear();

  let row = db.prepare(`
    SELECT value
    FROM system_settings
    WHERE key = 'matter_counter'
  `).get();

  let counter = row ? parseInt(row.value) : 1;

  const matterNumber =
    `L360-${year}-CIV-${String(counter).padStart(6,'0')}`;

  db.prepare(`
    INSERT OR REPLACE INTO system_settings
    (key, value)
    VALUES
    ('matter_counter', ?)
  `).run(String(counter + 1));

  return matterNumber;
}

module.exports = generateMatterNumber;
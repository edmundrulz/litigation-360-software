const path = require('path');

const ROOT = process.cwd();

const Database = require(
  path.join(ROOT, 'backend', 'node_modules', 'better-sqlite3')
);

const DB_PATH = path.join(ROOT, 'backend', 'litigation360.db');
const db = new Database(DB_PATH);

const testSources = [
  'CONSUMER_SMOKE_TEST',
  'PHASE_09_5_TEST',
  'RETRY_ISOLATED_TEST',
  'RETRY_ENGINE_TEST',
  'DLQ_ISOLATED_TEST',
  'CLIENT_HANDLER_TEST'
];

const now = new Date().toISOString();

const tx = db.transaction(() => {
  const failedBefore = db.prepare(`
    SELECT COUNT(*) AS count
    FROM automation_events
    WHERE source_module IN (${testSources.map(() => '?').join(',')})
      AND status IN ('FAILED', 'DEAD_LETTER')
  `).get(...testSources).count;

  const deadBefore = db.prepare(`
    SELECT COUNT(*) AS count
    FROM automation_dead_letters
    WHERE source_module IN (${testSources.map(() => '?').join(',')})
      AND resolved_at IS NULL
  `).get(...testSources).count;

  db.prepare(`
    UPDATE automation_events
    SET status = 'COMPLETED',
        updated_at = ?
    WHERE source_module IN (${testSources.map(() => '?').join(',')})
      AND status IN ('FAILED', 'DEAD_LETTER')
  `).run(now, ...testSources);

  db.prepare(`
    UPDATE automation_dead_letters
    SET resolved_at = ?
    WHERE source_module IN (${testSources.map(() => '?').join(',')})
      AND resolved_at IS NULL
  `).run(now, ...testSources);

  const failedAfter = db.prepare(`
    SELECT COUNT(*) AS count
    FROM automation_events
    WHERE status='FAILED'
  `).get().count;

  const deadAfter = db.prepare(`
    SELECT COUNT(*) AS count
    FROM automation_dead_letters
    WHERE resolved_at IS NULL
  `).get().count;

  console.log('Resolved failed/dead test events:', failedBefore);
  console.log('Resolved open test dead letters:', deadBefore);
  console.log('Remaining FAILED events:', failedAfter);
  console.log('Remaining open dead letters:', deadAfter);
});

tx();
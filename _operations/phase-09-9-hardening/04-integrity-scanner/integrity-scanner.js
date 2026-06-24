const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();

const Database = require(
  path.join(
    ROOT,
    'backend',
    'node_modules',
    'better-sqlite3'
  )
);

const REPORT_DIR = path.join(ROOT, '_operations', 'phase-09-9-hardening', '04-integrity-scanner');
const REPORT = path.join(REPORT_DIR, 'integrity-report.txt');

const DB_PATH = path.join(ROOT, 'backend', 'litigation360.db');

const requiredTables = [
  'automation_events',
  'automation_event_history',
  'automation_retry_rules',
  'automation_dead_letters',
  'automation_consumers'
];

const requiredRoutes = [
  '/api/health',
  '/api/status',
  '/api/enterprise/health',
  '/api/enterprise/automation',
  '/api/enterprise/events',
  '/api/enterprise/deadletters',
  '/api/enterprise/metrics'
];

const results = [];

function log(line = '') {
  results.push(line);
}

function pass(name) {
  log('[PASS] ' + name);
}

function fail(name, detail = '') {
  log('[FAIL] ' + name + (detail ? ' - ' + detail : ''));
}

function main() {
  fs.mkdirSync(REPORT_DIR, { recursive: true });

  log('=====================================================');
  log('LITIGATION 360 - PHASE 9.9D INTEGRITY REPORT');
  log('=====================================================');
  log('Date: ' + new Date().toISOString());
  log('Root: ' + ROOT);
  log('');

  if (!fs.existsSync(DB_PATH)) {
    fail('Database exists', DB_PATH);
    fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
    console.log(results.join('\n'));
    process.exit(1);
  }

  pass('Database exists');

  const db = new Database(DB_PATH);

  log('');
  log('DATABASE TABLE CHECKS');

  let tableFailures = 0;

  for (const table of requiredTables) {
    const row = db.prepare(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?"
    ).get(table);

    if (row) {
      pass('Table exists: ' + table);
    } else {
      fail('Missing table: ' + table);
      tableFailures++;
    }
  }

  log('');
  log('AUTOMATION STATUS CHECKS');

  const eventCounts = db.prepare(`
    SELECT status, COUNT(*) AS count
    FROM automation_events
    GROUP BY status
  `).all();

  if (eventCounts.length === 0) {
    fail('Automation events found', 'No events registered');
  } else {
    for (const row of eventCounts) {
      log('[INFO] automation_events status=' + row.status + ' count=' + row.count);
    }
  }

  const failed = db.prepare(
    "SELECT COUNT(*) AS count FROM automation_events WHERE status='FAILED'"
  ).get().count;

  const pending = db.prepare(
    "SELECT COUNT(*) AS count FROM automation_events WHERE status='PENDING'"
  ).get().count;

  const deadLetters = db.prepare(
    "SELECT COUNT(*) AS count FROM automation_dead_letters WHERE resolved_at IS NULL"
  ).get().count;

  if (failed === 0) pass('Failed automation events = 0');
  else fail('Failed automation events', String(failed));

  if (pending === 0) pass('Pending automation events = 0');
  else fail('Pending automation events', String(pending));

  if (deadLetters === 0) pass('Open dead letters = 0');
  else fail('Open dead letters', String(deadLetters));

  log('');
  log('ROUTE EXPECTATION CHECKS');
  for (const route of requiredRoutes) {
    log('[EXPECTED] ' + route);
  }

  log('');
  log('SUMMARY');

  const totalFailures = tableFailures + failed + pending + deadLetters;

  log('Table failures: ' + tableFailures);
  log('Failed automation events: ' + failed);
  log('Pending automation events: ' + pending);
  log('Open dead letters: ' + deadLetters);
  log('STATUS: ' + (totalFailures === 0 ? 'PASS' : 'FAIL'));

  fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
  console.log(results.join('\n'));
  console.log('');
  console.log('Report saved to: ' + REPORT);

  process.exit(totalFailures === 0 ? 0 : 1);
}

main();
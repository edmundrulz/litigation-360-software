const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();

const Database = require(
  path.join(ROOT, 'backend', 'node_modules', 'better-sqlite3')
);

const RECOVERY_DIR = path.join(ROOT, '_operations', 'phase-09-9-hardening', '05-recovery-center');
const BACKUP_DB = path.join(RECOVERY_DIR, 'backups', 'litigation360-recovery-test.db');
const REPORT = path.join(RECOVERY_DIR, 'recovery-report.txt');

const requiredTables = [
  'automation_events',
  'automation_event_history',
  'automation_retry_rules',
  'automation_dead_letters',
  'automation_consumers'
];

const results = [];

function log(line = '') {
  results.push(line);
}

function main() {
  log('=====================================================');
  log('LITIGATION 360 - PHASE 9.9E RECOVERY REPORT');
  log('=====================================================');
  log('Date: ' + new Date().toISOString());
  log('');

  if (!fs.existsSync(BACKUP_DB)) {
    log('[FAIL] Backup database not found');
    fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
    console.log(results.join('\n'));
    process.exit(1);
  }

  log('[PASS] Backup database exists');

  const size = fs.statSync(BACKUP_DB).size;
  log('[INFO] Backup size bytes: ' + size);

  if (size <= 0) {
    log('[FAIL] Backup database is empty');
    fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
    console.log(results.join('\n'));
    process.exit(1);
  }

  log('[PASS] Backup database is not empty');

  const db = new Database(BACKUP_DB, { readonly: true });

  let failures = 0;

  for (const table of requiredTables) {
    const row = db.prepare(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?"
    ).get(table);

    if (row) {
      log('[PASS] Backup contains table: ' + table);
    } else {
      log('[FAIL] Backup missing table: ' + table);
      failures++;
    }
  }

  const eventCount = db.prepare(
    'SELECT COUNT(*) AS count FROM automation_events'
  ).get().count;

  log('[INFO] Backup automation_events count: ' + eventCount);

  log('');
  log('SUMMARY');
  log('Recovery table failures: ' + failures);
  log('STATUS: ' + (failures === 0 ? 'PASS' : 'FAIL'));

  fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
  console.log(results.join('\n'));
  console.log('');
  console.log('Report saved to: ' + REPORT);

  process.exit(failures === 0 ? 0 : 1);
}

main();
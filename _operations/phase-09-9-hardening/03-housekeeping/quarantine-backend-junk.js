const fs = require('fs');
const path = require('path');

const DRY_RUN = false;

const ROOT = process.cwd();
const BACKEND = path.join(ROOT, 'backend');
const QUARANTINE = path.join(
  ROOT,
  '_operations',
  'phase-09-9-hardening',
  '03-housekeeping',
  'quarantine',
  'backend-root-junk-advanced'
);

const REPORT = path.join(
  ROOT,
  '_operations',
  'phase-09-9-hardening',
  '03-housekeeping',
  'backend-root-junk-dry-run-report.txt'
);

const keep = new Set([
  '.env',
  '.env.example',
  'ARCHIVE_DOCTOR_BACKUPS',
  'backup',
  'backups',
  'database',
  'dev-safe.bat',
  'enterprise',
  'launch-dev.bat',
  'litigation360.db',
  'logs',
  'migrate-clients-auditlogger.js',
  'migrate-matters-auditlogger.js',
  'node_modules',
  'package-lock.json',
  'package.json',
  'patch-client-audit-approved.js',
  'patch-deadlines-audit-approved.js',
  'patch-delete-client-audit-only.js',
  'patch-delete-client-exact.js',
  'patch-documents-audit-approved.js',
  'patch-matters-audit-approved.js',
  'patch-matters-audit-linebased.js',
  'patch-shutdown.ps1',
  'phase7_backend_files_clean.txt',
  'PHASE8A-FINAL-INVENTORY.js',
  'phase8a2-list-tables.js',
  'README.md',
  'repair-clients-route-approved.js',
  'repair-documents-deadlines-audit.js',
  'RUN-PHASE8A2.bat',
  'safe-rbac-patch-approved.ps1',
  'scripts',
  'src',
  'start-safe.bat',
  'tools',
  '_operations'
]);

function safeFileName(name) {
  return name.replace(/[^a-zA-Z0-9._-]/g, '_') || 'unnamed';
}

function uniqueTarget(basePath) {
  if (!fs.existsSync(basePath)) return basePath;

  const dir = path.dirname(basePath);
  const ext = path.extname(basePath);
  const stem = path.basename(basePath, ext);

  let i = 1;
  while (true) {
    const candidate = path.join(dir, `${stem}-${i}${ext}`);
    if (!fs.existsSync(candidate)) return candidate;
    i++;
  }
}

fs.mkdirSync(QUARANTINE, { recursive: true });

const entries = fs.readdirSync(BACKEND);

const report = [];
let moved = 0;
let kept = 0;
let flagged = 0;

report.push('=====================================================');
report.push('LITIGATION 360 - PHASE 9.9C BACKEND ROOT JUNK REVIEW');
report.push('=====================================================');
report.push('Date: ' + new Date().toISOString());
report.push('Mode: ' + (DRY_RUN ? 'DRY RUN - NO FILES MOVED' : 'LIVE QUARANTINE'));
report.push('');

for (const name of entries) {
  if (keep.has(name)) {
    kept++;
    report.push('[KEEP] ' + name);
    continue;
  }

  flagged++;

  const from = path.join(BACKEND, name);
  const safeName = safeFileName(name);
  const to = uniqueTarget(path.join(QUARANTINE, safeName + '.junk'));

  report.push('[FLAGGED] ' + name + ' => ' + path.relative(ROOT, to));

  if (!DRY_RUN) {
    fs.renameSync(from, to);
    moved++;
  }
}

report.push('');
report.push('SUMMARY');
report.push('Kept: ' + kept);
report.push('Flagged: ' + flagged);
report.push('Moved: ' + moved);
report.push('Status: ' + (flagged > 0 ? 'REVIEW REQUIRED' : 'PASS'));

fs.writeFileSync(REPORT, report.join('\n'), 'utf8');

console.log(report.join('\n'));
console.log('');
console.log('Report saved to: ' + REPORT);
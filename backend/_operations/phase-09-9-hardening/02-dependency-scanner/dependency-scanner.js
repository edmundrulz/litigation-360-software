const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const OUT = path.join(ROOT, '_operations', 'phase-09-9-hardening', '02-dependency-scanner');
const REPORT = path.join(OUT, 'dependency-scan-report.txt');

const ignoreFolders = new Set([
  'node_modules',
  '.git',
  'dist',
  'build',
  '.next',
  'coverage',
  '_operations'
]);

const results = [];
let scannedFiles = 0;
let missingLocalFiles = 0;
let suspiciousRequires = 0;

function log(line = '') {
  results.push(line);
}

function walk(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (!ignoreFolders.has(entry.name)) walk(full);
    } else if (entry.isFile() 
      scanFile(full);
    }
  }
}

function existsCandidate(base) {
  const candidates = [
    base,
    base + '.js',
    base + '.json',
    path.join(base, 'index.js')
  ];
  return candidates.some(fs.existsSync);
}

function scanFile(file) {
  scannedFiles++;
  const text = fs.readFileSync(file, 'utf8');
  const rel = path.relative(ROOT, file);

  const patterns = [
    /require\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
    /from\s+['"`]([^'"`]+)['"`]/g,
    /import\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g
  ];

  for (const pattern of patterns) {
    let match;
    while ((match = pattern.exec(text)) !== null) {
      const dep = match[1];

      if (dep.startsWith('.')) {
        const resolved = path.resolve(path.dirname(file), dep);
        if (!existsCandidate(resolved)) {
          missingLocalFiles++;
        }
      } else {
        suspiciousRequires++;
      }
    }
  }
}

function checkPackageJson() {
  const pkg = path.join(ROOT, 'package.json');
  if (!fs.existsSync(pkg)) {
    log('[CRITICAL] package.json not found.');
    return;
  }

  try {
    const data = JSON.parse(fs.readFileSync(pkg, 'utf8'));
    log('package.json: FOUND');
    log('Project name: ' + (data.name 
    log('Scripts available: ' + Object.keys(data.scripts 
  } catch (err) {
    log('[CRITICAL] package.json is invalid JSON: ' + err.message);
  }
}

function checkNodeModules() {
  const nm = path.join(ROOT, 'node_modules');
  if (fs.existsSync(nm)) {
    log('node_modules: FOUND');
  } else {
    log('[WARNING] node_modules not found. Run: npm install');
  }
}

function main() {
  if (!fs.existsSync(OUT)) fs.mkdirSync(OUT, { recursive: true });

  log('=====================================================');
  log('LITIGATION 360 - PHASE 9.9B DEPENDENCY SCAN REPORT');
  log('=====================================================');
  log('Date: ' + new Date().toISOString());
  log('Root: ' + ROOT);
  log('');

  checkPackageJson();
  checkNodeModules();

  log('');
  log('Scanning JavaScript files...');
  walk(ROOT);

  log('');
  log('=====================================================');
  log('SUMMARY');
  log('=====================================================');
  log('Files scanned: ' + scannedFiles);
  log('External dependency references detected: ' + suspiciousRequires);
  log('Missing local files: ' + missingLocalFiles);

  if (missingLocalFiles === 0) {
    log('STATUS: PASS');
  } else {
    log('STATUS: FAIL');
  }

  fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
  console.log(results.join('\n'));
  console.log('\nReport saved to: ' + REPORT);

  if (missingLocalFiles === 0) process.exit(0);
  process.exit(1);
}

main();

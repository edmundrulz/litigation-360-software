const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const OUT = path.join(ROOT, '_operations', 'phase-09-9-hardening', '02-dependency-scanner');
const REPORT = path.join(OUT, 'dependency-scan-active-runtime-report.txt');

const entryFiles = [
  'backend/src/index.js',
  'backend/src/server.js'
];

const results = [];
const visited = new Set();

let scannedFiles = 0;
let missingLocalFiles = 0;
let externalReferences = 0;

function log(line = '') {
  results.push(line);
}

function existsCandidate(base) {
  const candidates = [
    base,
    base + '.js',
    base + '.json',
    base + '.mjs',
    base + '.cjs',
    base + '.jsx',
    base + '.ts',
    base + '.tsx',
    path.join(base, 'index.js'),
    path.join(base, 'index.jsx'),
    path.join(base, 'index.ts'),
    path.join(base, 'index.tsx')
  ];

  for (const candidate of candidates) {
    if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) return candidate;
  }

  return null;
}

function extractDependencies(text) {
  const deps = [];

  const patterns = [
    /require\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g,
    /from\s+['"`]([^'"`]+)['"`]/g,
    /import\s*\(\s*['"`]([^'"`]+)['"`]\s*\)/g
  ];

  for (const pattern of patterns) {
    let match;

    while ((match = pattern.exec(text)) !== null) {
      deps.push(match[1]);
    }
  }

  return deps;
}

function scanFile(file) {
  const normalized = path.resolve(file);

  if (visited.has(normalized)) return;
  visited.add(normalized);

  if (!fs.existsSync(normalized)) {
    missingLocalFiles++;
    log('[MISSING ENTRY FILE] ' + path.relative(ROOT, normalized));
    return;
  }

  scannedFiles++;

  const text = fs.readFileSync(normalized, 'utf8');
  const rel = path.relative(ROOT, normalized);

  const deps = extractDependencies(text);

  for (const dep of deps) {
    if (dep.startsWith('.')) {
      const resolvedBase = path.resolve(path.dirname(normalized), dep);
      const found = existsCandidate(resolvedBase);

      if (!found) {
        missingLocalFiles++;
        log('[MISSING ACTIVE LOCAL FILE] ' + rel + ' -> ' + dep);
      } else {
        scanFile(found);
      }
    } else {
      externalReferences++;
    }
  }
}

function main() {
  fs.mkdirSync(OUT, { recursive: true });

  log('=====================================================');
  log('LITIGATION 360 - PHASE 9.9B.4 ACTIVE RUNTIME REPORT');
  log('=====================================================');
  log('Date: ' + new Date().toISOString());
  log('Root: ' + ROOT);
  log('');
  log('Scan mode: ACTIVE STARTUP DEPENDENCY TREE ONLY');
  log('Entry files: ' + entryFiles.join(', '));
  log('');

  for (const entry of entryFiles) {
    log('Scanning entry: ' + entry);
    scanFile(path.join(ROOT, entry));
  }

  log('');
  log('SUMMARY');
  log('Files scanned: ' + scannedFiles);
  log('External dependency references detected: ' + externalReferences);
  log('Missing active local files: ' + missingLocalFiles);
  log(missingLocalFiles === 0 ? 'STATUS: PASS' : 'STATUS: FAIL');

  fs.writeFileSync(REPORT, results.join('\n'), 'utf8');
  console.log(results.join('\n'));
  console.log('\nReport saved to: ' + REPORT);

  process.exit(missingLocalFiles === 0 ? 0 : 1);
}

main();
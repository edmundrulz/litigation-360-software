const fs = require('fs');
const file = 'phase6-today-runner.bat';

let code = fs.readFileSync(file, 'utf8');

code = code.replace(
  'echo [ ] One module completed - pending next approved patch >> ..\\%REPORT%',
  'echo [x] One module completed - Documents and Deadlines audit repaired >> ..\\%REPORT%'
);

code = code.replace(
  'echo Complete either Documents audit or Deadlines audit after inspection and approval. >> ..\\%REPORT%',
  'echo Next recommended work: migrate Clients and Matters audit calls to auditLogger.js, then run final Phase 6C verification. >> ..\\%REPORT%'
);

fs.writeFileSync(file, code, 'utf8');

console.log('phase6-today-runner.bat status updated.');
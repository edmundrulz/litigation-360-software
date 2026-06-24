const fs = require("fs");
const path = require("path");

const root = process.env.L360_SOP_ROOT;
const files = process.env.L360_SOP_FILES.split("|");

const required = [
  ...files.map(f => "sops/" + f),
  "registry/MASTER-SOP-LIBRARY-INDEX.md",
  "matrices/SOP-OWNERSHIP-MATRIX.md",
  "docs/SOP-REVIEW-SCHEDULE.md",
  "protocols/ENTERPRISE-SOP-FACTORY-PROTOCOL.md",
  "parameters/SOP-PARAMETERS.md",
  "blueprints/SOP-LIBRARY-BLUEPRINT.md",
  "prompts/SOP-PROMPT-LIBRARY.md",
  "checks-and-balances/SOP-CHECKS-AND-BALANCES.md",
  "verification/SOP-VERIFICATION-PLAN.md",
  "testing/SOP-TESTING-PLAN.md",
  "monitoring/SOP-MONITORING-PLAN.md"
];

let pass = true;

for (const item of required) {
  const ok = fs.existsSync(path.join(root, item));
  console.log(`${item}: ${String(ok).toLowerCase()}`);
  if (!ok) pass = false;
}

console.log("");

if (pass) {
  console.log("PHASE 10ZZ1A ENTERPRISE SOP FACTORY STATUS: PASS");
  process.exit(0);
}

console.log("PHASE 10ZZ1A ENTERPRISE SOP FACTORY STATUS: FAIL");
process.exit(1);

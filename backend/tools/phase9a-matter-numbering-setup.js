const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");

const files = {
  "src/utils/matterNumberGenerator.js": `
function padNumber(num) {
  return String(num).padStart(6, "0");
}

function validateDepartmentCode(code) {
  const allowed = ["LIT", "CIV", "FAM", "CORP"];
  return allowed.includes(code);
}

function buildMatterNumber(year, departmentCode, number) {
  if (!validateDepartmentCode(departmentCode)) {
    throw new Error("Invalid department code");
  }

  return \`MAT-\${year}-\${departmentCode}-\${padNumber(number)}\`;
}

module.exports = {
  padNumber,
  validateDepartmentCode,
  buildMatterNumber
};
`
};

for (const [file, content] of Object.entries(files)) {
  const fullPath = path.join(root, file);
  fs.mkdirSync(path.dirname(fullPath), { recursive: true });
  fs.writeFileSync(fullPath, content.trim() + "\\n");
  console.log("Created:", file);
}

console.log("Phase 9A utility setup complete.");
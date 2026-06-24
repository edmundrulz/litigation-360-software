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

  return `MAT-${year}-${departmentCode}-${padNumber(number)}`;
}

module.exports = {
  padNumber,
  validateDepartmentCode,
  buildMatterNumber
};
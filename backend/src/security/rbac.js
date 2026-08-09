const APPLICATION_ROLES = Object.freeze([
  "administrator",
  "managing_partner/senior_lawyer",
  "junior_lawyer",
  "consultant_lawyer",
  "legal_assistant_clerk",
  "chambering_student",
  "accountant_auditor",
]);

function requireRoles(...allowedRoles) {
  const allowed = new Set(allowedRoles);
  return (req, res, next) => {
    if (!req.user || !req.user.role) return res.status(401).json({ error: "Authentication required" });
    if (!allowed.has(req.user.role)) return res.status(403).json({ error: "Insufficient permission" });
    return next();
  };
}

module.exports = { APPLICATION_ROLES, requireRoles };

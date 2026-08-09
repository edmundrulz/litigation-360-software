const jwt = require("jsonwebtoken");

const ROLE_ALIASES = {
  system: "system_admin", system_admin: "system_admin", super_admin: "system_admin",
  administrator: "legal_knowledge_admin", admin: "legal_knowledge_admin", firm_admin: "legal_knowledge_admin",
  staff: "researcher", lawyer: "lawyer", paralegal: "paralegal", researcher: "researcher", viewer: "viewer",
  legal_knowledge_admin: "legal_knowledge_admin", source_manager: "source_manager", legal_reviewer: "legal_reviewer"
};

function authenticateLegalAuthority(req, res, next) {
  const secret = process.env.JWT_SECRET;
  if (!secret) return res.status(503).json({ error: "Legal Authorities authentication is not configured." });
  const header = req.headers.authorization || "";
  if (!header.startsWith("Bearer ")) return res.status(401).json({ error: "Authorization token missing" });
  try {
    const payload = jwt.verify(header.slice(7), secret, { algorithms: ["HS256"] });
    req.legalUser = { ...payload, userId: String(payload.userId || payload.id || payload.sub || "unknown"), normalizedRole: ROLE_ALIASES[String(payload.role || "viewer").toLowerCase()] || "viewer" };
    next();
  } catch {
    return res.status(403).json({ error: "Invalid or expired token" });
  }
}

function requireLegalRoles(...roles) {
  return (req, res, next) => roles.includes(req.legalUser?.normalizedRole) ? next() : res.status(403).json({ error: "Insufficient Legal Authorities permission", requiredRoles: roles });
}

module.exports = { authenticateLegalAuthority, requireLegalRoles };

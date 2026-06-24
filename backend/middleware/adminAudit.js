const fs = require("fs");
const path = require("path");

const auditFile = path.join(__dirname, "../admin/admin-actions-audit.log");

function adminAudit(action) {
  return function (req, res, next) {
    const user = req.user || {};

    fs.appendFileSync(
      auditFile,
      JSON.stringify({
        timestamp: new Date().toISOString(),
        action,
        admin_user_id: user.id || "UNKNOWN_ADMIN",
        admin_name: user.name || "UNKNOWN_ADMIN_NAME",
        admin_role: user.role || "UNKNOWN_ROLE",
        method: req.method,
        path: req.originalUrl,
        body: req.body || {}
      }) + "\n"
    );

    next();
  };
}

module.exports = {
  adminAudit
};

const fs = require("fs");
const path = require("path");

const matrixPath = path.join(__dirname, "../admin/approval-matrix.json");

function requireApproval(action) {
  return function (req, res, next) {
    const matrix = JSON.parse(fs.readFileSync(matrixPath, "utf8"));
    const user = req.user || {};
    const allowedRoles = matrix[action] || [];

    if (!allowedRoles.includes(user.role)) {
      return res.status(403).json({
        success: false,
        error: "ACTION_NOT_APPROVED",
        action,
        user_role: user.role || "UNKNOWN_ROLE",
        allowed_roles: allowedRoles
      });
    }

    next();
  };
}

module.exports = {
  requireApproval
};

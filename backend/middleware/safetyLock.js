const fs = require("fs");
const path = require("path");

const safetyPath = path.join(__dirname, "../admin/safety-locks.json");

function safetyLock(action) {
  return function (req, res, next) {
    const safety = JSON.parse(fs.readFileSync(safetyPath, "utf8"));
    const firmId = req.body?.firmId;

    const isGroundZero = safety.protected_firms.includes(firmId);

    if (isGroundZero) {
      if (
        action === "DOWNGRADE_PLAN" ||
        action === "SUSPEND_FIRM" ||
        action === "END_TRIAL" ||
        action === "REVOKE_FEATURE_OVERRIDE"
      ) {
        return res.status(403).json({
          success: false,
          error: "GROUND_ZERO_PROTECTED",
          action,
          firmId,
          message: "Ground Zero founding client cannot be downgraded, suspended, restricted, expired, or locked."
        });
      }
    }

    next();
  };
}

module.exports = {
  safetyLock
};

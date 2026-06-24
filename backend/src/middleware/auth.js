const jwt = require("jsonwebtoken");
const logger = require("../utils/logger");

const JWT_SECRET = process.env.JWT_SECRET || "local-dev-secret";

module.exports = (req, res, next) => {
  try {
    const localDevBypass =
      process.env.L360_LOCAL_DEV_BYPASS === "true" &&
      process.env.NODE_ENV !== "production";

    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      if (localDevBypass) {
        req.user = {
          userId: "local-dev-user",
          email: "localdev@litigation360.local",
          role: "administrator",
          firmId: 1
        };
        return next();
      }

      return res.status(401).json({
        success: false,
        error: "Authorization token missing"
      });
    }

    const token = authHeader.split(" ")[1];
    req.user = jwt.verify(token, JWT_SECRET, { algorithms: ["HS256"] });
    next();

  } catch (error) {
    logger.error(`Auth error: ${error.message}`);
    return res.status(401).json({
      success: false,
      error: "Invalid or expired token"
    });
  }
};



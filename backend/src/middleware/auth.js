const jwt = require("jsonwebtoken");
const logger = require("../utils/logger");
const { getJwtConfig } = require("../security/runtimeConfig");
const { sessionRegistry } = require("../security/sessionRegistry");

module.exports = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        error: "Authorization token missing"
      });
    }

    const token = authHeader.split(" ")[1];
    const config = getJwtConfig();
    req.user = jwt.verify(token, config.secret, { algorithms: config.algorithms });
    if (!req.user.sessionId || !sessionRegistry.getActive(req.user.sessionId, req.user.userId)) {
      return res.status(401).json({ success: false, error: "Session is expired or revoked" });
    }
    next();

  } catch (error) {
    logger.error(`Auth error: ${error.message}`);
    return res.status(401).json({
      success: false,
      error: "Invalid or expired token"
    });
  }
};



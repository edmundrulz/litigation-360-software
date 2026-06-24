const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  throw new Error("JWT_SECRET is missing. Set it in your .env file.");
}

function authenticateToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      error: "Authorization token missing",
    });
  }

  const token = authHeader.split(" ")[1];

  try {
    const user = jwt.verify(token, JWT_SECRET, {
      algorithms: ["HS256"],
    });

    req.user = user;
    next();
  } catch {
    return res.status(403).json({
      success: false,
      error: "Invalid or expired token",
    });
  }
}

module.exports = authenticateToken;
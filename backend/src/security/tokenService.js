const jwt = require("jsonwebtoken");
const { getJwtConfig } = require("./runtimeConfig");
const { sessionRegistry } = require("./sessionRegistry");

function issueToken(user, metadata = {}) {
  const config = getJwtConfig();
  const ttlMs = durationToMs(config.expiresIn);
  const session = sessionRegistry.issue({ userId: user.id, ttlMs, metadata });
  const token = jwt.sign(
    { userId: user.id, email: user.email, role: user.role, firmId: user.firmId, sessionId: session.id },
    config.secret,
    { expiresIn: config.expiresIn, algorithm: "HS256" }
  );
  return { token, sessionId: session.id };
}

function durationToMs(value) {
  const match = /^(\d+)(m|h|d)$/.exec(value);
  if (!match) throw new Error("Unsupported token duration.");
  const unit = { m: 60000, h: 3600000, d: 86400000 }[match[2]];
  return Number(match[1]) * unit;
}

module.exports = { issueToken, durationToMs };

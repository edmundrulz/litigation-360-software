const INSECURE_SECRETS = new Set([
  "your-secret-key",
  "local-dev-secret",
  "changeme",
  "secret",
]);

function getJwtConfig(env = process.env) {
  const secret = String(env.JWT_SECRET || "");
  if (secret.length < 32 || INSECURE_SECRETS.has(secret.toLowerCase())) {
    throw new Error("JWT_SECRET must be externally supplied with at least 32 characters.");
  }

  const expiresIn = String(env.JWT_EXPIRY || "2h");
  if (!/^([1-9]\d*)(m|h|d)$/.test(expiresIn)) {
    throw new Error("JWT_EXPIRY must use a positive m, h, or d duration.");
  }

  return Object.freeze({ secret, expiresIn, algorithms: ["HS256"] });
}

module.exports = { getJwtConfig, INSECURE_SECRETS };

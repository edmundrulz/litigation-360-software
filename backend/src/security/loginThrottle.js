class LoginThrottle {
  constructor({ maxFailures = 5, windowMs = 15 * 60 * 1000, lockMs = 15 * 60 * 1000, clock = () => Date.now() } = {}) {
    this.maxFailures = maxFailures;
    this.windowMs = windowMs;
    this.lockMs = lockMs;
    this.clock = clock;
    this.entries = new Map();
  }

  key(identity, ipAddress) {
    return `${String(identity || "").trim().toLowerCase()}|${String(ipAddress || "unknown")}`;
  }

  status(identity, ipAddress) {
    const key = this.key(identity, ipAddress);
    const now = this.clock();
    const entry = this.entries.get(key);
    if (!entry) return { blocked: false, retryAfterMs: 0 };
    if (entry.lockedUntil > now) return { blocked: true, retryAfterMs: entry.lockedUntil - now };
    if (now - entry.windowStartedAt >= this.windowMs) this.entries.delete(key);
    return { blocked: false, retryAfterMs: 0 };
  }

  failure(identity, ipAddress) {
    const key = this.key(identity, ipAddress);
    const now = this.clock();
    let entry = this.entries.get(key);
    if (!entry || now - entry.windowStartedAt >= this.windowMs) entry = { failures: 0, windowStartedAt: now, lockedUntil: 0 };
    entry.failures += 1;
    if (entry.failures >= this.maxFailures) entry.lockedUntil = now + this.lockMs;
    this.entries.set(key, entry);
    return this.status(identity, ipAddress);
  }

  success(identity, ipAddress) {
    this.entries.delete(this.key(identity, ipAddress));
  }
}

const loginThrottle = new LoginThrottle();
module.exports = { LoginThrottle, loginThrottle };

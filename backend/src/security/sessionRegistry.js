const crypto = require("crypto");

class SessionRegistry {
  constructor({ clock = () => Date.now() } = {}) {
    this.clock = clock;
    this.sessions = new Map();
  }

  issue({ userId, ttlMs, metadata = {} }) {
    if (!userId || !Number.isSafeInteger(ttlMs) || ttlMs <= 0) {
      throw new Error("A userId and positive integer ttlMs are required.");
    }
    const id = crypto.randomUUID();
    const now = this.clock();
    this.sessions.set(id, { id, userId: String(userId), createdAt: now, expiresAt: now + ttlMs, revokedAt: null, metadata: { ...metadata } });
    return { ...this.sessions.get(id) };
  }

  getActive(id, expectedUserId) {
    const session = this.sessions.get(String(id || ""));
    if (!session || session.revokedAt || session.expiresAt <= this.clock()) return null;
    if (expectedUserId && session.userId !== String(expectedUserId)) return null;
    return { ...session };
  }

  revoke(id) {
    const session = this.sessions.get(String(id || ""));
    if (!session || session.revokedAt) return false;
    session.revokedAt = this.clock();
    return true;
  }

  revokeUser(userId) {
    let count = 0;
    for (const session of this.sessions.values()) {
      if (session.userId === String(userId) && !session.revokedAt) {
        session.revokedAt = this.clock();
        count += 1;
      }
    }
    return count;
  }
}

const sessionRegistry = new SessionRegistry();
module.exports = { SessionRegistry, sessionRegistry };

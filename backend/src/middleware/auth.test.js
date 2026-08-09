const jwt = require("jsonwebtoken");
const authenticate = require("./auth");
const { sessionRegistry } = require("../security/sessionRegistry");

const SECRET = "synthetic-test-secret-000000000000000000000000";

function response() {
  return { statusCode: 200, body: null, status(code) { this.statusCode = code; return this; }, json(body) { this.body = body; return this; } };
}

describe("authentication middleware", () => {
  beforeAll(() => { process.env.JWT_SECRET = SECRET; });

  test("accepts only a signed token backed by an active server session", () => {
    const session = sessionRegistry.issue({ userId: "u1", ttlMs: 60000 });
    const token = jwt.sign({ userId: "u1", role: "administrator", sessionId: session.id }, SECRET, { algorithm: "HS256", expiresIn: "1h" });
    let nextCalled = false;
    authenticate({ headers: { authorization: `Bearer ${token}` } }, response(), () => { nextCalled = true; });
    expect(nextCalled).toBe(true);
  });

  test("rejects revoked sessions and unsupported algorithms", () => {
    const session = sessionRegistry.issue({ userId: "u2", ttlMs: 60000 });
    const token = jwt.sign({ userId: "u2", role: "administrator", sessionId: session.id }, SECRET, { algorithm: "HS256", expiresIn: "1h" });
    sessionRegistry.revoke(session.id);
    expect(authenticate({ headers: { authorization: `Bearer ${token}` } }, response(), () => {} ).statusCode).toBe(401);

    const unsigned = jwt.sign({ userId: "u2", sessionId: session.id }, "ignored", { algorithm: "none" });
    expect(authenticate({ headers: { authorization: `Bearer ${unsigned}` } }, response(), () => {} ).statusCode).toBe(401);
  });
});

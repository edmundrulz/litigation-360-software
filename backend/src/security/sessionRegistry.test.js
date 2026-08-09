const { SessionRegistry } = require("./sessionRegistry");

describe("server-owned sessions", () => {
  test("revocation invalidates a live session", () => {
    let now = 1000;
    const registry = new SessionRegistry({ clock: () => now });
    const session = registry.issue({ userId: "u1", ttlMs: 5000 });
    expect(registry.getActive(session.id, "u1")).not.toBeNull();
    expect(registry.revoke(session.id)).toBe(true);
    expect(registry.getActive(session.id, "u1")).toBeNull();
  });

  test("expiry and user mismatch fail closed", () => {
    let now = 1000;
    const registry = new SessionRegistry({ clock: () => now });
    const session = registry.issue({ userId: "u1", ttlMs: 50 });
    expect(registry.getActive(session.id, "u2")).toBeNull();
    now = 1051;
    expect(registry.getActive(session.id, "u1")).toBeNull();
  });
});

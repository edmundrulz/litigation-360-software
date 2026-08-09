const { requireRoles } = require("./rbac");

function response() {
  return { statusCode: 200, body: null, status(code) { this.statusCode = code; return this; }, json(body) { this.body = body; return this; } };
}

describe("server-authoritative RBAC", () => {
  test("denies missing identity and disallowed roles", () => {
    const middleware = requireRoles("administrator");
    let nextCalled = false;
    expect(middleware({}, response(), () => { nextCalled = true; }).statusCode).toBe(401);
    expect(middleware({ user: { role: "guest" } }, response(), () => { nextCalled = true; }).statusCode).toBe(403);
    expect(nextCalled).toBe(false);
  });

  test("allows an explicitly listed server token role", () => {
    const middleware = requireRoles("administrator");
    let nextCalled = false;
    middleware({ user: { role: "administrator" } }, response(), () => { nextCalled = true; });
    expect(nextCalled).toBe(true);
  });
});

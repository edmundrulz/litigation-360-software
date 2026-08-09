const { getJwtConfig } = require("./runtimeConfig");

describe("runtime security configuration", () => {
  test.each([undefined, "", "your-secret-key", "local-dev-secret", "short"])("rejects missing or unsafe JWT secret %p", (JWT_SECRET) => {
    expect(() => getJwtConfig({ JWT_SECRET })).toThrow(/JWT_SECRET/);
  });

  test("accepts an externally supplied strong secret", () => {
    expect(getJwtConfig({ JWT_SECRET: "x".repeat(48), JWT_EXPIRY: "90m" })).toMatchObject({ expiresIn: "90m", algorithms: ["HS256"] });
  });

  test("rejects ambiguous expiry values", () => {
    expect(() => getJwtConfig({ JWT_SECRET: "x".repeat(48), JWT_EXPIRY: "forever" })).toThrow(/JWT_EXPIRY/);
  });
});

const { scoreClientIdentity, normalizeValue } = require("../backend/src/utils/clientIdentityEngine");

describe("Phase 9B Master Client Identity Engine", () => {
  test("normalizes values safely", () => {
    expect(normalizeValue("  John@Example.COM  ")).toBe("john@example.com");
    expect(normalizeValue(null)).toBe("");
  });

  test("detects likely duplicate by email and name", () => {
    const result = scoreClientIdentity(
      { name: "John Smith", email: "john@example.com", phone: "" },
      { name: "John Smith", email: "john@example.com", phone: "" }
    );

    expect(result.score).toBeGreaterThanOrEqual(70);
    expect(result.rating).toBe("LIKELY_MATCH");
    expect(result.reasons).toContain("Email exact match");
    expect(result.reasons).toContain("Name exact match");
  });

  test("returns no match for unrelated client", () => {
    const result = scoreClientIdentity(
      { name: "Alice Tan", email: "alice@example.com", phone: "111" },
      { name: "John Smith", email: "john@example.com", phone: "222" }
    );

    expect(result.rating).toBe("NO_MATCH");
  });
});

const { classifyMatter, decideIntakeReadiness } = require("../backend/src/utils/matterIntakeWizard");

describe("Phase 9D Matter Intake Wizard", () => {
  test("validates matter classification", () => {
    const result = classifyMatter({ matterType: "LIT" });
    expect(result.valid).toBe(true);
    expect(result.departmentCode).toBe("LIT");
  });

  test("rejects invalid matter classification", () => {
    const result = classifyMatter({ matterType: "BAD" });
    expect(result.valid).toBe(false);
  });

  test("blocks intake on RED conflict", () => {
    const result = decideIntakeReadiness(
      { bestMatch: null },
      { rating: "RED" },
      { valid: true }
    );

    expect(result.ready).toBe(false);
    expect(result.status).toBe("BLOCKED");
  });

  test("allows clean intake", () => {
    const result = decideIntakeReadiness(
      { bestMatch: null },
      { rating: "GREEN" },
      { valid: true }
    );

    expect(result.ready).toBe(true);
    expect(result.status).toBe("READY");
  });
});

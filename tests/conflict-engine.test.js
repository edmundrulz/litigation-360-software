const { scoreConflict, normalizeValue } = require("../backend/src/utils/conflictEngine");

describe("Phase 9C Conflict Checking Engine", () => {
  test("normalizes values safely", () => {
    expect(normalizeValue("  John Smith  ")).toBe("john smith");
    expect(normalizeValue(null)).toBe("");
  });

  test("detects RED conflict when opposing party is existing client", () => {
    const result = scoreConflict(
      { clientName: "New Client", opposingParty: "John Smith", matterTitle: "Test Matter" },
      { clientName: "John Smith", opposingParty: "", matterTitle: "" }
    );

    expect(result.rating).toBe("RED");
    expect(result.action).toBe("BLOCK_PENDING_REVIEW");
    expect(result.reasons).toContain("Opposing party is existing client");
  });

  test("detects AMBER conflict for existing client name match", () => {
    const result = scoreConflict(
      { clientName: "John Smith", opposingParty: "Unknown", matterTitle: "New Matter" },
      { clientName: "John Smith", opposingParty: "", matterTitle: "" }
    );

    expect(result.rating).toBe("AMBER");
    expect(result.action).toBe("REVIEW_REQUIRED");
  });

  test("returns GREEN when no conflict exists", () => {
    const result = scoreConflict(
      { clientName: "Completely New Client", opposingParty: "Unknown Opponent", matterTitle: "New Matter" },
      { clientName: "John Smith", opposingParty: "", matterTitle: "" }
    );

    expect(result.rating).toBe("GREEN");
    expect(result.action).toBe("ALLOW");
  });
});

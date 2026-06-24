const { calculateDeadline, adjustWeekend } = require("../backend/src/utils/courtDeadlineCalculator");

describe("Phase 9G Court Deadline Calculator", () => {
  test("calculates service deadline", () => {
    const result = calculateDeadline({ deadlineType: "SERVICE", triggerDate: "2026-06-17" });
    expect(result.success).toBe(true);
    expect(result.deadlineType).toBe("SERVICE");
    expect(result.adjustedDeadline).toBe("2026-06-24");
  });

  test("adjusts Saturday deadline to Monday", () => {
    const adjusted = adjustWeekend(new Date("2026-06-20"));
    expect(adjusted.toISOString().slice(0, 10)).toBe("2026-06-22");
  });

  test("rejects invalid deadline type", () => {
    const result = calculateDeadline({ deadlineType: "BAD", triggerDate: "2026-06-17" });
    expect(result.success).toBe(false);
  });

  test("rejects invalid date", () => {
    const result = calculateDeadline({ deadlineType: "SERVICE", triggerDate: "not-a-date" });
    expect(result.success).toBe(false);
  });
});

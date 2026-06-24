const { TASK_TEMPLATES, generateTasksForStage } = require("../backend/src/utils/taskAutomationEngine");

describe("Phase 9F Task Automation Engine", () => {
  test("contains task templates", () => {
    expect(TASK_TEMPLATES.INTAKE).toBeDefined();
    expect(TASK_TEMPLATES.MATTER_OPENED).toBeDefined();
  });

  test("generates intake tasks", () => {
    const tasks = generateTasksForStage("INTAKE");
    expect(tasks.length).toBe(3);
    expect(tasks[0].title).toBe("Verify client identity");
    expect(tasks[0].priority).toBe("HIGH");
  });

  test("generates matter opened tasks", () => {
    const tasks = generateTasksForStage("MATTER_OPENED");
    expect(tasks.some(t => t.title === "Generate matter number")).toBe(true);
  });

  test("returns empty array for unknown stage", () => {
    const tasks = generateTasksForStage("UNKNOWN");
    expect(tasks.length).toBe(0);
  });
});

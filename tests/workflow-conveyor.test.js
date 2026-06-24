const { WORKFLOWS, getWorkflowTemplate, getWorkflowPreview } = require("../backend/src/utils/workflowConveyor");

describe("Phase 9E Workflow Conveyor Engine", () => {
  test("contains workflow templates", () => {
    expect(WORKFLOWS.LIT).toBeDefined();
    expect(WORKFLOWS.CIV).toBeDefined();
    expect(WORKFLOWS.FAM).toBeDefined();
    expect(WORKFLOWS.CORP).toBeDefined();
  });

  test("returns LIT workflow template", () => {
    const workflow = getWorkflowTemplate("LIT");
    expect(workflow[0]).toBe("INTAKE");
  });

  test("returns workflow preview", () => {
    const preview = getWorkflowPreview("LIT");
    expect(preview.valid).toBe(true);
    expect(preview.currentStage).toBe("INTAKE");
    expect(preview.nextStage).toBe("CONFLICT_CHECK");
  });

  test("rejects unknown workflow", () => {
    const preview = getWorkflowPreview("BAD");
    expect(preview.valid).toBe(false);
  });
});

const TASK_TEMPLATES = {
  INTAKE: [
    "Verify client identity",
    "Run conflict check",
    "Collect basic matter details"
  ],
  CONFLICT_CHECK: [
    "Review conflict result",
    "Record conflict clearance decision"
  ],
  MATTER_OPENED: [
    "Generate matter number",
    "Assign responsible lawyer",
    "Create opening checklist"
  ],
  DOCUMENT_COLLECTION: [
    "Request client documents",
    "Review received documents",
    "Flag missing documents"
  ],
  FILING: [
    "Prepare filing documents",
    "Review filing deadline",
    "Submit filing"
  ],
  HEARING: [
    "Prepare hearing bundle",
    "Confirm hearing date",
    "Update client"
  ],
  CLOSED: [
    "Close matter file",
    "Archive documents",
    "Final billing check"
  ]
};

function generateTasksForStage(stage) {
  const key = String(stage || "").trim().toUpperCase();
  const templates = TASK_TEMPLATES[key] || [];

  return templates.map((title, index) => ({
    title,
    stage: key,
    status: "PENDING",
    priority: index === 0 ? "HIGH" : "NORMAL"
  }));
}

module.exports = {
  TASK_TEMPLATES,
  generateTasksForStage
};
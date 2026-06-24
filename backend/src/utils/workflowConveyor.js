const WORKFLOWS = {
  LIT: [
    "INTAKE",
    "CONFLICT_CHECK",
    "MATTER_OPENED",
    "DOCUMENT_COLLECTION",
    "FILING",
    "HEARING",
    "JUDGMENT",
    "CLOSED"
  ],

  CIV: [
    "INTAKE",
    "CONFLICT_CHECK",
    "MATTER_OPENED",
    "PLEADINGS",
    "DISCOVERY",
    "TRIAL",
    "JUDGMENT",
    "CLOSED"
  ],

  FAM: [
    "INTAKE",
    "CONFLICT_CHECK",
    "MATTER_OPENED",
    "MEDIATION",
    "COURT_PROCEEDINGS",
    "ORDER",
    "CLOSED"
  ],

  CORP: [
    "INTAKE",
    "CONFLICT_CHECK",
    "MATTER_OPENED",
    "REVIEW",
    "DRAFTING",
    "EXECUTION",
    "CLOSED"
  ]
};

function getWorkflowTemplate(departmentCode) {
  return WORKFLOWS[departmentCode] || null;
}

function getWorkflowPreview(departmentCode) {
  const workflow = getWorkflowTemplate(departmentCode);

  if (!workflow) {
    return {
      valid: false,
      message: "Unknown workflow type"
    };
  }

  return {
    valid: true,
    currentStage: workflow[0],
    nextStage: workflow[1] || null,
    totalStages: workflow.length,
    workflow
  };
}

module.exports = {
  WORKFLOWS,
  getWorkflowTemplate,
  getWorkflowPreview
};
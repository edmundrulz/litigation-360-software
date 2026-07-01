export const WORKFLOW_STEPS = [
  { step: 1, label: "Assessment", title: "Preliminary Assessment & Triage", module: "Client Intake Discovery" },
  { step: 2, label: "Client Gate", title: "Client Search & Duplicate Detection", module: "Matter Intake" },
  { step: 3, label: "Client Details", title: "Client Details / Authority & Conflict", module: "Clients" },
  { step: 4, label: "Documents", title: "Documents & Evidence Readiness", module: "Documents" },
  { step: 5, label: "Scope & Strategy", title: "Scope, Risk & Strategy Review", module: "Cases" },
  { step: 6, label: "Draft Review", title: "Fee Estimate / Engagement / Draft Preview", module: "Review Submit" },
];

export function clampProgressPercent(value) {
  const numericValue = Number(value);
  if (!Number.isFinite(numericValue)) return 0;
  if (numericValue < 0) return 0;
  if (numericValue > 100) return 100;
  return Math.round(numericValue * 10) / 10;
}

export function getOverallWorkflowPercent(currentStep, totalSteps = WORKFLOW_STEPS.length) {
  if (!totalSteps) return 0;
  return clampProgressPercent((Number(currentStep || 0) / Number(totalSteps)) * 100);
}

export function getCurrentPageCompletionPercent(completedRequiredItems, totalRequiredItems) {
  if (!totalRequiredItems) return 0;
  return clampProgressPercent((Number(completedRequiredItems || 0) / Number(totalRequiredItems)) * 100);
}

export function getWizardStep(currentStep) {
  return WORKFLOW_STEPS.find((step) => step.step === Number(currentStep)) || WORKFLOW_STEPS[0];
}

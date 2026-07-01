import { WORKFLOW_STEPS, clampProgressPercent, getCurrentPageCompletionPercent, getOverallWorkflowPercent, getWizardStep } from "../../workflow/wizardProgress";

export default function WizardProgressPanel({ currentStep = 1, completedRequiredItems = 0, totalRequiredItems = 0, pageCompletionPercent, pageCompletionLabel = "Current Page Completion" }) {
  const totalSteps = WORKFLOW_STEPS.length;
  const activeStep = getWizardStep(currentStep);
  const overallPercent = getOverallWorkflowPercent(currentStep, totalSteps);
  const resolvedPagePercent = pageCompletionPercent === undefined ? getCurrentPageCompletionPercent(completedRequiredItems, totalRequiredItems) : clampProgressPercent(pageCompletionPercent);
  const completedCount = Math.max(0, Number(completedRequiredItems || 0));
  const totalCount = Math.max(0, Number(totalRequiredItems || 0));

  return (
    <section className="wizard-progress-panel" aria-label={"Workflow progress: Step " + activeStep.step + " of " + totalSteps}>
      <div className="wizard-progress-header">
        <div>
          <p className="wizard-progress-kicker">Step {activeStep.step} of {totalSteps}</p>
          <h3>{activeStep.title}</h3>
        </div>
        <div className="wizard-progress-summary" aria-label="Progress summary">
          <span>Overall: {overallPercent.toFixed(1)}%</span>
          <span>{pageCompletionLabel}: {resolvedPagePercent.toFixed(1)}%</span>
        </div>
      </div>

      <div className="wizard-progress-bars">
        <div className="wizard-progress-bar-group">
          <div className="wizard-progress-bar-label"><span>Overall Workflow Progress</span><strong>{overallPercent.toFixed(1)}%</strong></div>
          <div className="wizard-progress-track" aria-hidden="true"><div className="wizard-progress-fill" style={{ width: overallPercent + "%" }} /></div>
        </div>
        <div className="wizard-progress-bar-group">
          <div className="wizard-progress-bar-label"><span>{pageCompletionLabel}</span><strong>{resolvedPagePercent.toFixed(1)}%</strong></div>
          <div className="wizard-progress-track" aria-hidden="true"><div className="wizard-progress-fill page" style={{ width: resolvedPagePercent + "%" }} /></div>
          {totalCount > 0 && <small>{completedCount} of {totalCount} required items completed · {Math.max(totalCount - completedCount, 0)} missing</small>}
        </div>
      </div>

      <ol className="wizard-step-list" aria-label="Workflow step list">
        {WORKFLOW_STEPS.map((step) => {
          const state = step.step < activeStep.step ? "complete" : step.step === activeStep.step ? "active" : "pending";
          return (
            <li className={"wizard-step-item " + state} key={step.step}>
              <span className="wizard-step-number">{step.step}</span>
              <span className="wizard-step-text"><strong>{step.label}</strong><small>{state === "complete" ? "Complete" : state === "active" ? "Active" : "Pending"}</small></span>
            </li>
          );
        })}
      </ol>
    </section>
  );
}

import React, { useState } from "react";

const STEPS = [
  {
    id: 1,
    title: "Client Details",
    status: "OPEN",
    description: "Capture or confirm the client profile before opening the legal workflow.",
  },
  {
    id: 2,
    title: "Case / Matter Details",
    status: "OPEN",
    description: "Record the case, matter type, parties, facts, and legal issue summary.",
  },
  {
    id: 3,
    title: "Deadline Details",
    status: "OPEN",
    description: "Capture court dates, limitation dates, reminders, and urgent timeline risks.",
  },
  {
    id: 4,
    title: "Document Details",
    status: "OPEN",
    description: "Prepare document, evidence, filing, bundle, and template information.",
  },
  {
    id: 5,
    title: "Review",
    status: "OPEN",
    description: "Review the collected workflow details before completion.",
  },
  {
    id: 6,
    title: "Review / Save & Submit",
    status: "OPEN",
    description: "Final review point before saving, submission, or future workflow handoff.",
  },
];

export default function MatterIntakeWizard({ setModule } = {}) {
  const [step, setStep] = useState(1);
  const activeStep = STEPS.find((item) => item.id === step) || STEPS[0];

  function goHome() {
    if (typeof setModule === "function") {
      setModule("home");
    }
  }

  function previousStep() {
    if (step === 1) {
      goHome();
      return;
    }

    setStep((currentStep) => Math.max(1, currentStep - 1));
  }

  function nextStep() {
    setStep((currentStep) => Math.min(STEPS.length, currentStep + 1));
  }

  function renderStepBody() {
    if (step === 1) {
      return (
        <section className="card">
          <h2>▶ 1. Client Details</h2>
          <p>Confirm client profile details before continuing.</p>

          <div className="summary">
            <div>
              <strong>John Edmund Pereira</strong>
              <span>Client Name</span>
            </div>
            <div>
              <strong>edmundrulz@gmail.com</strong>
              <span>Email Address</span>
            </div>
            <div>
              <strong>0162172852</strong>
              <span>Primary Phone</span>
            </div>
            <div>
              <strong>20 JALAN SS2/6</strong>
              <span>Residential Address</span>
            </div>
          </div>
        </section>
      );
    }

    if (step === 2) {
      return (
        <section className="card">
          <h2>▶ 2. Case / Matter Details</h2>
          <p>Capture the case or matter summary, parties, legal issue, and file-opening details.</p>

          <div className="summary">
            <div>
              <strong>Case / Matter Details</strong>
              <span>Workflow Stage</span>
            </div>
            <div>
              <strong>OPEN</strong>
              <span>Status</span>
            </div>
          </div>
        </section>
      );
    }

    if (step === 3) {
      return (
        <section className="card">
          <h2>▶ 3. Deadline Details</h2>
          <p>Record court dates, filing deadlines, limitation periods, reminders, and urgency indicators.</p>

          <div className="summary">
            <div>
              <strong>Deadline Details</strong>
              <span>Workflow Stage</span>
            </div>
            <div>
              <strong>OPEN</strong>
              <span>Status</span>
            </div>
          </div>
        </section>
      );
    }

    if (step === 4) {
      return (
        <section className="card">
          <h2>▶ 4. Document Details</h2>
          <p>Prepare document, evidence, filing, bundle, template, and review information.</p>

          <div className="summary">
            <div>
              <strong>Document Details</strong>
              <span>Workflow Stage</span>
            </div>
            <div>
              <strong>OPEN</strong>
              <span>Status</span>
            </div>
          </div>
        </section>
      );
    }

    if (step === 5) {
      return (
        <section className="card">
          <h2>▶ 5. Review</h2>
          <p>Review the prepared workflow before save or submission.</p>

          <div className="summary">
            <div>
              <strong>Review</strong>
              <span>Workflow Stage</span>
            </div>
            <div>
              <strong>OPEN</strong>
              <span>Status</span>
            </div>
          </div>
        </section>
      );
    }

    return (
      <section className="card">
        <h2>▶ 6. Review / Save & Submit</h2>
        <p>Final review point before saving, submission, or future workflow handoff.</p>

        <div className="summary">
          <div>
            <strong>Review / Save & Submit</strong>
            <span>Workflow Stage</span>
          </div>
          <div>
            <strong>OPEN</strong>
            <span>Status</span>
          </div>
        </div>

        <div className="actions">
          <button type="button" onClick={() => setModule?.("Review Submit")}>
            Open Completion Review
          </button>
        </div>
      </section>
    );
  }

  return (
    <section className="module-frame">
      <div className="module-frame-header">
        <div>
          <p className="eyebrow">Matter Intake Workflow</p>
          <h2>{activeStep.title}</h2>
          <p>{activeStep.description}</p>
        </div>

        <span className="pill good">
          Step {activeStep.id} / {STEPS.length} · {activeStep.status}
        </span>
      </div>

      <div className="summary">
        {STEPS.map((item) => (
          <button
            key={item.id}
            type="button"
            className={item.id === step ? "active" : ""}
            onClick={() => setStep(item.id)}
          >
            {item.id}. {item.title}
          </button>
        ))}
      </div>

      {renderStepBody()}

      <div className="actions">
        <button type="button" onClick={previousStep}>
          ← Previous
        </button>

        <button type="button" onClick={goHome}>
          Main Page
        </button>

        {step < STEPS.length ? (
          <button type="button" onClick={nextStep}>
            Save & Next →
          </button>
        ) : (
          <button type="button" onClick={() => setModule?.("Review Submit")}>
            Complete / Review Submit
          </button>
        )}
      </div>
    </section>
  );
}

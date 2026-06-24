# L360 V1 MATTER INTAKE CONVEYOR BLUEPRINT

## Objective

Create a controlled step-by-step intake process:

Client -> Case/Matter -> Deadline -> Document -> Review -> Submit

## Rule

User should not jump randomly between pages. User proceeds step by step.

## Storage

Draft data is saved into SQLite table:

matter_intake_drafts

## Final Submit Creates

- Client
- Case/Matter
- Deadline
- Document

## Current Status

Backend route created:

/api/intake/draft
/api/intake/draft/:draftGuid
/api/intake/draft/:draftGuid/step/:step
/api/intake/draft/:draftGuid/submit

Frontend scaffold created:

frontend/src/pages/MatterIntakeWizard.jsx

## Next Manual Step

Wire MatterIntakeWizard.jsx into the app navigation/router after backend tests pass.

## Safety

This does not replace the existing dashboard.
This does not delete existing modules.
This does not remove Clients/Cases/Documents/Deadlines.

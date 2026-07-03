# PAGE 4+ Progress Calculator Implementation (2026-07-03)

## Files changed

- frontend/src/App.jsx
- docs/phase-14/implementation/PAGE_4_PLUS_PROGRESS_CALCULATOR_IMPLEMENTATION_20260703.md

## Pages / sections updated

Post-Page-3 workflow modules rendered through `ModuleFrame`:

- Cases
- Court Dates
- Documents / Documents & Evidence Readiness
- Draft Engagement Preview / Review Submit

## Formula used

`percentage = completed required items / total required items * 100`

Guard rule:

- If total required is `0`, percentage is `0` and label is `No required items`.

## Page 3 lock confirmation

Confirmed:

- No Page 3 CSS lock blocks modified.
- No Page 3 required / complete / missing counter CSS modified.
- No Page 3 alphabet filter CSS modified.
- No backend, database, auth, RBAC, API route, or server file modified.

## Build result

Verified with:

`npm --prefix frontend run build`

## Known limitations

The discovery scan did not expose separate literal Page 4 / Page 5 / Page 6 component files.

Current implementation therefore adds a controlled Page 4+ progress calculator through the shared `ModuleFrame` for post-Page-3 modules.

Current App.jsx exposes limited field-level required-item data for those modules. The present calculator uses real module render availability as the required completion item. This is safe and non-destructive, but it should be treated as module-level completion until page-specific required field models are added.

## Follow-up recommendation

Create a later field-mapping audit to replace module-level required items with true page-specific required field lists where each post-Page-3 page exposes concrete form/status fields.

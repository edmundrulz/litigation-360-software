# Legal Agent Registry

## Purpose
Define the Phase 11.0 foundation controls, processes, parameters and operator usage rules.

## Scope
Applies to the Autonomous Legal Enterprise Ecosystem layer of Litigation 360.

## Inputs
- Operations data
- Alert data
- Analytics data
- Predictive data
- Autonomous supervisor data
- Court and agency data
- Industrial Court readiness
- PERKESO readiness

## Outputs
- Health status
- Metrics status
- Dashboard status
- Agent registry status
- Orchestration status
- Validation reports

## Parameters
- Risk score range: 0 to 100
- Executive approval threshold: 90
- Manager review threshold: 70
- Allowed autonomous actions: report, alert, escalate, notify, recommend, queue task
- Blocked destructive actions: delete matter, delete client, delete document, delete database

## Rules
1. No destructive autonomous action without executive approval.
2. Industrial Court coverage must remain active.
3. PERKESO coverage must remain active.
4. Google Maps and Waze readiness must remain represented.
5. All ecosystem actions must generate records, logs or dashboards.
6. Every phase must include validation and PASS / FAIL status.

## Process
1. Check health endpoint.
2. Check metrics endpoint.
3. Check dashboard endpoint.
4. Check registry endpoint.
5. Check agent endpoint.
6. Review route mount.
7. Review validation report.
8. Confirm PASS before proceeding.

## Validation
Required status: PASS.

## Operator Checklist
- [ ] Project root confirmed
- [ ] Backend source confirmed
- [ ] Route mounted
- [ ] Engine files created
- [ ] Documentation created
- [ ] Validation created
- [ ] Dashboard generated
- [ ] Industrial Court coverage confirmed
- [ ] PERKESO coverage confirmed
- [ ] PASS shown in console

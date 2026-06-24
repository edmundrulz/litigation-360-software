# INDUSTRIAL-COURT-ANALYTICS

## Purpose
Provide Phase 10Z.2 enterprise operations analytics documentation for Litigation 360.

## Scope
Covers operations health, alert analytics, escalation analytics, workflow success, performance, backup readiness, deployment readiness, Industrial Court readiness, PERKESO readiness, Google Maps readiness, and Waze readiness.

## Inputs
- Backend health data
- Alert data
- Escalation data
- Workflow data
- Deployment data
- Backup data
- Performance data
- Court and agency operational data

## Outputs
- Analytics snapshots
- Metrics summaries
- Dashboard data
- Risk score
- Stability score
- Workflow success rate
- Deployment readiness signal
- Operator recommendations

## Parameters
- Stability score pass target: 85 and above
- Risk score normal target: below 15
- Workflow success rate target: 95 and above
- Critical alerts allowed before deployment: 0
- Backup failures allowed before deployment: 0
- Deployment blocks allowed before release: 0
- Live dashboard refresh: 30 seconds

## Rules
1. Critical alerts override normal operations status.
2. Backup failure blocks deployment readiness.
3. Gatekeeper failure blocks deployment readiness.
4. Industrial Court and PERKESO coverage must never be removed.
5. Google Maps and Waze readiness must remain included for navigation analytics.
6. Metrics must be generated from repeatable backend engine output.

## Process
1. Run deployment script from the project root.
2. Confirm backend route is mounted.
3. Start backend.
4. Check health endpoint.
5. Check metrics endpoint.
6. Check dashboard endpoint.
7. Review reports folder.
8. Confirm validation PASS.

## Validation
Validation checks file existence, route mount, engine loading, analytics snapshot creation, metrics creation, performance analysis, court coverage, PERKESO coverage, deployment coverage, dashboard generation, health generation, and metrics generation.

## Operator Checklist
- [ ] Confirm script was run from project root.
- [ ] Confirm PASS status printed.
- [ ] Restart backend using STOP-L360.bat and START-L360-CLEAN.bat.
- [ ] Open analytics health endpoint.
- [ ] Open analytics dashboard endpoint.
- [ ] Confirm Industrial Court Kuala Lumpur is visible.
- [ ] Confirm PERKESO Jalan Tun Razak and Jalan Ampang are visible.
- [ ] Confirm Google Maps and Waze readiness are visible.

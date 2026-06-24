# TESTING PROCEDURE AND TEST CASES

Version:
1.0.0

Status:
ACTIVE

Test Case TC-001:
Name: Folder structure exists
Expected Result: All PMO folders exist
Evidence: Health check report

Test Case TC-002:
Name: CSV database exists
Expected Result: TASKS, MILESTONES, RISKS, APPROVALS, CHANGE_LOG, KPI_METRICS exist
Evidence: Health check report

Test Case TC-003:
Name: Dashboard generated
Expected Result: DASHBOARD.md exists and contains current phase, status, tasks, risks and next action
Evidence: DASHBOARD.md

Test Case TC-004:
Name: Status report generated
Expected Result: Markdown report exists under 02_REPORTS
Evidence: Generated report path

Test Case TC-005:
Name: Phase 11 lock preserved
Expected Result: Dashboard states Phase 11 LOCKED
Evidence: DASHBOARD.md

Test Case TC-006:
Name: Rollback package exists
Expected Result: rollback script exists
Evidence: 11_ROLLBACK folder

Test Case TC-007:
Name: No application code modified
Expected Result: Script only creates _LEOS_CONTROL\PMO_TRACKING
Evidence: Deployment log
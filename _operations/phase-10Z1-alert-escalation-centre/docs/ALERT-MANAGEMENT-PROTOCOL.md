# ALERT MANAGEMENT PROTOCOL

## Purpose
This document defines the Phase 10Z.1 Enterprise Alert & Escalation Centre control rules for Litigation 360.

## Scope
Applies to backend alert generation, escalation routing, notification placeholders, dashboards, reports, validation and operator checks.

## Inputs
- System health signals
- Database health signals
- Backend and frontend operational signals
- Workflow, document, court, Industrial Court, PERKESO, navigation, deployment, security, performance, backup and gatekeeper signals
- Operator-created alerts
- Validation script outputs

## Outputs
- Alert records
- Escalation records
- Notification records
- Dashboard data
- Health data
- Metrics data
- Validation reports
- Operator checklists

## Parameters
Severity values:
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INFO

Status values:
- OPEN
- ACKNOWLEDGED
- ESCALATED
- RESOLVED
- CLOSED

Escalation levels:
- OPERATIONS
- MANAGER
- EXECUTIVE
- URGENT

Notification channels:
- DASHBOARD
- LOG
- EMAIL_PLACEHOLDER
- SMS_PLACEHOLDER
- WHATSAPP_PLACEHOLDER

Required categories:
- SYSTEM
- DATABASE
- BACKEND
- FRONTEND
- WORKFLOW
- DOCUMENT
- COURT
- INDUSTRIAL_COURT
- PERKESO
- NAVIGATION
- DEPLOYMENT
- SECURITY
- PERFORMANCE
- BACKUP
- GATEKEEPER

## Rules
1. Critical alerts must be visible on dashboard and escalation-ready.
2. High alerts must be visible on dashboard and manager-ready.
3. Real SMS, WhatsApp and email sending are not enabled in Phase 10Z.1.
4. Industrial Court Kuala Lumpur coverage must remain present.
5. PERKESO Kuala Lumpur / Jalan Tun Razak coverage must remain present.
6. PERKESO Headquarters / Jalan Ampang coverage must remain present.
7. Google Maps readiness, Waze readiness and court navigation readiness must remain present.
8. Deployment gatekeeper, release block, environment critical, hardening, backup and performance alerts must remain present.
9. Resolution requires operator notes and checks completed flag.
10. Validation must print PASS only when every required file, registry, route, flow and coverage check passes.

## Process
1. Create or receive alert.
2. Classify severity and category.
3. Queue dashboard notification.
4. Escalate if required.
5. Display on live dashboard endpoint.
6. Operator reviews alert.
7. Operator resolves alert with notes.
8. Validation confirms flow integrity.
9. Reports are saved under _operations.

## Validation
Use:
`cmd
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\L360-PHASE10Z1-ENTERPRISE-ALERT-ESCALATION-CENTRE.ps1" -Mode VALIDATE
`

Expected:
`	ext
PHASE 10Z.1 ALERT & ESCALATION CENTRE STATUS: PASS
`

## Operator Checklist
- Confirm backend starts.
- Confirm /api/enterprise/alerts/health works.
- Confirm /api/enterprise/alerts/metrics works.
- Confirm /api/enterprise/alerts/dashboard works.
- Confirm critical alert flow works.
- Confirm high alert flow works.
- Confirm escalation flow works.
- Confirm resolution flow works.
- Confirm Industrial Court coverage exists.
- Confirm PERKESO coverage exists.
- Confirm deployment coverage exists.
- Confirm validation report exists.

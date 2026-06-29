# Litigation 360 / LEOS 360
# Phase 14A Read-Only Discovery / Scope Map

Date: 2026-06-29
Project Root: C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
Branch: main
Current HEAD: a5f1ee8 docs(phase-13): close client lifecycle and set next-phase gate

## Current Status

Phase 14A Client Intake & Discovery Blueprint has been created.

This document performs read-only discovery and scope mapping only.

Implementation Status: NOT STARTED
Production Rollout Status: BLOCKED

## Purpose

Identify existing files, modules, and terminology related to the future Client Intake & Discovery workflow before any implementation is approved.

## Read-Only Discovery Search Areas

- clients
- matters
- intake
- questionnaires
- proposals
- engagement
- fees
- budgets
- documents
- evidence
- stakeholders
- contacts
- scope
- risk

## Likely Related Files Found

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\migrate-clients-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\migrate-matters-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-client-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-delete-client-audit-only.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-delete-client-exact.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-documents-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-matters-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\patch-matters-audit-linebased.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\repair-clients-route-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\repair-documents-deadlines-audit.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\enterprise\automation-handlers\clientCreatedHandler.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\enterprise\automation-handlers\matterCreatedHandler.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\enterprise\automation-handlers\test-client-created-handler.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\licensing\ground-zero-client.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\documentLifecycleEngine.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\matterIntelligenceEngine.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\riskScoringEngine.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\handlers\clientCreated.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\handlers\documentUploaded.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\handlers\matterCreated.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\migrations\005_create_matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Client.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Document.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Matter.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\clientIdentity.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\clients.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\documentLifecycleRoutes.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\documents.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\intake.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\matterIntake.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\matterIntelligenceRoutes.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\matterNumbering.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\utils\clientIdentityEngine.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\utils\matterIntakeWizard.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\utils\matterNumberGenerator.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\tools\phase9a-matter-numbering-setup.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\tools\phase9b-client-identity-setup.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\tools\phase9d-matter-intake-setup.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\configs\document-intake-config.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\MASTER-DOCUMENTATION-INDEX.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\historical-reconstruction\registries\MASTER-EVIDENCE-REGISTRY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\MASTER-HANDBOOK\25-RISK-REGISTER.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\MASTER-SYSTEM\MASTER-DOCUMENTATION-INDEX.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\mvp-roadmap\MVP_SCOPE_LOCK.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\CLIENT_BUTTON_LABEL_MICROCOPY_FIX_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_PANELS_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_MATTER_INTAKE_WIZARD_NAVIGATION_HOTFIX_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_R_MATTER_INTAKE_WIZARD_RUNTIME_RECOVERY_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_S_MATTER_INTAKE_EDITABLE_CLIENT_SEARCH_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_T_MATTER_INTAKE_EDITABLE_CLIENT_STEP_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_U_MATTER_INTAKE_CLIENT_SEARCH_UI_POLISH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_V_MATTER_INTAKE_FLOW_COHESION_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_W_UNIFIED_CLIENT_FLOW_SOURCE_AUDIT_AND_MERGE_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_X_UNIFIED_CLIENT_FLOW_TRIGGER_RETURN_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z1_SHARED_CLIENT_LABEL_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z2_B_CLIENT_SEARCH_GATE_PROTECTED_CREATION_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z2_CLIENT_SEARCH_GATE_PROTECTED_CREATION_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_A_CLIENT_PROFILE_MODERNIZATION_PRESERVATION_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_B_FULL_CLIENT_PROFILE_FIELD_REGISTRY_EXTRACTION_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_C2_CSS_FIRST_FULL_CLIENT_PROFILE_SECTION_CARD_SHELL_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_D_EXPLICIT_CLIENT_PROFILE_SECTION_WRAPPER_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_E_EXPLICIT_CLIENT_PROFILE_SECTION_WRAPPER_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z3_G1_STATIC_CLIENT_PROFILE_SUMMARY_RAIL_SHELL_PATCH_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_Z4_CLIENT_PROFILE_VALIDATION_COMPLETION_INTELLIGENCE_BLUEPRINT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\closeout\PHASE_13_CLIENT_LIFECYCLE_CLOSEOUT_AND_NEXT_PHASE_DECISION_GATE_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\closeout\PHASE_13E4Z_OVERALL_CLIENT_PROFILE_MODERNIZATION_CLOSEOUT_SSOT_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\project-control\phase-8\PHASE_8F_CLIENTS_FRONTEND_POST_COMMIT_CLOSEOUT_20260626.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_BROWSER_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13E4Z_V_MATTER_INTAKE_FLOW_COHESION_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13E4Z_X_UNIFIED_CLIENT_FLOW_TRIGGER_RETURN_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13E4Z_Z3_C2_CSS_FIRST_FULL_CLIENT_PROFILE_SECTION_CARD_SHELL_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13E4Z_Z3_E_EXPLICIT_CLIENT_PROFILE_SECTION_WRAPPER_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13E4Z_Z3_G1_STATIC_CLIENT_PROFILE_SUMMARY_RAIL_QA_20260627.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\risk-compliance\RISK_REGISTER.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\enterprise\governance\RiskManagement\RiskRegister.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\ClientsBackUpCopy.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Documents.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\MatterIntakeWizard.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Matters.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\services\clientService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\utils\formatters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\L360_CLIENT_PROFILE_FRONTEND_PATCH_PACK.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\client-profile\ValidatedField.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\lib\addressLookupService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\lib\clientProfileRules.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\styles\clientProfileEnhancements.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\01_PHASE_13B_FRONTEND_STATUS_CLARITY_STATUS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\02_PHASE13B_INJECTOR_PARSE_ERROR_FIXED.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\100_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\103_SAFE_GIT_BASELINE_ONLY_V2_REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\104_VERIFY_SAFE_GIT_BASELINE_V2_READONLY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\99_FINAL_CURRENT_STATE_AFTER_PHASE13B.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\PHASE13C_FINALIZED_V4_AFTER_REBOOT_20260624_181539.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_ACTIVE_CONTROL\PHASE13C_FINALIZED_V4_AFTER_REBOOT_20260624_182536.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\00_READ_FIRST\README-FIRST.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\01_PARAMETERS\PHASE-13-PARAMETERS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\02_PROTOCOLS\PHASE-13-SAFETY-PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\03_PHASE_13_ROADMAP\PHASE-13-ROADMAP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\04_PHASE_13B_QA\PHASE-13B-QA-CLIENTS-VERIFICATION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\05_PHASE_13C_ADDRESS_INTELLIGENCE\PHASE-13C-ADDRESS-INTELLIGENCE-PLAN.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\06_PHASE_13D_DISCOVERY_ONLY\PHASE-13D-DISCOVERY-ONLY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\07_PHASE_13E_UI_POLISH\PHASE-13E-UI-POLISH-PLAN.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\08_COPILOT_PROMPTS\PHASE-13-COPILOT-PROMPTS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\09_CHECKS_BALANCES\PHASE-13-CHECKS-AND-BALANCES.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\10_TESTING_VERIFICATION\PHASE-13-TESTING-VERIFICATION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\11_MONITORING\PHASE-13-LIVE-MONITORING-SPEC.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\12_REPORTS\PHASE-13-CONTROL-PACK-STATUS-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-CONTROL-QA-ROADMAP\14_NEXT_ACTION\PHASE-13-NEXT-ACTION-QUEUE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\00_READ_FIRST\README-FIRST.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\01_PARAMETERS\PARALLEL-WORKCELL-PARAMETERS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\02_PROTOCOLS\PARALLEL-WORKCELL-PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\03_PARALLEL_LANES\PARALLEL-LANES-BOARD.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\04_COPILOT_PROMPTS\COPILOT-PARALLEL-PROMPTS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\05_POWER_SHELL_COMMANDS\POWERSHELL-COMMAND-BOARD.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\06_BROWSER_QA\BROWSER-QA-BOARD.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\07_CHECKS_BALANCES\PARALLEL-CHECKS-AND-BALANCES.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\08_TESTING_VERIFICATION\PARALLEL-TESTING-VERIFICATION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\09_MONITORING\PARALLEL-LIVE-MONITOR-SPEC.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\10_REPORTS\PARALLEL-WORKCELL-STATUS-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_CLIENT_PROFILE_PATCH_ROLLBACK_ARCHIVE_20260624_220643\_L360_CONTROL\PHASE-13-PARALLEL-WORKCELL\12_NEXT_ACTION\NEXT-ACTION-QUEUE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE_8F_R_SOURCE_20260626\Clients.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE_8F_S_SOURCE_20260626\Clients.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\phase-10ZZD-commercialisation-framework\commercial-risk\COMMERCIAL-RISK-REGISTER.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\phase-10ZZD-commercialisation-framework\deployment\CLIENT-DEPLOYMENT-PLAYBOOK.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\phase-10ZZD-commercialisation-framework\onboarding\CLIENT-ONBOARDING-PROCESS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE\03_DOCUMENT_LEARNING_ENGINE\DOCUMENT_LEARNING_RULES.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE\08_MATTER_HEALTH_MONITOR\MATTER_HEALTH_RULES.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9A-MATTER-NUMBERING-BLUEPRINT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9A-MATTER-NUMBERING-COMPLETE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9B-CLIENT-IDENTITY-BLUEPRINT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9B-CLIENT-IDENTITY-COMPLETE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9D-MATTER-INTAKE-WIZARD-BLUEPRINT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\reports\phase9\PHASE9D-MATTER-INTAKE-WIZARD-COMPLETE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\migrate-clients-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\migrate-matters-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-client-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-delete-client-audit-only.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-delete-client-exact.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-documents-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-matters-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\patch-matters-audit-linebased.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\repair-clients-route-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\repair-documents-deadlines-audit.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\matterService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\migrations\005_create_matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\models\Client.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\models\Document.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\models\Matter.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\routes\clients.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\routes\documents.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\routes\matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\utils\matterNumberGenerator.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\migrate-clients-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\migrate-matters-auditlogger.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-client-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-delete-client-audit-only.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-delete-client-exact.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-documents-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-matters-audit-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\patch-matters-audit-linebased.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\repair-clients-route-approved.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\repair-documents-deadlines-audit.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\matterService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\migrations\005_create_matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\models\Client.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\models\Document.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\models\Matter.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\routes\clients.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\routes\documents.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\routes\matters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\utils\matterNumberGenerator.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\frontend\src\pages\Clients.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\frontend\src\pages\Documents.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\frontend\src\pages\Matters.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\frontend\src\services\clientService.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\frontend\src\utils\formatters.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7c-complete\tests\clients.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7c-complete\tests\documents.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7c-complete\tests\matters.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7c-testing-started\tests\clients.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\tests\client-identity.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\tests\clients.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\tests\documents.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\tests\matter-intake.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\tests\matters.test.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_PHASE_09_5_ENTERPRISE_CORE\documentation\00_PHASE_09_5_MASTER_README.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_PHASE_09_5_ENTERPRISE_CORE\prompts\01_DOCUMENT_CLASSIFICATION_PROMPT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_PHASE_09_5_ENTERPRISE_CORE\protocols\02_DOCUMENT_INTAKE_PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212032\App.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212032\App.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212032\index.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212032\main.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212938\App.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212938\App.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212938\index.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_212938\main.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_213436\App.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_213436\App.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_213436\index.css
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_RUNNER\CLIENT_PROFILE_FRONTEND_PATCH_BACKUP_20260624_213436\main.jsx
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\03_ROLLBACK\MATTER-DETAILS-ROLLBACK-PLAN.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-TEST-PLAN.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-VERIFICATION-CHECKLIST.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\PHASE12.0D-F-MANUAL-BROWSER-TEST-CHECKLIST.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\PHASE12.0E-READINESS-MATTER-TYPE-DISCOVERY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\05_MONITORING\MATTER_DETAILS\MATTER-DETAILS-FAST-TARGET-DISCOVERY-PROGRESS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\05_MONITORING\MATTER_DETAILS\MATTER-DETAILS-LIVE-PROGRESS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\05_MONITORING\MATTER_DETAILS\PHASE12.0D-F-MATTER-DETAILS-LIVE-STATUS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\06_AI_PROMPTS\MATTER_DETAILS\01-MATTER-DETAILS-IMPLEMENTATION-PROMPT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\06_AI_PROMPTS\MATTER_DETAILS\02-MATTER-DETAILS-DISCOVERY-PROMPT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\07_DISCOVERY\MATTER_DETAILS\MATTER-DETAILS-FAST-TARGET-SCAN-SUMMARY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\07_DISCOVERY\MATTER_DETAILS\MATTER-DETAILS-TARGET-FILE-SCAN-SUMMARY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\08_BLUEPRINTS\MATTER_DETAILS\MATTER-DETAILS-MASTER-BLUEPRINT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\09_PARAMETERS\MATTER_DETAILS\MATTER-DETAILS-PARAMETERS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\10_PROTOCOLS\MATTER_DETAILS\MATTER-DETAILS-IMPLEMENTATION-PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0B-MATTER-DETAILS-GOVERNANCE-PACK-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0D-A-MATTER-DETAILS-TARGET-LOCK-PREPATCH-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0D-B-R3-MATTER-DETAILS-UI-PATCH-VERIFICATION-REPAIR-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0D-C-R2-MATTER-DETAILS-RUNTIME-SAFETY-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0D-E-MATTER-DETAILS-UI-LAYOUT-POLISH-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\99_LOGS\PHASE12.0D-F-MATTER-DETAILS-FUNCTIONAL-CERTIFICATION-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-CONTACT-FORM-PATCH-REPORT-20260622-110136.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-CONTACT-FORM-V4-REPORT-20260622-113932.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-FORM-LAYOUT-STABILIZER-REPORT-20260622-110554.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V5-REPORT-20260622-120611.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V6-ALIGNMENT-VERIFICATION-DOCUMENTATION-REPORT-20260622-124152.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-1-FIELD-ALIGNMENT-NRIC-STATE-REGION-REPORT-20260622-133449.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-2-HOTFIX-REPORT-20260622-135047.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-2-MANDATORY-SINGLE-LINE-REPORT-20260622-134122.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-2-REQUIRED-FIELD-PARSE-REPAIR-REPORT-20260622-134504.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-3-SYNTAX-REPAIR-REPORT-20260622-135358.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-3-SYNTAX-REPAIR-REPORT-20260622-135738.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-4-FIELDLABEL-SYNTAX-REPAIR-REPORT-20260622-140948.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-6-IDENTIFIER-STAR-CLEANUP-REPORT-20260622-141546.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-PROFILE-V8-7-SAFE-FIELDLABEL-CLEANUP-REPORT-20260622-143613.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-REGISTRATION-ENHANCEMENT-REPORT-20260622-104525.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-SAVE-UI-FIX-REPORT-20260622-102720.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-TABLE-ENHANCEMENT-REPORT-20260622-101440.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\CLIENT-UI-V7-ALIGNMENT-NAV-RELATIONSHIP-REPORT-20260622-125954.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5A-CLIENTS-JSX-PARSE-FIX-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5B-CLIENTS-JSX-FIELDLABEL-CORRUPTION-SWEEP-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5D-CLIENTS-JSX-FUNCTION-NAME-CORRUPTION-FIX-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5E-CLIENTS-JSX-READONLY-FORENSIC-CHECK-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5F-CLIENTS-JSX-GENDER-TOKEN-CORRUPTION-FIX-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5G-CLIENTS-JSX-REMAINING-STAR-TOKEN-SWEEP-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5H-CLIENTS-JSX-REQUIRED-MARKER-FIX-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5I-CLIENTS-JSX-STRUCTURE-RESTORATION-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\PHASE-12.0N-R5J-CLIENTS-JSX-DUPLICATE-ISBLANK-FIX-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\reports\V7-APP-NAV-CLIENT-ALIGNMENT-VERIFICATION-REPORT-20260622-130316.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\executive-knowledge-registry\KNOWN-RISKS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10E-document-lifecycle-engine\docs\PHASE10E-DOCUMENT-LIFECYCLE-PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10E-document-lifecycle-engine\reports\phase10E-document-lifecycle-report.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10E-document-lifecycle-engine\validation\validate-phase10E-document-lifecycle.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10G-matter-intelligence-engine\docs\PHASE10G-MATTER-INTELLIGENCE-PROTOCOL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10G-matter-intelligence-engine\reports\phase10G-matter-intelligence-report.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10G-matter-intelligence-engine\validation\validate-phase10G-matter-intelligence.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10N-governance\templates\RISK-TEMPLATE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10X4-deployment-scoring-engine\docs\ENTERPRISE-RISK-MODEL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10Y-gui-stabilisation\docs\PHASE10Y_DOCUMENTATION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10Y0-enterprise-master-registry-digital-twin\registries\documents-registry.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10Z3-predictive-intelligence-engine\docs\COURT-RISK-PREDICTION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10Z3-predictive-intelligence-engine\docs\DEPLOYMENT-RISK-PREDICTION.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10Z3-predictive-intelligence-engine\docs\RISK-SCORING-MODEL.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\docs\DOCUMENTATION-LIFECYCLE-POLICY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\gaps\DOCUMENTATION-GAP-ANALYSIS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\matrices\DOCUMENTATION-COVERAGE-MATRIX.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\matrices\DOCUMENTATION-OWNERSHIP-MATRIX.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\registry\MASTER-DOCUMENTATION-REGISTRY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\reports\DOCUMENTATION-DUPLICATION-REPORT.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ0-enterprise-documentation-governance-audit\reports\PHASE-10ZZ0-SUMMARY.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1-sop-governance-audit\sops\CLIENT-INTAKE-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1-sop-governance-audit\sops\DOCUMENT-LIFECYCLE-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1-sop-governance-audit\sops\MATTER-MANAGEMENT-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\sops\CLIENT-INTAKE-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\sops\DOCUMENT-LIFECYCLE-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\sops\MATTER-MANAGEMENT-SOP.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ8-enterprise-knowledge-management\playbooks\CLIENT-INTAKE-PLAYBOOK.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ8-enterprise-knowledge-management\playbooks\MATTER-OPENING-PLAYBOOK.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ8-enterprise-knowledge-management\risk-registry\KNOWN-RISKS.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-enterprise-control-centre\matter-control\MATTER-CONTROL-SUMMARY.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-enterprise-control-centre\risk-control\RISK-CONTROL-DASHBOARD.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\01-change-intake\CHANGE-REQUEST-TEMPLATE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\03-risk-control\RISK-CONTROL-MATRIX.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZA-change-enforcement-engine\07-risk-command-centre\RISK-COMMAND-CENTRE.md
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_V1_INTAKE_CONVEYOR_DEPLOYMENT_20260621-212236\DOCS\INTAKE-CONVEYOR-BLUEPRINT.md
```

## Keyword Matches

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:10: │                          CLIENT LAYER                            │
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:72: - Client Portal Access
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:126: 4. Client stores token (secure storage)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:127: 5. Client sends token in Authorization header
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:165: ├── Client (Portal)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:192: **3. Client Management Service**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:193: - Client profiles
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:195: - Client communications
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:196: - Client history
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:295: clients
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:309: ├── client_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:346: ├── client_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:393: 4. Return to client
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:409: - Client data
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:496: - Attorney-client communications
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:626: 1. Client makes change
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:72: Client lifecycle
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:95: Future client portal
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:119: Client rollout: BLOCKED
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:376: Client data
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:431: Client Details
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:445: Client
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:495: Ground Zero is preserved as a planned founding-client rule from previous handovers.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:503: UNLIMITED_FOUNDING_CLIENT
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:548: Clients
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:558: Client CRUD: PASS
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:704: Current client rollout state:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:734: Client rollout
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:828: Client portal
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:838: Client portal expansion
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:862: The project scope includes clients, matters, documents, court operations, staff, monitoring, automation, governance, reporting, compliance, and future AI.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:892: Client Details
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:930: Client, matter, deadline, document, court date, and staff modules may remain standalone management modules.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1128: Controls certification, evidence, production approval, Phase 11 authorisation, and client rollout.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1397: [ ] Client rollout decision documented
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1580: Client Portal
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1638: Client portal
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:2013: Client rollout:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:2051: Client rollout
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:24: Client rollout: BLOCKED
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:143: "permissions": ["read:matters", "write:bills"],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:169: Scope: Firm, Matter, Document
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:199: **4. Matter Service (Core)**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:200: - Matter creation & management
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:201: - Matter status tracking
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:202: - Matter templates
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:203: - Matter stages
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:204: - Matter timeline
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:251: - Matter reports
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:306: matters
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:322: ├── matter_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:335: ├── matter_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:345: ├── matter_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:360: ├── matter_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:369: ├── matter_id (FK)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:408: - Matter data (frequently accessed)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:421: │   ├── matters/{matter_id}/
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:447: ├── Matter Events
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:448: │   ├── matter.created
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:449: │   ├── matter.updated
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:450: │   └── matter.closed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:647: ├── /matters/* → Matter Service
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:73: Matter lifecycle
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:433: Matter Details
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:449: Matter
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:550: Matters
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:562: Matter workflow / intake integration: IN PROGRESS depending on branch
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:581: Matter intelligence engine
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:862: The project scope includes clients, matters, documents, court operations, staff, monitoring, automation, governance, reporting, compliance, and future AI.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:894: Matter Details
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:930: Client, matter, deadline, document, court date, and staff modules may remain standalone management modules.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1288: Matter intelligence
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:25: Matter Type database migration: NOT RUN
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:26: Matter Type frontend/backend/API implementation: NOT STARTED
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:53: 2. Phase 12.0H Matter Type migration path.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:138: - Matter Type has not been added.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:139: - Backend/API/frontend have not been patched for Matter Type.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:229: 4. Matter Type migration is not run.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:230: 5. Matter Type is not added to database/backend/API/frontend.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:314: ### 3.5 Matter Type Completion
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:427: Approved intake workflow:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:465: It is not a standalone intake wizard.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:562: Matter workflow / intake integration: IN PROGRESS depending on branch
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:884: Decision 003 — Embedded Intake Workflow Approved
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:912: Decision 004 — Standalone Intake Wizard Deprecated
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:916: Standalone duplicate intake is deprecated.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1190: Variation G — Embedded Intake Workflow 10.5
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1198: Preserves approved operational intake journey.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1301: Standalone intake wizard
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1302: Separate intake page
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1303: Return-home-between-intake-stages workflow
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE10X3A-ENTERPRISE-ARCHITECTURE-REGISTRY.js:201: "NEW_CLIENT_INTAKE",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE10Y0-ENTERPRISE-MASTER-REGISTRY-DIGITAL-TWIN.js:209: "NEW_CLIENT_INTAKE",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE10Y0-ENTERPRISE-MASTER-REGISTRY-DIGITAL-TWIN.js:406: affected: ["Client Intake", "Matter Creation", "Court Preparation", "Document Review", "Task Progress"]
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\database.js:158: CREATE TABLE IF NOT EXISTS matter_intake_drafts (
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:32: // ─── Score a candidate client against the intake data ─────────────────────
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:33: function scoreClientMatch(candidate, intake) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:39: const icB = normaliseIC(intake.ic_number);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:45: if (candidate.email && intake.email &&
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:46: candidate.email.toLowerCase() === intake.email.toLowerCase()) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:52: const phoneB = (intake.phone || '').replace(/[^0-9]/g, '');
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:58: const nameSim = nameSimilarity(candidate.full_name, intake.full_name);
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:65: if (candidate.date_of_birth && intake.date_of_birth &&
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:66: candidate.date_of_birth === intake.date_of_birth) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:74: async function checkClientDuplicates(intake) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:77: } = intake;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:99: .map(c => scoreClientMatch(c, intake))
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:111: async function checkMatterDuplicates(intake) {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:112: const { client_id, matter_type, opposing_party } = intake;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\duplicateService.js:123: .whereIn('status', ['intake', 'review', 'active', 'hearing'])
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:74: app.use("/api/intake", require("./routes/intake"));
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:92: app.use("/api/matter-intake", require("./routes/matterIntake"));
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:13: // ─── Create a new matter (full intake flow) ───────────────────────────────
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:47: status:            'intake',
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:62: to_status:   'intake',
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:64: notes:       'Matter created via intake form',
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:84: intake:    ['review'],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\matterService.js:85: review:    ['active', 'intake'],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\ecosystemOrchestrationEngine.js:6: "Intake",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\workflowEngine.js:15: NEW_CLIENT_INTAKE: {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:15: - Initial questionnaire (customizable)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:15: - Initial questionnaire (customizable)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\LITIGATION_360_LEOS_SSOT_HANDOVER_V12_2_POST_12_0F_PRE_12_0G.md:34: No future variation, patch, script, documentation pack, UI enhancement, backend change, database change, or Phase 11 proposal may contradict this SSOT.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:263: - Proposal documentation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:263: - Proposal documentation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:68: 3. **Engagement Letter**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:89: ✅ Active matter with engagement letter signed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:161: - Expert engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:441: - Expert engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\06-integrations.md:196: - Feature engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\legal-management-enhancer.js:49: ["Client Files", "Client profiles, IDs, engagement letters, KYC and contact records."],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\legal-management-enhancer.js:62: ["Client Due Diligence", "Checks used to verify identity, risk, authority and suitability before or during engagement."],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\legal-management-enhancer.js:65: ["Retainer", "The engagement arrangement between the client and the legal practitioner or firm."],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:27: { icon: "ðŸ“", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:44: { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:47: { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE-12.0K-LEGAL-INTERFACE-UI-PROTOTYPE-PACK\LegalManagementShell.jsx:26: { icon: "📁", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE-12.0K-LEGAL-INTERFACE-UI-PROTOTYPE-PACK\LegalManagementShell.jsx:43: { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE-12.0K-LEGAL-INTERFACE-UI-PROTOTYPE-PACK\LegalManagementShell.jsx:46: { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:68: 3. **Engagement Letter**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:89: ✅ Active matter with engagement letter signed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:161: - Expert engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:441: - Expert engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\06-integrations.md:196: - Feature engagement
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:26: { icon: "ðŸ“", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:43: { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:46: { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface\LegalManagementShell.jsx:26: { icon: "ðŸ“", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface\LegalManagementShell.jsx:43: { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface\LegalManagementShell.jsx:46: { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package-lock.json:817: "integrity": "sha512-i6b4qw5qnP8c5FEeBJg/uZQ4ddrkN6Ca8qISJh0pr7a5hfn3h3v5x60BEbOC7OYAGZNMs1LfFLwnW2CuK8F57Q==",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Matter.js:29: type: DataTypes.ENUM('hourly', 'flatFee', 'contingency', 'hybrid'),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Matter.js:33: flatFee: DataTypes.DECIMAL(12, 2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:38: - Refer to external firm (with referral fee tracking)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:71: - Fee structure specification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:203: - Payment processing (filing fees)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:265: - Alternative fee discussions
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:305: - Court filing fees
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:306: - Expert witness fees
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:339: - Flat fee
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:397: - Earned fee transfers
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\03-database-schema.md:117: flat_fee DECIMAL(12,2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:28: Reuse canonical contact details, add address synchronization, enforce minimum phone digit validation, and improve save-block feedback.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3_MENU_ACTION_WIRING_PLAN_20260627.md:86: ### Phase 13B.3A - File Action Feedback Panels
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3_MENU_ACTION_WIRING_PLAN_20260627.md:141: Phase 13B.3A - File Action Feedback Panels
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3_MENU_ACTION_WIRING_PLAN_20260627.md:144: The File menu currently contains action items that should not feel dead.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_PANELS_20260627.md:2: # Phase 13B.3A File Action Feedback Panels
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_PANELS_20260627.md:12: The following items existed but did not provide useful visible feedback:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3E_MENU_ACTION_WIRING_CLOSEOUT_SSOT_20260627.md:19: ### Phase 13B.3A File Action Feedback Panels
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B4C_MENU_PLATFORM_FINAL_CLOSEOUT_20260627.md:64: - File action feedback panels
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13D1_MODULE_FRAME_POLISH_PLANNING_20260627.md:42: The goal is to make opened modules feel consistent, guided, and professional.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13D1_MODULE_FRAME_POLISH_PLANNING_20260627.md:56: - Review / Save & Submit should feel like a final workflow step
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13D1_MODULE_FRAME_POLISH_PLANNING_20260627.md:57: - Matter Intake should feel like the beginning of the guided process
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E1_WORKSPACE_DASHBOARD_POLISH_PLANNING_20260627.md:48: - The page should feel like a workflow command centre, not just a list of cards
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E3_WORKSPACE_DASHBOARD_UX_BLUEPRINT_20260627.md:32: The End User Workspace should feel like a guided legal workflow command centre.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E3_WORKSPACE_DASHBOARD_UX_BLUEPRINT_20260627.md:180: - hover feedback
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_V_MATTER_INTAKE_FLOW_COHESION_PATCH_20260627.md:12: Browser review showed the sequence could feel disjointed:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13E4Z_W_UNIFIED_CLIENT_FLOW_SOURCE_AUDIT_AND_MERGE_BLUEPRINT_20260627.md:107: - It feels disconnected from the Matter Intake conveyor.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\project-control\phase-8\PHASE_8F_POST_COMMIT_BROWSER_QA_DIRECTORY_DEFECT_20260626.md:39: Some results appear to overlap. Some controls appear pointless, not functioning, or not informative. The search and display path needs clearer linkage, better visual hierarchy, and more useful result feedback.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\project-control\phase-8\PHASE_8F_POST_COMMIT_BROWSER_QA_DIRECTORY_DEFECT_20260626.md:75: - Improve visual display and result feedback.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_BROWSER_QA_20260627.md:2: # Phase 13B.3A File Action Feedback Panels Browser QA
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\qa\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_BROWSER_QA_20260627.md:34: Phase 13B.3A File Action Feedback Panels: COMPLETE
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:121: background: #fee2e2;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css:4061: background: #fee2e2;
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\legal-management-enhancer.js:54: ["Billing / Finance", "Invoices, receipts, fee notes, disbursements and payment records."],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\components\legal-management-shell\LegalManagementShell.jsx:32: { icon: "ðŸ§¾", title: "Billing / Finance", description: "Invoices, receipts, fee notes and disbursement tracking." }
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\components\BackendConnectivityPanel.jsx:21: background: item.ok ? "#d1fae5" : "#fee2e2"
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\enterprise\components\EnterpriseStatusCard.jsx:10: : "#fee2e2";
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\menuConfig.js:89: keywords: ["support", "ticket", "bug", "feedback", "screenshot", "crash"],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\features\menu-platform\panels\SupportRequestPanel.jsx:9: "UI / UX Feedback",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:316: ├── budget
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models\Matter.js:36: budget: DataTypes.DECIMAL(12, 2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:317: 4. **Budget Monitoring**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:318: - Matter budget creation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:319: - Actual vs. budget comparison
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\03-database-schema.md:120: budget DECIMAL(12,2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\phase-10ZZD-commercialisation-framework\onboarding\CLIENT-ONBOARDING-PROCESS.md:11: - Budget range
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\backend\src\models\Matter.js:36: budget: DataTypes.DECIMAL(12, 2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:317: 4. **Budget Monitoring**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:318: - Matter budget creation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:319: - Actual vs. budget comparison
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\03-database-schema.md:120: budget DECIMAL(12,2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase7b-security-complete\backend\src\models\Matter.js:36: budget: DataTypes.DECIMAL(12, 2),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZC-family-succession-framework\authority-matrix\FAMILY-AUTHORITY-MATRIX.md:10: | Budget Approval | A | C | I | I | C |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:35: │  │ - Document Service             │  │
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:71: - Document Viewer
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:169: Scope: Firm, Matter, Document
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:206: **5. Document Service**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:207: - Document upload/download
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:208: - Document versioning
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:211: - Document sharing
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:219: - Document coding
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:263: - Document classification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:320: documents
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:422: │   │   ├── documents/
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:451: ├── Document Events
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:452: │   ├── document.uploaded
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:453: │   ├── document.processed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:454: │   └── document.deleted
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:497: - Work product documents
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:648: ├── /documents/* → Document Service
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:13: This document consolidates all project handovers, SSOT drafts, governance branches, certification controls, workflow decisions, variation logs, lock-control rules, and implementation safeguards discussed in this thread.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:15: This document supersedes and reconciles the following previously drafted or supplied authorities:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:22: Version 10ZZZ.3 — Governed Handover and Certification Control Document
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:26: This consolidated document is now the single source of truth for the next continuation step.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:28: No branch, feature, script, cleanup, deployment, audit, certification, or future thread may contradict this document.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:78: Document lifecycle
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:79: Document governance
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:111: Document-level consolidation: ACTIVE
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:146: Create one actual project-level SSOT control foundation based on this consolidated document.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:161: Documentation integrity review
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:189: This document is the master SSOT.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:191: All future documents, scripts, folders, reports, audits, registers, roadmaps, checklists, and prompts must inherit from this document.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:260: Documentation Update
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:302: Documentation consolidation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:346: Documentation
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:349: Naming cleanup in documents only
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:437: Document Details
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:457: Document
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:553: Documents
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:561: Document CRUD: PASS
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:579: Document lifecycle engine
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:593: Documentation governance established
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:671: Current document state:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:117: Evidence folders created: NOT YET CONFIRMED
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:130: Phase 10 governance, validation, module certification, repository governance, runtime verification, evidence collection, and certification control remain active.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:154: Evidence folders
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:169: Evidence before assumptions.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:171: Nothing is complete unless evidence exists.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:173: No gate may be marked PASS unless evidence exists.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:175: No gate may be marked FAIL unless evidence exists.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:179: Lack of evidence means:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:181: PENDING EVIDENCE
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:296: Evidence collection
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:524: It does not override security, evidence, certification, or deployment controls.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:598: Evidence collection architecture defined
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:696: Current evidence state:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:698: Evidence collection active conceptually, but actual project evidence folders are not yet confirmed to exist.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:716: Create evidence architecture
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:728: Run read-only evidence collection
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:759: Evidence folders
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:788: Evidence collection
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:789: Evidence verification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:801: Enterprise testing evidence
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:944: Phase 10 may be treated as structurally complete, but governance, validation, certification, module certification, repository review, and evidence collection remain active.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:982: Decision 009 — Evidence Before Assumptions
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:986: No claim may be accepted without evidence.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:990: The project has many branches and handovers. Evidence prevents false confidence.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1070: Planned modules cannot be activated unless frontend route, backend route, API, RBAC, logging, audit, and testing evidence exist.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1128: Controls certification, evidence, production approval, Phase 11 authorisation, and client rollout.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1267: Evidence Collection Framework
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1358: [ ] Evidence path recorded
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1359: [ ] PASS / FAIL assigned only with evidence
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1391: [ ] Evidence collected
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1392: [ ] Evidence verified
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1471: Create evidence categories:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1516: Evidence folder check
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1522: No PASS without evidence.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1524: No FAIL without evidence.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1526: Unknown results remain PENDING EVIDENCE.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1536: Evidence Collection
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1540: Evidence Verification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1668: Evidence-based certification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1757: Evidence
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:76: 4. **Stakeholder Management**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\05-security-compliance.md:331: Notification: Stakeholders notified per requirements
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\02-workflow-phases.md:76: 4. **Stakeholder Management**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\snapshots\phase6c-complete\docs\05-security-compliance.md:331: Notification: Stakeholders notified per requirements
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\08-deployment-control\DEPLOYMENT-CONTROL-PLAN.md:38: [ ] Stakeholders informed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\15-incident-response\INCIDENT-RESPONSE-PLAN.md:26: 6. Notify stakeholders
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:194: - Contact information
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:86: - Emergency Contact and Documentation Verification were separated.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:621: - Client identity and contact data must be consistent and auditable.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package-lock.json:2935: "deprecated": "Old versions of glob are not supported, and contain widely publicized security vulnerabilities, which have been fixed in the current version. Please update. Support for old versions may be purchased (at exorbitant rates) by contacting i@izs.me",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package-lock.json:5265: "deprecated": "Old versions of glob are not supported, and contain widely publicized security vulnerabilities, which have been fixed in the current version. Please update. Support for old versions may be purchased (at exorbitant rates) by contacting i@izs.me",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\package-lock.json:5190: "deprecated": "No longer maintained. Please contact the author of the relevant native addon; alternatives are available.",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:121: // L360_V3K2_SAFE_GOOGLE_CONTACTS_PLACEHOLDER_ROUTE
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:122: app.get("/api/google-contacts/search", (req, res) => {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:128: connector: "google-contacts",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:130: contacts: [],
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\index.js:132: "Google Contacts backend placeholder route exists. OAuth/Google People API integration is not configured yet."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\02-workflow-phases.md:54: - Contact information capture
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\03-database-schema.md:247: from_contact_id UUID REFERENCES clients(id),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\03-database-schema.md:249: to_contact_id UUID REFERENCES clients(id),
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\05-security-compliance.md:33: - Contact information
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\05-security-compliance.md:338: ## 📞 Security Contacts
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\07-mobile-strategy.md:68: - Contacts
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-8\PHASE_8F_FINAL_CLOSEOUT_20260626.md:16: 107dc66 fix(clients): reuse contact details and sync correspondence address
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-8\PHASE_8F_FINAL_CLOSEOUT_20260626.md:17: 2dd761b fix(clients): prevent duplicate preferred contact choices
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-8\PHASE_8F_FINAL_CLOSEOUT_20260626.md:35: - Duplicate preferred contact choices cannot be selected
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-8\PHASE_8F_FINAL_CLOSEOUT_20260626.md:46: - Backup / alternate contact toggle does not crash
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-8\PHASE_8F_FINAL_CLOSEOUT_20260626.md:47: - Backup / alternate contact is used only when explicitly enabled
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\features\EMAIL_1_CLOSEOUT_20260627.md:28: EMAIL-2: Integrate EmailAutocompleteInput into one safe client/contact form only.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\features\EMAIL_AUTOCOMPLETE_FIELD.md:14: This phase does not integrate the component into live client, contact, matter, user, or firm forms.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:9: Current HEAD confirmed by terminal output: `107dc66 fix(clients): reuse contact details and sync correspondence address`
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:11: - `2dd761b fix(clients): prevent duplicate preferred contact choices`
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:20: `4. Contact Information and Communication Preferences`
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:25: Prevent duplicate preferred contact method selections and add visible contact-choice guard behaviour.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:28: Reuse canonical contact details, add address synchronization, enforce minimum phone digit validation, and improve save-block feedback.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:33: HEAD: 107dc66 fix(clients): reuse contact details and sync correspondence address
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:39: The implementation and build are complete. However, this audit cannot honestly certify 100% final closure until the final browser QA checklist is explicitly passed, especially the backup/alternate contact toggle path.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:166: #### Phase 8F-R: Duplicate Preferred Contact Choice Guard
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:173: Duplicate preferred contact methods are prevented across 1st–5th choices.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:175: A visible preferred contact guard panel was added.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:178: Inline errors are associated with duplicate preferred contact fields.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:179: Email selected as a contact choice reuses the main Email Address where available.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:182: #### Phase 8F-S: Canonical Contact Reuse + Address Sync + Phone Gate
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:189: Email contact choice reuses the main Email Address.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:192: Backup/alternate number support exists for preferred contact detail where explicitly enabled.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:193: Reused contact values are displayed as greyed-out read-only fields.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\10ZZD-LEGAL-ERP-INTEGRATION.md:17: SCOPE
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\ARCHITECTURE.md:169: Scope: Firm, Matter, Document
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:862: The project scope includes clients, matters, documents, court operations, staff, monitoring, automation, governance, reporting, compliance, and future AI.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1751: Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:48: ## 1. Audit Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:733: | Treat project as LEOS | Scope exceeds normal case management | Active |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:15: ## 0. AUDIT SCOPE, METHOD, AND LIMITATION
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:17: ### 0.1 Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\package-lock.json:2457: "eslint-scope": "^7.2.2",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\package-lock.json:2492: "node_modules/eslint-scope": {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:9: **Scope:** Full firm access by default
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:41: **Scope:** Assigned matters and cases
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:72: **Scope:** Billing and financial data
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:105: **Scope:** System administration and firm configuration
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:138: **Scope:** Own case information only
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:170: **Scope:** Specific matter only (temporary)
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\01-user-roles.md:292: **Scope Configuration:**
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\05-security-compliance.md:295: - Audit scope:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\closeout\phase-13\PHASE_13B2A_MENU_PLATFORM_CLOSEOUT_20260626.md:63: - Do not patch yet until exact file scope is confirmed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\features\EMAIL_1_CLOSEOUT_20260627.md:5: Scope Completed:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\features\EMAIL_AUTOCOMPLETE_FIELD.md:10: ## Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:293: Backend validation/RBAC/document storage lifecycle remain outside this frontend patch scope.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:382: | Use `Clients.jsx` and `index.css` only | Scope control | FINAL |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:413: [ ] Scope limited to approved frontend files unless separately approved.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:495: RBAC/access control remains backend/security scope and must not be implied by frontend-only changes.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\handover\phase-8\L360_PHASE_8F_R_S_VERIFICATION_AUDIT_SSOT_HANDOVER_20260626.md:541: Allowed/forbidden scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\MASTER-SYSTEM\03-blueprints\MASTER-BLUEPRINT-TEMPLATE.md:9: ## Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\mvp-roadmap\MVP_SCOPE_LOCK.md:1: # MVP Scope Lock
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-10ZF\PHASE-10ZF-NAVIGATION-MODULE-MENU-PROTOCOL.md:6: ## Deployment Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\CLIENT_BUTTON_LABEL_MICROCOPY_FIX_20260627.md:22: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2_CONTROLLED_UNLOCK_DECISION_20260626.md:51: 4. Separate frontend-only, backend-only, database-only, and documentation-only scopes.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2A_MENU_PLATFORM_IMPLEMENTATION_20260626.md:6: Scope Type: Frontend-only reusable feature package
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2B_MENU_SIDEBAR_INTEGRATION_20260626.md:35: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2C_VISIBLE_APP_MENU_INTEGRATION_20260626.md:38: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2D_MENU_VISIBILITY_HOTFIX_20260626.md:37: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2E_PROFESSIONAL_MENU_OVERLAY_FIX_20260626.md:53: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2F_MENU_DUPLICATE_HOME_CLEANUP_20260626.md:55: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B2G_MENU_PLATFORM_CLOSEOUT_SSOT_20260627.md:86: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3_MENU_ACTION_WIRING_PLAN_20260627.md:44: ## Non-Negotiable Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\docs\phase-13\PHASE_13B3A_FILE_ACTION_FEEDBACK_PANELS_20260627.md:53: ## Safety Scope
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:255: Risk Classification
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:342: 2.10 Risk Classification Framework
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:344: LOW risk:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:351: MEDIUM risk:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:359: HIGH risk:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:370: CRITICAL risk:
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:775: Risk classification framework
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:878: SQLite is currently operational and stable. Migration adds risk without immediate operational necessity.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1318: [ ] Risk classification assigned
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1360: [ ] Regression risk reviewed
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1373: [ ] Security risk classification assigned
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1662: Risk management
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\EXTRACTED-SSOT-12-CONSOLIDATED-MASTER-HANDOVER.md:1755: Risks
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:355: - Copilot output identified useful risks and QA checklist.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:448: - localStorage merge conflict risk
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:511: 3. Phase 13B-QA final PASS/WITH RISKS/FAIL decision not logged.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:736: | Use frontend-safe work first | Minimises backend/database risk | Active |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:739: | Do not treat Copilot “production-ready” wording as certification | Risks remain | Active |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:798: 9. Mark Phase 13B-QA as PASS WITH KNOWN RISKS or FAILED.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_PHASE13_AUDIT_AND_SSOT_HANDOVER_20260625.md:959: PHASE 13B-QA: PASS WITH KNOWN RISKS
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:284: | Gap | Risk | Required Action |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:295: | Gap | Risk | Required Action |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:304: | Gap | Risk | Required Action |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\L360_THREAD_AUDIT_COMPLETION_VERIFICATION_MASTER_SSOT_20260625.md:481: | D-004 | No backend/RBAC/database edits | High-risk protected layers | Active |
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\LITIGATION_360_LEOS_SSOT_HANDOVER_V12_2_POST_12_0F_PRE_12_0G.md:382: Rationale: Renaming routes/files adds unnecessary risk. UI terminology can improve first while technical filenames remain stable.
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE10X7-MASTER-GOVERNANCE-DOCS.js:94: risk: loaded.scoring?.risk ?? null,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE10Y0-ENTERPRISE-MASTER-REGISTRY-DIGITAL-TWIN.js:345: latestRisk: scoring?.risk ?? null,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:35: id: "AUTO-DEADLINE-RISK",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:36: name: "Deadline risk requires triage",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:39: description: "Detects predicted deadline failure risk and creates escalation."
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:63: id: "AUTO-MATTER-RISK",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:64: name: "High-risk matter requires review",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:204: if (deadlineForecast.predictedDeadlineFailureRisk === "HIGH") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:205: const rule = RULES.find(r => r.id === "AUTO-DEADLINE-RISK");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:218: title: "Autonomous Escalation: Deadline Risk",
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:297: if (forecast.predictedRisk === "HIGH" || forecast.predictedRisk === "CRITICAL") {
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:298: const rule = RULES.find(r => r.id === "AUTO-MATTER-RISK");
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:303: reason: `Matter ${profile.matterId} predicted risk is ${forecast.predictedRisk}.`,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:311: title: `Autonomous Escalation: High Risk Matter ${profile.matterId}`,
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\automation\autonomousOperationsEngine.js:313: severity: forecast.predictedRisk === "CRITICAL" ? "HIGH" : "MEDIUM",
```

## Initial Scope Map

### Likely Frontend Areas

- client pages
- matter intake pages
- workspace pages
- form components
- reusable autocomplete fields
- document / evidence UI
- proposal or engagement planning UI

### Possible Future Backend / Database Areas

These are NOT approved for editing yet, but may require future planning:

- client intake records
- matter records
- document metadata
- proposal records
- fee estimate records
- engagement status records
- stakeholder records
- evidence tracker records

### Possible Future Security / RBAC Areas

These are NOT approved for editing yet, but may require future planning:

- who can create intake records
- who can convert intake into client / matter
- who can view sensitive evidence
- who can approve proposals
- who can approve fee changes
- who can close or reject a prospective client

## Forbidden Until Separate Approval

- backend
- database
- auth
- RBAC
- API routes
- server files
- migrations
- package files
- production infrastructure logic

## Discovery Conclusion

Phase 14A remains in planning.

The next step is to produce a Phase 14A Execution Scope Decision.

## Recommended Decision

Recommended next decision: start with frontend-only planning or prototype scope unless backend/database scope is explicitly approved.

## Recent Commit Chain

```text
a5f1ee8 docs(phase-13): close client lifecycle and set next-phase gate
e346449 docs(phase-13): close client profile modernization
f114794 docs(phase-13): close Z4 validation intelligence
739ed1b docs(phase-13): record section completion status QA pass
d6efbb5 feat(clients): add section completion status
6716e4c docs(phase-13): record required field counter QA pass
ad60398 feat(clients): add existing required field counter
3913316 docs(phase-13): record static completion shell QA pass
6339220 feat(clients): add static completion status shell
1ceb325 docs(governance): record next-phase decision gate after Phase 13
87e77a8 docs(phase-13): update overall Phase 13 closeout SSOT
8a941b3 docs(phase-13): map client validation completion states
6da3c24 docs(phase-13): record keyboard framework QA pass
34a454d docs(phase-13): audit client validation sources
36b94fb docs(phase-13): record keyboard framework QA pass
9342d7f docs(phase-13): blueprint client validation completion intelligence
aa9c2b6 feat(app): add keyboard shortcut help framework
41feda5 docs(phase-13): close Z3 client profile modernization
b8b24e9 docs(phase-13): record pre-submission review QA pass
a58e251 feat(clients): add pre-submission review panel
```

## Phase 14A Status

Phase 14A Read-Only Discovery: CREATED
Phase 14A Implementation: NOT APPROVED
Next Recommended Step: Phase 14A Execution Scope Decision

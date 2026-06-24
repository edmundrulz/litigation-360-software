# LITIGATION 360 LEOS
# MASTER SINGLE SOURCE OF TRUTH HANDOVER & RESTART CHECKPOINT

**Version:** 12.2-SSOT-CHECKPOINT-POST-12.0F-PRE-12.0G  
**Date:** 23 June 2026  
**Prepared For:** Litigation 360 Checkpoint / Next Thread / Post-PC-Restart Continuation  
**Project Root:** `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`  
**Control Root:** `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL`  
**Current Restart Point:** `PHASE 12.0G — ACTIVE SQLITE DATABASE IDENTIFICATION`  
**Current Permission Level:** Read-only discovery / planning only  
**Patch Approval Status:** Matter Type patch NOT approved yet  
**Phase 11 Status:** LOCKED  

---

## 0. MASTER AUTHORITY STATEMENT

This document is the current authoritative restart-safe handover for the Litigation 360 LEOS project after the Phase 12.0E and Phase 12.0F work completed in this thread.

It consolidates:

- The prior SSOT Version 12.1 position.
- The Matter Details UI foundation status from Phase 12.0D.
- The Phase 12.0E Matter Type backend/data support discovery.
- The Phase 12.0F backend/database planning pack and execution.
- The Phase 12.0G attempted active SQLite database identification pack creation.
- The current failed-safe state before PC restart.
- The exact post-restart continuation path.

This document governs all future branched-out work.

If another thread, document, script, report, or note conflicts with this document, this document prevails unless formally superseded by a later SSOT version.

No future variation, patch, script, documentation pack, UI enhancement, backend change, database change, or Phase 11 proposal may contradict this SSOT.

---

# 1. EXECUTIVE SUMMARY

## 1.1 Project Identity

**Project Name:** Litigation 360 Enterprise Platform  
**Working Classification:** Litigation 360 LEOS — Legal Enterprise Operating System  
**Earlier Classification:** LPOS — Legal Practice Operating System  
**Strategic Direction:** Enterprise Legal Operating Ecosystem / Legal Intelligence Operating System  

## 1.2 Project Purpose

Litigation 360 LEOS is intended to become a structured, governed, auditable legal operations platform that can support client lifecycle management, matter lifecycle management, court operations, litigation workflows, document governance, deadline tracking, staff operations, legal workflow automation, audit trails, monitoring, rollback discipline, verification and testing, future AI-assisted support, and future reporting/command-centre style oversight.

The project is not merely a simple case-management page. It is being developed as a controlled enterprise legal operating system.

## 1.3 Current Status

The project is currently in the **Matter Details expansion path**.

The Matter Details UI foundation was previously completed under Phase 12.0D. The UI now shows Matter Details, a Create New Matter button, an existing matters table, and a collapsed/expanded Matter form. The form appears after clicking Create New Matter.

Phase 12.0E was executed successfully as read-only discovery. It produced a final certification decision of:

`DISCOVERY PASS / PATCH NOT APPROVED`

Phase 12.0F was executed successfully as read-only backend/database planning. It created the planning pack, evidence, matrix, planning report, and final planning certification report.

The current next phase is:

`PHASE 12.0G — ACTIVE SQLITE DATABASE IDENTIFICATION`

Phase 12.0G was attempted with an initial creator script, but the first script failed safely with a PowerShell quote terminator error. A V2 base64-safe replacement script was provided but has not yet been confirmed as successfully run.

## 1.4 Current Destination / Goal

The immediate goal is **not Phase 11** and not a frontend Matter Type patch.

The immediate goal is:

1. Identify the active operational SQLite database among the 61 SQLite candidates found.
2. Read or certify the schema safely in read-only mode.
3. Confirm whether the active database has the needed table/column structure.
4. Only then prepare a controlled Matter Type migration plan.
5. Only after migration planning and certification should Matter Type be exposed in the UI.

---

# 2. PROJECT PARAMETERS & PROTOCOLS

## 2.1 Golden Governance Rule

No uncontrolled direct modification.

Every meaningful change must follow:

1. Request.
2. Assessment.
3. Approval.
4. Backup.
5. Controlled patch or read-only discovery.
6. Verification.
7. Build/runtime check where applicable.
8. Report.
9. Rollback availability where applicable.
10. Closure decision.
11. SSOT update.

## 2.2 Current Safety Mode

Current safety mode:

`READ-ONLY DISCOVERY / READ-ONLY PLANNING / CONTROL-LAYER ONLY`

Allowed:

- Documentation creation.
- Governance document creation.
- Read-only source inspection.
- Read-only database identification.
- Hashing and evidence generation.
- CSV/JSON/MD report generation.
- Live monitoring.
- Planning scripts.
- Parser-safe script repair.
- Control-folder script replacement.

Blocked:

- Editing `Cases.jsx`.
- Editing `frontend\src\api.js`.
- Editing `backend\src\routes\cases.js`.
- Editing database files.
- Running migrations.
- Adding Matter Type manually.
- Renaming cases to matters.
- Phase 11 work.
- Production deployment.
- Client data testing.
- Deleting or cleaning folders.
- Removing backups.

## 2.3 Project Roots

Primary app root:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`

Control root:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL`

Phase 12.0E root:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY`

Phase 12.0F root:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0F-MATTER-TYPE-BACKEND-DATABASE-PLANNING`

Phase 12.0G root:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION`

## 2.4 Known Application Files

Matter Details UI file:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx`

Frontend API helper:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\api.js`

Backend active cases route:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\cases.js`

Do-not-touch backup route:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\cases.js`

## 2.5 Database Protocol

SQLite remains the current operational database authority unless later certified otherwise.

Important current database fact:

- Phase 12.0E found `61` SQLite candidates.
- `sqlite3` command-line tool is not available on the machine.
- Matter Type was not detected in frontend, API, backend, or database schema evidence.
- The active operational SQLite database has not yet been certified.

No migration may be run until the active database is certified.

## 2.6 PowerShell Script Placement Rule

All generated scripts should be placed in:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`

Do not assume Downloads.

Previously failed path assumption:

`C:\Users\jep_edmundrulz\Downloads\...`

Correct convention:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\...`

## 2.7 Parser Safety Rule

PowerShell scripts must avoid fragile huge here-string blocks where possible.

Known PowerShell failure patterns from this thread:

1. Missing here-string terminator: `The string is missing the terminator: "@.`
2. Missing single-quote here-string terminator: `The string is missing the terminator: '.`
3. Invalid variable reference before colon: `Variable reference is not valid. ':' was not followed by a valid variable name character.`

Correct form:

`${port}:`

not:

`$port:`

---

# 3. TIMELINE & CURRENCY TRACKER

## 3.1 Past — Completed / Achieved

### Phase 12.0D — Matter Details UI Foundation

Status: `Substantially complete`

Completed results:

- Matter Details UI foundation exists.
- Form appears after clicking Create New Matter.
- UI includes Matter Title, Linked Client, Status, Description, and Create Matter.
- Existing matters table includes Matter Title, Client, Status, Actions.
- Build previously passed.
- Frontend server previously confirmed on port 5173.
- Backend was not modified.
- Database was not modified.
- Phase 11 remained locked.

### Phase 12.0E — Matter Type Backend / Data Support Discovery

Status: `Completed successfully`

Final output:

`PHASE 12.0E ALL READ-ONLY COMPLETED SUCCESSFULLY`

Important generated files:

- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\08_EVIDENCE\PHASE12.0E-TARGET-FILE-EVIDENCE-20260623-095644.csv`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\08_EVIDENCE\PHASE12.0E-KEYWORD-EVIDENCE-20260623-095644.csv`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\08_EVIDENCE\PHASE12.0E-SQLITE-CANDIDATES-20260623-095644.csv`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\08_EVIDENCE\PHASE12.0E-SQLITE-SCHEMA-READONLY-20260623-095644.txt`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\07_REPORTS\PHASE12.0E-READONLY-DISCOVERY-REPORT-20260623-095644.md`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\08_EVIDENCE\PHASE12.0E-DISCOVERY-SUMMARY-20260623-095644.json`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\07_REPORTS\PHASE12.0E-FINAL-CERTIFICATION-REPORT-20260623-095653.md`

Phase 12.0E key result:

```json
{
  "SqliteSchemaStatus": "SQLITE3_COMMAND_NOT_AVAILABLE",
  "SqliteCandidatesFound": 61,
  "FrontendMatterTypeMention": false,
  "ApiMatterTypeMention": false,
  "BackendMatterTypeMention": false,
  "DatabaseMatterTypeMention": false,
  "FrontendBaseFieldMention": true,
  "BackendBaseFieldMention": true,
  "PreliminaryRecommendation": "NO_CONFIRMED_MATTER_TYPE_SUPPORT_PLAN_BACKEND_DATABASE_FIRST"
}
```

Certification decision:

`STATUS: DISCOVERY PASS / PATCH NOT APPROVED`

Invalid/premature report:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\07_REPORTS\PHASE12.0E-FINAL-CERTIFICATION-REPORT-20260623-094711.md`

Reason invalid: It was created after a failed discovery script. Do not use it as authority.

### Phase 12.0F — Backend / Database Planning

Status: `Completed successfully`

Pack creation output:

`PHASE 12.0F BACKEND / DATABASE PLANNING PACK CREATED SUCCESSFULLY`

Run output:

`PHASE 12.0F ALL READ-ONLY PLANNING COMPLETED SUCCESSFULLY`

Important generated files:

- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0F-MATTER-TYPE-BACKEND-DATABASE-PLANNING\07_REPORTS\PHASE12.0F-READONLY-BACKEND-DATABASE-PLANNING-REPORT-20260623-102827.md`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0F-MATTER-TYPE-BACKEND-DATABASE-PLANNING\08_EVIDENCE\PHASE12.0F-PLANNING-SUMMARY-20260623-102827.json`
- `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0F-MATTER-TYPE-BACKEND-DATABASE-PLANNING\07_REPORTS\PHASE12.0F-FINAL-PLANNING-CERTIFICATION-REPORT-20260623-102828.md`

Evidence created:

- Backend route evidence.
- Package DB dependency evidence.
- SQLite candidate planning review.
- Backend/database planning matrix.

## 3.2 Present — Current / Active

Current active phase:

`PHASE 12.0G — ACTIVE SQLITE DATABASE IDENTIFICATION`

Current state:

- Phase 12.0G is required.
- First Phase 12.0G creator script failed before pack creation.
- V2 base64-safe replacement was provided.
- V2 has not yet been confirmed as successfully run.
- PC restart is pending.
- The correct post-restart action is to run the V2 Phase 12.0G creator script.

Known bad/obsolete script:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK.ps1`

Expected good replacement script:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1`

## 3.3 Upcoming — Planned / Future

Immediate next post-restart command:

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1"
```

Expected success message:

`PHASE 12.0G ACTIVE DATABASE IDENTIFICATION PACK V2 CREATED SUCCESSFULLY`

Then run:

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"
```

Expected success message:

`PHASE 12.0G ALL READ-ONLY COMPLETED SUCCESSFULLY`

Possible next phase after 12.0G:

`PHASE 12.0H — CONTROLLED MATTER TYPE MIGRATION PLAN`

Important: Phase 12.0H should be a plan first, not immediate migration execution.

---

# 4. DECISION LOG

## Decision 001 — Matter is the parent concept, not Case

Status: `Active`

Rationale: A matter covers litigation, advisory, debt recovery, conveyancing, employment, family, criminal, corporate, and other legal work. A court case is only one type of matter.

## Decision 002 — Keep Cases.jsx as technical file name for now

Status: `Active temporary compromise`

Rationale: Renaming routes/files adds unnecessary risk. UI terminology can improve first while technical filenames remain stable.

## Decision 003 — Backend remains untouched during UI foundation

Status: `Completed / active boundary`

Rationale: Phase 12.0D was frontend-only and should not modify backend logic.

## Decision 004 — Database remains untouched until certified

Status: `Active mandatory rule`

Rationale: Matter Type requires database support. No schema change without active database identification and backup/migration planning.

## Decision 005 — Matter Type is deferred

Status: `Active`

Rationale: Phase 12.0E found no Matter Type support signals in frontend, API, backend, or database evidence.

## Decision 006 — Phase 12.0E patch not approved

Status: `Final`

Rationale: Certification stated `DISCOVERY PASS / PATCH NOT APPROVED`.

## Decision 007 — Phase 12.0F completed as planning

Status: `Final`

Rationale: Backend/database planning pack and reports were created successfully.

## Decision 008 — Phase 12.0G required before migration plan

Status: `Active`

Rationale: 61 SQLite candidates exist and the active operational database has not been certified.

## Decision 009 — Initial Phase 12.0G creator script deprecated

Status: `Deprecated`

Rationale: It failed with a PowerShell string terminator error.

## Decision 010 — Phase 12.0G V2 base64-safe script is the current restart path

Status: `Active pending execution`

Rationale: It is intended to avoid fragile here-string parsing.

## Decision 011 — Phase 11 remains locked

Status: `Mandatory`

Rationale: Current project is still in controlled Matter Details/backend/database discovery path. Phase 11 readiness gates are not complete.

---

# 5. VARIATION REGISTRY

## 5.1 Active Variations

### Variation A — SSOT 12.2 Restart Checkpoint

Status: `Active master`

Purpose: Current authoritative restart handover after Phase 12.0F and before Phase 12.0G execution.

### Variation B — Matter Details UI Foundation

Status: `Active completed foundation`

Purpose: Preserves Matter Details UI while advanced fields are deferred.

### Variation C — Matter Type Backend/Database Planning Path

Status: `Active`

Purpose: Prevents fake UI field creation before backend/database support exists.

### Variation D — Active SQLite Database Identification

Status: `Active pending execution`

Purpose: Identify the real operational SQLite database among 61 candidates.

### Variation E — Base64-Safe Script Writer Pattern

Status: `Active recommended scripting pattern`

Purpose: Avoid PowerShell here-string parser issues.

## 5.2 Deprecated Variations

Deprecated:

- Adding Matter Type directly to `Cases.jsx`.
- Treating Phase 12.0E as patch approval.
- Trusting premature Phase 12.0E final report `094711`.
- Assuming `sqlite3` exists on the machine.
- Using Downloads as default file location.
- Using initial Phase 12.0G creator script.
- Treating a visually available UI field as proof of backend/database support.
- Proceeding to Phase 11.

## 5.3 Merged Variations

Merged into current path:

- Matter Details terminology polish.
- Create New Matter button behavior.
- Runtime safety arrays from Phase 12.0D.
- Read-only discovery evidence style from Phase 12.0E.
- Backend/database planning matrix style from Phase 12.0F.
- Live monitoring support.

## 5.4 Deferred Variations

Deferred until later phases:

- Matter Type field.
- Matter Number.
- Priority.
- Open Date.
- Person in Charge.
- Assistant/Clerk.
- Court Related.
- Court Case Number.
- Opposing Party.
- Next Deadline.
- Document linkage.
- Notes panel.
- Archive instead of Delete.
- Backend route rename from cases to matters.
- Database table rename.
- Phase 11 features.

---

# 6. COMPLIANCE CHECKLIST

## 6.1 Any Future Phase Must Have

- [ ] Phase purpose clearly stated.
- [ ] Project root stated.
- [ ] Control root stated.
- [ ] Phase root stated.
- [ ] Allowed actions stated.
- [ ] Blocked actions stated.
- [ ] Generated documentation.
- [ ] Generated protocol.
- [ ] Generated parameters.
- [ ] Generated blueprint.
- [ ] Generated checklist.
- [ ] Generated prompt.
- [ ] Generated scripts.
- [ ] Generated evidence.
- [ ] Generated report.
- [ ] Final certification report.
- [ ] Clear next recommendation.
- [ ] SSOT update.

## 6.2 Before Any Frontend Patch

- [ ] Backend support confirmed.
- [ ] API support confirmed.
- [ ] Database support confirmed.
- [ ] Target file backed up.
- [ ] Rollback script created.
- [ ] Build test planned.
- [ ] Browser test planned.
- [ ] No unsupported fake field.
- [ ] SSOT updated.

## 6.3 Before Any Backend Patch

- [ ] Active route identified.
- [ ] Existing behavior documented.
- [ ] Request/response shape documented.
- [ ] Database impact reviewed.
- [ ] Backup created.
- [ ] Rollback script created.
- [ ] API impact reviewed.
- [ ] Frontend impact reviewed.
- [ ] Test plan created.
- [ ] SSOT updated.

## 6.4 Before Any Database Migration

- [ ] Active database identified.
- [ ] Database backup created.
- [ ] Schema inspected.
- [ ] Existing records checked.
- [ ] Migration script created.
- [ ] Rollback migration created.
- [ ] Dry-run or read-only validation performed.
- [ ] Backend route impact reviewed.
- [ ] Frontend impact reviewed.
- [ ] Post-migration verification plan created.
- [ ] Explicit approval recorded.

## 6.5 Matter Type Specific Gate

Matter Type may not be added until all are true:

- [ ] Active database is certified.
- [ ] Matter table/cases table is identified.
- [ ] Existing columns are known.
- [ ] Migration need is known.
- [ ] Backend route accepts/saves Matter Type.
- [ ] API helper transmits Matter Type.
- [ ] Frontend renders Matter Type.
- [ ] New records save correctly.
- [ ] Existing records tolerate missing Matter Type.
- [ ] Build passes.
- [ ] Browser test passes.
- [ ] Rollback exists.

Current status: `NOT READY`

---

# 7. DEFINED PATH & JOURNEY

## 7.1 Completed Journey

1. Matter Details governance handover created.
2. Matter Details UI foundation completed.
3. Phase 12.0E discovery pack created after repairs.
4. Phase 12.0E discovery executed successfully.
5. Phase 12.0E certified as Discovery Pass / Patch Not Approved.
6. Phase 12.0F backend/database planning pack created.
7. Phase 12.0F planning executed successfully.
8. Phase 12.0F final planning certification created.
9. Phase 12.0G first creator failed safely.
10. Phase 12.0G V2 base64-safe replacement provided.

## 7.2 Current Exact Position

The exact restart position is:

`POST-PHASE 12.0F / PRE-PHASE 12.0G EXECUTION`

## 7.3 Next Exact Step After PC Restart

Run:

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1"
```

Then run:

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"
```

Then inspect or send:

`PHASE12.0G-FINAL-ACTIVE-DB-CERTIFICATION-REPORT-[timestamp].md`

## 7.4 Expected Outcomes of Phase 12.0G

### Outcome A — Active database certified with schema read

Next:

`PHASE 12.0H — CONTROLLED MATTER TYPE MIGRATION PLAN`

### Outcome B — Likely active database found but schema not read

Next:

Manual schema confirmation or Node dependency/schema access repair.

### Outcome C — Multiple possible active databases

Next:

Manual review of top candidates.

### Outcome D — Active database not identified

Next:

Do not patch. Search backend config, server startup logs, environment variables, and database connection files.

---

# 8. INDUSTRY STANDARDS REFERENCE

## 8.1 Governance Standard

The project follows professional change-management discipline similar to:

- ITIL-style change control.
- Release management.
- Configuration management.
- Audit-driven software development.
- Controlled migration practice.
- Evidence-first development.

## 8.2 Naming Standard

Phase format:

`PHASE12.0X-MODULE-ACTION`

Examples:

- `PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY`
- `PHASE12.0F-MATTER-TYPE-BACKEND-DATABASE-PLANNING`
- `PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION`

Report format:

`PHASE12.0X-ACTION-REPORT-[timestamp].md`

Evidence format:

`PHASE12.0X-EVIDENCE-TYPE-[timestamp].csv/json/txt`

Script format:

`Run-PHASE12.0X-Action.ps1`

## 8.3 Folder Standard

Every phase should include:

```text
00_DOCUMENTATION
01_PROTOCOLS
02_PARAMETERS
03_BLUEPRINTS
04_CHECKLISTS
05_PROMPTS
06_SCRIPTS
07_REPORTS
08_EVIDENCE
09_READONLY_SNAPSHOTS
10_LIVE_MONITORING
99_LOGS
```

## 8.4 Evidence Standard

Reports must be supported by:

- CSV evidence.
- JSON summary.
- Markdown report.
- Logs.
- Final certification report.
- Explicit safety confirmation.

## 8.5 Script Safety Standard

Scripts must:

- Use `$ErrorActionPreference = "Stop"`.
- Validate paths.
- Avoid fragile quotes where possible.
- Use `-LiteralPath`.
- Create reports.
- Stop on failure.
- Not continue to final certification if main phase fails.
- Avoid modifying app code unless explicitly in a patch phase.

---

# 9. VERSION CONTROL & UPDATE PROTOCOL

## 9.1 Current SSOT Version

Current version:

`12.2-SSOT-CHECKPOINT-POST-12.0F-PRE-12.0G`

## 9.2 Supersedes

This document supersedes:

- Earlier partial thread summaries.
- Any assumption that Phase 12.0E approved a patch.
- Any assumption that Phase 12.0G has completed.
- Any assumption that Matter Type can be added now.

It extends:

- SSOT Version 12.1 from Matter Details UI foundation.

## 9.3 Update Triggers

This SSOT must be updated when:

- Phase 12.0G pack V2 is successfully created.
- Phase 12.0G completes.
- Active database is certified.
- Phase 12.0H starts.
- Any backend/database migration plan is created.
- Any rollback is used.
- Any patch is approved.
- Any Phase 11 lock status changes.

## 9.4 Duplicate Prevention

Before creating a new phase pack, check whether equivalent folders already exist under:

`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL`

If equivalent exists:

- Extend or repair.
- Do not duplicate blindly.

## 9.5 Divergence Prevention

All future branches must:

- Reference this SSOT.
- Preserve the Phase 11 lock.
- Preserve the no-patch rule until active DB certification.
- Not contradict Phase 12.0E/12.0F results.
- Treat Phase 12.0G as pending until executed successfully.

---

# 10. COMPREHENSIVE VERIFICATION & AUDIT

## 10.1 Prior Completion Check

Question:

Has the overall Matter Type backend/database readiness task already been fully completed?

Answer:

`NO`

Reason:

Phase 12.0E completed discovery and rejected patch approval. Phase 12.0F completed planning. Phase 12.0G has not yet completed because the first Phase 12.0G creator failed and the V2 replacement has not yet been confirmed as run.

## 10.2 Completed Items Verified

The following are verified complete based on thread outputs:

- Phase 12.0E pack creation eventually succeeded.
- Phase 12.0E live monitor was repaired.
- Phase 12.0E discovery core was repaired.
- Phase 12.0E performance scan was repaired.
- Phase 12.0E read-only discovery completed.
- Phase 12.0E final valid certification report was created.
- Phase 12.0E final result was Discovery Pass / Patch Not Approved.
- Phase 12.0F pack creation completed.
- Phase 12.0F live monitor started.
- Phase 12.0F planning execution completed.
- Phase 12.0F final planning certification was created.
- Phase 12.0G need was correctly identified.

## 10.3 Incomplete / Pending Items

The following are not yet complete:

- Phase 12.0G V2 base64-safe pack creation not yet confirmed.
- Phase 12.0G active DB read-only run not yet executed.
- Active operational SQLite database not yet certified.
- Schema not yet read/certified.
- Matter Type column not yet confirmed.
- Matter Type migration plan not yet prepared.
- Matter Type migration not approved.
- Matter Type UI patch not approved.
- Backend route update not approved.
- API update not approved.
- Phase 11 remains locked.

## 10.4 Gap and Hole Analysis

Current gaps:

### Gap 001 — Active database unknown

There are 61 SQLite candidates, but the actual operational database has not been certified.

### Gap 002 — Schema access unresolved

`sqlite3` command-line tool is unavailable. Node-based read-only schema inspection is planned in Phase 12.0G.

### Gap 003 — Matter Type unsupported

No Matter Type signal was found in:

- Frontend.
- API helper.
- Backend route.
- Database evidence.

### Gap 004 — Migration not planned yet

Phase 12.0H has not been created. It should not be created until Phase 12.0G completes.

### Gap 005 — Initial Phase 12.0G script failed

A replacement V2 script exists, but must be run after restart.

## 10.5 Secondary Review

Secondary review conclusion:

The completed phases are internally consistent:

- 12.0E correctly refused patch approval.
- 12.0F correctly moved to planning.
- 12.0G is the correct next dependency.
- No safe shortcut exists to add Matter Type yet.

The failed scripts did not create app/backend/database modifications and therefore failed safely.

## 10.6 Final State Confirmation

Current state is not final for the Matter Type feature.

Current state is final only for:

- Phase 12.0E discovery.
- Phase 12.0F planning.

Current state is not final for:

- Active DB identification.
- Matter Type backend support.
- Matter Type database support.
- Matter Type frontend exposure.
- Phase 11 readiness.

## 10.7 Conclusion

There is more to do.

The only correct next action is:

`Proceed to Phase 12.0G using the V2 base64-safe active database identification pack.`

There is nothing more to do inside Phase 12.0E or Phase 12.0F unless auditing their reports. Those phases are complete. The project must now move to the next dependency: active database identification.

---

# 11. POST-RESTART QUICK START COMMANDS

## 11.1 Open PowerShell

Open PowerShell normally.

## 11.2 Go to project root

```powershell
cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
```

## 11.3 Run Phase 12.0G V2 pack creator

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1"
```

Expected:

```text
PHASE 12.0G ACTIVE DATABASE IDENTIFICATION PACK V2 CREATED SUCCESSFULLY
```

## 11.4 Run Phase 12.0G

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"
```

Expected:

```text
PHASE 12.0G ALL READ-ONLY COMPLETED SUCCESSFULLY
```

## 11.5 Optional live monitor

```powershell
powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Start-PHASE12.0G-Live-Monitor.ps1" -IntervalSeconds 10
```

Stop with:

```text
CTRL + C
```

---

# 12. WHAT TO SEND INTO THE NEXT THREAD

After Phase 12.0G completes, send:

1. The Phase 12.0G final certification report.
2. The Phase 12.0G active DB summary JSON.
3. The top rows of the SQLite candidate ranking CSV if requested.

Likely files:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\07_REPORTS\PHASE12.0G-FINAL-ACTIVE-DB-CERTIFICATION-REPORT-[timestamp].md
```

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\08_EVIDENCE\PHASE12.0G-ACTIVE-DB-SUMMARY-[timestamp].json
```

---

# 13. FINAL CONTROL STATEMENT

Do not add Matter Type yet.

Do not edit frontend, backend, or database yet.

Do not proceed to Phase 11.

The correct continuation is:

`PHASE 12.0G — ACTIVE SQLITE DATABASE IDENTIFICATION`

using:

`PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1`

END OF SSOT VERSION 12.2

# LITIGATION 360 LEOS — PHASE 13B MASTER EXECUTION BLUEPRINT

**Document Type:** Single Source of Truth continuation pack  
**Phase:** Phase 13B — Frontend-Only Navigation + Operational Status Clarity  
**Project Root:** `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`  
**Control Folder:** `C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS`  
**Status:** Ready for safe execution  
**Date Context:** 24 June 2026  
**Authority:** Extends the current SSOT where Phase 12 is closed, Phase 13A is completed, RBAC is parked, Documents is stable, and Phase 11 remains locked.

---

## 1. Executive Summary

Phase 13B is a **frontend-only safety, clarity, and governance phase**.

The goal is not to build new backend functionality.  
The goal is to prevent confusion inside the user interface by clearly marking which modules are live, metadata-only, restricted, parked, future, or blocked.

This phase exists because the current SSOT confirms:

- Phase 12 is closed as **PASS WITH PARKED RBAC**.
- Phase 13A is completed as **frontend-safe Documents operational readiness**.
- Documents currently operate as **metadata records only**.
- RBAC is parked.
- `/api/users` is intentionally parked as a controlled `403 PARKED_RBAC_ROUTE`.
- Phase 11 remains locked.
- Production/client rollout is blocked.
- Database migration has not run and must not run without explicit approval.

Therefore, Phase 13B must stay within the safe frontend/documentation lane.

---

## 2. Non-Negotiable Phase 13B Rules

### 2.1 Absolute No-Touch Areas

Do **not** edit:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\middleware
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\controllers
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\models
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\database.js
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\.env
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\package.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\package-lock.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\package-lock.json
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\*.db
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\**\*.db
```

### 2.2 Allowed Areas

Allowed:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL
```

Allowed file types:

```text
.jsx
.tsx
.js
.ts
.md
.json
.txt
.ps1
.log
```

Allowed activity:

- Read-only audit.
- Frontend navigation clarity patch.
- Status badges.
- Disabled/parked labels.
- Documentation.
- Progress logs.
- Verification reports.
- Rollback instructions.

### 2.3 Forbidden Claims

Do **not** claim any of the following are active unless backend work is later approved and verified:

- Real file upload.
- Real file storage.
- Document download.
- Document preview.
- OCR.
- Full-text document search.
- Version history.
- Document-level RBAC.
- Admin/user management.
- Production readiness.
- Client rollout readiness.
- Phase 11 unlock readiness.

---

## 3. Phase 13B Objective

Create a clear navigation and app-shell status system that tells the user exactly what is operational.

### 3.1 Required UI Categories

Every major navigation item should be classifiable into one of these statuses:

| Status | Meaning | UI Treatment |
|---|---|---|
| `LIVE` | Safe and working now | Normal link |
| `METADATA_ONLY` | Works only with metadata records | Link allowed with clear badge |
| `PARKED` | Intentionally stopped for safety | Disabled or warning badge |
| `RESTRICTED` | Requires backend/auth/RBAC approval | Disabled or guarded |
| `FUTURE` | Planned but not implemented | Disabled or roadmap badge |
| `BLOCKED` | Explicitly blocked by SSOT | Disabled with reason |

### 3.2 Current Required Status Map

| Module / Area | Status | Reason |
|---|---|---|
| Dashboard / Home | `LIVE` if already accessible | Frontend shell only |
| Cases / Matters | `LIVE` if already accessible | Existing project area |
| Documents | `METADATA_ONLY` | Phase 13A confirmed metadata-record mode only |
| Users / Admin / RBAC | `PARKED` | `/api/users` parked as controlled 403 |
| Upload / Storage / Preview / Download | `FUTURE` | Backend/storage not implemented |
| Matter Type migration | `BLOCKED` | Exact approval phrase not given |
| Phase 11 features | `BLOCKED` | Phase 11 locked |
| Production / Client rollout | `BLOCKED` | Not approved |

---

## 4. Required Folder Structure

The Phase 13B generator creates this exact structure:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS
├── 00_PHASE_13B_MASTER_EXECUTION_BLUEPRINT.md
├── 01_PROTOCOLS_AND_PARAMETERS.md
├── 02_CHECKS_AND_BALANCES.md
├── 03_VERIFICATION_AND_TESTING.md
├── 04_REAL_TIME_PROGRESS_MONITORING.md
├── 05_ROLLBACK_AND_RECOVERY.md
├── 06_CURSOR_COPILOT_PROMPT.md
├── 07_PHASE_13B_COMPLETION_REPORT_TEMPLATE.md
├── checklists
│   ├── PHASE_13B_EXECUTION_CHECKLIST.md
│   └── PHASE_13B_UI_STATUS_MATRIX.md
├── logs
│   └── progress.jsonl
├── reports
│   ├── PREFLIGHT_AUDIT_REPORT.md
│   ├── NAVIGATION_FILE_CANDIDATES.md
│   └── VERIFICATION_REPORT.md
├── backups
│   └── .gitkeep
└── scripts
    ├── PHASE_13B_01_PREFLIGHT_AUDIT.ps1
    ├── PHASE_13B_02_FIND_NAV_FILES.ps1
    ├── PHASE_13B_03_BACKUP_FRONTEND_NAV.ps1
    ├── PHASE_13B_04_MONITOR_PROGRESS.ps1
    ├── PHASE_13B_05_VERIFY_AFTER_PATCH.ps1
    └── PHASE_13B_06_ROLLBACK_FROM_BACKUP.ps1
```

---

## 5. Execution Sequence

Run in this order:

### Step 1 — Generate Control Pack

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
& ".\L360_PHASE13B_CREATE_CONTROL_PACK.ps1"
```

### Step 2 — Preflight Audit

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_01_PREFLIGHT_AUDIT.ps1"
```

### Step 3 — Find Frontend Navigation Files

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_02_FIND_NAV_FILES.ps1"
```

### Step 4 — Create Frontend Navigation Backup

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_03_BACKUP_FRONTEND_NAV.ps1"
```

### Step 5 — Start Live Monitor

Open a separate PowerShell window and run:

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_04_MONITOR_PROGRESS.ps1" -IntervalSeconds 10
```

Stop the monitor with `CTRL + C`.

### Step 6 — Apply One Frontend-Only Navigation Patch

Use the Cursor/Copilot prompt in:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\06_CURSOR_COPILOT_PROMPT.md
```

### Step 7 — Verify After Patch

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_05_VERIFY_AFTER_PATCH.ps1"
```

Optional build check:

```powershell
& "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\scripts\PHASE_13B_05_VERIFY_AFTER_PATCH.ps1" -RunBuild
```

### Step 8 — Complete Report

Fill:

```text
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_CONTROL\PHASE-13B-NAVIGATION-OPERATIONAL-STATUS\07_PHASE_13B_COMPLETION_REPORT_TEMPLATE.md
```

---

## 6. Completion Definition

Phase 13B is complete only when all are true:

- Navigation files identified.
- Frontend nav/app shell backed up.
- UI status map documented.
- Parked/restricted/future/blocked modules are clearly labelled.
- Documents remains labelled as metadata-only.
- RBAC/user/admin remains parked.
- No backend files changed.
- No database files changed.
- No package files changed.
- `/api/documents`, `/api/status`, and `/api/health` remain stable if backend is running.
- `/api/users` remains controlled parked behavior unless a later approved RBAC phase changes it.
- Verification report exists.
- Completion report exists.

---

## 7. Current Safest Next Action

Run the control-pack generator, then run the preflight audit and navigation file finder.

Do **not** patch backend.
Do **not** unlock Phase 11.
Do **not** run migration.
Do **not** continue RBAC.

End of blueprint.

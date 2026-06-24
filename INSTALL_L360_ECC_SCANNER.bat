@echo off
setlocal
title Install Litigation 360 ECC Scanner

cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

mkdir "tools" 2>nul
mkdir "LITIGATION360_LIVE_DASHBOARD\data" 2>nul
mkdir "LITIGATION360_LIVE_DASHBOARD\logs" 2>nul

echo Creating ECC scanner...

(
echo const fs = require("fs");
echo const path = require("path");
echo.
echo const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
echo const OUT = path.join(ROOT, "LITIGATION360_LIVE_DASHBOARD", "data", "project_status.json");
echo const LOG = path.join(ROOT, "LITIGATION360_LIVE_DASHBOARD", "logs", "ecc_scanner.log");
echo.
echo function exists(p^) { return fs.existsSync(path.join(ROOT, p^)); }
echo.
echo function walk(dir, list = []^) {
echo   const full = path.join(ROOT, dir^);
echo   if (!fs.existsSync(full^)^) return list;
echo   for (const item of fs.readdirSync(full^)^) {
echo     if (["node_modules",".git","backup","backups","ARCHIVE_DOCTOR_BACKUPS","CLEANUP_QUARANTINE"].includes(item^)^) continue;
echo     const p = path.join(full, item^);
echo     const rel = path.relative(ROOT, p^);
echo     const stat = fs.statSync(p^);
echo     if (stat.isDirectory(^)^) walk(rel, list^);
echo     else list.push(rel^);
echo   }
echo   return list;
echo }
echo.
echo const files = walk("."^);
echo.
echo function countContains(term^) {
echo   return files.filter(f =^> f.toLowerCase(^).includes(term.toLowerCase(^)^)^).length;
echo }
echo.
echo function countExt(ext^) {
echo   return files.filter(f =^> f.toLowerCase(^).endsWith(ext^)^).length;
echo }
echo.
echo function score(items^) {
echo   const passed = items.filter(Boolean^).length;
echo   return Math.round((passed / items.length^) * 100^);
echo }
echo.
echo const modules = [
echo   {
echo     name: "Core Platform",
echo     progress: score([exists("package.json"^), exists("backend"^), exists("frontend"^), exists("README.md"^), exists("PROJECT-STATUS.md"^)]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Backend",
echo     progress: score([exists("backend\\package.json"^), exists("backend\\src"^), exists("backend\\litigation360.db"^), exists("backend\\logs"^)]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Frontend",
echo     progress: score([exists("frontend"^), countContains("frontend"^) ^> 10, countExt(".jsx"^) ^> 0 || countExt(".tsx"^) ^> 0 || countExt(".js"^) ^> 20]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Database",
echo     progress: score([exists("backend\\litigation360.db"^), exists("backend\\database"^), countExt(".sql"^) ^> 0]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Security / RBAC",
echo     progress: score([countContains("rbac"^) ^> 0, countContains("audit"^) ^> 0, countContains("security"^) ^> 0]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Monitoring",
echo     progress: score([countContains("monitor"^) ^> 0, countContains("health"^) ^> 0, countContains("diagnostic"^) ^> 0]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Automation Bus",
echo     progress: score([exists("backend\\enterprise\\automation-bus"^), exists("backend\\enterprise\\automation-consumer"^), exists("backend\\enterprise\\event-catalog"^)]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Notification Framework",
echo     progress: score([exists("backend\\enterprise\\notification-hub"^), countContains("notification"^) ^> 0]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Workflow Engine",
echo     progress: score([countContains("workflow"^) ^> 0, exists("L360-PHASE10D-WORKFLOW-AUTOMATION-ENGINE.ps1"^)]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Document Lifecycle",
echo     progress: score([countContains("document"^) ^> 0, exists("L360-PHASE10E-DOCUMENT-LIFECYCLE-ENGINE.ps1"^)]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "AI Knowledge Center",
echo     progress: score([exists("PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE"^), countContains("AI_KNOWLEDGE"^) ^> 0, countContains("LEGAL_AUDITOR"^) ^> 0]^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Testing",
echo     progress: Math.min(100, Math.round((countContains("test"^) / 30^) * 100^)^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Documentation",
echo     progress: Math.min(100, Math.round((countExt(".md"^) / 25^) * 100^)^),
echo     status: "Auto-scanned"
echo   },
echo   {
echo     name: "Mobile Ecosystem",
echo     progress: score([exists("android-app"^), exists("windows-app"^)]^),
echo     status: "Auto-scanned"
echo   }
echo ];
echo.
echo const overall = Math.round(modules.reduce((a,m^) =^> a + m.progress, 0^) / modules.length^);
echo const errorLogs = files.filter(f =^> f.toLowerCase(^).includes("error"^)^).length;
echo const testFiles = files.filter(f =^> f.toLowerCase(^).includes("test"^)^).length;
echo.
echo const status = {
echo   project: "Litigation 360 Enterprise Platform",
echo   status: "Live Auto-Scanned",
echo   overall_progress: overall,
echo   health_score: errorLogs === 0 ? 100 : Math.max(70, 100 - errorLogs^),
echo   integrity_score: exists("backend\\litigation360.db"^) ? 100 : 70,
echo   current_phase: "Phase 10B - Executive Command Centre Scanner",
echo   last_scanned: new Date(^).toLocaleString(^),
echo   total_files: files.length,
echo   js_files: countExt(".js"^),
echo   sql_files: countExt(".sql"^),
echo   markdown_files: countExt(".md"^),
echo   test_files: testFiles,
echo   error_related_files: errorLogs,
echo   modules
echo };
echo.
echo fs.writeFileSync(OUT, JSON.stringify(status, null, 2^)^);
echo fs.appendFileSync(LOG, `[${new Date(^).toISOString(^)}] ECC scan complete. Overall: ${overall}%%, Files: ${files.length}\n`^);
echo console.log("ECC scan complete."^);
echo console.log("Overall Progress:", overall + "%%"^);
echo console.log("Total Files:", files.length^);
) > "tools\l360-ecc-scanner.js"

echo Creating scanner runner...

(
echo @echo off
echo title Litigation 360 ECC Live Scanner
echo cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
echo echo Starting Litigation 360 ECC Scanner...
echo echo This updates the dashboard every 60 seconds.
echo echo.
echo :loop
echo node tools\l360-ecc-scanner.js
echo timeout /t 60 /nobreak
echo goto loop
) > "RUN_L360_ECC_SCANNER.bat"

echo Creating all-in-one launcher...

(
echo @echo off
echo title Litigation 360 ECC Dashboard Launcher
echo cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
echo start "ECC Scanner" cmd /k RUN_L360_ECC_SCANNER.bat
echo cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\LITIGATION360_LIVE_DASHBOARD"
echo start "" "http://localhost:8787/"
echo python -m http.server 8787
) > "START_L360_ECC_DASHBOARD.bat"

echo.
echo =====================================================
echo INSTALL COMPLETE
echo =====================================================
echo.
echo Now run:
echo START_L360_ECC_DASHBOARD.bat
echo.
pause
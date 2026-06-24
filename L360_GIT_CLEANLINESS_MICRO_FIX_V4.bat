@echo off
setlocal EnableExtensions EnableDelayedExpansion
title L360 GIT CLEANLINESS MICRO FIX V4

set "PROJECT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
set "RUNNER=C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER"
set "ACTIVE=%PROJECT%\_L360_ACTIVE_CONTROL"

if not exist "%RUNNER%" mkdir "%RUNNER%"
if not exist "%ACTIVE%" mkdir "%ACTIVE%"

for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set "D=%%d%%b%%c"
for /f "tokens=1-3 delims=:." %%a in ("%time%") do set "T=%%a%%b%%c"
set "T=%T: =0%"

set "OUTSIDE_REPORT=%RUNNER%\L360_GIT_CLEANLINESS_MICRO_FIX_V4_RESULT_%D%_%T%.txt"
set "INSIDE_REPORT=%ACTIVE%\108_GIT_CLEANLINESS_MICRO_FIX_V4.md"
set "STATUS_BEFORE=%RUNNER%\_l360_git_micro_v4_status_before.txt"
set "STATUS_AFTER_RESTORE=%RUNNER%\_l360_git_micro_v4_status_after_restore.txt"
set "STATUS_BEFORE_COMMIT=%RUNNER%\_l360_git_micro_v4_status_before_commit.txt"
set "STATUS_FINAL=%RUNNER%\_l360_git_micro_v4_status_final.txt"

cls
echo ============================================================
echo  L360 GIT CLEANLINESS MICRO FIX V4
echo ============================================================
echo Project : %PROJECT%
echo Report  : %OUTSIDE_REPORT%
echo Safety  : exact restore only; no clean, no reset, no delete, no push
echo ============================================================
echo.

echo ============================================================ > "%OUTSIDE_REPORT%"
echo L360 GIT CLEANLINESS MICRO FIX V4 >> "%OUTSIDE_REPORT%"
echo ============================================================ >> "%OUTSIDE_REPORT%"
echo Project: %PROJECT% >> "%OUTSIDE_REPORT%"
echo Generated: %date% %time% >> "%OUTSIDE_REPORT%"
echo Safety: exact restore only; no git clean, no git reset, no delete, no push/pull/fetch. >> "%OUTSIDE_REPORT%"
echo ============================================================ >> "%OUTSIDE_REPORT%"
echo. >> "%OUTSIDE_REPORT%"

where git >nul 2>nul
if errorlevel 1 (
  echo STOPPED: Git not found.
  echo STOPPED: Git not found. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

if not exist "%PROJECT%\.git\" (
  echo STOPPED: .git folder not found.
  echo STOPPED: .git folder not found. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

echo Step 1: Current Git status...
git -C "%PROJECT%" status --short > "%STATUS_BEFORE%" 2>&1
type "%STATUS_BEFORE%"

echo. >> "%OUTSIDE_REPORT%"
echo -------- STATUS BEFORE MICRO FIX V4 -------- >> "%OUTSIDE_REPORT%"
type "%STATUS_BEFORE%" >> "%OUTSIDE_REPORT%"
echo. >> "%OUTSIDE_REPORT%"

echo.
echo Step 2: Exact restore of the one known remaining tracked helper file...
echo Command: git checkout HEAD -- L360_ONE_CLICK_RESUME_CONTROLLER.ps1
echo Command: git checkout HEAD -- L360_ONE_CLICK_RESUME_CONTROLLER.ps1 >> "%OUTSIDE_REPORT%"
git -C "%PROJECT%" checkout HEAD -- "L360_ONE_CLICK_RESUME_CONTROLLER.ps1" >> "%OUTSIDE_REPORT%" 2>&1
set "RESTORE_EXIT=%ERRORLEVEL%"
echo Restore exit code: %RESTORE_EXIT%
echo Restore exit code: %RESTORE_EXIT% >> "%OUTSIDE_REPORT%"

if not "%RESTORE_EXIT%"=="0" (
  echo.
  echo STOPPED: Exact restore failed. See report.
  echo STOPPED: Exact restore failed. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

echo.
echo Step 3: Status after exact restore...
git -C "%PROJECT%" status --short > "%STATUS_AFTER_RESTORE%" 2>&1
type "%STATUS_AFTER_RESTORE%"

echo. >> "%OUTSIDE_REPORT%"
echo -------- STATUS AFTER EXACT RESTORE V4 -------- >> "%OUTSIDE_REPORT%"
type "%STATUS_AFTER_RESTORE%" >> "%OUTSIDE_REPORT%"
echo. >> "%OUTSIDE_REPORT%"

findstr /B /C:" D " /C:"D  " "%STATUS_AFTER_RESTORE%" >nul 2>nul
if not errorlevel 1 (
  echo.
  echo STOPPED: A deleted tracked file still remains. No commit will be made.
  echo STOPPED: Deleted tracked file remains after exact restore. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

echo.
echo Step 4: Ensure _L360_CONTROL/ is local-only ignored...
findstr /C:"_L360_CONTROL/" "%PROJECT%\.gitignore" >nul 2>nul
if errorlevel 1 (
  echo.>> "%PROJECT%\.gitignore"
  echo # L360 local-only generated control clutter; keep on disk, do not track.>> "%PROJECT%\.gitignore"
  echo _L360_CONTROL/>> "%PROJECT%\.gitignore"
  echo Added _L360_CONTROL/ to .gitignore.
  echo Added _L360_CONTROL/ to .gitignore. >> "%OUTSIDE_REPORT%"
) else (
  echo _L360_CONTROL/ already ignored.
  echo _L360_CONTROL/ already ignored. >> "%OUTSIDE_REPORT%"
)

echo.
echo Step 5: Write inside-repo V4 control report...
(
echo # L360 Git Cleanliness Micro Fix V4
echo.
echo Generated: %date% %time%
echo.
echo ## Purpose
echo.
echo V3 stopped because one tracked helper file still showed as deleted:
echo.
echo `L360_ONE_CLICK_RESUME_CONTROLLER.ps1`
echo.
echo ## Exact Action
echo.
echo This V4 fix ran:
echo.
echo ```text
echo git checkout HEAD -- L360_ONE_CLICK_RESUME_CONTROLLER.ps1
echo ```
echo.
echo ## Safety
echo.
echo This V4 fix did not run:
echo.
echo - git clean
echo - git reset
echo - git push
echo - git pull
echo - git fetch
echo.
echo It did not delete files.
echo.
echo ## Status Before V4 Fix
echo.
echo ```text
type "%STATUS_BEFORE%"
echo ```
echo.
echo ## Status After Exact Restore
echo.
echo ```text
type "%STATUS_AFTER_RESTORE%"
echo ```
echo.
echo ## Still Blocked
echo.
echo - backend/RBAC/database edits
echo - Phase 11 unlock
echo - production/client rollout
) > "%INSIDE_REPORT%"

echo Inside report written:
echo %INSIDE_REPORT%
echo Inside report written: %INSIDE_REPORT% >> "%OUTSIDE_REPORT%"

echo.
echo Step 6: Stage safe helper/report/control files only...
git -C "%PROJECT%" add ".gitignore" >> "%OUTSIDE_REPORT%" 2>&1

for %%F in (
  "L360_GIT_BASELINE_DIRECT_VERIFY_V4.bat"
  "README_GIT_BASELINE_DIRECT_VERIFY_V4.txt"
  "L360_GIT_CLEANLINESS_FIX_AFTER_BASELINE.bat"
  "README_GIT_CLEANLINESS_FIX_AFTER_BASELINE.txt"
  "L360_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V2.bat"
  "README_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V2.txt"
  "L360_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V3.bat"
  "README_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V3.txt"
  "L360_GIT_CLEANLINESS_MICRO_FIX_V4.bat"
  "README_GIT_CLEANLINESS_MICRO_FIX_V4.txt"
) do (
  if exist "%PROJECT%\%%~F" (
    echo Staging %%~F
    echo Staging %%~F >> "%OUTSIDE_REPORT%"
    git -C "%PROJECT%" add "%%~F" >> "%OUTSIDE_REPORT%" 2>&1
  )
)

for %%F in (
  "_L360_ACTIVE_CONTROL/103_SAFE_GIT_BASELINE_ONLY_V2_REPORT.md"
  "_L360_ACTIVE_CONTROL/104_VERIFY_SAFE_GIT_BASELINE_V2_READONLY.md"
  "_L360_ACTIVE_CONTROL/105_GIT_CLEANLINESS_FIX_AFTER_BASELINE.md"
  "_L360_ACTIVE_CONTROL/106_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V2.md"
  "_L360_ACTIVE_CONTROL/107_GIT_CLEANLINESS_FIX_AFTER_BASELINE_V3.md"
  "_L360_ACTIVE_CONTROL/108_GIT_CLEANLINESS_MICRO_FIX_V4.md"
) do (
  if exist "%PROJECT%\%%~F" (
    echo Staging %%~F
    echo Staging %%~F >> "%OUTSIDE_REPORT%"
    git -C "%PROJECT%" add "%%~F" >> "%OUTSIDE_REPORT%" 2>&1
  )
)

echo.
echo Step 7: Status before follow-up commit...
git -C "%PROJECT%" status --short > "%STATUS_BEFORE_COMMIT%" 2>&1
type "%STATUS_BEFORE_COMMIT%"

echo. >> "%OUTSIDE_REPORT%"
echo -------- STATUS BEFORE FOLLOW-UP COMMIT V4 -------- >> "%OUTSIDE_REPORT%"
type "%STATUS_BEFORE_COMMIT%" >> "%OUTSIDE_REPORT%"
echo. >> "%OUTSIDE_REPORT%"

findstr /B /C:" D " /C:"D  " "%STATUS_BEFORE_COMMIT%" >nul 2>nul
if not errorlevel 1 (
  echo.
  echo STOPPED: Deleted tracked file appeared before commit. No commit will be made.
  echo STOPPED: Deleted tracked file appeared before commit. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

echo.
echo Step 8: Creating one follow-up local commit...
git -C "%PROJECT%" commit -m "L360 record git cleanliness verification" >> "%OUTSIDE_REPORT%" 2>&1
set "COMMIT_EXIT=%ERRORLEVEL%"
echo Commit exit code: %COMMIT_EXIT%
echo Commit exit code: %COMMIT_EXIT% >> "%OUTSIDE_REPORT%"

if not "%COMMIT_EXIT%"=="0" (
  echo.
  echo STOPPED: Follow-up commit failed. See outside report.
  echo STOPPED: Follow-up commit failed. >> "%OUTSIDE_REPORT%"
  pause
  exit /b 1
)

echo.
echo Step 9: Final Git status...
git -C "%PROJECT%" status --short > "%STATUS_FINAL%" 2>&1
for %%A in ("%STATUS_FINAL%") do set "STATUS_FINAL_SIZE=%%~zA"

for /f "usebackq delims=" %%i in (`git -C "%PROJECT%" branch --show-current 2^>nul`) do set "BRANCH=%%i"
for /f "usebackq delims=" %%i in (`git -C "%PROJECT%" log --oneline -1 2^>nul`) do set "LATEST=%%i"
git -C "%PROJECT%" ls-files > "%RUNNER%\_l360_git_lsfiles_micro_v4.txt" 2>&1
for /f %%C in ('type "%RUNNER%\_l360_git_lsfiles_micro_v4.txt" ^| find /c /v ""') do set "TRACKED_COUNT=%%C"

if "%STATUS_FINAL_SIZE%"=="0" (
  set "FINAL_CLEAN=TRUE"
) else (
  set "FINAL_CLEAN=FALSE"
)

echo. >> "%OUTSIDE_REPORT%"
echo -------- FINAL STATUS V4 -------- >> "%OUTSIDE_REPORT%"
type "%STATUS_FINAL%" >> "%OUTSIDE_REPORT%"
echo. >> "%OUTSIDE_REPORT%"
echo Branch: %BRANCH% >> "%OUTSIDE_REPORT%"
echo Latest commit: %LATEST% >> "%OUTSIDE_REPORT%"
echo Final clean: %FINAL_CLEAN% >> "%OUTSIDE_REPORT%"
echo Tracked files: %TRACKED_COUNT% >> "%OUTSIDE_REPORT%"

echo.
echo ============================================================
if /I "%FINAL_CLEAN%"=="TRUE" (
  echo  GIT CLEANLINESS MICRO FIX V4 COMPLETE
) else (
  echo  GIT CLEANLINESS MICRO FIX V4 PARTIAL - CHECK STILL NEEDED
)
echo ============================================================
echo Branch        : %BRANCH%
echo Latest commit : %LATEST%
echo Final clean   : %FINAL_CLEAN%
echo Tracked files : %TRACKED_COUNT%
echo Report        : %OUTSIDE_REPORT%
echo ============================================================

if /I not "%FINAL_CLEAN%"=="TRUE" (
  echo.
  echo CURRENT FINAL STATUS:
  type "%STATUS_FINAL%"
)

echo.
pause
endlocal

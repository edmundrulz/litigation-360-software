# ============================================================
# LITIGATION 360
# FINAL SAFE REPAIR: Restore App.jsx then add functional Previous Page button
#
# What this does:
# 1. Creates a backup of the current App.jsx, even if currently broken.
# 2. Restores App.jsx from the latest backup created before the V3 patch.
# 3. Applies a smaller, safer previous-page navigation patch.
# 4. Modifies ONLY frontend\src\App.jsx.
#
# What this does NOT do:
# - Does not modify backend
# - Does not modify database
# - Does not delete files
# - Does not touch node_modules
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[FINAL PREVIOUS PAGE FIX] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Fail {
    param([string]$Message)
    throw "[FAIL] $Message"
}

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

$AppPath = Join-Path $ProjectRoot "frontend\src\App.jsx"
$SrcFolder = Split-Path -Path $AppPath -Parent
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path -LiteralPath $AppPath -PathType Leaf)) {
    Fail "Could not find frontend\src\App.jsx at: $AppPath"
}

Write-Step "Target App.jsx:"
Write-Host $AppPath -ForegroundColor Green

# Backup current state first, even if broken.
$BrokenBackup = "$AppPath.BACKUP_CURRENT_BEFORE_FINAL_PREVIOUS_PAGE_REPAIR_$Stamp"
Copy-Item -LiteralPath $AppPath -Destination $BrokenBackup -Force
Write-Pass "Current App.jsx backed up first:"
Write-Host $BrokenBackup -ForegroundColor Green

# Restore from the clean backup created before V3, or fallback to V2/V1 previous page backups.
$BackupCandidates = Get-ChildItem -LiteralPath $SrcFolder -File |
    Where-Object {
        $_.Name -like "App.jsx.BACKUP_BEFORE_PREVIOUS_PAGE_BUTTON_V3_*" -or
        $_.Name -like "App.jsx.BACKUP_BEFORE_PREVIOUS_PAGE_BUTTON_20*" -or
        $_.Name -like "App.jsx.BACKUP_BEFORE_PREVIOUS_PAGE_BUTTON_*"
    } |
    Sort-Object LastWriteTime -Descending

if ($BackupCandidates.Count -eq 0) {
    Write-Warn "No previous-page backup file found. The script will patch the current App.jsx instead."
} else {
    $RestoreBackup = $BackupCandidates[0].FullName
    Copy-Item -LiteralPath $RestoreBackup -Destination $AppPath -Force
    Write-Pass "Restored App.jsx from clean backup:"
    Write-Host $RestoreBackup -ForegroundColor Green
}

# Read and normalize line endings.
$content = [System.IO.File]::ReadAllText($AppPath)
$content = $content -replace "`r`n", "`n"

if ($content -notmatch 'export\s+default\s+function\s+App\s*\(') {
    Fail "This does not look like the expected App.jsx. Patch stopped."
}

if ($content -notmatch 'function\s+Workspace\s*\(') {
    Fail "Could not find Workspace function. Patch stopped."
}

if ($content -notmatch 'function\s+ModuleFrame\s*\(') {
    Fail "Could not find ModuleFrame function. Patch stopped."
}

# ------------------------------------------------------------
# 1. Add moduleHistory state
# ------------------------------------------------------------
if ($content -notmatch 'moduleHistory') {
    $needle = 'const [module, setModule] = useState("home");'
    $replace = @'
const [module, setModule] = useState("home");
  const [moduleHistory, setModuleHistory] = useState([]);
'@.TrimEnd()

    if ($content.Contains($needle)) {
        $content = $content.Replace($needle, $replace)
        Write-Pass "Added moduleHistory state."
    } else {
        Fail "Could not find module state line."
    }
} else {
    Write-Warn "moduleHistory already exists. Skipping state insert."
}

# ------------------------------------------------------------
# 2. Replace openWorkspace with goToModule + backToPreviousModule + openWorkspace
# ------------------------------------------------------------
$oldOpenWorkspace = @'
function openWorkspace() {
    setView("workspace");
    setModule("home");
  }
'@.Trim()

$newOpenWorkspace = @'
function goToModule(nextModule) {
    if (nextModule === module) return;

    if (nextModule === "home") {
      setModuleHistory([]);
      setModule("home");
      return;
    }

    setModuleHistory((previousHistory) => [...previousHistory, module]);
    setModule(nextModule);
  }

  function backToPreviousModule() {
    setModuleHistory((previousHistory) => {
      if (previousHistory.length === 0) {
        setModule("home");
        return previousHistory;
      }

      const previousModule = previousHistory[previousHistory.length - 1];
      setModule(previousModule);

      return previousHistory.slice(0, -1);
    });
  }

  function openWorkspace() {
    setView("workspace");
    setModuleHistory([]);
    setModule("home");
  }
'@.Trim()

if ($content -notmatch 'function\s+goToModule\s*\(') {
    if ($content.Contains($oldOpenWorkspace)) {
        $content = $content.Replace($oldOpenWorkspace, $newOpenWorkspace)
        Write-Pass "Added goToModule, backToPreviousModule, and enhanced openWorkspace."
    } else {
        Fail "Could not find the original openWorkspace block."
    }
} else {
    Write-Warn "goToModule already exists. Skipping openWorkspace replacement."
}

# ------------------------------------------------------------
# 3. Pass goToModule/history props into Workspace
# ------------------------------------------------------------
$oldWorkspaceProps = @'
<Workspace
            module={module}
            setModule={setModule}
            results={results}
'@.Trim()

$newWorkspaceProps = @'
<Workspace
            module={module}
            setModule={goToModule}
            previous={backToPreviousModule}
            canGoBack={moduleHistory.length > 0}
            results={results}
'@.Trim()

if ($content -notmatch 'previous=\{backToPreviousModule\}') {
    if ($content.Contains($oldWorkspaceProps)) {
        $content = $content.Replace($oldWorkspaceProps, $newWorkspaceProps)
        Write-Pass "Workspace now receives goToModule and previous-page props."
    } else {
        Fail "Could not find Workspace props block."
    }
} else {
    Write-Warn "Workspace previous-page props already present. Skipping."
}

# ------------------------------------------------------------
# 4. Update Workspace signature
# ------------------------------------------------------------
$oldWorkspaceSignature = 'function Workspace({ module, setModule, results, runChecks, passed, failed, updated }) {'
$newWorkspaceSignature = 'function Workspace({ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated }) {'

if ($content.Contains($oldWorkspaceSignature)) {
    $content = $content.Replace($oldWorkspaceSignature, $newWorkspaceSignature)
    Write-Pass "Workspace signature updated."
} elseif ($content.Contains($newWorkspaceSignature)) {
    Write-Warn "Workspace signature already updated."
} else {
    Fail "Could not find Workspace signature."
}

# ------------------------------------------------------------
# 5. Add previous/canGoBack props to every ModuleFrame usage
# ------------------------------------------------------------
$moduleTitles = @(
    "Clients",
    "Cases",
    "Matters",
    "Court Dates",
    "Documents",
    "Staff",
    "Review / Save & Submit",
    "Matter Intake"
)

foreach ($title in $moduleTitles) {
    $old = "<ModuleFrame title=`"$title`" setModule={setModule}>"
    $new = "<ModuleFrame title=`"$title`" setModule={setModule} previous={previous} canGoBack={canGoBack}>"
    if ($content.Contains($old)) {
        $content = $content.Replace($old, $new)
        Write-Pass "Updated ModuleFrame props for: $title"
    }
}

# ------------------------------------------------------------
# 6. Update ModuleFrame signature
# ------------------------------------------------------------
$oldModuleFrameSignature = 'function ModuleFrame({ title, setModule, children }) {'
$newModuleFrameSignature = 'function ModuleFrame({ title, setModule, previous, canGoBack, children }) {'

if ($content.Contains($oldModuleFrameSignature)) {
    $content = $content.Replace($oldModuleFrameSignature, $newModuleFrameSignature)
    Write-Pass "ModuleFrame signature updated."
} elseif ($content.Contains($newModuleFrameSignature)) {
    Write-Warn "ModuleFrame signature already updated."
} else {
    Fail "Could not find ModuleFrame signature."
}

# ------------------------------------------------------------
# 7. Add previous button next to Back to Main Workspace
# ------------------------------------------------------------
$oldBackButton = '<button onClick={() => setModule("home")}>← Back to Main Workspace</button>'

$newBackButtons = @'
<div style={{ display: "flex", gap: "8px", alignItems: "center" }}>
          <button type="button" onClick={() => setModule("home")}>
            ← Back to Main Workspace
          </button>

          <button
            type="button"
            onClick={() => {
              if (canGoBack && typeof previous === "function") {
                previous();
                return;
              }

              setModule("home");
            }}
          >
            ← Previous Page
          </button>
        </div>
'@.TrimEnd()

if ($content.Contains($oldBackButton)) {
    $content = $content.Replace($oldBackButton, $newBackButtons)
    Write-Pass "Added ← Previous Page button beside Back to Main Workspace."
} elseif ($content -match '← Previous Page') {
    Write-Warn "Previous Page button already appears to exist."
} else {
    Fail "Could not find Back to Main Workspace button line."
}

# ------------------------------------------------------------
# 8. Write file
# ------------------------------------------------------------
$content = $content -replace "`n", "`r`n"
[System.IO.File]::WriteAllText($AppPath, $content, (New-Object System.Text.UTF8Encoding($false)))

# ------------------------------------------------------------
# 9. Create report
# ------------------------------------------------------------
$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "PREVIOUS-PAGE-BUTTON-FINAL-REPAIR-REPORT-$Stamp.md"

$Report = @"
# Previous Page Button Final Repair Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified file:
$AppPath

Backup of current/broken file:
$BrokenBackup

Restored backup used:
$(if ($BackupCandidates.Count -gt 0) { $BackupCandidates[0].FullName } else { "No restore backup used; patched current App.jsx" })

## Change Summary

- Added moduleHistory state.
- Added goToModule() to record workflow navigation history.
- Added backToPreviousModule() to return to the immediately previous module.
- Kept Back to Main Workspace separate.
- Updated Workspace to pass previous-page props.
- Updated ModuleFrame to show the new Previous Page button.
- Modified only frontend\src\App.jsx.

## Safety

Backend modified: NO
Database modified: NO
Files deleted: NO
node_modules touched: NO

## Test

1. cd "$ProjectRoot\frontend"
2. npm run dev
3. Ctrl + F5 in browser
4. Test: Workspace → Clients → Save & Next → Previous Page
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "FINAL PREVIOUS PAGE BUTTON REPAIR COMPLETE"
Write-Host ""
Write-Host "Modified file:" -ForegroundColor Cyan
Write-Host $AppPath
Write-Host ""
Write-Host "Backup of current/broken file:" -ForegroundColor Cyan
Write-Host $BrokenBackup
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

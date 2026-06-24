# ============================================================
# LITIGATION 360
# PREVIOUS PAGE BUTTON FIX - V4 LINE-SAFE PATCH
#
# Purpose:
#   Fix the failed previous-page patch by using a line-safe search
#   instead of looking for one exact button string.
#
# Safety:
#   - Creates a backup before any write
#   - Modifies ONLY frontend\src\App.jsx
#   - Does NOT touch backend
#   - Does NOT touch database
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[PREVIOUS PAGE FIX V4] $Message" -ForegroundColor Cyan
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
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path -LiteralPath $AppPath -PathType Leaf)) {
    Fail "Could not find frontend\src\App.jsx at: $AppPath"
}

Write-Step "Target file:"
Write-Host $AppPath -ForegroundColor Green

# Backup current App.jsx first
$BackupPath = "$AppPath.BACKUP_BEFORE_PREVIOUS_PAGE_FIX_V4_$Stamp"
Copy-Item -LiteralPath $AppPath -Destination $BackupPath -Force
Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# Read file
$content = [System.IO.File]::ReadAllText($AppPath)
$content = $content -replace "`r`n", "`n"

if ($content -notmatch 'export\s+default\s+function\s+App\s*\(') {
    Fail "App.jsx does not look like the expected React App file."
}

if ($content -notmatch 'function\s+Workspace\s*\(') {
    Fail "Could not find Workspace function."
}

if ($content -notmatch 'function\s+ModuleFrame\s*\(') {
    Fail "Could not find ModuleFrame function."
}

# ------------------------------------------------------------
# 1. Add moduleHistory state
# ------------------------------------------------------------
if ($content -notmatch 'const\s+\[moduleHistory,\s*setModuleHistory\]') {
    $pattern = 'const\s+\[module,\s*setModule\]\s*=\s*useState\("home"\);'
    $replacement = 'const [module, setModule] = useState("home");' + "`n" + '  const [moduleHistory, setModuleHistory] = useState([]);'

    $newContent = [regex]::Replace($content, $pattern, $replacement, 1)

    if ($newContent -eq $content) {
        Fail "Could not add moduleHistory state because module state line was not found."
    }

    $content = $newContent
    Write-Pass "Added moduleHistory state."
} else {
    Write-Warn "moduleHistory already exists. Skipped."
}

# ------------------------------------------------------------
# 2. Add navigation wrappers around existing openWorkspace
# ------------------------------------------------------------
if ($content -notmatch 'function\s+goToModule\s*\(') {
    $openWorkspacePattern = '(?s)function\s+openWorkspace\s*\(\)\s*\{\s*setView\("workspace"\);\s*setModule\("home"\);\s*\}'

    $navigationBlock = @'
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
'@.TrimEnd()

    $newContent = [regex]::Replace($content, $openWorkspacePattern, $navigationBlock, 1)

    if ($newContent -eq $content) {
        Fail "Could not find openWorkspace function block."
    }

    $content = $newContent
    Write-Pass "Added goToModule, backToPreviousModule, and enhanced openWorkspace."
} else {
    Write-Warn "goToModule already exists. Skipped."
}

# ------------------------------------------------------------
# 3. Replace only the Workspace setModule prop with goToModule,
#    and add previous/canGoBack props.
# ------------------------------------------------------------
if ($content -notmatch 'previous=\{backToPreviousModule\}') {
    $workspacePropsPattern = '(?s)<Workspace\s+module=\{module\}\s+setModule=\{setModule\}\s+results=\{results\}'
    $workspacePropsReplacement = @'
<Workspace
            module={module}
            setModule={goToModule}
            previous={backToPreviousModule}
            canGoBack={moduleHistory.length > 0}
            results={results}
'@.TrimEnd()

    $newContent = [regex]::Replace($content, $workspacePropsPattern, $workspacePropsReplacement, 1)

    if ($newContent -eq $content) {
        Fail "Could not update Workspace props."
    }

    $content = $newContent
    Write-Pass "Workspace now receives goToModule, previous, and canGoBack."
} else {
    Write-Warn "Workspace previous/canGoBack props already exist. Skipped."
}

# ------------------------------------------------------------
# 4. Update Workspace function signature
# ------------------------------------------------------------
$content = $content.Replace(
    'function Workspace({ module, setModule, results, runChecks, passed, failed, updated }) {',
    'function Workspace({ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated }) {'
)

if ($content -match 'function Workspace\(\{ module, setModule, previous, canGoBack, results, runChecks, passed, failed, updated \}\) \{') {
    Write-Pass "Workspace signature verified."
} else {
    Fail "Workspace signature was not updated correctly."
}

# ------------------------------------------------------------
# 5. Add previous/canGoBack props to ModuleFrame calls
# ------------------------------------------------------------
$moduleFramePattern = '<ModuleFrame title="([^"]+)" setModule=\{setModule\}>'
$moduleFrameReplacement = '<ModuleFrame title="$1" setModule={setModule} previous={previous} canGoBack={canGoBack}>'
$content = [regex]::Replace($content, $moduleFramePattern, $moduleFrameReplacement)

if ($content -notmatch 'previous=\{previous\}\s+canGoBack=\{canGoBack\}') {
    Fail "ModuleFrame props were not added."
}

Write-Pass "ModuleFrame calls now receive previous/canGoBack props."

# ------------------------------------------------------------
# 6. Update ModuleFrame signature
# ------------------------------------------------------------
$content = $content.Replace(
    'function ModuleFrame({ title, setModule, children }) {',
    'function ModuleFrame({ title, setModule, previous, canGoBack, children }) {'
)

if ($content -match 'function ModuleFrame\(\{ title, setModule, previous, canGoBack, children \}\) \{') {
    Write-Pass "ModuleFrame signature verified."
} else {
    Fail "ModuleFrame signature was not updated correctly."
}

# ------------------------------------------------------------
# 7. Replace the line containing Back to Main Workspace.
#    This avoids exact left-arrow / whitespace matching problems.
# ------------------------------------------------------------
if ($content -notmatch 'Previous Page') {
    $lines = New-Object System.Collections.Generic.List[string]
    $content.Split("`n") | ForEach-Object { $lines.Add($_) | Out-Null }

    $buttonIndex = -1

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like '*Back to Main Workspace*') {
            $buttonIndex = $i
            break
        }
    }

    if ($buttonIndex -lt 0) {
        Fail "Could not find any line containing Back to Main Workspace."
    }

    $indentMatch = [regex]::Match($lines[$buttonIndex], '^\s*')
    $indent = $indentMatch.Value

    $replacementLines = @(
        "$indent<div style={{ display: `"flex`", gap: `"8px`", alignItems: `"center`" }}>",
        "$indent  <button type=`"button`" onClick={() => setModule(`"home`")}>",
        "$indent    ← Back to Main Workspace",
        "$indent  </button>",
        "",
        "$indent  <button",
        "$indent    type=`"button`"",
        "$indent    onClick={() => {",
        "$indent      if (canGoBack && typeof previous === `"function`") {",
        "$indent        previous();",
        "$indent        return;",
        "$indent      }",
        "",
        "$indent      setModule(`"home`");",
        "$indent    }}",
        "$indent  >",
        "$indent    ← Previous Page",
        "$indent  </button>",
        "$indent</div>"
    )

    $lines.RemoveAt($buttonIndex)

    for ($j = $replacementLines.Count - 1; $j -ge 0; $j--) {
        $lines.Insert($buttonIndex, $replacementLines[$j])
    }

    $content = [string]::Join("`n", $lines)
    Write-Pass "Previous Page button inserted using line-safe replacement."
} else {
    Write-Warn "Previous Page button already exists. Skipped button insertion."
}

# ------------------------------------------------------------
# 8. Basic structural sanity checks
# ------------------------------------------------------------
if ($content -match '\}\)\s*\{') {
    Write-Warn "Found pattern '}) {' which may be normal or may indicate a bad replacement; continuing because JSX often contains similar syntax."
}

if ($content -notmatch '← Previous Page') {
    Fail "Final file does not contain Previous Page button."
}

if ($content -notmatch 'function\s+backToPreviousModule\s*\(') {
    Fail "Final file does not contain backToPreviousModule."
}

# Write final file
$content = $content -replace "`n", "`r`n"
[System.IO.File]::WriteAllText($AppPath, $content, (New-Object System.Text.UTF8Encoding($false)))

# Report
$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
$ReportPath = Join-Path $ReportFolder "PREVIOUS-PAGE-BUTTON-FIX-V4-REPORT-$Stamp.md"

$Report = @"
# Previous Page Button Fix V4 Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified file:
$AppPath

Backup:
$BackupPath

## Changes Applied

- Added moduleHistory state
- Added goToModule()
- Added backToPreviousModule()
- Updated openWorkspace() to clear history
- Passed previous/canGoBack into Workspace
- Passed previous/canGoBack into ModuleFrame
- Added Previous Page button beside Back to Main Workspace

## Safety

Backend modified: NO
Database modified: NO
Files deleted: NO
node_modules touched: NO

## Test

cd "$ProjectRoot\frontend"
npm run dev

Then hard refresh browser with Ctrl + F5.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "PREVIOUS PAGE BUTTON FIX V4 COMPLETE"
Write-Host ""
Write-Host "Modified file:" -ForegroundColor Cyan
Write-Host $AppPath
Write-Host ""
Write-Host "Backup:" -ForegroundColor Cyan
Write-Host $BackupPath
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

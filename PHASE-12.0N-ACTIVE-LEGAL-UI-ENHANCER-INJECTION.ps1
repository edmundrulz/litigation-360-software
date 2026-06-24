# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N ACTIVE LEGAL UI ENHANCER INJECTION
#
# PURPOSE:
#   Make the requested legal-system interface controls visible
#   inside the currently running frontend without depending on
#   App.jsx route structure.
#
# WHAT THIS ADDS VISIBLY:
#   - Search
#   - Instructions
#   - Glossary
#   - Firm Profile
#   - Managing Partner
#   - MY/SG Legal News
#   - Settings / Configuration
#   - Scales of justice / legal visual branding
#
# METHOD:
#   - Backs up frontend\index.html
#   - Creates frontend\src\legal-management-enhancer.js
#   - Creates frontend\src\legal-management-enhancer.css
#   - Injects one Vite module script into frontend\index.html
#
# SAFE MODE:
#   - DOES NOT modify database
#   - DOES NOT modify backend
#   - DOES NOT touch Court Dates
#   - DOES NOT modify Authentication/RBAC
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0N] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Save-Text {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $Folder = Split-Path -Path $Path -Parent
    if (!(Test-Path -LiteralPath $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$FrontendRoot = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $FrontendRoot "src"
$IndexHtml = Join-Path $FrontendRoot "index.html"

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-$RunStamp"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $RollbackRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

Write-Step "Running preflight checks..."

$PreflightRows = @()
$PreflightRows += [PSCustomObject]@{ Item="frontend folder"; Path=$FrontendRoot; Exists=(Test-Path -LiteralPath $FrontendRoot -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="frontend/src folder"; Path=$FrontendSrc; Exists=(Test-Path -LiteralPath $FrontendSrc -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="frontend/index.html"; Path=$IndexHtml; Exists=(Test-Path -LiteralPath $IndexHtml -PathType Leaf) }

$PreflightRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-PREFLIGHT-CHECK.csv") -NoTypeInformation -Encoding UTF8

$Missing = @($PreflightRows | Where-Object { $_.Exists -eq $false })

if ($Missing.Count -gt 0) {
    $MissingText = ($Missing | ForEach-Object { "$($_.Item): $($_.Path)" }) -join "`r`n"
    $FailReport = @"
# PHASE 12.0N ACTIVE LEGAL UI ENHANCER INJECTION - FAILED PREFLIGHT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Result

FAILED PREFLIGHT - NO ACTIVE INJECTION PERFORMED

## Missing Items

$MissingText

## Safety

No active frontend file was modified.
No database was modified.
No production feature was unlocked.
No Phase 11 work was started.
"@
    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-FAILED-PREFLIGHT-REPORT.md") -Content $FailReport
    Write-Fail "Preflight failed. Open report:"
    Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-FAILED-PREFLIGHT-REPORT.md"'
    exit 1
}

Write-Pass "Preflight passed."

Write-Step "Backing up frontend index.html..."

$IndexBackup = Join-Path $RollbackRoot "index.html.BACKUP-BEFORE-12.0N"
Copy-Item -LiteralPath $IndexHtml -Destination $IndexBackup -Force

Write-Pass "Backup created:"
Write-Host $IndexBackup -ForegroundColor Green

Write-Step "Creating legal-management-enhancer.css..."

$Css = @'
.leos-legal-dock {
  position: fixed;
  left: 18px;
  top: 215px;
  width: 235px;
  z-index: 2147483000;
  background: linear-gradient(180deg, #111827 0%, #17213a 100%);
  color: #ffffff;
  border: 1px solid rgba(201, 166, 70, 0.45);
  border-radius: 16px;
  box-shadow: 0 22px 44px rgba(15, 23, 42, 0.35);
  padding: 12px;
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}
.leos-legal-dock * { box-sizing: border-box; }
.leos-legal-dock-header {
  display: flex; align-items: center; gap: 10px;
  border-bottom: 1px solid rgba(255,255,255,0.14);
  padding-bottom: 10px; margin-bottom: 10px;
}
.leos-legal-mark {
  width: 42px; height: 42px; display: grid; place-items: center;
  border-radius: 14px; background: rgba(201,166,70,0.18);
  border: 1px solid rgba(201,166,70,0.65);
  color: #f6d778; font-size: 25px;
}
.leos-legal-dock-title { display: grid; line-height: 1.1; }
.leos-legal-dock-title strong { font-size: 13px; }
.leos-legal-dock-title small { color: rgba(255,255,255,0.65); margin-top: 4px; font-size: 11px; }
.leos-legal-dock button {
  width: 100%; cursor: pointer; border: 1px solid rgba(255,255,255,0.15);
  background: rgba(255,255,255,0.06); color: #ffffff;
  border-radius: 11px; padding: 9px 10px; margin: 5px 0;
  text-align: left; font-size: 12px; font-weight: 800; transition: 0.16s ease;
}
.leos-legal-dock button:hover, .leos-legal-dock button:focus {
  outline: none; border-color: rgba(201,166,70,0.8);
  background: rgba(201,166,70,0.20); transform: translateX(2px);
}
.leos-legal-drawer {
  position: fixed; left: 278px; top: 72px;
  width: min(680px, calc(100vw - 310px));
  max-height: calc(100vh - 110px); overflow: auto;
  z-index: 2147483001; background: #ffffff; color: #1f2937;
  border: 1px solid #e5decf; border-radius: 22px;
  box-shadow: 0 28px 70px rgba(15, 23, 42, 0.32);
  padding: 20px; font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  display: none;
}
.leos-legal-drawer.leos-open { display: block; }
.leos-legal-drawer-header {
  display: flex; justify-content: space-between; align-items: flex-start;
  gap: 14px; border-bottom: 1px solid #ebe4d8; padding-bottom: 14px; margin-bottom: 16px;
}
.leos-legal-drawer-header h2 { margin: 0; color: #111827; font-size: 24px; }
.leos-legal-drawer-header p { margin: 4px 0 0; color: #6b7280; font-size: 13px; }
.leos-close-btn { cursor: pointer; border: none; border-radius: 999px; background: #111827; color: #fff; padding: 8px 11px; font-weight: 900; }
.leos-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 12px; }
.leos-card { border: 1px solid #e5decf; background: #fffdf8; border-radius: 16px; padding: 14px; display: grid; gap: 5px; }
.leos-card strong { color: #111827; font-size: 14px; }
.leos-card span, .leos-card small, .leos-card p { color: #64748b; font-size: 12px; line-height: 1.45; margin: 0; }
.leos-search-input, .leos-form input, .leos-form textarea, .leos-form select {
  width: 100%; border: 1px solid #d8d0c1; border-radius: 12px; padding: 11px 12px; margin-bottom: 10px; font: inherit;
}
.leos-form label { display: block; font-size: 12px; color: #475569; font-weight: 800; margin-bottom: 4px; }
.leos-form-actions { display: flex; gap: 10px; flex-wrap: wrap; }
.leos-action-btn { cursor: pointer; border: none; background: #111827; color: #fff; border-radius: 999px; padding: 10px 14px; font-weight: 900; }
.leos-secondary-btn { cursor: pointer; border: 1px solid #c9a646; background: #fff8dd; color: #5b4614; border-radius: 999px; padding: 10px 14px; font-weight: 900; }
.leos-news-link { color: inherit; text-decoration: none; }
.leos-news-link:hover strong { text-decoration: underline; }
.leos-status-pill { display: inline-flex; border-radius: 999px; background: #ecfdf5; color: #047857; font-weight: 900; padding: 4px 8px; font-size: 11px; width: fit-content; }
.leos-warning-pill { display: inline-flex; border-radius: 999px; background: #fff7ed; color: #c2410c; font-weight: 900; padding: 4px 8px; font-size: 11px; width: fit-content; }
@media (max-width: 900px) {
  .leos-legal-dock { left: 10px; top: auto; bottom: 12px; width: calc(100vw - 20px); display: grid; grid-template-columns: 1fr 1fr; gap: 6px; }
  .leos-legal-dock-header { grid-column: 1 / -1; }
  .leos-legal-dock button { margin: 0; }
  .leos-legal-drawer { left: 10px; top: 10px; width: calc(100vw - 20px); max-height: calc(100vh - 20px); }
}
'@

$CssPath = Join-Path $FrontendSrc "legal-management-enhancer.css"
Save-Text -Path $CssPath -Content $Css

Write-Step "Creating legal-management-enhancer.js..."

$Js = @'
import "./legal-management-enhancer.css";

(function installLeosLegalEnhancer() {
  const ENHANCER_ID = "leos-legal-enhancer";
  const DRAWER_ID = "leos-legal-drawer";

  if (document.getElementById(ENHANCER_ID)) return;

  const defaultProfile = {
    firmName: "Your Law Firm Name",
    shortName: "Legal 360",
    tagline: "Justice • Integrity • Precision",
    logoEmoji: "⚖️",
    address: "Configurable firm address",
    email: "admin@example.com",
    phone: "+60-00-000-0000",
    website: "https://example.com",
    partnerName: "Managing Partner Name",
    partnerTitle: "Managing Partner / Owner",
    partnerEmail: "partner@example.com",
    partnerPhone: "+60-00-000-0000",
    partnerCredentials: "LLB, Advocate & Solicitor, Professional Credentials",
    partnerAvatar: "👨‍⚖️"
  };

  const repositoryItems = [
    ["📁", "Client Files", "Client profiles, IDs, engagement letters, KYC and contact records."],
    ["📂", "Matter Folders", "Case files, pleadings, court documents, status notes and progress records."],
    ["📄", "Documents", "Drafts, letters, affidavits, bundles, exhibits, templates and filings."],
    ["⏰", "Deadlines", "Limitation periods, hearing dates, filing deadlines and reminders."],
    ["⚖️", "Legal Research", "Authorities, statutes, legal notes, case summaries and research extracts."],
    ["🧾", "Billing / Finance", "Invoices, receipts, fee notes, disbursements and payment records."],
    ["🏛️", "Court Operations", "Court locations, attendance plans, hearing preparation and registry follow-ups."],
    ["🛡️", "Audit / Compliance", "Access logs, RBAC checks, compliance evidence and governance records."]
  ];

  const glossaryTerms = [
    ["Affidavit", "A written statement confirmed by oath or affirmation for use as evidence."],
    ["Cause Papers", "Court documents filed in a matter, including pleadings, applications and supporting documents."],
    ["Client Due Diligence", "Checks used to verify identity, risk, authority and suitability before or during engagement."],
    ["Limitation Period", "The legal time limit within which a claim or action must be started."],
    ["Matter", "A legal file or case handled for a client."],
    ["Retainer", "The engagement arrangement between the client and the legal practitioner or firm."],
    ["Hearing", "A court session where a matter, application or issue is considered."],
    ["Bundle", "A prepared set of documents arranged for court, hearing, filing or review."]
  ];

  const newsLinks = [
    { icon: "🇲🇾", title: "Malaysian Bar — Legal News", description: "Malaysia legal and general legal news.", url: "https://www.malaysianbar.org.my/list/news/legal-and-general-news/legal-news" },
    { icon: "🇲🇾", title: "Malaysian Bar — Court Judgments", description: "Court judgments and appellate highlights from the Malaysian Bar site.", url: "https://www.malaysianbar.org.my/" },
    { icon: "🇸🇬", title: "Singapore Law Watch — Headlines", description: "Singapore legal headlines and legal-sector updates.", url: "https://www.singaporelawwatch.sg/Headlines/category/overview" },
    { icon: "🇸🇬", title: "Singapore Ministry of Law — News", description: "Official Singapore legal-sector announcements, press releases and speeches.", url: "https://www.mlaw.gov.sg/news/press-releases/" },
    { icon: "🏛️", title: "Singapore Courts — News", description: "Media releases, speeches and court news from Singapore Judiciary.", url: "https://www.judiciary.gov.sg/news-and-resources/news" }
  ];

  function getProfile() {
    try { return { ...defaultProfile, ...(JSON.parse(localStorage.getItem("leosFirmProfile") || "{}")) }; }
    catch { return { ...defaultProfile }; }
  }

  function saveProfile(profile) {
    localStorage.setItem("leosFirmProfile", JSON.stringify(profile));
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function card(icon, title, description, extra = "") {
    return `<article class="leos-card"><strong>${icon} ${escapeHtml(title)}</strong><span>${escapeHtml(description)}</span>${extra}</article>`;
  }

  function openDrawer(title, subtitle, html) {
    const drawer = document.getElementById(DRAWER_ID);
    drawer.innerHTML = `
      <div class="leos-legal-drawer-header">
        <div><h2>${title}</h2><p>${subtitle}</p></div>
        <button class="leos-close-btn" type="button" data-leos-close>✕</button>
      </div>${html}`;
    drawer.classList.add("leos-open");
    const close = drawer.querySelector("[data-leos-close]");
    if (close) close.addEventListener("click", () => drawer.classList.remove("leos-open"));
  }

  function showSearch() {
    const itemsHtml = repositoryItems.map(([icon, title, desc]) => card(icon, title, desc)).join("");
    openDrawer("🔎 Search Legal Repository", "Find documents, files, folders, client records, matter records and legal references.",
      `<input class="leos-search-input" id="leos-search-input" placeholder="Search clients, matters, documents, deadlines, folders..." />
       <div class="leos-grid" id="leos-search-results">${itemsHtml}</div>`);
    const input = document.getElementById("leos-search-input");
    const results = document.getElementById("leos-search-results");
    input.addEventListener("input", () => {
      const q = input.value.toLowerCase();
      const filtered = repositoryItems.filter(([, title, desc]) => `${title} ${desc}`.toLowerCase().includes(q));
      results.innerHTML = filtered.length
        ? filtered.map(([icon, title, desc]) => card(icon, title, desc)).join("")
        : `<article class="leos-card"><strong>🔍 No match</strong><span>No matching legal repository folder found.</span></article>`;
    });
  }

  function showInstructions() {
    openDrawer("📘 Instructions & User Guides", "Training, tutorials, SOPs and help documentation for staff.",
      `<div class="leos-grid">
        ${card("🚀", "Getting Started Guide", "How to use the Legal 360 workspace safely.")}
        ${card("👤", "Client Intake Workflow", "Opening a client record, checking profile completeness and locating client files.")}
        ${card("💼", "Matter Opening SOP", "How matters should be opened, labelled, linked and monitored.")}
        ${card("📄", "Document Handling Guide", "Document upload, naming, review, filing and archive practices.")}
        ${card("⏰", "Deadline Monitoring Guide", "How to check deadlines, reminders and court-related dates.")}
        ${card("🛡️", "Security / RBAC / Audit SOP", "How access controls, user roles and audit logs should be reviewed.")}
      </div>`);
  }

  function showGlossary() {
    openDrawer("📚 Legal Glossary", "Common legal terms and internal terminology used in this system.",
      `<div class="leos-grid">${glossaryTerms.map(([term, definition]) => card("⚖️", term, definition)).join("")}</div>`);
  }

  function showNews() {
    openDrawer("📰 Malaysia & Singapore Legal News", "Staff legal-awareness links. External sites open in a new tab.",
      `<div class="leos-grid">${newsLinks.map(item => `
        <a class="leos-card leos-news-link" href="${item.url}" target="_blank" rel="noreferrer">
          <strong>${item.icon} ${escapeHtml(item.title)}</strong>
          <small>${escapeHtml(item.description)}</small>
          <span class="leos-status-pill">Open legal news</span>
        </a>`).join("")}</div>`);
  }

  function showFirmProfile() {
    const p = getProfile();
    openDrawer("🏢 Firm Information", "Configurable firm name, logo, tagline and basic information.",
      `<div class="leos-grid">
        ${card(p.logoEmoji, p.firmName, p.tagline, `<small>${escapeHtml(p.address)}</small><small>${escapeHtml(p.email)} · ${escapeHtml(p.phone)}</small>`)}
        ${card("🌐", "Website", p.website)}
      </div>
      <hr style="border:none;border-top:1px solid #ebe4d8;margin:16px 0;" />
      <form class="leos-form" id="leos-firm-form">
        <label>Firm Name</label><input name="firmName" value="${escapeHtml(p.firmName)}" />
        <label>Short Name</label><input name="shortName" value="${escapeHtml(p.shortName)}" />
        <label>Logo Emoji / Symbol</label><input name="logoEmoji" value="${escapeHtml(p.logoEmoji)}" />
        <label>Tagline</label><input name="tagline" value="${escapeHtml(p.tagline)}" />
        <label>Address</label><textarea name="address">${escapeHtml(p.address)}</textarea>
        <label>Email</label><input name="email" value="${escapeHtml(p.email)}" />
        <label>Phone</label><input name="phone" value="${escapeHtml(p.phone)}" />
        <label>Website</label><input name="website" value="${escapeHtml(p.website)}" />
        <div class="leos-form-actions">
          <button class="leos-action-btn" type="submit">Save Firm Profile</button>
          <button class="leos-secondary-btn" type="button" id="leos-reset-profile">Reset</button>
        </div>
      </form>`);
    document.getElementById("leos-firm-form").addEventListener("submit", event => {
      event.preventDefault();
      saveProfile({ ...getProfile(), ...Object.fromEntries(new FormData(event.currentTarget).entries()) });
      refreshDockTitle(); showFirmProfile();
    });
    document.getElementById("leos-reset-profile").addEventListener("click", () => {
      localStorage.removeItem("leosFirmProfile"); refreshDockTitle(); showFirmProfile();
    });
  }

  function showPartnerProfile() {
    const p = getProfile();
    openDrawer("👨‍⚖️ Owner / Managing Partner Details", "Editable owner or managing partner information.",
      `<div class="leos-grid">
        ${card(p.partnerAvatar, p.partnerName, p.partnerTitle, `<small>${escapeHtml(p.partnerEmail)} · ${escapeHtml(p.partnerPhone)}</small><small>${escapeHtml(p.partnerCredentials)}</small>`)}
      </div>
      <hr style="border:none;border-top:1px solid #ebe4d8;margin:16px 0;" />
      <form class="leos-form" id="leos-partner-form">
        <label>Name</label><input name="partnerName" value="${escapeHtml(p.partnerName)}" />
        <label>Title / Role</label><input name="partnerTitle" value="${escapeHtml(p.partnerTitle)}" />
        <label>Email</label><input name="partnerEmail" value="${escapeHtml(p.partnerEmail)}" />
        <label>Phone</label><input name="partnerPhone" value="${escapeHtml(p.partnerPhone)}" />
        <label>Credentials</label><textarea name="partnerCredentials">${escapeHtml(p.partnerCredentials)}</textarea>
        <label>Avatar Emoji / Symbol</label><input name="partnerAvatar" value="${escapeHtml(p.partnerAvatar)}" />
        <div class="leos-form-actions"><button class="leos-action-btn" type="submit">Save Partner Profile</button></div>
      </form>`);
    document.getElementById("leos-partner-form").addEventListener("submit", event => {
      event.preventDefault();
      saveProfile({ ...getProfile(), ...Object.fromEntries(new FormData(event.currentTarget).entries()) });
      showPartnerProfile();
    });
  }

  function showSettings() {
    openDrawer("⚙️ Settings & Configuration", "System-wide preferences and configuration areas.",
      `<div class="leos-grid">
        ${card("👤", "User Preferences", "Default workspace, quick links, language and working style.")}
        ${card("🎨", "Display Settings", "Theme, density, font size and layout preferences.")}
        ${card("🔔", "Notification Preferences", "Deadline reminders, alert escalation and staff notifications.")}
        ${card("🛡️", "Access Controls", "Roles, permissions and module visibility. Backend RBAC remains controlled by the system.", `<span class="leos-warning-pill">Review only</span>`)}
        ${card("🏢", "Firm Customization", "Firm profile, logo, tagline and contact details.")}
        ${card("🧾", "Audit & Compliance", "Audit logs, retention rules and compliance evidence.")}
      </div>`);
  }

  function refreshDockTitle() {
    const p = getProfile();
    const firm = document.querySelector("[data-leos-firm]");
    const short = document.querySelector("[data-leos-short]");
    const mark = document.querySelector("[data-leos-mark]");
    if (firm) firm.textContent = p.shortName || p.firmName;
    if (short) short.textContent = p.tagline || "Legal Tools";
    if (mark) mark.textContent = p.logoEmoji || "⚖️";
  }

  function mount() {
    const p = getProfile();
    const dock = document.createElement("aside");
    dock.id = ENHANCER_ID;
    dock.className = "leos-legal-dock";
    dock.innerHTML = `
      <div class="leos-legal-dock-header">
        <div class="leos-legal-mark" data-leos-mark>${escapeHtml(p.logoEmoji)}</div>
        <div class="leos-legal-dock-title">
          <strong data-leos-firm>${escapeHtml(p.shortName || p.firmName)}</strong>
          <small data-leos-short>${escapeHtml(p.tagline)}</small>
        </div>
      </div>
      <button type="button" data-leos-action="search">🔎 Search</button>
      <button type="button" data-leos-action="instructions">📘 Instructions</button>
      <button type="button" data-leos-action="glossary">📚 Glossary</button>
      <button type="button" data-leos-action="firm">🏢 Firm Info</button>
      <button type="button" data-leos-action="partner">👨‍⚖️ Managing Partner</button>
      <button type="button" data-leos-action="news">📰 MY/SG Legal News</button>
      <button type="button" data-leos-action="settings">⚙️ Settings</button>`;
    const drawer = document.createElement("section");
    drawer.id = DRAWER_ID;
    drawer.className = "leos-legal-drawer";
    drawer.setAttribute("aria-live", "polite");
    document.body.appendChild(dock);
    document.body.appendChild(drawer);
    dock.addEventListener("click", event => {
      const button = event.target.closest("[data-leos-action]");
      if (!button) return;
      const action = button.getAttribute("data-leos-action");
      if (action === "search") showSearch();
      if (action === "instructions") showInstructions();
      if (action === "glossary") showGlossary();
      if (action === "firm") showFirmProfile();
      if (action === "partner") showPartnerProfile();
      if (action === "news") showNews();
      if (action === "settings") showSettings();
    });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", mount);
  else mount();
})();
'@

$JsPath = Join-Path $FrontendSrc "legal-management-enhancer.js"
Save-Text -Path $JsPath -Content $Js

Write-Step "Injecting enhancer into frontend/index.html..."

$IndexContent = [System.IO.File]::ReadAllText($IndexHtml)
$ScriptLine = '    <script type="module" src="/src/legal-management-enhancer.js"></script>'
$AlreadyInjected = $IndexContent.Contains('/src/legal-management-enhancer.js')
$InjectStatus = "ALREADY EXISTS"

if (-not $AlreadyInjected) {
    if ($IndexContent -match "</body>") {
        $IndexContent = $IndexContent -replace "</body>", "$ScriptLine`r`n  </body>"
        $InjectStatus = "INJECTED BEFORE BODY CLOSE"
    }
    else {
        $IndexContent = $IndexContent + "`r`n" + $ScriptLine + "`r`n"
        $InjectStatus = "APPENDED - NO BODY CLOSE FOUND"
    }
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($IndexHtml, $IndexContent, $Utf8NoBom)
}

Write-Step "Creating rollback guide and report..."

$RollbackGuide = @"
# PHASE 12.0N ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restore frontend/index.html

Backup:

$IndexBackup

Restore to:

$IndexHtml

Command:

Copy-Item -LiteralPath "$IndexBackup" -Destination "$IndexHtml" -Force

## What this rollback does

Restoring index.html removes the active enhancer injection.

The generated enhancer files can remain safely unused:

$JsPath
$CssPath

## Safety

No database rollback is needed.
No backend rollback is needed.
No production setting rollback is needed.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

$SmokeChecklist = @"
# PHASE 12.0N POST-INJECTION SMOKE CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restart Frontend

cd "$FrontendRoot"
npm run dev

## Open Existing Page

http://localhost:5173/

## Expected Visual Change

You should now see a legal tools panel on the left side with:

- ⚖️ legal branding
- 🔎 Search
- 📘 Instructions
- 📚 Glossary
- 🏢 Firm Info
- 👨‍⚖️ Managing Partner
- 📰 MY/SG Legal News
- ⚙️ Settings

## Existing Pages To Confirm

http://localhost:5173/
http://localhost:5173/clients
http://localhost:5173/cases
http://localhost:5173/deadlines
http://localhost:5173/documents

## Report Back Format

Legal tools panel visible:
YES / NO

Search works:
YES / NO

Instructions works:
YES / NO

Glossary works:
YES / NO

Firm Info editable:
YES / NO

Managing Partner editable:
YES / NO

MY/SG Legal News visible:
YES / NO

Settings works:
YES / NO

Existing pages still work:
YES / NO

Browser console errors:
YES / NO

Backend terminal errors:
YES / NO
"@

Save-Text -Path (Join-Path $RollbackRoot "POST-INJECTION-SMOKE-CHECKLIST.md") -Content $SmokeChecklist

$Report = @"
# PHASE 12.0N ACTIVE LEGAL UI ENHANCER INJECTION REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

frontend/index.html was backed up before injection.
No database was modified.
No backend source was modified.
No Court Dates change was made.
Authentication/RBAC was not modified.
Production feature unlock was NOT performed.
Phase 11 was NOT started.

## Active Files Created / Modified

Created:
$JsPath

Created:
$CssPath

Modified:
$IndexHtml

Backup:
$IndexBackup

## Injection Status

$InjectStatus

## Visual Features Added

- Scales of justice / legal branding
- Search button
- Instructions button
- Glossary button
- Firm Info button
- Managing Partner button
- MY/SG Legal News button
- Settings button

## Rollback Folder

$RollbackRoot

## Test URL

http://localhost:5173/

## Next Action

Restart or refresh frontend.

Then open:

http://localhost:5173/

You should now see the legal tools panel on the left side of the current workspace.

## Files Created

- $RollbackRoot\PHASE-12.0N-PREFLIGHT-CHECK.csv
- $RollbackRoot\ROLLBACK-GUIDE.md
- $RollbackRoot\POST-INJECTION-SMOKE-CHECKLIST.md

## Final Ruling

Phase 12.0N:
ACTIVE LEGAL UI ENHANCER INJECTION COMPLETE

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-ACTIVE-LEGAL-UI-ENHANCER-INJECTION-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0N ACTIVE LEGAL UI ENHANCER INJECTION COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-ACTIVE-LEGAL-UI-ENHANCER-INJECTION-REPORT.md"'
Write-Host ""
Write-Host "Open smoke checklist:" -ForegroundColor Cyan
Write-Host "notepad `"$($RollbackRoot.Substring($ProjectRoot.Length).TrimStart("\"))\POST-INJECTION-SMOKE-CHECKLIST.md`""
Write-Host ""
Write-Host "Test URL:" -ForegroundColor Cyan
Write-Host "http://localhost:5173/"
Write-Host ""
Write-Pass "Paste the Phase 12.0N report and visual result back into ChatGPT."

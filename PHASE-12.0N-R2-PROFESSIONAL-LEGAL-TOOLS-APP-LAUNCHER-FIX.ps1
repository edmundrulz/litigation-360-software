# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R2 PROFESSIONAL LEGAL TOOLS + APP LAUNCHER FIX
#
# PURPOSE:
#   Replace the broken mojibake/emoji legal enhancer with a clean,
#   professional, ASCII-safe legal tools dock.
#
# FIXES:
#   - Removes corrupted emoji display by avoiding raw emoji characters
#   - Uses HTML entities and plain professional labels
#   - Adds Application Launcher
#   - Adds Email / Office / PDF / document category access
#   - Adds Search / Instructions / Glossary / Firm / Partner / News / Settings
#   - Ensures frontend/index.html has UTF-8 charset meta
#
# SAFE MODE:
#   - Backs up index.html and previous enhancer files
#   - Does NOT modify database
#   - Does NOT modify backend
#   - Does NOT unlock production
#   - Does NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0N-R2] $Message" -ForegroundColor Cyan
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

function Backup-If-Exists {
    param(
        [string]$Source,
        [string]$BackupFolder,
        [string]$Name
    )

    if (Test-Path -LiteralPath $Source -PathType Leaf) {
        $Destination = Join-Path $BackupFolder $Name
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        return $Destination
    }

    return ""
}

# ------------------------------------------------------------
# 1. Resolve paths
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$FrontendRoot = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $FrontendRoot "src"
$IndexHtml = Join-Path $FrontendRoot "index.html"

$JsPath = Join-Path $FrontendSrc "legal-management-enhancer.js"
$CssPath = Join-Path $FrontendSrc "legal-management-enhancer.css"

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R2-$RunStamp"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $RollbackRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. Preflight
# ------------------------------------------------------------
Write-Step "Running preflight checks..."

$PreflightRows = @()
$PreflightRows += [PSCustomObject]@{ Item="frontend folder"; Path=$FrontendRoot; Exists=(Test-Path -LiteralPath $FrontendRoot -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="frontend/src folder"; Path=$FrontendSrc; Exists=(Test-Path -LiteralPath $FrontendSrc -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="frontend/index.html"; Path=$IndexHtml; Exists=(Test-Path -LiteralPath $IndexHtml -PathType Leaf) }

$PreflightRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R2-PREFLIGHT-CHECK.csv") -NoTypeInformation -Encoding UTF8

$Missing = @($PreflightRows | Where-Object { $_.Exists -eq $false })

if ($Missing.Count -gt 0) {
    $MissingText = ($Missing | ForEach-Object { "$($_.Item): $($_.Path)" }) -join "`r`n"

    $FailReport = @"
# PHASE 12.0N-R2 FAILED PREFLIGHT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Missing items:

$MissingText

No active modification was performed.
"@

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R2-FAILED-PREFLIGHT-REPORT.md") -Content $FailReport
    Write-Fail "Preflight failed."
    exit 1
}

Write-Pass "Preflight passed."

# ------------------------------------------------------------
# 3. Backup files
# ------------------------------------------------------------
Write-Step "Backing up current enhancer and index files..."

$IndexBackup = Backup-If-Exists -Source $IndexHtml -BackupFolder $RollbackRoot -Name "index.html.BACKUP-BEFORE-12.0N-R2"
$JsBackup = Backup-If-Exists -Source $JsPath -BackupFolder $RollbackRoot -Name "legal-management-enhancer.js.BACKUP-BEFORE-12.0N-R2"
$CssBackup = Backup-If-Exists -Source $CssPath -BackupFolder $RollbackRoot -Name "legal-management-enhancer.css.BACKUP-BEFORE-12.0N-R2"

Write-Pass "Backups created under:"
Write-Host $RollbackRoot -ForegroundColor Green

# ------------------------------------------------------------
# 4. CSS
# ------------------------------------------------------------
Write-Step "Writing professional legal enhancer CSS..."

$Css = @'
.leos-pro-dock,
.leos-pro-drawer,
.leos-pro-drawer * {
  box-sizing: border-box;
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
}

.leos-pro-dock {
  position: fixed;
  left: 14px;
  top: 190px;
  width: 172px;
  max-height: calc(100vh - 210px);
  overflow: auto;
  z-index: 2147483000;
  background: #111827;
  color: #ffffff;
  border: 1px solid rgba(201, 166, 70, 0.45);
  border-radius: 14px;
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.32);
  padding: 10px;
}

.leos-pro-title {
  display: grid;
  gap: 4px;
  border-bottom: 1px solid rgba(255,255,255,0.14);
  padding-bottom: 9px;
  margin-bottom: 8px;
}

.leos-pro-title strong {
  font-size: 14px;
  line-height: 1.2;
}

.leos-pro-title small {
  color: rgba(255,255,255,0.66);
  font-size: 10px;
  line-height: 1.25;
}

.leos-pro-seal {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  border-radius: 12px;
  border: 1px solid rgba(201,166,70,0.72);
  background: rgba(201,166,70,0.15);
  color: #f6d778;
  font-size: 22px;
  margin-bottom: 7px;
}

.leos-pro-dock button {
  cursor: pointer;
  width: 100%;
  border: 1px solid rgba(255,255,255,0.12);
  background: #1f2937;
  color: #ffffff;
  border-radius: 10px;
  padding: 8px 8px;
  margin: 4px 0;
  text-align: left;
  font-size: 11px;
  font-weight: 800;
  line-height: 1.25;
}

.leos-pro-dock button:hover,
.leos-pro-dock button:focus {
  outline: none;
  border-color: rgba(201,166,70,0.85);
  background: #283447;
}

.leos-pro-dock .major {
  background: #f8f3dc;
  color: #111827;
  border-color: #c9a646;
}

.leos-pro-drawer {
  position: fixed;
  left: 210px;
  top: 32px;
  width: min(860px, calc(100vw - 235px));
  max-height: calc(100vh - 64px);
  overflow: auto;
  z-index: 2147483001;
  background: #ffffff;
  color: #111827;
  border: 1px solid #e5decf;
  border-radius: 20px;
  box-shadow: 0 28px 70px rgba(15, 23, 42, 0.32);
  padding: 20px;
  display: none;
}

.leos-pro-drawer.open {
  display: block;
}

.leos-pro-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 14px;
  border-bottom: 1px solid #ebe4d8;
  margin-bottom: 16px;
  padding-bottom: 14px;
}

.leos-pro-head h2 {
  margin: 0;
  color: #111827;
  font-size: 23px;
}

.leos-pro-head p {
  margin: 5px 0 0;
  color: #64748b;
  font-size: 13px;
  line-height: 1.4;
}

.leos-pro-close {
  cursor: pointer;
  border: none;
  border-radius: 999px;
  background: #111827;
  color: #ffffff;
  padding: 8px 12px;
  font-weight: 900;
}

.leos-pro-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
  gap: 12px;
}

.leos-pro-card {
  display: grid;
  gap: 6px;
  min-height: 92px;
  border: 1px solid #e5decf;
  background: #fffdf8;
  border-radius: 16px;
  padding: 14px;
  color: inherit;
  text-decoration: none;
}

.leos-pro-card strong {
  color: #111827;
  font-size: 14px;
  line-height: 1.25;
}

.leos-pro-card span,
.leos-pro-card small,
.leos-pro-card p {
  color: #64748b;
  font-size: 12px;
  line-height: 1.45;
  margin: 0;
}

a.leos-pro-card:hover,
button.leos-pro-card:hover {
  border-color: #c9a646;
  box-shadow: 0 10px 22px rgba(15, 23, 42, 0.12);
}

button.leos-pro-card {
  cursor: pointer;
  text-align: left;
  width: 100%;
}

.leos-pro-input,
.leos-pro-form input,
.leos-pro-form textarea {
  width: 100%;
  border: 1px solid #d8d0c1;
  border-radius: 12px;
  padding: 11px 12px;
  margin-bottom: 10px;
  font: inherit;
}

.leos-pro-form label {
  display: block;
  color: #475569;
  font-size: 12px;
  font-weight: 900;
  margin-bottom: 4px;
}

.leos-pro-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 9px;
  margin-top: 6px;
}

.leos-pro-primary,
.leos-pro-secondary {
  cursor: pointer;
  border-radius: 999px;
  padding: 10px 14px;
  font-weight: 900;
}

.leos-pro-primary {
  border: none;
  background: #111827;
  color: #ffffff;
}

.leos-pro-secondary {
  border: 1px solid #c9a646;
  background: #fff8dd;
  color: #5b4614;
}

.leos-pro-pill {
  display: inline-flex;
  width: fit-content;
  border-radius: 999px;
  background: #ecfdf5;
  color: #047857;
  font-weight: 900;
  padding: 4px 8px;
  font-size: 11px;
}

.leos-pro-warn {
  display: inline-flex;
  width: fit-content;
  border-radius: 999px;
  background: #fff7ed;
  color: #c2410c;
  font-weight: 900;
  padding: 4px 8px;
  font-size: 11px;
}

@media (max-width: 900px) {
  .leos-pro-dock {
    left: 10px;
    right: 10px;
    top: auto;
    bottom: 10px;
    width: auto;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    max-height: 45vh;
  }

  .leos-pro-title {
    grid-column: 1 / -1;
  }

  .leos-pro-drawer {
    left: 10px;
    right: 10px;
    top: 10px;
    width: auto;
    max-height: calc(100vh - 20px);
  }
}
'@

Save-Text -Path $CssPath -Content $Css

# ------------------------------------------------------------
# 5. JS
# ------------------------------------------------------------
Write-Step "Writing professional legal enhancer JS..."

$Js = @'
import "./legal-management-enhancer.css";

(function installProfessionalLegalTools() {
  const DOCK_ID = "leos-pro-legal-dock";
  const DRAWER_ID = "leos-pro-legal-drawer";

  const oldDock = document.getElementById("leos-legal-enhancer");
  const oldDrawer = document.getElementById("leos-legal-drawer");
  if (oldDock) oldDock.remove();
  if (oldDrawer) oldDrawer.remove();

  const existingDock = document.getElementById(DOCK_ID);
  const existingDrawer = document.getElementById(DRAWER_ID);
  if (existingDock) existingDock.remove();
  if (existingDrawer) existingDrawer.remove();

  const defaultProfile = {
    firmName: "Your Law Firm Name",
    shortName: "Legal 360",
    tagline: "Justice - Integrity - Precision",
    address: "Configurable firm address",
    email: "admin@example.com",
    phone: "+60-00-000-0000",
    website: "https://example.com",
    partnerName: "Managing Partner Name",
    partnerTitle: "Managing Partner / Owner",
    partnerEmail: "partner@example.com",
    partnerPhone: "+60-00-000-0000",
    partnerCredentials: "LLB, Advocate and Solicitor, Professional Credentials"
  };

  const repositoryItems = [
    ["Client Files", "Client profiles, IDs, engagement letters, KYC and contact records."],
    ["Matter Folders", "Case files, pleadings, court documents, status notes and progress records."],
    ["Documents", "Drafts, letters, affidavits, bundles, exhibits, templates and filings."],
    ["Deadlines", "Limitation periods, hearing dates, filing deadlines and reminders."],
    ["Legal Research", "Authorities, statutes, legal notes, case summaries and research extracts."],
    ["Billing / Finance", "Invoices, receipts, fee notes, disbursements and payment records."],
    ["Court Operations", "Court locations, attendance plans, hearing preparation and registry follow-ups."],
    ["Audit / Compliance", "Access logs, RBAC checks, compliance evidence and governance records."]
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

  const legalNewsLinks = [
    ["Malaysian Bar Legal News", "Malaysia legal and general legal news.", "https://www.malaysianbar.org.my/list/news/legal-and-general-news/legal-news"],
    ["Malaysian Bar Main Portal", "Malaysia Bar updates, legal resources and public information.", "https://www.malaysianbar.org.my/"],
    ["Singapore Law Watch Headlines", "Singapore legal headlines and legal sector updates.", "https://www.singaporelawwatch.sg/Headlines/category/overview"],
    ["Singapore Ministry of Law News", "Official Singapore legal-sector announcements and press releases.", "https://www.mlaw.gov.sg/news/press-releases/"],
    ["Singapore Courts News", "Singapore Judiciary news and resources.", "https://www.judiciary.gov.sg/news-and-resources/news"]
  ];

  const appLaunchItems = [
    ["New Email", "Create a new email using the default mail application.", "mailto:?subject=Litigation%20360"],
    ["Outlook Web Mail", "Open Microsoft Outlook web mail.", "https://outlook.office.com/mail/"],
    ["Gmail", "Open Gmail in the browser.", "https://mail.google.com/"],
    ["Microsoft Word", "Open Word for the web through Microsoft 365.", "https://www.office.com/launch/word"],
    ["Microsoft Excel", "Open Excel for the web through Microsoft 365.", "https://www.office.com/launch/excel"],
    ["Microsoft PowerPoint", "Open PowerPoint for the web through Microsoft 365.", "https://www.office.com/launch/powerpoint"],
    ["OneDrive", "Open Microsoft OneDrive.", "https://onedrive.live.com/"],
    ["SharePoint", "Open Microsoft 365 SharePoint landing page.", "https://www.microsoft365.com/launch/sharepoint"],
    ["Adobe Acrobat Online", "Open Adobe Acrobat web tools for PDFs.", "https://acrobat.adobe.com/link/home/"],
    ["Google Drive", "Open Google Drive.", "https://drive.google.com/"],
    ["Google Docs", "Open Google Docs.", "https://docs.google.com/"],
    ["Google Sheets", "Open Google Sheets.", "https://sheets.google.com/"]
  ];

  const internalDocumentLaunch = [
    ["Email Attachments", "Find email attachments connected to clients, matters, deadlines or documents."],
    ["Word Documents", "Open or search draft letters, pleadings, agreements and internal notes."],
    ["PDF Documents", "Open or search scanned documents, authorities, bundles, exhibits and signed PDFs."],
    ["Excel Sheets", "Open or search schedules, ledgers, trackers and matter spreadsheets."],
    ["PowerPoint Files", "Open or search presentations, briefings and visual summaries."],
    ["Templates", "Open or search firm templates, letters, forms and precedents."],
    ["Court Bundles", "Open or search bundles, exhibits, authorities and hearing papers."],
    ["Scanned Files", "Open or search scanned files and OCR document folders."]
  ];

  function getProfile() {
    try {
      return { ...defaultProfile, ...(JSON.parse(localStorage.getItem("leosFirmProfile") || "{}")) };
    } catch {
      return { ...defaultProfile };
    }
  }

  function saveProfile(profile) {
    localStorage.setItem("leosFirmProfile", JSON.stringify(profile));
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function card(title, description, marker) {
    return `
      <article class="leos-pro-card">
        <strong>${marker || "&#167;"} ${escapeHtml(title)}</strong>
        <span>${escapeHtml(description)}</span>
      </article>
    `;
  }

  function linkCard(title, description, url, marker) {
    return `
      <a class="leos-pro-card" href="${escapeHtml(url)}" target="_blank" rel="noreferrer">
        <strong>${marker || "&#128279;"} ${escapeHtml(title)}</strong>
        <span>${escapeHtml(description)}</span>
        <small class="leos-pro-pill">Open</small>
      </a>
    `;
  }

  function openDrawer(title, subtitle, html) {
    const drawer = document.getElementById(DRAWER_ID);
    drawer.innerHTML = `
      <div class="leos-pro-head">
        <div>
          <h2>${title}</h2>
          <p>${subtitle}</p>
        </div>
        <button class="leos-pro-close" type="button" data-close>Close</button>
      </div>
      ${html}
    `;
    drawer.classList.add("open");
    drawer.querySelector("[data-close]").addEventListener("click", () => drawer.classList.remove("open"));
  }

  function showSearch() {
    const itemHtml = repositoryItems.map(([title, desc]) => card(title, desc, "&#128193;")).join("");
    openDrawer(
      "Search Legal Repository",
      "Find documents, files, folders, client records, matter records and legal references.",
      `
        <input class="leos-pro-input" id="leos-pro-search" placeholder="Search clients, matters, documents, deadlines, folders..." />
        <div class="leos-pro-grid" id="leos-pro-search-results">${itemHtml}</div>
      `
    );

    const input = document.getElementById("leos-pro-search");
    const results = document.getElementById("leos-pro-search-results");
    input.addEventListener("input", () => {
      const q = input.value.toLowerCase();
      const filtered = repositoryItems.filter(([title, desc]) => (title + " " + desc).toLowerCase().includes(q));
      results.innerHTML = filtered.length
        ? filtered.map(([title, desc]) => card(title, desc, "&#128193;")).join("")
        : card("No match", "No matching legal repository folder found.", "&#128269;");
    });
  }

  function showInstructions() {
    openDrawer(
      "Instructions and User Guides",
      "Training, tutorials, SOPs and help documentation for staff.",
      `
        <div class="leos-pro-grid">
          ${card("Getting Started Guide", "How to use the Legal 360 workspace safely.", "&#9658;")}
          ${card("Client Intake Workflow", "Opening a client record, checking profile completeness and locating client files.", "&#128100;")}
          ${card("Matter Opening SOP", "How matters should be opened, labelled, linked and monitored.", "&#128188;")}
          ${card("Document Handling Guide", "Document upload, naming, review, filing and archive practices.", "&#128196;")}
          ${card("Deadline Monitoring Guide", "How to check deadlines, reminders and court-related dates.", "&#9200;")}
          ${card("Security / RBAC / Audit SOP", "How access controls, user roles and audit logs should be reviewed.", "&#128274;")}
        </div>
      `
    );
  }

  function showGlossary() {
    openDrawer(
      "Legal Glossary",
      "Common legal terms and internal terminology used in this system.",
      `<div class="leos-pro-grid">${glossaryTerms.map(([term, definition]) => card(term, definition, "&#9878;")).join("")}</div>`
    );
  }

  function showLaunchApps() {
    openDrawer(
      "Launch Applications and Document Tools",
      "Open email, Microsoft Office, PDF tools, cloud drives and document categories.",
      `
        <h3>External Applications</h3>
        <div class="leos-pro-grid">
          ${appLaunchItems.map(([title, desc, url]) => linkCard(title, desc, url, "&#128279;")).join("")}
        </div>

        <h3 style="margin-top:18px;">Internal Document Categories</h3>
        <div class="leos-pro-grid">
          ${internalDocumentLaunch.map(([title, desc]) => card(title, desc, "&#128196;")).join("")}
        </div>

        <article class="leos-pro-card" style="margin-top:14px;">
          <strong>&#9888; Desktop app launching note</strong>
          <span>Browsers cannot safely open local Windows programs, folders or local Office files without a trusted connector. For true desktop launch actions, use Windows Power Automate, an Electron shell, or a backend helper with strict allow-listed paths.</span>
        </article>
      `
    );
  }

  function showNews() {
    openDrawer(
      "Malaysia and Singapore Legal News",
      "Staff legal-awareness links. External sites open in a new tab.",
      `<div class="leos-pro-grid">${legalNewsLinks.map(([title, desc, url]) => linkCard(title, desc, url, "&#128240;")).join("")}</div>`
    );
  }

  function showFirm() {
    const p = getProfile();
    openDrawer(
      "Firm Information",
      "Configurable firm name, logo, tagline and basic firm information.",
      `
        <div class="leos-pro-grid">
          ${card(p.firmName, p.tagline + " | " + p.address, "&#127963;")}
          ${card("Contact", p.email + " | " + p.phone + " | " + p.website, "&#9742;")}
        </div>

        <form class="leos-pro-form" id="leos-pro-firm-form" style="margin-top:16px;">
          <label>Firm Name</label><input name="firmName" value="${escapeHtml(p.firmName)}" />
          <label>Short Name</label><input name="shortName" value="${escapeHtml(p.shortName)}" />
          <label>Tagline</label><input name="tagline" value="${escapeHtml(p.tagline)}" />
          <label>Address</label><textarea name="address">${escapeHtml(p.address)}</textarea>
          <label>Email</label><input name="email" value="${escapeHtml(p.email)}" />
          <label>Phone</label><input name="phone" value="${escapeHtml(p.phone)}" />
          <label>Website</label><input name="website" value="${escapeHtml(p.website)}" />
          <div class="leos-pro-actions">
            <button class="leos-pro-primary" type="submit">Save Firm Profile</button>
            <button class="leos-pro-secondary" type="button" id="leos-pro-reset-profile">Reset</button>
          </div>
        </form>
      `
    );

    document.getElementById("leos-pro-firm-form").addEventListener("submit", event => {
      event.preventDefault();
      const data = Object.fromEntries(new FormData(event.currentTarget).entries());
      saveProfile({ ...getProfile(), ...data });
      refreshDockTitle();
      showFirm();
    });

    document.getElementById("leos-pro-reset-profile").addEventListener("click", () => {
      localStorage.removeItem("leosFirmProfile");
      refreshDockTitle();
      showFirm();
    });
  }

  function showPartner() {
    const p = getProfile();
    openDrawer(
      "Owner / Managing Partner Details",
      "Editable owner or managing partner information.",
      `
        <div class="leos-pro-grid">
          ${card(p.partnerName, p.partnerTitle + " | " + p.partnerEmail + " | " + p.partnerPhone, "&#128188;")}
          ${card("Credentials", p.partnerCredentials, "&#167;")}
        </div>

        <form class="leos-pro-form" id="leos-pro-partner-form" style="margin-top:16px;">
          <label>Name</label><input name="partnerName" value="${escapeHtml(p.partnerName)}" />
          <label>Title / Role</label><input name="partnerTitle" value="${escapeHtml(p.partnerTitle)}" />
          <label>Email</label><input name="partnerEmail" value="${escapeHtml(p.partnerEmail)}" />
          <label>Phone</label><input name="partnerPhone" value="${escapeHtml(p.partnerPhone)}" />
          <label>Credentials</label><textarea name="partnerCredentials">${escapeHtml(p.partnerCredentials)}</textarea>
          <div class="leos-pro-actions">
            <button class="leos-pro-primary" type="submit">Save Managing Partner</button>
          </div>
        </form>
      `
    );

    document.getElementById("leos-pro-partner-form").addEventListener("submit", event => {
      event.preventDefault();
      const data = Object.fromEntries(new FormData(event.currentTarget).entries());
      saveProfile({ ...getProfile(), ...data });
      showPartner();
    });
  }

  function showSettings() {
    openDrawer(
      "Settings and Configuration",
      "System-wide preferences and administrative configuration categories.",
      `
        <div class="leos-pro-grid">
          ${card("User Preferences", "Default workspace, quick links, language and working style.", "&#128100;")}
          ${card("Display Settings", "Theme, density, font size and layout preferences.", "&#9638;")}
          ${card("Notification Preferences", "Deadline reminders, alert escalation and staff notifications.", "&#128276;")}
          ${card("Access Controls", "Roles, permissions and module visibility. Backend RBAC remains controlled by the system.", "&#128274;")}
          ${card("Firm Customization", "Firm profile, logo, tagline and contact details.", "&#127963;")}
          ${card("Audit and Compliance", "Audit logs, retention rules and compliance evidence.", "&#128221;")}
          ${card("Application Launcher", "Configure allowed app links, document categories and future Power Automate connectors.", "&#128640;")}
          ${card("PDF and Office Handling", "Configure Word, Excel, PowerPoint, PDF and scanned document handling rules.", "&#128196;")}
        </div>
      `
    );
  }

  function refreshDockTitle() {
    const p = getProfile();
    const firm = document.querySelector("[data-leos-firm]");
    const sub = document.querySelector("[data-leos-sub]");
    if (firm) firm.textContent = p.shortName || "Legal 360";
    if (sub) sub.textContent = p.tagline || "Legal Tools";
  }

  function mount() {
    const p = getProfile();

    const dock = document.createElement("aside");
    dock.id = DOCK_ID;
    dock.className = "leos-pro-dock";
    dock.innerHTML = `
      <div class="leos-pro-title">
        <div class="leos-pro-seal">&#9878;</div>
        <strong data-leos-firm>${escapeHtml(p.shortName || "Legal 360")}</strong>
        <small data-leos-sub>${escapeHtml(p.tagline || "Legal Tools")}</small>
      </div>
      <button class="major" type="button" data-action="launch">Launch Apps / Docs</button>
      <button type="button" data-action="search">Search Repository</button>
      <button type="button" data-action="instructions">Instructions</button>
      <button type="button" data-action="glossary">Glossary</button>
      <button type="button" data-action="firm">Firm Info</button>
      <button type="button" data-action="partner">Managing Partner</button>
      <button type="button" data-action="news">MY/SG Legal News</button>
      <button type="button" data-action="settings">Settings</button>
    `;

    const drawer = document.createElement("section");
    drawer.id = DRAWER_ID;
    drawer.className = "leos-pro-drawer";
    drawer.setAttribute("aria-live", "polite");

    document.body.appendChild(dock);
    document.body.appendChild(drawer);

    dock.addEventListener("click", event => {
      const button = event.target.closest("[data-action]");
      if (!button) return;

      const action = button.getAttribute("data-action");
      if (action === "launch") showLaunchApps();
      if (action === "search") showSearch();
      if (action === "instructions") showInstructions();
      if (action === "glossary") showGlossary();
      if (action === "firm") showFirm();
      if (action === "partner") showPartner();
      if (action === "news") showNews();
      if (action === "settings") showSettings();
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mount);
  } else {
    mount();
  }
})();
'@

Save-Text -Path $JsPath -Content $Js

# ------------------------------------------------------------
# 6. Ensure index injection and charset
# ------------------------------------------------------------
Write-Step "Ensuring index.html has UTF-8 and enhancer script..."

$IndexContent = [System.IO.File]::ReadAllText($IndexHtml)

$CharsetStatus = "ALREADY PRESENT"
if (-not ($IndexContent -match '<meta\s+charset=')) {
    if ($IndexContent -match '<head[^>]*>') {
        $IndexContent = $IndexContent -replace '(<head[^>]*>)', "`$1`r`n    <meta charset=""UTF-8"" />"
        $CharsetStatus = "INSERTED"
    }
    else {
        $IndexContent = "<meta charset=""UTF-8"" />`r`n" + $IndexContent
        $CharsetStatus = "PREPENDED"
    }
}

$ScriptLine = '    <script type="module" src="/src/legal-management-enhancer.js"></script>'
$ScriptStatus = "ALREADY PRESENT"

if (-not $IndexContent.Contains('/src/legal-management-enhancer.js')) {
    if ($IndexContent -match '</body>') {
        $IndexContent = $IndexContent -replace '</body>', "$ScriptLine`r`n  </body>"
        $ScriptStatus = "INJECTED BEFORE BODY CLOSE"
    }
    else {
        $IndexContent = $IndexContent + "`r`n" + $ScriptLine + "`r`n"
        $ScriptStatus = "APPENDED"
    }
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($IndexHtml, $IndexContent, $Utf8NoBom)

# ------------------------------------------------------------
# 7. Rollback and report
# ------------------------------------------------------------
Write-Step "Creating rollback guide and report..."

$RollbackGuide = @"
# PHASE 12.0N-R2 ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restore index.html

Copy-Item -LiteralPath "$IndexBackup" -Destination "$IndexHtml" -Force

## Restore previous enhancer JS, if needed

$JsBackup

## Restore previous enhancer CSS, if needed

$CssBackup

## Safe note

Restoring index.html removes the active enhancer script reference.
No database or backend rollback is needed.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

$Checklist = @"
# PHASE 12.0N-R2 POST-FIX CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restart frontend

cd "$FrontendRoot"
npm run dev

## Open

http://localhost:5173/

## Expected

The broken emoji garbage should be gone.

You should see a compact professional Legal 360 dock with:

- Launch Apps / Docs
- Search Repository
- Instructions
- Glossary
- Firm Info
- Managing Partner
- MY/SG Legal News
- Settings

## Test

Click Launch Apps / Docs.

You should see:
- New Email
- Outlook Web Mail
- Gmail
- Microsoft Word
- Microsoft Excel
- Microsoft PowerPoint
- OneDrive
- SharePoint
- Adobe Acrobat Online
- Google Drive
- Google Docs
- Google Sheets
- Internal document categories for Word, PDF, Excel, PowerPoint, scanned files, templates, court bundles, and email attachments

## Report back

Broken emoji text gone:
YES / NO

Launch Apps / Docs visible:
YES / NO

Email link visible:
YES / NO

MS Office links visible:
YES / NO

PDF tools visible:
YES / NO

Internal document categories visible:
YES / NO

Search works:
YES / NO

Firm/Partner editable:
YES / NO

Existing pages still work:
YES / NO

Browser console errors:
YES / NO
"@

Save-Text -Path (Join-Path $RollbackRoot "POST-FIX-CHECKLIST.md") -Content $Checklist

$Report = @"
# PHASE 12.0N-R2 PROFESSIONAL LEGAL TOOLS + APP LAUNCHER FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

frontend/index.html was backed up.
Previous enhancer files were backed up if present.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Files Written

$JsPath
$CssPath

## Files Modified

$IndexHtml

## Backup Folder

$RollbackRoot

## Charset Status

$CharsetStatus

## Script Injection Status

$ScriptStatus

## Visible Fixes

- Removed corrupted raw emoji labels
- Added professional compact Legal 360 dock
- Added Launch Apps / Docs
- Added Email links
- Added Microsoft Office links
- Added PDF tools link
- Added internal document categories
- Added Search Repository
- Added Instructions
- Added Glossary
- Added Firm Info editor
- Added Managing Partner editor
- Added MY/SG Legal News
- Added Settings

## Important Limitation

A normal browser cannot safely launch local Windows desktop programs, local folders, or local Office files directly without a trusted connector.

For true desktop launch actions later, use one of:
- Windows Power Automate
- Electron shell
- backend helper with strict allow-listed paths
- Microsoft Graph / SharePoint / OneDrive integration

## Test URL

http://localhost:5173/

## Final Ruling

Phase 12.0N-R2:
PROFESSIONAL LEGAL TOOLS + APP LAUNCHER FIX COMPLETE

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R2-PROFESSIONAL-LEGAL-TOOLS-APP-LAUNCHER-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0N-R2 PROFESSIONAL LEGAL TOOLS + APP LAUNCHER FIX COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R2-PROFESSIONAL-LEGAL-TOOLS-APP-LAUNCHER-FIX-REPORT.md"'
Write-Host ""
Write-Host "Open checklist:" -ForegroundColor Cyan
Write-Host "notepad `"$($RollbackRoot.Substring($ProjectRoot.Length).TrimStart("\"))\POST-FIX-CHECKLIST.md`""
Write-Host ""
Write-Host "Test URL:" -ForegroundColor Cyan
Write-Host "http://localhost:5173/"
Write-Host ""
Write-Pass "Paste the Phase 12.0N-R2 report and visual result back into ChatGPT."

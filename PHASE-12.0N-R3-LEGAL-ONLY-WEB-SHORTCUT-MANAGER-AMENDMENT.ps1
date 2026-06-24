# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R3 LEGAL-ONLY WEB SHORTCUT MANAGER AMENDMENT
#
# PURPOSE:
#   Amend the visible Legal 360 dock so staff can manually add more
#   LEGAL-ONLY web shortcuts.
#
# WHAT THIS ADDS:
#   - Separate "Legal Web Links" button
#   - Manual add form for legal-only links
#   - Categories:
#       Legal News
#       Legal Forms
#       Legal Research
#       Court / Tribunal Portal
#       Bar / Regulator
#       Government Legal Portal
#       Client-Lawyer Work Portal
#       Legal Document Portal
#       Law Firm Resource
#   - Local browser storage for manually added links
#   - Delete button for manually added links
#   - Legal-only reminder and prohibited categories warning
#
# WHAT THIS DOES NOT DO:
#   - Does NOT mix legal links with Launch Apps / Docs
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
    Write-Host "[PHASE 12.0N-R3] $Message" -ForegroundColor Cyan
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R3-$RunStamp"

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
$PreflightRows += [PSCustomObject]@{ Item="legal-management-enhancer.js"; Path=$JsPath; Exists=(Test-Path -LiteralPath $JsPath -PathType Leaf) }
$PreflightRows += [PSCustomObject]@{ Item="legal-management-enhancer.css"; Path=$CssPath; Exists=(Test-Path -LiteralPath $CssPath -PathType Leaf) }

$PreflightRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R3-PREFLIGHT-CHECK.csv") -NoTypeInformation -Encoding UTF8

$Missing = @($PreflightRows | Where-Object { $_.Exists -eq $false })

if ($Missing.Count -gt 0) {
    $MissingText = ($Missing | ForEach-Object { "$($_.Item): $($_.Path)" }) -join "`r`n"

    $FailReport = @"
# PHASE 12.0N-R3 FAILED PREFLIGHT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Missing items:

$MissingText

No active modification was performed.

Recommended fix:
Run Phase 12.0N-R2 first, then run this R3 amendment.
"@

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R3-FAILED-PREFLIGHT-REPORT.md") -Content $FailReport
    Write-Fail "Preflight failed."
    exit 1
}

Write-Pass "Preflight passed."

# ------------------------------------------------------------
# 3. Backup files
# ------------------------------------------------------------
Write-Step "Backing up current enhancer and index files..."

$IndexBackup = Backup-If-Exists -Source $IndexHtml -BackupFolder $RollbackRoot -Name "index.html.BACKUP-BEFORE-12.0N-R3"
$JsBackup = Backup-If-Exists -Source $JsPath -BackupFolder $RollbackRoot -Name "legal-management-enhancer.js.BACKUP-BEFORE-12.0N-R3"
$CssBackup = Backup-If-Exists -Source $CssPath -BackupFolder $RollbackRoot -Name "legal-management-enhancer.css.BACKUP-BEFORE-12.0N-R3"

Write-Pass "Backups created under:"
Write-Host $RollbackRoot -ForegroundColor Green

# ------------------------------------------------------------
# 4. Append small CSS additions only
# ------------------------------------------------------------
Write-Step "Adding CSS for legal-only shortcut manager..."

$CssAppend = @'

/* PHASE 12.0N-R3 Legal-only shortcut manager additions */
.leos-pro-legal-rule {
  border: 1px solid #bfdbfe;
  background: #eff6ff;
  color: #1e3a8a;
  border-radius: 14px;
  padding: 12px;
  margin-bottom: 14px;
  font-size: 12px;
  line-height: 1.45;
}

.leos-pro-danger-rule {
  border: 1px solid #fed7aa;
  background: #fff7ed;
  color: #9a3412;
  border-radius: 14px;
  padding: 12px;
  margin-bottom: 14px;
  font-size: 12px;
  line-height: 1.45;
}

.leos-pro-link-row {
  display: grid;
  gap: 8px;
}

.leos-pro-link-tools {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-top: 6px;
}

.leos-pro-delete {
  cursor: pointer;
  border: 1px solid #fecaca;
  background: #fef2f2;
  color: #991b1b;
  border-radius: 999px;
  padding: 7px 10px;
  font-weight: 900;
  font-size: 11px;
}

.leos-pro-legal-category {
  display: inline-flex;
  width: fit-content;
  border-radius: 999px;
  background: #eef2ff;
  color: #3730a3;
  font-weight: 900;
  padding: 4px 8px;
  font-size: 11px;
}

.leos-pro-form select {
  width: 100%;
  border: 1px solid #d8d0c1;
  border-radius: 12px;
  padding: 11px 12px;
  margin-bottom: 10px;
  font: inherit;
  background: #ffffff;
}
'@

$ExistingCss = [System.IO.File]::ReadAllText($CssPath)
if (-not $ExistingCss.Contains("PHASE 12.0N-R3 Legal-only shortcut manager additions")) {
    Save-Text -Path $CssPath -Content ($ExistingCss + "`r`n" + $CssAppend)
}

# ------------------------------------------------------------
# 5. Replace JS with upgraded professional version
# ------------------------------------------------------------
Write-Step "Writing upgraded legal enhancer JS with legal-only link manager..."

$Js = @'
import "./legal-management-enhancer.css";

(function installProfessionalLegalTools() {
  const DOCK_ID = "leos-pro-legal-dock";
  const DRAWER_ID = "leos-pro-legal-drawer";
  const CUSTOM_LEGAL_LINKS_KEY = "leosCustomLegalLinks";

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

  const allowedLegalCategories = [
    "Legal News",
    "Legal Forms",
    "Legal Research",
    "Court / Tribunal Portal",
    "Bar / Regulator",
    "Government Legal Portal",
    "Client-Lawyer Work Portal",
    "Legal Document Portal",
    "Law Firm Resource"
  ];

  const defaultLegalLinks = [
    ["Malaysian Bar Legal News", "Malaysia legal and general legal news.", "https://www.malaysianbar.org.my/list/news/legal-and-general-news/legal-news", "Legal News"],
    ["Malaysian Bar Main Portal", "Malaysia Bar updates, legal resources and public information.", "https://www.malaysianbar.org.my/", "Bar / Regulator"],
    ["Singapore Law Watch Headlines", "Singapore legal headlines and legal sector updates.", "https://www.singaporelawwatch.sg/Headlines/category/overview", "Legal News"],
    ["Singapore Ministry of Law News", "Official Singapore legal-sector announcements and press releases.", "https://www.mlaw.gov.sg/news/press-releases/", "Government Legal Portal"],
    ["Singapore Courts News", "Singapore Judiciary news and resources.", "https://www.judiciary.gov.sg/news-and-resources/news", "Court / Tribunal Portal"]
  ];

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

  function getCustomLegalLinks() {
    try {
      const parsed = JSON.parse(localStorage.getItem(CUSTOM_LEGAL_LINKS_KEY) || "[]");
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  }

  function saveCustomLegalLinks(links) {
    localStorage.setItem(CUSTOM_LEGAL_LINKS_KEY, JSON.stringify(links));
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function normalizeUrl(url) {
    const trimmed = String(url || "").trim();
    if (!trimmed) return "";
    if (trimmed.startsWith("http://") || trimmed.startsWith("https://") || trimmed.startsWith("mailto:")) return trimmed;
    return "https://" + trimmed;
  }

  function isLegalCategory(category) {
    return allowedLegalCategories.includes(category);
  }

  function card(title, description, marker) {
    return `
      <article class="leos-pro-card">
        <strong>${marker || "&#167;"} ${escapeHtml(title)}</strong>
        <span>${escapeHtml(description)}</span>
      </article>
    `;
  }

  function linkCard(title, description, url, marker, category, customIndex) {
    const deleteButton = Number.isInteger(customIndex)
      ? `<button class="leos-pro-delete" type="button" data-delete-legal-link="${customIndex}">Delete manual link</button>`
      : "";
    return `
      <article class="leos-pro-card leos-pro-link-row">
        <a href="${escapeHtml(url)}" target="_blank" rel="noreferrer" style="color:inherit;text-decoration:none;">
          <strong>${marker || "&#128279;"} ${escapeHtml(title)}</strong>
          <span>${escapeHtml(description)}</span>
        </a>
        <span class="leos-pro-legal-category">${escapeHtml(category || "Legal Link")}</span>
        <div class="leos-pro-link-tools">
          <a class="leos-pro-pill" href="${escapeHtml(url)}" target="_blank" rel="noreferrer" style="text-decoration:none;">Open</a>
          ${deleteButton}
        </div>
      </article>
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

  function renderLegalLinksHtml(filterText = "") {
    const q = String(filterText || "").toLowerCase();
    const defaults = defaultLegalLinks
      .map(([title, desc, url, category]) => ({ title, desc, url, category, source: "Default" }));
    const customs = getCustomLegalLinks()
      .map((item, index) => ({ ...item, source: "Manual", customIndex: index }));

    const all = [...defaults, ...customs]
      .filter(item => {
        const haystack = `${item.title} ${item.desc} ${item.url} ${item.category}`.toLowerCase();
        return haystack.includes(q);
      });

    if (!all.length) {
      return card("No legal link found", "No matching legal-only shortcut was found.", "&#128269;");
    }

    return all.map(item => linkCard(item.title, item.desc, item.url, "&#128279;", item.category, item.source === "Manual" ? item.customIndex : null)).join("");
  }

  function showLegalLinks() {
    openDrawer(
      "Legal-Only Web Shortcuts",
      "Manual legal-only links for legal news, legal forms, legal issues, legal research, court portals and client-lawyer work resources.",
      `
        <div class="leos-pro-legal-rule">
          <strong>Legal-only rule:</strong>
          Add only legal-based websites: legal news, legal forms, court portals, bar/regulator pages, legal research, government legal portals, client-lawyer work portals, legal document portals, and law-firm work resources.
        </div>

        <div class="leos-pro-danger-rule">
          <strong>Do not mix here:</strong>
          General shopping, entertainment, social media, unrelated news, random tools, non-legal business sites, or personal links. General apps remain under "Launch Apps / Docs".
        </div>

        <input class="leos-pro-input" id="leos-legal-link-search" placeholder="Search legal shortcuts..." />

        <div class="leos-pro-grid" id="leos-legal-links-grid">
          ${renderLegalLinksHtml("")}
        </div>

        <hr style="border:none;border-top:1px solid #ebe4d8;margin:18px 0;" />

        <h3>Add Manual Legal Link</h3>

        <form class="leos-pro-form" id="leos-add-legal-link-form">
          <label>Legal Link Title</label>
          <input name="title" placeholder="Example: Malaysian Court Forms" required />

          <label>URL</label>
          <input name="url" placeholder="https://..." required />

          <label>Legal Category</label>
          <select name="category" required>
            ${allowedLegalCategories.map(category => `<option value="${escapeHtml(category)}">${escapeHtml(category)}</option>`).join("")}
          </select>

          <label>Description / Use</label>
          <textarea name="desc" placeholder="Example: Official legal forms, court filing guidance, legal research, law-firm client document portal..." required></textarea>

          <div class="leos-pro-actions">
            <button class="leos-pro-primary" type="submit">Add Legal-Only Link</button>
            <button class="leos-pro-secondary" type="button" id="leos-clear-manual-legal-links">Clear All Manual Legal Links</button>
          </div>
        </form>
      `
    );

    const search = document.getElementById("leos-legal-link-search");
    const grid = document.getElementById("leos-legal-links-grid");

    function refreshGrid() {
      grid.innerHTML = renderLegalLinksHtml(search.value);
      grid.querySelectorAll("[data-delete-legal-link]").forEach(button => {
        button.addEventListener("click", () => {
          const index = Number(button.getAttribute("data-delete-legal-link"));
          const links = getCustomLegalLinks();
          links.splice(index, 1);
          saveCustomLegalLinks(links);
          refreshGrid();
        });
      });
    }

    search.addEventListener("input", refreshGrid);
    refreshGrid();

    document.getElementById("leos-add-legal-link-form").addEventListener("submit", event => {
      event.preventDefault();
      const form = Object.fromEntries(new FormData(event.currentTarget).entries());

      const title = String(form.title || "").trim();
      const url = normalizeUrl(form.url);
      const category = String(form.category || "").trim();
      const desc = String(form.desc || "").trim();

      if (!title || !url || !desc || !isLegalCategory(category)) {
        alert("This shortcut was not added. Please complete all fields and choose an approved legal category only.");
        return;
      }

      const links = getCustomLegalLinks();
      links.push({ title, url, category, desc, addedAt: new Date().toISOString() });
      saveCustomLegalLinks(links);
      event.currentTarget.reset();
      refreshGrid();
    });

    document.getElementById("leos-clear-manual-legal-links").addEventListener("click", () => {
      const confirmClear = confirm("Clear all manually added legal-only links from this browser?");
      if (confirmClear) {
        saveCustomLegalLinks([]);
        refreshGrid();
      }
    });
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
      "General app launcher for email, Microsoft Office, PDF tools, cloud drives and document categories.",
      `
        <div class="leos-pro-danger-rule">
          <strong>Separation rule:</strong>
          This area is for general work applications and document tools. Legal-only websites belong under "Legal Web Links".
        </div>

        <h3>External Applications</h3>
        <div class="leos-pro-grid">
          ${appLaunchItems.map(([title, desc, url]) => linkCard(title, desc, url, "&#128279;", "Work Application", null)).join("")}
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
          ${card("Legal Web Links", "Manage legal-only shortcuts separately from general work apps.", "&#167;")}
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
      <button class="major" type="button" data-action="legal-links">Legal Web Links</button>
      <button type="button" data-action="launch">Launch Apps / Docs</button>
      <button type="button" data-action="search">Search Repository</button>
      <button type="button" data-action="instructions">Instructions</button>
      <button type="button" data-action="glossary">Glossary</button>
      <button type="button" data-action="firm">Firm Info</button>
      <button type="button" data-action="partner">Managing Partner</button>
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
      if (action === "legal-links") showLegalLinks();
      if (action === "launch") showLaunchApps();
      if (action === "search") showSearch();
      if (action === "instructions") showInstructions();
      if (action === "glossary") showGlossary();
      if (action === "firm") showFirm();
      if (action === "partner") showPartner();
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
# 6. Ensure index still references enhancer
# ------------------------------------------------------------
Write-Step "Ensuring frontend/index.html references enhancer..."

$IndexContent = [System.IO.File]::ReadAllText($IndexHtml)

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

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($IndexHtml, $IndexContent, $Utf8NoBom)
}

# ------------------------------------------------------------
# 7. Rollback, checklist, report
# ------------------------------------------------------------
Write-Step "Creating rollback guide and report..."

$RollbackGuide = @"
# PHASE 12.0N-R3 ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restore previous JS

Copy-Item -LiteralPath "$JsBackup" -Destination "$JsPath" -Force

## Restore previous CSS

Copy-Item -LiteralPath "$CssBackup" -Destination "$CssPath" -Force

## Restore index.html if needed

Copy-Item -LiteralPath "$IndexBackup" -Destination "$IndexHtml" -Force

## Note

Manual legal links are stored in browser localStorage under:
leosCustomLegalLinks

To clear manually added legal links, use the button inside Legal Web Links or clear localStorage.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

$Checklist = @"
# PHASE 12.0N-R3 POST-AMENDMENT CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restart frontend

cd "$FrontendRoot"
npm run dev

## Open

http://localhost:5173/

## Expected

Dock should show:

- Legal Web Links
- Launch Apps / Docs
- Search Repository
- Instructions
- Glossary
- Firm Info
- Managing Partner
- Settings

## Click Legal Web Links

Expected:

- Default Malaysia/Singapore legal links
- Search legal shortcuts input
- Add Manual Legal Link form
- Category dropdown with legal-only categories
- Delete manual link button after adding one
- Legal-only reminder
- Do-not-mix warning

## Test Add Link

Add a legal-only test link such as:

Title:
Test Legal Research Link

URL:
https://www.malaysianbar.org.my/

Category:
Bar / Regulator

Description:
Legal professional reference link for testing.

Then confirm it appears.

## Report Back

Legal Web Links visible:
YES / NO

Manual Add Legal Link form visible:
YES / NO

Legal-only categories visible:
YES / NO

Added legal test link appears:
YES / NO

Delete manual link works:
YES / NO

Launch Apps / Docs still separate:
YES / NO

Existing pages still work:
YES / NO

Browser console errors:
YES / NO
"@

Save-Text -Path (Join-Path $RollbackRoot "POST-AMENDMENT-CHECKLIST.md") -Content $Checklist

$Report = @"
# PHASE 12.0N-R3 LEGAL-ONLY WEB SHORTCUT MANAGER AMENDMENT REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

Previous enhancer files were backed up.
frontend/index.html was backed up.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Files Updated

$JsPath
$CssPath

## Backup Folder

$RollbackRoot

## Script Injection Status

$ScriptStatus

## Amendment Added

- Separate Legal Web Links section
- Manual add form for legal-only web shortcuts
- Legal-only categories
- Legal-only warning
- Separation from Launch Apps / Docs
- Local browser storage for manual links
- Delete function for manually added links
- Search/filter legal shortcuts

## Approved Legal Categories

- Legal News
- Legal Forms
- Legal Research
- Court / Tribunal Portal
- Bar / Regulator
- Government Legal Portal
- Client-Lawyer Work Portal
- Legal Document Portal
- Law Firm Resource

## Important Rule

Legal Web Links must not be mixed with general applications, Office tools, email tools, shopping, entertainment, social media, unrelated news, or personal links.

General apps stay under Launch Apps / Docs.

## Test URL

http://localhost:5173/

## Final Ruling

Phase 12.0N-R3:
LEGAL-ONLY WEB SHORTCUT MANAGER AMENDMENT COMPLETE

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R3-LEGAL-ONLY-WEB-SHORTCUT-MANAGER-AMENDMENT-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0N-R3 LEGAL-ONLY WEB SHORTCUT MANAGER AMENDMENT COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R3-LEGAL-ONLY-WEB-SHORTCUT-MANAGER-AMENDMENT-REPORT.md"'
Write-Host ""
Write-Host "Open checklist:" -ForegroundColor Cyan
Write-Host "notepad `"$($RollbackRoot.Substring($ProjectRoot.Length).TrimStart("\"))\POST-AMENDMENT-CHECKLIST.md`""
Write-Host ""
Write-Host "Test URL:" -ForegroundColor Cyan
Write-Host "http://localhost:5173/"
Write-Host ""
Write-Pass "Paste the Phase 12.0N-R3 report and visual result back into ChatGPT."

# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0K LEGAL INTERFACE UI PROTOTYPE PACK
#
# PURPOSE:
#   Install a lab-safe legal interface UI prototype under _LEOS_CONTROL.
#
# SAFE MODE:
#   - DOES NOT overwrite frontend source
#   - DOES NOT modify database
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Save-Text {
    param([string]$Path, [string]$Content)
    $Folder = Split-Path -Path $Path -Parent
    if (!(Test-Path -LiteralPath $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$PrototypeRoot = Join-Path $ProjectRoot "_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface"
$ReportRoot = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"

New-Item -ItemType Directory -Path $PrototypeRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

$Component = @'
import React, { useMemo, useState } from "react";
import "./LegalManagementShell.css";
import firmProfile from "./firmProfile.config.json";
import legalNewsLinks from "./legalNewsLinks.config.json";

/**
 * LegalManagementShell
 * Lab-safe legal management interface shell.
 *
 * Purpose:
 * - Left sidebar navigation
 * - Search / Instructions / Glossary / Settings
 * - Firm branding panel
 * - Owner / Managing Partner profile
 * - Legal news links for Malaysia and Singapore
 *
 * Integration rule:
 * Do not overwrite existing App.jsx until reviewed.
 */
export default function LegalManagementShell() {
  const [activePanel, setActivePanel] = useState("workspace");
  const [query, setQuery] = useState("");

  const searchFolders = useMemo(() => {
    return [
      { icon: "📁", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
      { icon: "📂", title: "Matter Folders", description: "Case records, pleadings, status notes, court timelines." },
      { icon: "📄", title: "Documents", description: "Drafts, templates, letters, affidavits, bundles and exhibits." },
      { icon: "⏰", title: "Deadlines", description: "Limitation dates, hearing dates, filing dates and reminders." },
      { icon: "⚖️", title: "Legal Research", description: "Research notes, case summaries, statutory extracts and authorities." },
      { icon: "🧾", title: "Billing / Finance", description: "Invoices, receipts, fee notes and disbursement tracking." }
    ];
  }, []);

  const filteredFolders = searchFolders.filter((item) => {
    const haystack = `${item.title} ${item.description}`.toLowerCase();
    return haystack.includes(query.toLowerCase());
  });

  const glossaryTerms = [
    { term: "Affidavit", definition: "A written statement confirmed by oath or affirmation for use as evidence." },
    { term: "Cause Papers", definition: "Court documents filed in a case, including pleadings and applications." },
    { term: "Client Due Diligence", definition: "Checks performed to verify identity, risk, authority and engagement suitability." },
    { term: "Limitation Period", definition: "The time limit within which a claim or legal action must be started." },
    { term: "Matter", definition: "A legal file or case handled for a client." },
    { term: "Retainer", definition: "The engagement arrangement between a legal practitioner or firm and a client." }
  ];

  function renderPanel() {
    switch (activePanel) {
      case "search":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">🔎</span>
              <div>
                <h2>Search Legal Repository</h2>
                <p>Find documents, files, folders, client records, matter records and legal references.</p>
              </div>
            </div>

            <input
              className="legal-search-input"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Search clients, matters, documents, deadlines, folders..."
              aria-label="Search legal repository"
            />

            <div className="folder-grid">
              {filteredFolders.map((item) => (
                <button key={item.title} className="folder-card" type="button">
                  <span className="folder-icon">{item.icon}</span>
                  <strong>{item.title}</strong>
                  <small>{item.description}</small>
                </button>
              ))}
            </div>
          </section>
        );

      case "instructions":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">📘</span>
              <div>
                <h2>Instructions & User Guides</h2>
                <p>Training, tutorials, SOPs and help documentation for staff.</p>
              </div>
            </div>

            <div className="instruction-list">
              <button type="button">🚀 Getting Started Guide</button>
              <button type="button">👤 Client Intake Workflow</button>
              <button type="button">💼 Matter Opening SOP</button>
              <button type="button">📄 Document Upload & Review Guide</button>
              <button type="button">⏰ Deadline Monitoring Guide</button>
              <button type="button">🛡️ Security, RBAC & Audit SOP</button>
            </div>
          </section>
        );

      case "glossary":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">📚</span>
              <div>
                <h2>Legal Glossary</h2>
                <p>Common legal terms and internal terminology used in this system.</p>
              </div>
            </div>

            <div className="glossary-list">
              {glossaryTerms.map((item) => (
                <article key={item.term} className="glossary-item">
                  <strong>{item.term}</strong>
                  <p>{item.definition}</p>
                </article>
              ))}
            </div>
          </section>
        );

      case "settings":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">⚙️</span>
              <div>
                <h2>System Settings & Configuration</h2>
                <p>System-wide preferences and administrative controls.</p>
              </div>
            </div>

            <div className="settings-grid">
              <div className="settings-card"><strong>👤 User Preferences</strong><span>Language, default dashboard, quick links.</span></div>
              <div className="settings-card"><strong>🎨 Display Settings</strong><span>Theme, density, font size, layout mode.</span></div>
              <div className="settings-card"><strong>🔔 Notifications</strong><span>Email, in-app alerts, deadline reminders.</span></div>
              <div className="settings-card"><strong>🛡️ Access Controls</strong><span>Roles, permissions, module visibility, RBAC.</span></div>
              <div className="settings-card"><strong>🏛️ Firm Profile</strong><span>Firm name, logo, tagline and contact details.</span></div>
              <div className="settings-card"><strong>🧾 Audit & Compliance</strong><span>Logs, retention rules, review controls.</span></div>
            </div>
          </section>
        );

      case "news":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">📰</span>
              <div>
                <h2>Malaysia & Singapore Legal News</h2>
                <p>Staff legal-awareness links for Malaysia and Singapore.</p>
              </div>
            </div>

            <div className="news-grid">
              {legalNewsLinks.map((item) => (
                <a key={item.url} className="news-card" href={item.url} target="_blank" rel="noreferrer">
                  <span>{item.icon}</span>
                  <strong>{item.title}</strong>
                  <small>{item.description}</small>
                </a>
              ))}
            </div>
          </section>
        );

      default:
        return (
          <section className="panel-card hero-panel">
            <div className="justice-mark">⚖️</div>
            <h1>{firmProfile.firmName}</h1>
            <p>{firmProfile.tagline}</p>
            <div className="hero-actions">
              <button type="button" onClick={() => setActivePanel("search")}>🔎 Search Repository</button>
              <button type="button" onClick={() => setActivePanel("clients")}>💼 Open Workspace</button>
              <button type="button" onClick={() => setActivePanel("news")}>📰 Legal News</button>
            </div>
          </section>
        );
    }
  }

  return (
    <div className="legal-shell">
      <aside className="legal-sidebar" aria-label="Legal management navigation">
        <div className="brand-block">
          <div className="brand-logo">{firmProfile.firmLogoEmoji || "⚖️"}</div>
          <div>
            <strong>{firmProfile.firmName}</strong>
            <small>{firmProfile.shortName}</small>
          </div>
        </div>

        <nav className="side-nav">
          <button type="button" onClick={() => setActivePanel("workspace")}>⚖️ Workspace</button>
          <button type="button" onClick={() => setActivePanel("search")}>🔎 Search</button>
          <button type="button" onClick={() => setActivePanel("instructions")}>📘 Instructions</button>
          <button type="button" onClick={() => setActivePanel("glossary")}>📚 Glossary</button>
          <button type="button" onClick={() => setActivePanel("news")}>📰 MY/SG Legal News</button>
          <button type="button" onClick={() => setActivePanel("settings")}>⚙️ Settings</button>
        </nav>

        <div className="sidebar-footer">
          <span>🏛️ Legal Operations</span>
          <small>Lab UI Prototype</small>
        </div>
      </aside>

      <main className="legal-main">
        <header className="top-bar">
          <div>
            <h1>Legal Management System</h1>
            <p>Professional legal workspace for matters, clients, documents and governance.</p>
          </div>
          <button className="settings-pill" type="button" onClick={() => setActivePanel("settings")}>⚙️ Configure</button>
        </header>

        <section className="profile-grid">
          <article className="firm-card">
            <div className="mini-logo">{firmProfile.firmLogoEmoji || "⚖️"}</div>
            <div>
              <h2>{firmProfile.firmName}</h2>
              <p>{firmProfile.tagline}</p>
              <small>{firmProfile.address}</small>
            </div>
          </article>

          <article className="partner-card">
            <div className="avatar">{firmProfile.managingPartner.avatarEmoji || "👨‍⚖️"}</div>
            <div>
              <h2>{firmProfile.managingPartner.name}</h2>
              <p>{firmProfile.managingPartner.title}</p>
              <small>{firmProfile.managingPartner.email} · {firmProfile.managingPartner.phone}</small>
              <small>{firmProfile.managingPartner.credentials}</small>
            </div>
          </article>
        </section>

        {renderPanel()}
      </main>
    </div>
  );
}

'@

$Css = @'
:root {
  --legal-navy: #17213a;
  --legal-blue: #263d63;
  --legal-gold: #c9a646;
  --legal-cream: #f8f5ed;
  --legal-paper: #ffffff;
  --legal-border: #ded6c7;
  --legal-text: #1f2937;
  --legal-muted: #6b7280;
  --legal-shadow: 0 18px 40px rgba(23, 33, 58, 0.14);
}

.legal-shell {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 280px 1fr;
  background: linear-gradient(135deg, #f8f5ed 0%, #eef2f7 100%);
  color: var(--legal-text);
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.legal-sidebar {
  background: var(--legal-navy);
  color: white;
  padding: 22px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  border-right: 4px solid var(--legal-gold);
}

.brand-block {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px;
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.14);
  border-radius: 18px;
}

.brand-logo,
.mini-logo,
.justice-mark {
  display: grid;
  place-items: center;
  background: rgba(201,166,70,0.18);
  border: 1px solid rgba(201,166,70,0.55);
  color: var(--legal-gold);
  border-radius: 16px;
}

.brand-logo {
  width: 54px;
  height: 54px;
  font-size: 30px;
}

.brand-block strong,
.brand-block small {
  display: block;
}

.brand-block small {
  opacity: 0.75;
  margin-top: 3px;
}

.side-nav {
  display: grid;
  gap: 10px;
}

.side-nav button {
  cursor: pointer;
  text-align: left;
  color: white;
  background: transparent;
  border: 1px solid rgba(255,255,255,0.14);
  border-radius: 14px;
  padding: 13px 14px;
  font-weight: 700;
  transition: 0.18s ease;
}

.side-nav button:hover,
.side-nav button:focus {
  outline: none;
  background: rgba(201,166,70,0.22);
  border-color: rgba(201,166,70,0.7);
  transform: translateX(3px);
}

.sidebar-footer {
  margin-top: auto;
  display: grid;
  gap: 4px;
  color: rgba(255,255,255,0.82);
  font-size: 13px;
}

.legal-main {
  padding: 28px;
  display: grid;
  gap: 22px;
  align-content: start;
}

.top-bar,
.profile-grid,
.panel-card {
  width: min(1180px, 100%);
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: var(--legal-paper);
  border: 1px solid var(--legal-border);
  box-shadow: var(--legal-shadow);
  border-radius: 24px;
  padding: 22px 24px;
}

.top-bar h1,
.panel-card h2,
.firm-card h2,
.partner-card h2 {
  margin: 0;
  color: var(--legal-navy);
}

.top-bar p,
.panel-card p,
.firm-card p,
.partner-card p {
  margin: 6px 0 0;
  color: var(--legal-muted);
}

.settings-pill,
.hero-actions button {
  cursor: pointer;
  border: none;
  background: var(--legal-navy);
  color: white;
  padding: 12px 16px;
  border-radius: 999px;
  font-weight: 800;
}

.profile-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.firm-card,
.partner-card {
  display: flex;
  gap: 14px;
  align-items: center;
  background: rgba(255,255,255,0.78);
  border: 1px solid var(--legal-border);
  border-radius: 22px;
  padding: 18px;
}

.mini-logo,
.avatar {
  width: 62px;
  height: 62px;
  flex: 0 0 auto;
  font-size: 34px;
  border-radius: 18px;
}

.avatar {
  display: grid;
  place-items: center;
  background: #eef2ff;
  border: 1px solid #c7d2fe;
}

.partner-card small {
  display: block;
  color: var(--legal-muted);
  margin-top: 3px;
}

.panel-card {
  background: var(--legal-paper);
  border: 1px solid var(--legal-border);
  border-radius: 26px;
  padding: 24px;
  box-shadow: var(--legal-shadow);
}

.panel-header {
  display: flex;
  gap: 14px;
  align-items: flex-start;
  margin-bottom: 18px;
}

.panel-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  background: var(--legal-cream);
  border: 1px solid var(--legal-border);
  border-radius: 16px;
  font-size: 26px;
}

.hero-panel {
  text-align: center;
  padding: 46px 30px;
}

.justice-mark {
  width: 96px;
  height: 96px;
  margin: 0 auto 18px;
  font-size: 56px;
}

.hero-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 22px;
  flex-wrap: wrap;
}

.legal-search-input {
  width: 100%;
  border: 1px solid var(--legal-border);
  border-radius: 16px;
  padding: 14px 16px;
  font-size: 16px;
  margin-bottom: 18px;
}

.folder-grid,
.news-grid,
.settings-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 14px;
}

.folder-card,
.news-card,
.settings-card,
.glossary-item,
.instruction-list button {
  border: 1px solid var(--legal-border);
  background: #fff;
  border-radius: 18px;
  padding: 16px;
  text-align: left;
  display: grid;
  gap: 7px;
}

.folder-card,
.instruction-list button {
  cursor: pointer;
}

.folder-card:hover,
.instruction-list button:hover,
.news-card:hover {
  border-color: var(--legal-gold);
  box-shadow: 0 10px 22px rgba(23, 33, 58, 0.10);
}

.folder-icon {
  font-size: 28px;
}

.news-card {
  color: inherit;
  text-decoration: none;
}

.news-card span {
  font-size: 28px;
}

.instruction-list,
.glossary-list {
  display: grid;
  gap: 12px;
}

.instruction-list button {
  font-weight: 800;
}

.settings-card strong,
.news-card strong,
.folder-card strong {
  color: var(--legal-navy);
}

.settings-card span,
.news-card small,
.folder-card small {
  color: var(--legal-muted);
  line-height: 1.35;
}

@media (max-width: 900px) {
  .legal-shell {
    grid-template-columns: 1fr;
  }

  .legal-sidebar {
    position: static;
  }

  .profile-grid,
  .top-bar {
    grid-template-columns: 1fr;
    flex-direction: column;
    align-items: stretch;
  }
}

'@

$FirmConfig = @'
{
  "firmName": "Your Law Firm Name",
  "shortName": "YLF",
  "firmLogoEmoji": "\u2696\ufe0f",
  "tagline": "Justice \u2022 Integrity \u2022 Precision",
  "address": "Configurable firm address goes here",
  "phone": "+60-00-000-0000",
  "email": "admin@example.com",
  "website": "https://example.com",
  "managingPartner": {
    "name": "Managing Partner Name",
    "title": "Managing Partner / Owner",
    "email": "partner@example.com",
    "phone": "+60-00-000-0000",
    "credentials": "LLB, Advocate & Solicitor, Professional Credentials",
    "avatarEmoji": "\ud83d\udc68\u200d\u2696\ufe0f",
    "bio": "Editable professional profile summary."
  }
}
'@

$NewsConfig = @'
[
  {
    "country": "Malaysia",
    "icon": "\ud83c\uddf2\ud83c\uddfe",
    "title": "Malaysian Bar - Legal & General News",
    "description": "Malaysia legal news, Bar updates, press statements, judgments and legal/general news.",
    "url": "https://www.malaysianbar.org.my/list/news/legal-and-general-news"
  },
  {
    "country": "Malaysia",
    "icon": "\u2696\ufe0f",
    "title": "Malaysian Bar - Court Judgments & Highlights",
    "description": "Court judgments and appellate-court highlights from the Malaysian Bar site.",
    "url": "https://www.malaysianbar.org.my/"
  },
  {
    "country": "Singapore",
    "icon": "\ud83c\uddf8\ud83c\uddec",
    "title": "Singapore Law Watch - Headlines",
    "description": "Singapore legal headlines, judgments and legal developments.",
    "url": "https://www.singaporelawwatch.sg/Headlines/category/overview"
  },
  {
    "country": "Singapore",
    "icon": "\ud83c\udfdb\ufe0f",
    "title": "Singapore Ministry of Law - News",
    "description": "Official Singapore legal-sector press releases, speeches and announcements.",
    "url": "https://www.mlaw.gov.sg/news/press-releases/"
  },
  {
    "country": "Singapore",
    "icon": "\ud83d\udcf0",
    "title": "Singapore Law Gazette",
    "description": "Official publication of the Law Society of Singapore.",
    "url": "https://lawgazette.com.sg/"
  }
]
'@

$Guide = @'
# PHASE 12.0K LEGAL INTERFACE UI PROTOTYPE PACK

## Purpose

This pack provides a lab-safe UI prototype for a Legal Management System interface.

It includes:

- Left sidebar navigation
- Search button and repository search panel
- Instructions/help documentation panel
- Legal glossary panel
- Settings/configuration panel
- Scales of justice and legal branding
- Configurable firm information
- Configurable owner/managing partner details
- Malaysia/Singapore legal news links
- React component and CSS styling

## Files

- LegalManagementShell.jsx
- LegalManagementShell.css
- firmProfile.config.json
- legalNewsLinks.config.json

## Lab Integration Path

Do not overwrite your existing frontend immediately.

Recommended safe review location:

_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface

## Future Frontend Integration Option

After review, the files can be copied to something like:

frontend\src\components\legal-shell\LegalManagementShell.jsx
frontend\src\components\legal-shell\LegalManagementShell.css
frontend\src\components\legal-shell\firmProfile.config.json
frontend\src\components\legal-shell\legalNewsLinks.config.json

Then imported into a route/page.

Example:

import LegalManagementShell from "./components/legal-shell/LegalManagementShell";

function App() {
  return <LegalManagementShell />;
}

## Safety

This prototype does not modify database, auth, RBAC, audit, production flags, or Phase 11 status.

## News Link Rule

The MY/SG legal news links are external links and should open in a new browser tab.
For a production-grade version, create an internal Staff Legal News page that lists approved external sources.

'@

Save-Text -Path (Join-Path $PrototypeRoot "LegalManagementShell.jsx") -Content $Component
Save-Text -Path (Join-Path $PrototypeRoot "LegalManagementShell.css") -Content $Css
Save-Text -Path (Join-Path $PrototypeRoot "firmProfile.config.json") -Content $FirmConfig
Save-Text -Path (Join-Path $PrototypeRoot "legalNewsLinks.config.json") -Content $NewsConfig
Save-Text -Path (Join-Path $PrototypeRoot "IMPLEMENTATION-GUIDE.md") -Content $Guide

$Report = @"
# PHASE 12.0K LEGAL INTERFACE UI PROTOTYPE PACK REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Prototype Root:
$PrototypeRoot

## Files Created

- LegalManagementShell.jsx
- LegalManagementShell.css
- firmProfile.config.json
- legalNewsLinks.config.json
- IMPLEMENTATION-GUIDE.md

## Safety Confirmation

No frontend source files were overwritten.
No source code was modified outside _LEOS_CONTROL.
No database was modified.
No production feature was unlocked.
No Phase 11 work was started.

## Next Step

Open:

notepad "_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface\IMPLEMENTATION-GUIDE.md"

Review the files before copying anything into frontend\src.
"@

Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0K-LEGAL-INTERFACE-UI-PROTOTYPE-PACK-REPORT.md") -Content $Report

Write-Host ""
Write-Host "[PASS] PHASE 12.0K LEGAL INTERFACE UI PROTOTYPE PACK CREATED" -ForegroundColor Green
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0K-LEGAL-INTERFACE-UI-PROTOTYPE-PACK-REPORT.md`""
Write-Host ""
Write-Host "Open guide:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface\IMPLEMENTATION-GUIDE.md`""

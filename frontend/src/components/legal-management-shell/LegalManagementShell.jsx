import React, { useMemo, useState } from "react";
import "./LegalManagementShell.css";
import firmProfile from "./firmProfile.config.json";
import legalNewsLinks from "./legalNewsLinks.config.json";
import { MenuPlatform } from "../../features/menu-platform";

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

  const todayOverviewSections = [
    {
      title: "Urgent Matters",
      items: [
        "Sample Matter A — affidavit review due tomorrow",
        "Sample Matter B — client instructions pending today"
      ]
    },
    {
      title: "Upcoming Deadlines",
      items: [
        "Sample Hearing — 3 days",
        "Filing Reminder — 5 days"
      ]
    },
    {
      title: "Missing Documents",
      items: [
        "Authority letter pending",
        "Identification copy pending",
        "Supporting exhibits pending"
      ]
    },
    {
      title: "Pending Client Instructions",
      items: [
        "Confirm chronology",
        "Approve draft letter",
        "Confirm settlement position"
      ]
    },
    {
      title: "Overdue Tasks",
      items: [
        "Follow up unsigned engagement letter",
        "Update matter status note"
      ]
    },
    {
      title: "Recently Updated Matters",
      items: [
        "Sample Matter A — status note updated",
        "Sample Matter C — documents marked received"
      ]
    }
  ];

  function renderTodayOverview() {
    return (
      <section className="panel-card" aria-label="Legal practice control desk today overview">
        <div className="panel-header">
          <span className="panel-icon">⚖️</span>
          <div>
            <h2>Today Overview</h2>
            <p>Sample legal practice control desk for urgent work, deadlines, documents, instructions, and follow-ups.</p>
          </div>
        </div>

        <div className="settings-grid">
          {todayOverviewSections.map((section) => (
            <div className="settings-card" key={section.title}>
              <strong>{section.title}</strong>
              {section.items.map((item) => (
                <span key={item}>{item}</span>
              ))}
            </div>
          ))}
        </div>
      </section>
    );
  }

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
              <button type="button" onClick={() => setActivePanel("workspace")}>💼 Open Workspace</button>
              <button type="button" onClick={() => setActivePanel("news")}>📰 Legal News</button>
            </div>
          </section>
        );
    }
  }

  return (
    <div className="legal-shell">
      <aside className="legal-sidebar" aria-label="Legal management navigation">
        <div className="legal-sidebar-menu-platform" aria-label="Application menu hub">
          <MenuPlatform
            context="sidebar"
            triggerLabel="App Menu"
            triggerVariant="sidebar"
            appVersion="0.0.0"
            onNavigate={(target) => {
              if (target === "home") {
                setActivePanel("workspace");
              }
            }}
            onAction={(item) => {
              if (item.id === "home") {
                setActivePanel("workspace");
              }
            }}
          />
        </div>

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

        {activePanel === "workspace" ? renderTodayOverview() : null}

        {renderPanel()}
      </main>
    </div>
  );
}

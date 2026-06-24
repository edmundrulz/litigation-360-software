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
      { icon: "ðŸ“", title: "Client Files", description: "Client profiles, IDs, engagement letters, contact details." },
      { icon: "ðŸ“‚", title: "Matter Folders", description: "Case records, pleadings, status notes, court timelines." },
      { icon: "ðŸ“„", title: "Documents", description: "Drafts, templates, letters, affidavits, bundles and exhibits." },
      { icon: "â°", title: "Deadlines", description: "Limitation dates, hearing dates, filing dates and reminders." },
      { icon: "âš–ï¸", title: "Legal Research", description: "Research notes, case summaries, statutory extracts and authorities." },
      { icon: "ðŸ§¾", title: "Billing / Finance", description: "Invoices, receipts, fee notes and disbursement tracking." }
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
              <span className="panel-icon">ðŸ”Ž</span>
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
              <span className="panel-icon">ðŸ“˜</span>
              <div>
                <h2>Instructions & User Guides</h2>
                <p>Training, tutorials, SOPs and help documentation for staff.</p>
              </div>
            </div>

            <div className="instruction-list">
              <button type="button">ðŸš€ Getting Started Guide</button>
              <button type="button">ðŸ‘¤ Client Intake Workflow</button>
              <button type="button">ðŸ’¼ Matter Opening SOP</button>
              <button type="button">ðŸ“„ Document Upload & Review Guide</button>
              <button type="button">â° Deadline Monitoring Guide</button>
              <button type="button">ðŸ›¡ï¸ Security, RBAC & Audit SOP</button>
            </div>
          </section>
        );

      case "glossary":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">ðŸ“š</span>
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
              <span className="panel-icon">âš™ï¸</span>
              <div>
                <h2>System Settings & Configuration</h2>
                <p>System-wide preferences and administrative controls.</p>
              </div>
            </div>

            <div className="settings-grid">
              <div className="settings-card"><strong>ðŸ‘¤ User Preferences</strong><span>Language, default dashboard, quick links.</span></div>
              <div className="settings-card"><strong>ðŸŽ¨ Display Settings</strong><span>Theme, density, font size, layout mode.</span></div>
              <div className="settings-card"><strong>ðŸ”” Notifications</strong><span>Email, in-app alerts, deadline reminders.</span></div>
              <div className="settings-card"><strong>ðŸ›¡ï¸ Access Controls</strong><span>Roles, permissions, module visibility, RBAC.</span></div>
              <div className="settings-card"><strong>ðŸ›ï¸ Firm Profile</strong><span>Firm name, logo, tagline and contact details.</span></div>
              <div className="settings-card"><strong>ðŸ§¾ Audit & Compliance</strong><span>Logs, retention rules, review controls.</span></div>
            </div>
          </section>
        );

      case "news":
        return (
          <section className="panel-card">
            <div className="panel-header">
              <span className="panel-icon">ðŸ“°</span>
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
            <div className="justice-mark">âš–ï¸</div>
            <h1>{firmProfile.firmName}</h1>
            <p>{firmProfile.tagline}</p>
            <div className="hero-actions">
              <button type="button" onClick={() => setActivePanel("search")}>ðŸ”Ž Search Repository</button>
              <button type="button" onClick={() => setActivePanel("clients")}>ðŸ’¼ Open Workspace</button>
              <button type="button" onClick={() => setActivePanel("news")}>ðŸ“° Legal News</button>
            </div>
          </section>
        );
    }
  }

  return (
    <div className="legal-shell">
      <aside className="legal-sidebar" aria-label="Legal management navigation">
        <div className="brand-block">
          <div className="brand-logo">{firmProfile.firmLogoEmoji || "âš–ï¸"}</div>
          <div>
            <strong>{firmProfile.firmName}</strong>
            <small>{firmProfile.shortName}</small>
          </div>
        </div>

        <nav className="side-nav">
          <button type="button" onClick={() => setActivePanel("workspace")}>âš–ï¸ Workspace</button>
          <button type="button" onClick={() => setActivePanel("search")}>ðŸ”Ž Search</button>
          <button type="button" onClick={() => setActivePanel("instructions")}>ðŸ“˜ Instructions</button>
          <button type="button" onClick={() => setActivePanel("glossary")}>ðŸ“š Glossary</button>
          <button type="button" onClick={() => setActivePanel("news")}>ðŸ“° MY/SG Legal News</button>
          <button type="button" onClick={() => setActivePanel("settings")}>âš™ï¸ Settings</button>
        </nav>

        <div className="sidebar-footer">
          <span>ðŸ›ï¸ Legal Operations</span>
          <small>Lab UI Prototype</small>
        </div>
      </aside>

      <main className="legal-main">
        <header className="top-bar">
          <div>
            <h1>Legal Management System</h1>
            <p>Professional legal workspace for matters, clients, documents and governance.</p>
          </div>
          <button className="settings-pill" type="button" onClick={() => setActivePanel("settings")}>âš™ï¸ Configure</button>
        </header>

        <section className="profile-grid">
          <article className="firm-card">
            <div className="mini-logo">{firmProfile.firmLogoEmoji || "âš–ï¸"}</div>
            <div>
              <h2>{firmProfile.firmName}</h2>
              <p>{firmProfile.tagline}</p>
              <small>{firmProfile.address}</small>
            </div>
          </article>

          <article className="partner-card">
            <div className="avatar">{firmProfile.managingPartner.avatarEmoji || "ðŸ‘¨â€âš–ï¸"}</div>
            <div>
              <h2>{firmProfile.managingPartner.name}</h2>
              <p>{firmProfile.managingPartner.title}</p>
              <small>{firmProfile.managingPartner.email} Â· {firmProfile.managingPartner.phone}</small>
              <small>{firmProfile.managingPartner.credentials}</small>
            </div>
          </article>
        </section>

        {renderPanel()}
      </main>
    </div>
  );
}

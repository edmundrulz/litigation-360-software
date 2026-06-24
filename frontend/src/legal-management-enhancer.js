import "./legal-management-enhancer.css";

(function installSidebarIntegratedLegalTools() {
  const DRAWER_ID = "leos-pro-legal-drawer";
  const TOOLS_ID = "leos-sidebar-tools";
  const CUSTOM_LEGAL_LINKS_KEY = "leosCustomLegalLinks";

  const oldFloatingDock = document.getElementById("leos-pro-legal-dock") || document.getElementById("leos-legal-enhancer");
  const oldFloatingDrawer = document.getElementById("leos-legal-drawer");
  if (oldFloatingDock) oldFloatingDock.remove();
  if (oldFloatingDrawer) oldFloatingDrawer.remove();

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

  const iconSvg = {
    scales: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M12 3v17"/><path d="M7 7h10"/><path d="M9 7 5.5 12a3.5 3.5 0 0 0 7 0L9 7Z"/><path d="M15 7 11.5 12a3.5 3.5 0 0 0 7 0L15 7Z"/><path d="M8 21h8"/></svg></span>',
    courthouse: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M3 9h18"/><path d="M5 9v8"/><path d="M9 9v8"/><path d="M15 9v8"/><path d="M19 9v8"/><path d="M2 19h20"/><path d="M12 4 3 8h18L12 4Z"/></svg></span>',
    gavel: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="m14 5 5 5"/><path d="m12 7 5 5"/><path d="m5 14 5 5"/><path d="m4 20 7-7"/><path d="m10 4 7 7"/><path d="M3 21h6"/></svg></span>',
    folder: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M3 7h6l2 2h10v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7Z"/></svg></span>',
    document: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M7 3h7l4 4v14H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z"/><path d="M14 3v5h5"/><path d="M9 13h6"/><path d="M9 17h6"/></svg></span>',
    briefcase: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M8 7V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><path d="M3 8h18v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8Z"/><path d="M3 12h18"/><path d="M10 12v2"/><path d="M14 12v2"/></svg></span>',
    partner: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><path d="M10 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8Z"/><path d="M18 8a3 3 0 0 1 0 6"/><path d="M20 21v-2a4 4 0 0 0-3-3.87"/></svg></span>',
    research: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M10 4a6 6 0 1 0 0 12 6 6 0 0 0 0-12Z"/><path d="m15 15 5 5"/><path d="M8 8h4"/><path d="M8 11h3"/></svg></span>',
    settings: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M12 8.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7Z"/><path d="M19.4 15a1.7 1.7 0 0 0 .34 1.87l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.7 1.7 0 0 0-1.87-.34 1.7 1.7 0 0 0-1.04 1.56V21a2 2 0 1 1-4 0v-.09a1.7 1.7 0 0 0-1.04-1.56 1.7 1.7 0 0 0-1.87.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.7 1.7 0 0 0 4.6 15a1.7 1.7 0 0 0-1.56-1.04H3a2 2 0 1 1 0-4h.04A1.7 1.7 0 0 0 4.6 8.92a1.7 1.7 0 0 0-.34-1.87L4.2 7a2 2 0 1 1 2.83-2.83l.06.06A1.7 1.7 0 0 0 8.96 4.6 1.7 1.7 0 0 0 10 3.04V3a2 2 0 1 1 4 0v.04A1.7 1.7 0 0 0 15.04 4.6a1.7 1.7 0 0 0 1.87-.34l.06-.06A2 2 0 1 1 19.8 7l-.06.06A1.7 1.7 0 0 0 19.4 8.9c.1.39.61 1.06 1.56 1.06H21a2 2 0 1 1 0 4h-.04c-.95 0-1.46.67-1.56 1.04Z"/></svg></span>',
    link: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M10 13a5 5 0 0 1 0-7l1-1a5 5 0 0 1 7 7l-1 1"/><path d="M14 11a5 5 0 0 1 0 7l-1 1a5 5 0 1 1-7-7l1-1"/></svg></span>',
    email: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M4 6h16v12H4z"/><path d="m4 8 8 6 8-6"/></svg></span>',
    news: '<span class="leos-svg-icon"><svg viewBox="0 0 24 24"><path d="M5 5h12v14H5z"/><path d="M17 7h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H7"/><path d="M8 9h6"/><path d="M8 12h6"/><path d="M8 15h3"/></svg></span>'
  };

  function largeIcon(name) {
    return `<span class="leos-svg-icon large">${iconSvg[name]?.replace('leos-svg-icon', '').replace('<span class="">', '').replace('</span>', '') || ''}</span>`;
  }

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

  function card(title, description, marker, iconName = "document") {
    return `
      <article class="leos-pro-card">
        <div class="leos-pro-card-top">
          <div class="leos-pro-card-icon">${iconSvg[iconName] || iconSvg.document}</div>
          <strong>${marker || "Section"} ${escapeHtml(title)}</strong>
        </div>
        <span>${escapeHtml(description)}</span>
      </article>
    `;
  }

  function linkCard(title, description, url, marker, category, customIndex, iconName = "link") {
    const deleteButton = Number.isInteger(customIndex)
      ? `<button class="leos-pro-delete" type="button" data-delete-legal-link="${customIndex}">Delete manual link</button>`
      : "";
    return `
      <article class="leos-pro-card leos-pro-link-row">
        <a href="${escapeHtml(url)}" target="_blank" rel="noreferrer" style="color:inherit;text-decoration:none;">
          <div class="leos-pro-card-top">
            <div class="leos-pro-card-icon">${iconSvg[iconName] || iconSvg.link}</div>
            <strong>${marker || "Open"} ${escapeHtml(title)}</strong>
          </div>
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

  function drawerIconByAction(action) {
    const map = {
      "Legal-Only Web Shortcuts": "scales",
      "Search Legal Repository": "folder",
      "Instructions and User Guides": "courthouse",
      "Legal Glossary": "document",
      "Launch Applications and Document Tools": "briefcase",
      "Firm Information": "courthouse",
      "Owner / Managing Partner Details": "partner",
      "Settings and Configuration": "settings"
    };
    return map[action] || "scales";
  }

  function ensureDrawer() {
    let drawer = document.getElementById(DRAWER_ID);
    if (!drawer) {
      drawer = document.createElement("section");
      drawer.id = DRAWER_ID;
      drawer.className = "leos-pro-drawer";
      drawer.setAttribute("aria-live", "polite");
      document.body.appendChild(drawer);
    }
    return drawer;
  }

  function openDrawer(title, subtitle, html) {
    const drawer = ensureDrawer();
    const drawerIcon = drawerIconByAction(title);
    drawer.innerHTML = `
      <div class="leos-pro-head">
        <div class="leos-pro-head-left">
          <div class="leos-pro-head-icon">${iconSvg[drawerIcon] || iconSvg.scales}</div>
          <div>
            <h2>${title}</h2>
            <p>${subtitle}</p>
          </div>
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
      return card("No legal link found", "No matching legal-only shortcut was found.", "Search", "research");
    }

    return all.map(item => linkCard(item.title, item.desc, item.url, "Legal", item.category, item.source === "Manual" ? item.customIndex : null, "news")).join("");
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

      if (!title || !url || !desc || !allowedLegalCategories.includes(category)) {
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
    const itemHtml = repositoryItems.map(([title, desc]) => card(title, desc, "Repository", "folder")).join("");
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
        ? filtered.map(([title, desc]) => card(title, desc, "Repository", "folder")).join("")
        : card("No match", "No matching legal repository folder found.", "Search", "research");
    });
  }

  function showInstructions() {
    openDrawer(
      "Instructions and User Guides",
      "Training, tutorials, SOPs and help documentation for staff.",
      `
        <div class="leos-pro-grid">
          ${card("Getting Started Guide", "How to use the Legal 360 workspace safely.", "Guide", "courthouse")}
          ${card("Client Intake Workflow", "Opening a client record, checking profile completeness and locating client files.", "Workflow", "partner")}
          ${card("Matter Opening SOP", "How matters should be opened, labelled, linked and monitored.", "SOP", "briefcase")}
          ${card("Document Handling Guide", "Document upload, naming, review, filing and archive practices.", "Guide", "document")}
          ${card("Deadline Monitoring Guide", "How to check deadlines, reminders and court-related dates.", "Guide", "gavel")}
          ${card("Security / RBAC / Audit SOP", "How access controls, user roles and audit logs should be reviewed.", "Control", "scales")}
        </div>
      `
    );
  }

  function showGlossary() {
    openDrawer(
      "Legal Glossary",
      "Common legal terms and internal terminology used in this system.",
      `<div class="leos-pro-grid">${glossaryTerms.map(([term, definition]) => card(term, definition, "Term", "document")).join("")}</div>`
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
          ${appLaunchItems.map(([title, desc, url]) => linkCard(title, desc, url, "Open", "Work Application", null, title.includes("Email") || title.includes("Gmail") || title.includes("Outlook") ? "email" : "briefcase")).join("")}
        </div>

        <h3 style="margin-top:18px;">Internal Document Categories</h3>
        <div class="leos-pro-grid">
          ${internalDocumentLaunch.map(([title, desc]) => card(title, desc, "Document", "document")).join("")}
        </div>

        <article class="leos-pro-card" style="margin-top:14px;">
          <div class="leos-pro-card-top">
            <div class="leos-pro-card-icon">${iconSvg.gavel}</div>
            <strong>Desktop app launching note</strong>
          </div>
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
          ${card(p.firmName, p.tagline + " | " + p.address, "Firm", "courthouse")}
          ${card("Contact", p.email + " | " + p.phone + " | " + p.website, "Profile", "briefcase")}
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
      showFirm();
    });

    document.getElementById("leos-pro-reset-profile").addEventListener("click", () => {
      localStorage.removeItem("leosFirmProfile");
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
          ${card(p.partnerName, p.partnerTitle + " | " + p.partnerEmail + " | " + p.partnerPhone, "Partner", "partner")}
          ${card("Credentials", p.partnerCredentials, "Credentials", "scales")}
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
          ${card("User Preferences", "Default workspace, quick links, language and working style.", "Settings", "partner")}
          ${card("Display Settings", "Theme, density, font size and layout preferences.", "Settings", "scales")}
          ${card("Notification Preferences", "Deadline reminders, alert escalation and staff notifications.", "Settings", "news")}
          ${card("Access Controls", "Roles, permissions and module visibility. Backend RBAC remains controlled by the system.", "Control", "scales")}
          ${card("Firm Customization", "Firm profile, logo, tagline and contact details.", "Firm", "courthouse")}
          ${card("Audit and Compliance", "Audit logs, retention rules and compliance evidence.", "Compliance", "gavel")}
          ${card("Application Launcher", "Configure allowed app links, document categories and future Power Automate connectors.", "Apps", "briefcase")}
          ${card("Legal Web Links", "Manage legal-only shortcuts separately from general work apps.", "Links", "link")}
        </div>
      `
    );
  }

  function textOf(el) {
    return (el && el.textContent ? el.textContent : "").replace(/\s+/g, " ").trim();
  }

  function findSidebarContainer() {
    const labels = ["End User Workspace", "Operations Centre", "Admin Centre", "Developer Centre"];
    const candidates = Array.from(document.querySelectorAll("aside, nav, section, div"));

    const matching = candidates
      .filter(el => {
        const t = textOf(el);
        return labels.every(label => t.includes(label));
      })
      .sort((a, b) => {
        const areaA = a.getBoundingClientRect().width * a.getBoundingClientRect().height;
        const areaB = b.getBoundingClientRect().width * b.getBoundingClientRect().height;
        return areaA - areaB;
      });

    if (matching.length) return matching[0];

    const titleCandidates = candidates
      .filter(el => {
        const t = textOf(el);
        return t.includes("Litigation 360") && (t.includes("End User Workspace") || t.includes("Operations Centre"));
      })
      .sort((a, b) => {
        const areaA = a.getBoundingClientRect().width * a.getBoundingClientRect().height;
        const areaB = b.getBoundingClientRect().width * b.getBoundingClientRect().height;
        return areaA - areaB;
      });

    return titleCandidates[0] || null;
  }

  function createToolButton(label, action, primary, iconName) {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.className = primary ? "leos-sidebar-tool-btn leos-primary-tool" : "leos-sidebar-tool-btn";
    btn.setAttribute("data-leos-sidebar-action", action);
    btn.innerHTML = `
      <span class="leos-sidebar-btn-wrap">
        <span class="leos-sidebar-btn-icon">${iconSvg[iconName] || iconSvg.scales}</span>
        <span class="leos-sidebar-btn-label">${escapeHtml(label)}</span>
      </span>
    `;
    return btn;
  }

  function injectSidebarTools() {
    const existing = document.getElementById(TOOLS_ID);
    if (existing) {
      existing.remove();
    }

    const sidebar = findSidebarContainer();
    if (!sidebar) {
      return false;
    }

    const toolBox = document.createElement("div");
    toolBox.id = TOOLS_ID;
    toolBox.className = "leos-sidebar-tools";

    const titleWrap = document.createElement("div");
    titleWrap.className = "leos-sidebar-tools-title-wrap";
    titleWrap.innerHTML = `
      <div class="leos-sidebar-tools-title-icon">${iconSvg.scales}</div>
      <div class="leos-sidebar-tools-title">Legal Tools</div>
    `;
    toolBox.appendChild(titleWrap);

    toolBox.appendChild(createToolButton("Legal Web Links", "legal-links", false, "link"));
    toolBox.appendChild(createToolButton("Launch Apps / Docs", "launch", false, "briefcase"));
    toolBox.appendChild(createToolButton("Search Repository", "search", false, "folder"));
    toolBox.appendChild(createToolButton("Instructions", "instructions", false, "courthouse"));
    toolBox.appendChild(createToolButton("Glossary", "glossary", false, "document"));
    toolBox.appendChild(createToolButton("Firm Info", "firm", false, "courthouse"));
    toolBox.appendChild(createToolButton("Managing Partner", "partner", false, "partner"));
    toolBox.appendChild(createToolButton("Settings", "settings", false, "settings"));

    sidebar.appendChild(toolBox);

    toolBox.addEventListener("click", event => {
      const button = event.target.closest("[data-leos-sidebar-action]");
      if (!button) return;

      const action = button.getAttribute("data-leos-sidebar-action");
      if (action === "legal-links") showLegalLinks();
      if (action === "launch") showLaunchApps();
      if (action === "search") showSearch();
      if (action === "instructions") showInstructions();
      if (action === "glossary") showGlossary();
      if (action === "firm") showFirm();
      if (action === "partner") showPartner();
      if (action === "settings") showSettings();
    });

    ensureDrawer();
    return true;
  }

  function mount() {
    if (injectSidebarTools()) return;

    let attempts = 0;
    const timer = window.setInterval(() => {
      attempts += 1;
      if (injectSidebarTools() || attempts > 25) {
        window.clearInterval(timer);
      }
    }, 300);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mount);
  } else {
    mount();
  }
})();
# Litigation 360 / LEOS 360
# Phase 14A Clients Section Reorder Pass 5 — Matter Context / Case Origin Local Map

Date: 2026-07-01 13:03:34
Source: frontend/src/pages/Clients.jsx

## Purpose

Read-only landmark map before applying Pass 5.
No backend, database, API, auth, RBAC, package, storage, PDF, email, export, or unrelated component changes are approved.

## Search Results

### Pattern: client-matter-context-origin
- Line 2019: { anchor: "client-matter-context-origin", label: "Matter Context" },
- Line 3979: <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
- Line 4528: <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
- Line 5783: <a href="#client-matter-context-origin" className="client-profile-review-link">Jump to Matter Context</a>

### Pattern: Matter Context and Case Origin
- Line 3979: <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
- Line 4528: <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>

### Pattern: Matter Context / Case Origin
- Not found

### Pattern: Client Role in Matter
- Line 4534: Client Role in Matter

### Pattern: clientRoleInMatter
- Line 214: clientRoleInMatter: "Plaintiff",
- Line 1448: clientRoleInMatter: source.clientRoleInMatter || "Plaintiff",
- Line 1530: ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
- Line 4535: <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>

### Pattern: Case Origin
- Line 3979: <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
- Line 4528: <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
- Line 4529: <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
- Line 4543: Case Origin

### Pattern: caseOriginType
- Line 215: caseOriginType: "New Direct Client",
- Line 1449: caseOriginType: source.caseOriginType || "New Direct Client",
- Line 1530: ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
- Line 2840: if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
- Line 2844: if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
- Line 4544: <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
- Line 4551: {form.caseOriginType === "Inherited / Taken Over from Another Firm" && (
- Line 4562: {form.caseOriginType === "Joint Representation / Multi-firm Action" && (

### Pattern: Previous Firm
- Line 4553: Previous Firm
- Line 4557: placeholder="Previous firm name, if known"

### Pattern: previousFirmName
- Line 216: previousFirmName: "",
- Line 1450: previousFirmName: source.previousFirmName || "",
- Line 2841: next.previousFirmName = "";
- Line 4555: value={form.previousFirmName}
- Line 4556: onChange={(event) => updateForm("previousFirmName", event.target.value)}

### Pattern: Co-counsel
- Line 4564: Co-counsel / Partner Firm Notes
- Line 4568: placeholder="Example: joint representation, co-counsel, merged client group, shared litigation strategy."

### Pattern: coCounselNotes
- Line 217: coCounselNotes: "",
- Line 1451: coCounselNotes: source.coCounselNotes || "",
- Line 2845: next.coCounselNotes = "";
- Line 4566: value={form.coCounselNotes}
- Line 4567: onChange={(event) => updateForm("coCounselNotes", event.target.value)}

### Pattern: client-source-value-indicators
- Line 2020: { anchor: "client-source-value-indicators", label: "Source / Value" },
- Line 3980: <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>

### Pattern: Client Source and Value Indicators
- Line 3980: <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>


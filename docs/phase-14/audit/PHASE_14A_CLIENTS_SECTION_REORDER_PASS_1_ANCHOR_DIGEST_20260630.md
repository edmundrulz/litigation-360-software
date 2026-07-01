# Phase 14A Clients Section Reorder Pass 1 Anchor Digest

Date: 2026-06-30
Source map: docs/phase-14/audit/PHASE_14A_CLIENTS_SECTION_REORDER_PASS_1_LOCAL_MAP_20260630.md

Purpose: Short anchor digest for Pass 1 only — Header, Client File Alert / Status, and Client Summary Dashboard alignment.

No code changes are made by this script.

## Anchor: client-profile-summary-rail

### Match around map line 12
```text
Purpose: Identify safe Pass 1 anchors for Header, Client File Alert / Status, and Client Summary Dashboard alignment.

No code changes are made by this script.

## Landmark Search Results

### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
```

### Match around map line 13
```text

No code changes are made by this script.

## Landmark Search Results

### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">
```

### Match around map line 14
```text
No code changes are made by this script.

## Landmark Search Results

### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

```

### Match around map line 15
```text

## Landmark Search Results

### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
```

### Match around map line 86
```text
### Pattern: Return to Stage 2 Matter Intake
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

## Top-Level Context Windows

### Context for 'client-profile-summary-rail' around line 1902
```jsx
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
 1909:       if (type === "checkbox" || type === "radio") {
 1910:         const name = control.getAttribute("name");
```

### Match around map line 96
```text
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
 1909:       if (type === "checkbox" || type === "radio") {
 1910:         const name = control.getAttribute("name");
 1911:
 1912:         if (name) {
 1913:           const groupKey = type + ":" + name;
 1914:           if (countedGroups.has(groupKey)) return null;
 1915:           countedGroups.add(groupKey);
 1916:
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
 1919:           );
 1920:
```

### Match around map line 117
```text
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
 1919:           );
 1920:
```

### Context for 'client-profile-summary-rail' around line 2039
```jsx
 2031:
 2032:   useEffect(() => {
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
 2046:       if (type === "checkbox" || type === "radio") {
 2047:         return Boolean(control.checked);
```

### Match around map line 127
```text
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
 2046:       if (type === "checkbox" || type === "radio") {
 2047:         return Boolean(control.checked);
 2048:       }
 2049:
 2050:       return String(control.value || "").trim().length > 0;
 2051:     };
 2052:
 2053:     const countRequiredControls = (controls, sectionRoot) => {
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
 2056:       let complete = 0;
 2057:
```

### Match around map line 148
```text
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
 2056:       let complete = 0;
 2057:
```

### Context for 'client-profile-summary-rail' around line 3956
```jsx
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
```

### Match around map line 158
```text
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3971:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment Details</a></li>
 3972:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3973:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3974:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
```

### Match around map line 191
```text
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
 1909:       if (type === "checkbox" || type === "radio") {
 1910:         const name = control.getAttribute("name");
 1911:
 1912:         if (name) {
 1913:           const groupKey = type + ":" + name;
 1914:           if (countedGroups.has(groupKey)) return null;
 1915:           countedGroups.add(groupKey);
 1916:
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
```

```

### Match around map line 222
```text
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
 2046:       if (type === "checkbox" || type === "radio") {
 2047:         return Boolean(control.checked);
 2048:       }
 2049:
 2050:       return String(control.value || "").trim().length > 0;
 2051:     };
 2052:
 2053:     const countRequiredControls = (controls, sectionRoot) => {
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
```

```

### Match around map line 296
```text
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
```

### Context for 'ClientRequiredFieldCounter' around line 4059
```jsx
 4051:             <h4>Manual Review Remains Required</h4>
 4052:             <p>
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
```

### Match around map line 1653
```text
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Context for 'Return to Stage 2 Matter Intake' around line 3952
```jsx
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
```

### Match around map line 1681
```text
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
```

```

## Anchor: client-profile-completion-shell

### Match around map line 17
```text

### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
```

### Match around map line 18
```text
### Pattern: client-profile-summary-rail
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
```

### Match around map line 19
```text
- Line 1902: if (control.closest(".client-profile-summary-rail")) return false;
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
```

### Match around map line 20
```text
- Line 2039: if (control.closest(".client-profile-summary-rail")) return false;
- Line 3956: <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
```

### Match around map line 94
```text
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
 1909:       if (type === "checkbox" || type === "radio") {
 1910:         const name = control.getAttribute("name");
 1911:
 1912:         if (name) {
 1913:           const groupKey = type + ":" + name;
 1914:           if (countedGroups.has(groupKey)) return null;
 1915:           countedGroups.add(groupKey);
 1916:
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
```

### Match around map line 125
```text
 2031:
 2032:   useEffect(() => {
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
 2046:       if (type === "checkbox" || type === "radio") {
 2047:         return Boolean(control.checked);
 2048:       }
 2049:
 2050:       return String(control.value || "").trim().length > 0;
 2051:     };
 2052:
 2053:     const countRequiredControls = (controls, sectionRoot) => {
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
```

### Match around map line 179
```text
 3971:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment Details</a></li>
 3972:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3973:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3974:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
```

### Context for 'client-profile-completion-shell' around line 1900
```jsx
 1892:     missing: 0,
 1893:   });
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
```

### Match around map line 189
```text
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
 1907:       const type = (control.getAttribute("type") || "").toLowerCase();
 1908:
 1909:       if (type === "checkbox" || type === "radio") {
 1910:         const name = control.getAttribute("name");
 1911:
 1912:         if (name) {
 1913:           const groupKey = type + ":" + name;
 1914:           if (countedGroups.has(groupKey)) return null;
 1915:           countedGroups.add(groupKey);
 1916:
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
```

### Match around map line 210
```text
 1915:           countedGroups.add(groupKey);
 1916:
 1917:           const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
 1918:             (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
```

### Context for 'client-profile-completion-shell' around line 2037
```jsx
 2029:
 2030:   const [sections, setSections] = useState([]);
 2031:
 2032:   useEffect(() => {
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
```

### Match around map line 220
```text
 2031:
 2032:   useEffect(() => {
 2033:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 2034:
 2035:     const isVisible = (control) => {
 2036:       if (!control || control.disabled) return false;
 2037:       if (control.closest(".client-profile-completion-shell")) return false;
 2038:       if (control.closest(".client-profile-review-panel")) return false;
 2039:       if (control.closest(".client-profile-summary-rail")) return false;
 2040:       return Boolean(control.offsetParent || control.getClientRects().length);
 2041:     };
 2042:
 2043:     const hasValue = (control) => {
 2044:       const type = (control.getAttribute("type") || "").toLowerCase();
 2045:
 2046:       if (type === "checkbox" || type === "radio") {
 2047:         return Boolean(control.checked);
 2048:       }
 2049:
 2050:       return String(control.value || "").trim().length > 0;
 2051:     };
 2052:
 2053:     const countRequiredControls = (controls, sectionRoot) => {
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
```

### Match around map line 241
```text
 2052:
 2053:     const countRequiredControls = (controls, sectionRoot) => {
 2054:       const countedGroups = new Set();
 2055:       let required = 0;
```

### Context for 'client-profile-completion-shell' around line 4010
```jsx
 4002:       </div>
 4003:
 4004:       {status && (
 4005:         <p className={"client-status client-status-" + statusType}>
 4006:           {status}
 4007:         </p>
 4008:       )}
 4009:
 4010:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4011:         <div className="client-profile-completion-header">
 4012:           <div>
 4013:             <p className="client-profile-completion-kicker">Completion Intelligence</p>
 4014:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4015:             <p>
 4016:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
 4017:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4018:             </p>
```

### Match around map line 251
```text
 4004:       {status && (
 4005:         <p className={"client-status client-status-" + statusType}>
 4006:           {status}
 4007:         </p>
 4008:       )}
 4009:
 4010:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4011:         <div className="client-profile-completion-header">
 4012:           <div>
 4013:             <p className="client-profile-completion-kicker">Completion Intelligence</p>
 4014:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4015:             <p>
 4016:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
 4017:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4018:             </p>
 4019:           </div>
 4020:           <span className="client-profile-completion-status">Static shell only</span>
 4021:         </div>
 4022:
 4023:         <div className="client-profile-completion-grid">
 4024:           <article className="client-profile-completion-card">
 4025:             <p className="client-profile-completion-kicker">Profile Readiness</p>
 4026:             <h4>Verify Before Saving</h4>
 4027:             <p>
 4028:               Completion indicators are prepared for future audited validation mapping. This card does not calculate
```

### Match around map line 294
```text
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
```

### Context for 'ClientRequiredFieldCounter' around line 4059
```jsx
 4051:             <h4>Manual Review Remains Required</h4>
 4052:             <p>
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
```

### Match around map line 418
```text
 4004:       {status && (
 4005:         <p className={"client-status client-status-" + statusType}>
 4006:           {status}
 4007:         </p>
 4008:       )}
 4009:
 4010:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4011:         <div className="client-profile-completion-header">
 4012:           <div>
 4013:             <p className="client-profile-completion-kicker">Completion Intelligence</p>
 4014:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4015:             <p>
 4016:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
```

### Context for 'client-directory' around line 2365
```jsx
 2357:     setActiveAlphabetFilter(initial || "All");
 2358:     setSelectedClientTagFilter("All");
 2359:     setManualClientTagSearch("");
 2360:     setViewingClientProfile(normalized);
 2361:
 2362:     showStatus("Manual client selection applied to the shared directory filter context.", "info");
 2363:
 2364:     window.setTimeout(() => {
```

## Anchor: ClientRequiredFieldCounter

### Match around map line 22
```text

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
```

### Match around map line 23
```text
### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
```

### Match around map line 24
```text
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
```

### Match around map line 272
```text
 4025:             <p className="client-profile-completion-kicker">Profile Readiness</p>
 4026:             <h4>Verify Before Saving</h4>
 4027:             <p>
 4028:               Completion indicators are prepared for future audited validation mapping. This card does not calculate
```

### Context for 'ClientRequiredFieldCounter' around line 1888
```jsx
 1880:       ...getCorrespondenceAddressUpdatesFromResidential(withCanonicalContacts)
 1881:     };
 1882:   }
 1883:
 1884:   return withCanonicalContacts;
 1885: }
 1886:
 1887:
 1888: function ClientRequiredFieldCounter() {
 1889:   const [snapshot, setSnapshot] = useState({
 1890:     total: 0,
 1891:     complete: 0,
 1892:     missing: 0,
 1893:   });
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
```

### Match around map line 282
```text
 1882:   }
 1883:
 1884:   return withCanonicalContacts;
 1885: }
 1886:
 1887:
 1888: function ClientRequiredFieldCounter() {
 1889:   const [snapshot, setSnapshot] = useState({
 1890:     total: 0,
 1891:     complete: 0,
 1892:     missing: 0,
 1893:   });
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
```

### Match around map line 303
```text
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
```

### Context for 'ClientRequiredFieldCounter' around line 4059
```jsx
 4051:             <h4>Manual Review Remains Required</h4>
 4052:             <p>
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
```

### Match around map line 313
```text
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
 4073:           <div>
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4076:           </div>
 4077:           <div className="client-directory-actions">
```

### Match around map line 373
```text
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
 4073:           <div>
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4076:           </div>
 4077:           <div className="client-directory-actions">
```

## Anchor: ClientSectionCompletionStatus

### Match around map line 26
```text
- Line 4010: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
- Line 3888: .client-directory-header-row,
- Line 3889: .client-directory-summary-row {
```

### Match around map line 27
```text

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
- Line 3888: .client-directory-header-row,
- Line 3889: .client-directory-summary-row {
- Line 3896: .client-directory-actions {
```

### Match around map line 28
```text
### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
- Line 3888: .client-directory-header-row,
- Line 3889: .client-directory-summary-row {
- Line 3896: .client-directory-actions {
- Line 3921: .client-directory-mini-list {
```

### Match around map line 315
```text
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
 4073:           <div>
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4076:           </div>
 4077:           <div className="client-directory-actions">
```

```

### Match around map line 334
```text
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4076:           </div>
 4077:           <div className="client-directory-actions">
```

### Context for 'ClientSectionCompletionStatus' around line 2013
```jsx
 2005:           <strong>{snapshot.missing}</strong>
 2006:           Missing
 2007:         </span>
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Profile Details" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment" },
 2018:     { anchor: "client-family-marital-details", label: "Family / Marital" },
 2019:     { anchor: "client-matter-context-origin", label: "Matter Context" },
 2020:     { anchor: "client-source-value-indicators", label: "Source / Value" },
 2021:     { anchor: "client-will-estate-metadata", label: "Will / Estate" },
```

### Match around map line 344
```text
 2007:         </span>
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Profile Details" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment" },
 2018:     { anchor: "client-family-marital-details", label: "Family / Marital" },
 2019:     { anchor: "client-matter-context-origin", label: "Matter Context" },
 2020:     { anchor: "client-source-value-indicators", label: "Source / Value" },
 2021:     { anchor: "client-will-estate-metadata", label: "Will / Estate" },
 2022:     { anchor: "client-health-oku-accommodation", label: "Health / OKU / Accommodation" },
 2023:     { anchor: "client-contact-communication-preferences", label: "Contact / Communication" },
 2024:     { anchor: "client-address-service-location", label: "Address / Service Location" },
 2025:     { anchor: "client-emergency-next-of-kin", label: "Emergency / Next of Kin" },
 2026:     { anchor: "client-documentation-verification", label: "Documentation Verification" },
 2027:     { anchor: "client-internal-remarks-issues", label: "Remarks / Pending Info" },
 2028:   ];
 2029:
 2030:   const [sections, setSections] = useState([]);
 2031:
```

### Match around map line 365
```text
 2028:   ];
 2029:
 2030:   const [sections, setSections] = useState([]);
 2031:
```

### Context for 'ClientSectionCompletionStatus' around line 4061
```jsx
 4053:               Documentation verification, pending information, backend warnings, and local fallback warnings remain controlled
 4054:               by the existing Clients workflow.
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
```

### Match around map line 375
```text
 4055:             </p>
 4056:           </article>
 4057:         </div>
 4058:
 4059:         <ClientRequiredFieldCounter />
 4060:
 4061:         <ClientSectionCompletionStatus />
 4062:
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
 4073:           <div>
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4076:           </div>
 4077:           <div className="client-directory-actions">
 4078:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4079:               + Add/Create New Client Profile
```

## Anchor: client-count-card

### Match around map line 30
```text
- Line 4059: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
- Line 3888: .client-directory-header-row,
- Line 3889: .client-directory-summary-row {
- Line 3896: .client-directory-actions {
- Line 3921: .client-directory-mini-list {
- Line 3927: .client-directory-mini-card {
- Line 3935: .client-directory-mini-card span {
```

### Match around map line 31
```text

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4061: <ClientSectionCompletionStatus />

### Pattern: client-count-card
- Line 3998: <div className="client-count-card">

### Pattern: client-directory
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3686: .client-directory-mini-card-actions {
- Line 3731: .client-directory-control-panel {
- Line 3737: .client-directory-summary-row {
- Line 3741: .client-directory-mini-list {
- Line 3775: .client-directory-mini-card span,
- Line 3781: .client-directory-mini-card {
- Line 3816: .client-directory-result-actions {
- Line 3881: .client-directory-control-panel {
- Line 3888: .client-directory-header-row,
- Line 3889: .client-directory-summary-row {
- Line 3896: .client-directory-actions {
- Line 3921: .client-directory-mini-list {
- Line 3927: .client-directory-mini-card {
- Line 3935: .client-directory-mini-card span {
- Line 4071: <div className="client-directory-control-panel">
```

### Match around map line 396
```text
 4076:           </div>
 4077:           <div className="client-directory-actions">
 4078:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4079:               + Add/Create New Client Profile
```

### Context for 'client-count-card' around line 3998
```jsx
 3990:             </p>
 3991:           </div>
 3992:         </aside>
 3993: <p>
 3994:             Client database, directory and profile management.
 3995:           </p>
 3996:         </div>
 3997:
 3998:         <div className="client-count-card">
 3999:           <strong>All Clients ({clients.length})</strong>
 4000:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 4001:         </div>
 4002:       </div>
 4003:
 4004:       {status && (
 4005:         <p className={"client-status client-status-" + statusType}>
 4006:           {status}
```

### Match around map line 406
```text
 3992:         </aside>
 3993: <p>
 3994:             Client database, directory and profile management.
 3995:           </p>
 3996:         </div>
 3997:
 3998:         <div className="client-count-card">
 3999:           <strong>All Clients ({clients.length})</strong>
 4000:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 4001:         </div>
 4002:       </div>
 4003:
 4004:       {status && (
 4005:         <p className={"client-status client-status-" + statusType}>
 4006:           {status}
 4007:         </p>
 4008:       )}
 4009:
 4010:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4011:         <div className="client-profile-completion-header">
 4012:           <div>
 4013:             <p className="client-profile-completion-kicker">Completion Intelligence</p>
 4014:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4015:             <p>
 4016:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
```

## Anchor: Return to Stage 2 Matter Intake

### Match around map line 80
```text

### Pattern: client-profile-form
- Line 3648: <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
- Line 3726: .client-profile-form-closed .client-form-v6,
- Line 3727: .client-profile-form-closed .client-validation-box {

### Pattern: Return to Stage 2 Matter Intake
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

## Top-Level Context Windows

### Context for 'client-profile-summary-rail' around line 1902
```jsx
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
```

### Match around map line 81
```text
### Pattern: client-profile-form
- Line 3648: <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
- Line 3726: .client-profile-form-closed .client-form-v6,
- Line 3727: .client-profile-form-closed .client-validation-box {

### Pattern: Return to Stage 2 Matter Intake
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

## Top-Level Context Windows

### Context for 'client-profile-summary-rail' around line 1902
```jsx
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
```

### Match around map line 82
```text
- Line 3648: <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
- Line 3726: .client-profile-form-closed .client-form-v6,
- Line 3727: .client-profile-form-closed .client-validation-box {

### Pattern: Return to Stage 2 Matter Intake
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

## Top-Level Context Windows

### Context for 'client-profile-summary-rail' around line 1902
```jsx
 1894:
 1895:   useEffect(() => {
 1896:     const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
 1897:
 1898:     const isVisible = (control) => {
 1899:       if (!control || control.disabled) return false;
 1900:       if (control.closest(".client-profile-completion-shell")) return false;
 1901:       if (control.closest(".client-profile-review-panel")) return false;
 1902:       if (control.closest(".client-profile-summary-rail")) return false;
 1903:       return Boolean(control.offsetParent || control.getClientRects().length);
 1904:     };
 1905:
 1906:     const isFilled = (control, root, countedGroups) => {
```

### Match around map line 151
```text
 2057:
```

### Context for 'client-profile-summary-rail' around line 3956
```jsx
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Match around map line 154
```text
### Context for 'client-profile-summary-rail' around line 3956
```jsx
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
```

### Match around map line 885
```text
 3943:         <div>
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
```

### Context for 'client-directory' around line 4071
```jsx
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
```

### Match around map line 888
```text
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
```

### Context for 'client-directory' around line 4071
```jsx
 4063:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4064:           <a href="#client-profile-details">Identity</a>
 4065:           <a href="#client-contact-communication-preferences">Contact</a>
 4066:           <a href="#client-address-service-location">Address</a>
 4067:           <a href="#client-documentation-verification">Documentation</a>
 4068:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4069:         </div>
 4070:       </section>
 4071: <div className="client-directory-control-panel">
 4072:         <div className="client-directory-header-row">
 4073:           <div>
 4074:             <h3>Advanced Client Directory / Manual Management</h3>
 4075:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
```

### Match around map line 1636
```text
 3742:           order: 3 !important;
 3743:         }
 3744:
 3745:         .client-alphabet-filter {
```

### Context for 'Return to Stage 2 Matter Intake' around line 3949
```jsx
 3941:       `}</style>
 3942:       <div className="client-module-header">
 3943:         <div>
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
```

### Match around map line 1646
```text
 3943:         <div>
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Match around map line 1649
```text
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Context for 'Return to Stage 2 Matter Intake' around line 3952
```

### Match around map line 1667
```text
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Context for 'Return to Stage 2 Matter Intake' around line 3952
```jsx
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
```

### Match around map line 1674
```text
```jsx
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
```

### Match around map line 1677
```text
 3946:           <strong>Advanced Client Directory / Manual Management</strong>
 3947:           <p>
 3948:             This workspace preserves the full original client profile, directory, validation, draft, and manual management process. Labels are aligned with the Matter Intake conveyor, but the original manual Clients protocol remains preserved.
 3949:             Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
 3950:           </p>
 3951:           <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>
 3952:             Return to Stage 2 Matter Intake
 3953:           </button>
 3954:         </div>
 3955:
 3956:         <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
 3957:           <div className="client-profile-summary-card">
 3958:             <p className="client-profile-summary-kicker">Profile Status</p>
 3959:             <h3>Full Client Profile Summary</h3>
 3960:             <p>
 3961:               Static preservation rail. Original fields, validation, backend checks, local fallback, draft behaviour,
 3962:               and manual management protocols remain unchanged.
 3963:             </p>
 3964:           </div>
 3965:
 3966:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3967:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
```


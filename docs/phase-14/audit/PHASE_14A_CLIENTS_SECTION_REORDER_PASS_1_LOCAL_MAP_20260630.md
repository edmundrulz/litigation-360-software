# Phase 14A Clients Page Section Reorder Pass 1 Local Map

Date: 2026-06-30
Source: frontend/src/pages/Clients.jsx

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
- Line 4072: <div className="client-directory-header-row">
- Line 4077: <div className="client-directory-actions">
- Line 4118: list="client-directory-name-suggestions"
- Line 4123: <datalist id="client-directory-name-suggestions">
- Line 4203: <div className="client-directory-summary-row" style={{ display: "none" }}>
- Line 4208: <div className="client-directory-mini-list" style={{ display: "none" }}>
- Line 4212: className="client-directory-mini-card"
- Line 4240: <div className="client-directory-result-actions">
- Line 4257: <div className="client-directory-actions">
- Line 4313: <div className="client-directory-result-actions">

### Pattern: View Client Profile
- Line 4229: <h3>View Client Profile</h3>
- Line 4254: <h3>View Client Profile</h3>
- Line 4314: <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); viewClientProfile(client); }}>View Client Profile</button>
- Line 6011: <button type="button" onClick={(event) => { event.stopPropagation(); viewClientProfile(normalized); }}>View Client Profile</button>

### Pattern: client-profile-preview
- Line 3823: .client-profile-preview-card {
- Line 3831: .client-profile-preview-header {
- Line 3838: .client-profile-preview-grid {
- Line 4227: <div className="client-profile-preview-card" style={{ display: "none" }}>
- Line 4228: <div className="client-profile-preview-header">
- Line 4232: <div className="client-profile-preview-grid">

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
 2365:       document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
 2366:     }, 50);
 2367:   }
 2368:
 2369:   function clearDirectoryFilters() {
 2370:     setSearchTerm("");
 2371:     setClientLookupSearchBy("All Fields");
 2372:     setActiveAlphabetFilter("All");
 2373:     setSelectedClientTagFilter("All");
 2374:     setManualClientTagSearch("");
 2375:     setViewingClientProfile(null);
 2376:     showStatus("All client directory filters cleared. Showing all clients.", "info");
 2377:   }
 2378:
 2379:   function getClientDirectoryActiveFilterSummary() {
 2380:     const filters = [];
 2381:
 2382:     if (String(searchTerm || "").trim()) {
 2383:       filters.push("Search: " + String(searchTerm || "").trim());
```

### Context for 'client-directory' around line 3686
```jsx
 3678:           max-width: 190px;
 3679:         }
 3680:         .client-contact-meta {
 3681:           display: flex;
 3682:           flex-wrap: wrap;
 3683:           gap: 4px 12px;
 3684:           align-items: center;
 3685:         }
 3686:         .client-directory-mini-card-actions {
 3687:           display: flex;
 3688:           flex-wrap: wrap;
 3689:           gap: 6px;
 3690:           margin-top: 10px;
 3691:         }
 3692:         .client-profile-view-card {
 3693:           border: 1px solid rgba(148, 163, 184, 0.45);
 3694:           border-radius: 16px;
 3695:           background: #ffffff;
 3696:           padding: 16px;
 3697:           margin: 16px 0;
 3698:         }
 3699:         .client-profile-view-header {
 3700:           display: flex;
 3701:           justify-content: space-between;
 3702:           gap: 12px;
 3703:           align-items: flex-start;
 3704:           flex-wrap: wrap;
```

### Context for 'client-directory' around line 3731
```jsx
 3723:           grid-column: 1 / -1;
 3724:         }
 3725:         /* L360_DASHBOARD_V3E_FINAL_CLEANUP */
 3726:         .client-profile-form-closed .client-form-v6,
 3727:         .client-profile-form-closed .client-validation-box {
 3728:           display: none !important;
 3729:         }
 3730:
 3731:         .client-directory-control-panel {
 3732:           display: flex !important;
 3733:           flex-direction: column !important;
 3734:           gap: 10px !important;
 3735:         }
 3736:
 3737:         .client-directory-summary-row {
 3738:           order: 2 !important;
 3739:         }
 3740:
 3741:         .client-directory-mini-list {
 3742:           order: 3 !important;
 3743:         }
 3744:
 3745:         .client-alphabet-filter {
 3746:           order: 4 !important;
 3747:         }
 3748:
 3749:         .client-alphabet-filter.two-rows {
```

### Context for 'client-directory' around line 3737
```jsx
 3729:         }
 3730:
 3731:         .client-directory-control-panel {
 3732:           display: flex !important;
 3733:           flex-direction: column !important;
 3734:           gap: 10px !important;
 3735:         }
 3736:
 3737:         .client-directory-summary-row {
 3738:           order: 2 !important;
 3739:         }
 3740:
 3741:         .client-directory-mini-list {
 3742:           order: 3 !important;
 3743:         }
 3744:
 3745:         .client-alphabet-filter {
 3746:           order: 4 !important;
 3747:         }
 3748:
 3749:         .client-alphabet-filter.two-rows {
 3750:           display: grid !important;
 3751:           gap: 6px !important;
 3752:           margin: 10px 0 !important;
 3753:         }
 3754:
 3755:         .client-alphabet-filter.two-rows .alphabet-action-row {
```

### Context for 'client-directory' around line 3741
```jsx
 3733:           flex-direction: column !important;
 3734:           gap: 10px !important;
 3735:         }
 3736:
 3737:         .client-directory-summary-row {
 3738:           order: 2 !important;
 3739:         }
 3740:
 3741:         .client-directory-mini-list {
 3742:           order: 3 !important;
 3743:         }
 3744:
 3745:         .client-alphabet-filter {
 3746:           order: 4 !important;
 3747:         }
 3748:
 3749:         .client-alphabet-filter.two-rows {
 3750:           display: grid !important;
 3751:           gap: 6px !important;
 3752:           margin: 10px 0 !important;
 3753:         }
 3754:
 3755:         .client-alphabet-filter.two-rows .alphabet-action-row {
 3756:           display: flex !important;
 3757:           gap: 6px !important;
 3758:           justify-content: flex-start !important;
 3759:         }
```

### Context for 'client-directory' around line 3775
```jsx
 3767:         .client-alphabet-filter.two-rows button {
 3768:           min-width: 0 !important;
 3769:           width: 100% !important;
 3770:           padding: 4px 0 !important;
 3771:           font-size: 11px !important;
 3772:           text-align: center !important;
 3773:         }
 3774:
 3775:         .client-directory-mini-card span,
 3776:         .client-contact-result-card span {
 3777:           white-space: normal !important;
 3778:           line-height: 1.25 !important;
 3779:         }
 3780:
 3781:         .client-directory-mini-card {
 3782:           min-height: auto !important;
 3783:         }
 3784:
 3785:         .client-form-v6 label.full > button.btn-small {
 3786:           margin-top: 8px;
 3787:         }
 3788:         /* L360_SURGICAL_CLIENT_PATCH_V2_STYLE */
 3789:         /* L360_DASHBOARD_V3F_BUILD_FIX_UI_REFINEMENT */
 3790:         .extended-contact-choices {
 3791:           display: contents;
 3792:         }
 3793:         .client-alphabet-filter.two-rows {
```

### Context for 'client-directory' around line 3781
```jsx
 3773:         }
 3774:
 3775:         .client-directory-mini-card span,
 3776:         .client-contact-result-card span {
 3777:           white-space: normal !important;
 3778:           line-height: 1.25 !important;
 3779:         }
 3780:
 3781:         .client-directory-mini-card {
 3782:           min-height: auto !important;
 3783:         }
 3784:
 3785:         .client-form-v6 label.full > button.btn-small {
 3786:           margin-top: 8px;
 3787:         }
 3788:         /* L360_SURGICAL_CLIENT_PATCH_V2_STYLE */
 3789:         /* L360_DASHBOARD_V3F_BUILD_FIX_UI_REFINEMENT */
 3790:         .extended-contact-choices {
 3791:           display: contents;
 3792:         }
 3793:         .client-alphabet-filter.two-rows {
 3794:           align-items: center;
 3795:           justify-items: center;
 3796:         }
 3797:         .client-alphabet-filter.two-rows .alphabet-action-row,
 3798:         .client-alphabet-filter.two-rows .alphabet-row {
 3799:           display: flex !important;
```

### Context for 'client-directory' around line 3816
```jsx
 3808:           flex: 0 0 auto !important;
 3809:           min-width: 42px;
 3810:           max-width: 180px;
 3811:           white-space: nowrap;
 3812:         }
 3813:         .client-alphabet-filter.two-rows .alphabet-action-row button {
 3814:           min-width: 130px;
 3815:         }
 3816:         .client-directory-result-actions {
 3817:           display: flex;
 3818:           flex-wrap: wrap;
 3819:           gap: 6px;
 3820:           align-items: center;
 3821:           justify-content: flex-end;
 3822:         }
 3823:         .client-profile-preview-card {
 3824:           border: 1px solid rgba(15, 23, 42, 0.14);
 3825:           border-radius: 14px;
 3826:           padding: 14px;
 3827:           margin: 14px 0;
 3828:           background: #ffffff;
 3829:           box-shadow: 0 10px 24px rgba(15, 23, 42, 0.06);
 3830:         }
 3831:         .client-profile-preview-header {
 3832:           display: flex;
 3833:           justify-content: space-between;
 3834:           align-items: center;
```

### Context for 'client-directory' around line 3881
```jsx
 3873:           gap: 10px;
 3874:           align-items: center;
 3875:           padding: 10px;
 3876:           border: 1px solid rgba(148, 163, 184, 0.35);
 3877:           border-radius: 12px;
 3878:           background: #ffffff;
 3879:         }
 3880:         /* L360_CLIENT_DIRECTORY_V3C_STYLE */
 3881:         .client-directory-control-panel {
 3882:           border: 1px solid rgba(148, 163, 184, 0.45);
 3883:           border-radius: 16px;
 3884:           padding: 16px;
 3885:           margin: 16px 0;
 3886:           background: rgba(255, 255, 255, 0.94);
 3887:         }
 3888:         .client-directory-header-row,
 3889:         .client-directory-summary-row {
 3890:           display: flex;
 3891:           justify-content: space-between;
 3892:           gap: 12px;
 3893:           align-items: center;
 3894:           flex-wrap: wrap;
 3895:         }
 3896:         .client-directory-actions {
 3897:           display: flex;
 3898:           gap: 8px;
 3899:           flex-wrap: wrap;
```

### Context for 'client-directory' around line 3888
```jsx
 3880:         /* L360_CLIENT_DIRECTORY_V3C_STYLE */
 3881:         .client-directory-control-panel {
 3882:           border: 1px solid rgba(148, 163, 184, 0.45);
 3883:           border-radius: 16px;
 3884:           padding: 16px;
 3885:           margin: 16px 0;
 3886:           background: rgba(255, 255, 255, 0.94);
 3887:         }
 3888:         .client-directory-header-row,
 3889:         .client-directory-summary-row {
 3890:           display: flex;
 3891:           justify-content: space-between;
 3892:           gap: 12px;
 3893:           align-items: center;
 3894:           flex-wrap: wrap;
 3895:         }
 3896:         .client-directory-actions {
 3897:           display: flex;
 3898:           gap: 8px;
 3899:           flex-wrap: wrap;
 3900:         }
 3901:         .client-alphabet-filter,
 3902:         .client-search-history {
 3903:           display: flex;
 3904:           flex-wrap: wrap;
 3905:           gap: 6px;
 3906:           margin: 12px 0;
```

### Context for 'client-directory' around line 3889
```jsx
 3881:         .client-directory-control-panel {
 3882:           border: 1px solid rgba(148, 163, 184, 0.45);
 3883:           border-radius: 16px;
 3884:           padding: 16px;
 3885:           margin: 16px 0;
 3886:           background: rgba(255, 255, 255, 0.94);
 3887:         }
 3888:         .client-directory-header-row,
 3889:         .client-directory-summary-row {
 3890:           display: flex;
 3891:           justify-content: space-between;
 3892:           gap: 12px;
 3893:           align-items: center;
 3894:           flex-wrap: wrap;
 3895:         }
 3896:         .client-directory-actions {
 3897:           display: flex;
 3898:           gap: 8px;
 3899:           flex-wrap: wrap;
 3900:         }
 3901:         .client-alphabet-filter,
 3902:         .client-search-history {
 3903:           display: flex;
 3904:           flex-wrap: wrap;
 3905:           gap: 6px;
 3906:           margin: 12px 0;
 3907:         }
```

### Context for 'client-directory' around line 3896
```jsx
 3888:         .client-directory-header-row,
 3889:         .client-directory-summary-row {
 3890:           display: flex;
 3891:           justify-content: space-between;
 3892:           gap: 12px;
 3893:           align-items: center;
 3894:           flex-wrap: wrap;
 3895:         }
 3896:         .client-directory-actions {
 3897:           display: flex;
 3898:           gap: 8px;
 3899:           flex-wrap: wrap;
 3900:         }
 3901:         .client-alphabet-filter,
 3902:         .client-search-history {
 3903:           display: flex;
 3904:           flex-wrap: wrap;
 3905:           gap: 6px;
 3906:           margin: 12px 0;
 3907:         }
 3908:         .client-alphabet-filter button,
 3909:         .client-search-history button {
 3910:           border: 1px solid rgba(148, 163, 184, 0.55);
 3911:           border-radius: 999px;
 3912:           padding: 5px 10px;
 3913:           background: #fff;
 3914:           cursor: pointer;
```

### Context for 'client-directory' around line 3921
```jsx
 3913:           background: #fff;
 3914:           cursor: pointer;
 3915:         }
 3916:         .client-alphabet-filter button.active {
 3917:           font-weight: 800;
 3918:           border-color: #2563eb;
 3919:           box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.12);
 3920:         }
 3921:         .client-directory-mini-list {
 3922:           display: grid;
 3923:           grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
 3924:           gap: 10px;
 3925:           margin-top: 12px;
 3926:         }
 3927:         .client-directory-mini-card {
 3928:           text-align: left;
 3929:           border: 1px solid rgba(148, 163, 184, 0.45);
 3930:           border-radius: 12px;
 3931:           padding: 10px;
 3932:           background: #fff;
 3933:           cursor: pointer;
 3934:         }
 3935:         .client-directory-mini-card span {
 3936:           display: block;
 3937:           margin-top: 4px;
 3938:           font-size: 0.86rem;
 3939:           opacity: 0.78;
```

### Context for 'client-directory' around line 3927
```jsx
 3919:           box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.12);
 3920:         }
 3921:         .client-directory-mini-list {
 3922:           display: grid;
 3923:           grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
 3924:           gap: 10px;
 3925:           margin-top: 12px;
 3926:         }
 3927:         .client-directory-mini-card {
 3928:           text-align: left;
 3929:           border: 1px solid rgba(148, 163, 184, 0.45);
 3930:           border-radius: 12px;
 3931:           padding: 10px;
 3932:           background: #fff;
 3933:           cursor: pointer;
 3934:         }
 3935:         .client-directory-mini-card span {
 3936:           display: block;
 3937:           margin-top: 4px;
 3938:           font-size: 0.86rem;
 3939:           opacity: 0.78;
 3940:         }
 3941:       `}</style>
 3942:       <div className="client-module-header">
 3943:         <div>
 3944:           <h2>Client Registration / Full Client Profile</h2>
 3945:         <div className="client-flow-bridge-panel">
```

### Context for 'client-directory' around line 3935
```jsx
 3927:         .client-directory-mini-card {
 3928:           text-align: left;
 3929:           border: 1px solid rgba(148, 163, 184, 0.45);
 3930:           border-radius: 12px;
 3931:           padding: 10px;
 3932:           background: #fff;
 3933:           cursor: pointer;
 3934:         }
 3935:         .client-directory-mini-card span {
 3936:           display: block;
 3937:           margin-top: 4px;
 3938:           font-size: 0.86rem;
 3939:           opacity: 0.78;
 3940:         }
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
 4076:           </div>
 4077:           <div className="client-directory-actions">
 4078:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4079:               + Add/Create New Client Profile
 4080:             </button>
 4081:             {showClientProfileForm && (
 4082:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4083:                 Hide Client Profile Form
 4084:               </button>
 4085:             )}
 4086:           </div>
 4087:         </div>
 4088:
 4089:         <div className="inline-fields four-even">
```

### Context for 'client-directory' around line 4072
```jsx
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
 4080:             </button>
 4081:             {showClientProfileForm && (
 4082:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4083:                 Hide Client Profile Form
 4084:               </button>
 4085:             )}
 4086:           </div>
 4087:         </div>
 4088:
 4089:         <div className="inline-fields four-even">
 4090:           <label>
```

### Context for 'client-directory' around line 4077
```jsx
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
 4080:             </button>
 4081:             {showClientProfileForm && (
 4082:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4083:                 Hide Client Profile Form
 4084:               </button>
 4085:             )}
 4086:           </div>
 4087:         </div>
 4088:
 4089:         <div className="inline-fields four-even">
 4090:           <label>
 4091:             Search By
 4092:             <select value={clientLookupSearchBy} onChange={(event) => setClientLookupSearchBy(event.target.value)}>
 4093:               {[
 4094:                 "All Fields",
 4095:                 "Client Name",
```

### Context for 'client-directory' around line 4118
```jsx
 4110:                 <option key={option} value={option}>{option}</option>
 4111:               ))}
 4112:             </select>
 4113:           </label>
 4114:
 4115:           <label>
 4116:             Search Existing Client
 4117:             <input
 4118:               list="client-directory-name-suggestions"
 4119:               value={searchTerm}
 4120:               onChange={handleDirectorySearchChange}
 4121:               placeholder="Search as you type: name, phone, WhatsApp, email, NRIC/passport, postcode, town/city, district, municipality, council, borough, state, tags or remarks"
 4122:             />
 4123:             <datalist id="client-directory-name-suggestions">
 4124:               {clientNameSuggestions.map((name) => <option key={name} value={name} />)}
 4125:             </datalist>
 4126:           </label>
 4127:
 4128:           <label>
 4129:             Manual Client Selection
 4130:             <select
 4131:               value=""
 4132:               onChange={(event) => {
 4133:                 const selected = clients.find((client) => getClientId(client) === event.target.value);
 4134:                 if (selected) selectClientFromDirectory(selected);
 4135:               }}
 4136:             >
```

### Context for 'client-directory' around line 4123
```jsx
 4115:           <label>
 4116:             Search Existing Client
 4117:             <input
 4118:               list="client-directory-name-suggestions"
 4119:               value={searchTerm}
 4120:               onChange={handleDirectorySearchChange}
 4121:               placeholder="Search as you type: name, phone, WhatsApp, email, NRIC/passport, postcode, town/city, district, municipality, council, borough, state, tags or remarks"
 4122:             />
 4123:             <datalist id="client-directory-name-suggestions">
 4124:               {clientNameSuggestions.map((name) => <option key={name} value={name} />)}
 4125:             </datalist>
 4126:           </label>
 4127:
 4128:           <label>
 4129:             Manual Client Selection
 4130:             <select
 4131:               value=""
 4132:               onChange={(event) => {
 4133:                 const selected = clients.find((client) => getClientId(client) === event.target.value);
 4134:                 if (selected) selectClientFromDirectory(selected);
 4135:               }}
 4136:             >
 4137:               <option value="">Select existing client</option>
 4138:               {clients
 4139:                 .slice()
 4140:                 .sort((a, b) => getClientDirectoryName(a).localeCompare(getClientDirectoryName(b)))
 4141:                 .map((client) => (
```

### Context for 'client-directory' around line 4203
```jsx
 4195:             <strong>Recent searches:</strong>
 4196:             {clientSearchHistory.map((item) => (
 4197:               <button type="button" key={item} onClick={() => setSearchTerm(item)}>{item}</button>
 4198:             ))}
 4199:             <button type="button" onClick={() => setClientSearchHistory([])}>Clear History</button>
 4200:           </div>
 4201:         )}
 4202:
 4203:         <div className="client-directory-summary-row" style={{ display: "none" }}>
 4204:           <span>Directory Results: {filteredDirectoryClients.length}</span>
 4205:           <button type="button" className="btn btn-secondary btn-small" onClick={clearDirectoryFilters}>Clear Filters</button>
 4206:         </div>
 4207:
 4208:         <div className="client-directory-mini-list" style={{ display: "none" }}>
 4209:           {filteredDirectoryClients.slice(0, 26).map((client) => (
 4210:             <button
 4211:               type="button"
 4212:               className="client-directory-mini-card"
 4213:               key={getClientId(client) || getClientDirectoryName(client)}
 4214:               onClick={() => selectClientFromDirectory(client)}
 4215:             >
 4216:               <strong>{getClientDirectoryName(client)}</strong>
 4217:               <span className="client-contact-meta">
 4218:                 <span>{client.email || "No email"}</span>
 4219:                 <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4220:                 <span>{client.townCity || "No town/city"}</span>
 4221:               </span>
```

### Context for 'client-directory' around line 4208
```jsx
 4200:           </div>
 4201:         )}
 4202:
 4203:         <div className="client-directory-summary-row" style={{ display: "none" }}>
 4204:           <span>Directory Results: {filteredDirectoryClients.length}</span>
 4205:           <button type="button" className="btn btn-secondary btn-small" onClick={clearDirectoryFilters}>Clear Filters</button>
 4206:         </div>
 4207:
 4208:         <div className="client-directory-mini-list" style={{ display: "none" }}>
 4209:           {filteredDirectoryClients.slice(0, 26).map((client) => (
 4210:             <button
 4211:               type="button"
 4212:               className="client-directory-mini-card"
 4213:               key={getClientId(client) || getClientDirectoryName(client)}
 4214:               onClick={() => selectClientFromDirectory(client)}
 4215:             >
 4216:               <strong>{getClientDirectoryName(client)}</strong>
 4217:               <span className="client-contact-meta">
 4218:                 <span>{client.email || "No email"}</span>
 4219:                 <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4220:                 <span>{client.townCity || "No town/city"}</span>
 4221:               </span>
 4222:             </button>
 4223:           ))}
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
```

### Context for 'client-directory' around line 4212
```jsx
 4204:           <span>Directory Results: {filteredDirectoryClients.length}</span>
 4205:           <button type="button" className="btn btn-secondary btn-small" onClick={clearDirectoryFilters}>Clear Filters</button>
 4206:         </div>
 4207:
 4208:         <div className="client-directory-mini-list" style={{ display: "none" }}>
 4209:           {filteredDirectoryClients.slice(0, 26).map((client) => (
 4210:             <button
 4211:               type="button"
 4212:               className="client-directory-mini-card"
 4213:               key={getClientId(client) || getClientDirectoryName(client)}
 4214:               onClick={() => selectClientFromDirectory(client)}
 4215:             >
 4216:               <strong>{getClientDirectoryName(client)}</strong>
 4217:               <span className="client-contact-meta">
 4218:                 <span>{client.email || "No email"}</span>
 4219:                 <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4220:                 <span>{client.townCity || "No town/city"}</span>
 4221:               </span>
 4222:             </button>
 4223:           ))}
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
 4227:             <div className="client-profile-preview-card" style={{ display: "none" }}>
 4228:               <div className="client-profile-preview-header">
 4229:                 <h3>View Client Profile</h3>
 4230:                 <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>Close View</button>
```

### Context for 'client-directory' around line 4240
```jsx
 4232:               <div className="client-profile-preview-grid">
 4233:                 <span><strong>Client ID</strong><br />{getClientId(viewingClientProfile) || "Not assigned"}</span>
 4234:                 <span><strong>Name</strong><br />{[viewingClientProfile.titlePrefix, viewingClientProfile.givenName, viewingClientProfile.surname].filter(Boolean).join(" ") || viewingClientProfile.name || "Unnamed client"}</span>
 4235:                 <span><strong>Email</strong><br />{viewingClientProfile.email || "No email recorded"}</span>
 4236:                 <span><strong>Phone</strong><br />{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || "No phone recorded"}</span>
 4237:                 <span><strong>Town / City</strong><br />{viewingClientProfile.townCity || "Not recorded"}</span>
 4238:                 <span><strong>Status</strong><br />{viewingClientProfile.verificationStatus || viewingClientProfile.documentStatus || "To be reviewed"}</span>
 4239:               </div>
 4240:               <div className="client-directory-result-actions">
 4241:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>Edit / Amend</button>
 4242:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => deleteClient(viewingClientProfile)}>Delete</button>
 4243:               </div>
 4244:             </div>
 4245:           )}
 4246:         </div>
 4247:       </div>
 4248:
 4249:       {/* L360_DASHBOARD_V3G2_VIEW_PROFILE_PANEL */}
 4250:       {viewingClientProfile && (
 4251:         <section className="client-profile-view-card">
 4252:           <div className="client-profile-view-header">
 4253:             <div>
 4254:               <h3>View Client Profile</h3>
 4255:               <p className="mandatory-note">Read-only client profile view. Use Edit / Amend to change details.</p>
 4256:             </div>
 4257:             <div className="client-directory-actions">
 4258:               <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>
```

### Context for 'client-directory' around line 4257
```jsx
 4249:       {/* L360_DASHBOARD_V3G2_VIEW_PROFILE_PANEL */}
 4250:       {viewingClientProfile && (
 4251:         <section className="client-profile-view-card">
 4252:           <div className="client-profile-view-header">
 4253:             <div>
 4254:               <h3>View Client Profile</h3>
 4255:               <p className="mandatory-note">Read-only client profile view. Use Edit / Amend to change details.</p>
 4256:             </div>
 4257:             <div className="client-directory-actions">
 4258:               <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>
 4259:                 Edit / Amend
 4260:               </button>
 4261:               <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>
 4262:                 Close View
 4263:               </button>
 4264:             </div>
 4265:           </div>
 4266:
 4267:           <div className="client-profile-view-grid">
 4268:             <div><strong>Client ID</strong><span>{getClientId(viewingClientProfile) || "Not assigned"}</span></div>
 4269:             <div><strong>Name</strong><span>{getClientDirectoryName(viewingClientProfile)}</span></div>
 4270:             <div><strong>Email</strong><span>{viewingClientProfile.email || "No email"}</span></div>
 4271:             <div><strong>Phone / WhatsApp</strong><span>{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || viewingClientProfile.phoneNumber || "No phone"}</span></div>
 4272:             <div><strong>NRIC / Passport</strong><span>{viewingClientProfile.nricPassportNumber || "Not recorded"}</span></div>
 4273:             <div><strong>Gender / Ethnicity</strong><span>{[viewingClientProfile.gender, viewingClientProfile.ethnicity].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4274:             <div><strong>Date / State of Birth</strong><span>{[viewingClientProfile.dateOfBirth, viewingClientProfile.stateOfBirth].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4275:             <div><strong>Document Status</strong><span>{[viewingClientProfile.documentType, viewingClientProfile.documentStatus, viewingClientProfile.verificationStatus].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
```

### Context for 'client-directory' around line 4313
```jsx
 4305:                 <span>
 4306:                   <strong>{[client.givenName, client.surname].filter(Boolean).join(" ") || client.name || "Unnamed client"}</strong><br />
 4307:                   <span className="client-contact-meta">
 4308:                     <span>{client.email || "No email"}</span>
 4309:                     <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4310:                     <span>{client.townCity || "No town/city"}</span>
 4311:                   </span>
 4312:                 </span>
 4313:                                 <div className="client-directory-result-actions">
 4314:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); viewClientProfile(client); }}>View Client Profile</button>
 4315:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); editClient(client); }}>Edit / Amend</button>
 4316:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); deleteClient(client); }}>Delete</button>
 4317:                 </div>
 4318:               </div>
 4319:             ))}
 4320:           </div>
 4321:         )}
 4322:       </div>
 4323:
 4324:       {validationErrors.length > 0 && (
 4325:         <div className="client-validation-box">
 4326:           <strong>Validation / Compliance Issues</strong>
 4327:           <ul>
 4328:             {validationErrors.map((error) => (
 4329:               <li key={error}>{error}</li>
 4330:             ))}
 4331:           </ul>
```

### Context for 'View Client Profile' around line 4229
```jsx
 4221:               </span>
 4222:             </button>
 4223:           ))}
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
 4227:             <div className="client-profile-preview-card" style={{ display: "none" }}>
 4228:               <div className="client-profile-preview-header">
 4229:                 <h3>View Client Profile</h3>
 4230:                 <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>Close View</button>
 4231:               </div>
 4232:               <div className="client-profile-preview-grid">
 4233:                 <span><strong>Client ID</strong><br />{getClientId(viewingClientProfile) || "Not assigned"}</span>
 4234:                 <span><strong>Name</strong><br />{[viewingClientProfile.titlePrefix, viewingClientProfile.givenName, viewingClientProfile.surname].filter(Boolean).join(" ") || viewingClientProfile.name || "Unnamed client"}</span>
 4235:                 <span><strong>Email</strong><br />{viewingClientProfile.email || "No email recorded"}</span>
 4236:                 <span><strong>Phone</strong><br />{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || "No phone recorded"}</span>
 4237:                 <span><strong>Town / City</strong><br />{viewingClientProfile.townCity || "Not recorded"}</span>
 4238:                 <span><strong>Status</strong><br />{viewingClientProfile.verificationStatus || viewingClientProfile.documentStatus || "To be reviewed"}</span>
 4239:               </div>
 4240:               <div className="client-directory-result-actions">
 4241:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>Edit / Amend</button>
 4242:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => deleteClient(viewingClientProfile)}>Delete</button>
 4243:               </div>
 4244:             </div>
 4245:           )}
 4246:         </div>
 4247:       </div>
```

### Context for 'View Client Profile' around line 4254
```jsx
 4246:         </div>
 4247:       </div>
 4248:
 4249:       {/* L360_DASHBOARD_V3G2_VIEW_PROFILE_PANEL */}
 4250:       {viewingClientProfile && (
 4251:         <section className="client-profile-view-card">
 4252:           <div className="client-profile-view-header">
 4253:             <div>
 4254:               <h3>View Client Profile</h3>
 4255:               <p className="mandatory-note">Read-only client profile view. Use Edit / Amend to change details.</p>
 4256:             </div>
 4257:             <div className="client-directory-actions">
 4258:               <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>
 4259:                 Edit / Amend
 4260:               </button>
 4261:               <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>
 4262:                 Close View
 4263:               </button>
 4264:             </div>
 4265:           </div>
 4266:
 4267:           <div className="client-profile-view-grid">
 4268:             <div><strong>Client ID</strong><span>{getClientId(viewingClientProfile) || "Not assigned"}</span></div>
 4269:             <div><strong>Name</strong><span>{getClientDirectoryName(viewingClientProfile)}</span></div>
 4270:             <div><strong>Email</strong><span>{viewingClientProfile.email || "No email"}</span></div>
 4271:             <div><strong>Phone / WhatsApp</strong><span>{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || viewingClientProfile.phoneNumber || "No phone"}</span></div>
 4272:             <div><strong>NRIC / Passport</strong><span>{viewingClientProfile.nricPassportNumber || "Not recorded"}</span></div>
```

### Context for 'View Client Profile' around line 4314
```jsx
 4306:                   <strong>{[client.givenName, client.surname].filter(Boolean).join(" ") || client.name || "Unnamed client"}</strong><br />
 4307:                   <span className="client-contact-meta">
 4308:                     <span>{client.email || "No email"}</span>
 4309:                     <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4310:                     <span>{client.townCity || "No town/city"}</span>
 4311:                   </span>
 4312:                 </span>
 4313:                                 <div className="client-directory-result-actions">
 4314:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); viewClientProfile(client); }}>View Client Profile</button>
 4315:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); editClient(client); }}>Edit / Amend</button>
 4316:                   <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); deleteClient(client); }}>Delete</button>
 4317:                 </div>
 4318:               </div>
 4319:             ))}
 4320:           </div>
 4321:         )}
 4322:       </div>
 4323:
 4324:       {validationErrors.length > 0 && (
 4325:         <div className="client-validation-box">
 4326:           <strong>Validation / Compliance Issues</strong>
 4327:           <ul>
 4328:             {validationErrors.map((error) => (
 4329:               <li key={error}>{error}</li>
 4330:             ))}
 4331:           </ul>
 4332:         </div>
```

### Context for 'View Client Profile' around line 6011
```jsx
 6003:                   <td>{normalized.verificationStatus || "-"}</td>
 6004:                   <td>
 6005:                     {normalized.verificationFlags.length > 0 ? normalized.verificationFlags.join("; ") : normalized.specialRemarksStaffLawyerNotes || "-"}
 6006:                   </td>
 6007:                   <td>{formatDateTime(normalized.createdAt)}</td>
 6008:                   <td>{formatDateTime(normalized.updatedAt)}</td>
 6009:                   <td>
 6010:                     <div className="client-row-actions">
 6011:                       <button type="button" onClick={(event) => { event.stopPropagation(); viewClientProfile(normalized); }}>View Client Profile</button>
 6012:                       <button type="button" onClick={(event) => { event.stopPropagation(); editClient(normalized); }}>Edit / Amend</button>
 6013:                       <button type="button" onClick={(event) => { event.stopPropagation(); deleteClient(normalized); }}>Delete</button>
 6014:                     </div>
 6015:                   </td>
 6016:                 </tr>
 6017:               );
 6018:             })}
 6019:           </tbody>
 6020:         </table>
 6021:       </div>
 6022:
 6023:       <p className="client-footnote">
 6024:         * required field. NRIC is fully masked in table views. Passport is partially masked.
 6025:         Age category and generation are locked from NRIC date of birth. Verification discrepancies are flagged for review and stored in the local audit trail until backend audit support is added.
 6026:       </p>
 6027:     </section>
 6028:   );
 6029: }
```

### Context for 'client-profile-preview' around line 3823
```jsx
 3815:         }
 3816:         .client-directory-result-actions {
 3817:           display: flex;
 3818:           flex-wrap: wrap;
 3819:           gap: 6px;
 3820:           align-items: center;
 3821:           justify-content: flex-end;
 3822:         }
 3823:         .client-profile-preview-card {
 3824:           border: 1px solid rgba(15, 23, 42, 0.14);
 3825:           border-radius: 14px;
 3826:           padding: 14px;
 3827:           margin: 14px 0;
 3828:           background: #ffffff;
 3829:           box-shadow: 0 10px 24px rgba(15, 23, 42, 0.06);
 3830:         }
 3831:         .client-profile-preview-header {
 3832:           display: flex;
 3833:           justify-content: space-between;
 3834:           align-items: center;
 3835:           gap: 10px;
 3836:           margin-bottom: 10px;
 3837:         }
 3838:         .client-profile-preview-grid {
 3839:           display: grid;
 3840:           grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
 3841:           gap: 10px;
```

### Context for 'client-profile-preview' around line 3831
```jsx
 3823:         .client-profile-preview-card {
 3824:           border: 1px solid rgba(15, 23, 42, 0.14);
 3825:           border-radius: 14px;
 3826:           padding: 14px;
 3827:           margin: 14px 0;
 3828:           background: #ffffff;
 3829:           box-shadow: 0 10px 24px rgba(15, 23, 42, 0.06);
 3830:         }
 3831:         .client-profile-preview-header {
 3832:           display: flex;
 3833:           justify-content: space-between;
 3834:           align-items: center;
 3835:           gap: 10px;
 3836:           margin-bottom: 10px;
 3837:         }
 3838:         .client-profile-preview-grid {
 3839:           display: grid;
 3840:           grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
 3841:           gap: 10px;
 3842:           margin-bottom: 12px;
 3843:         }
 3844:         .client-form-has-errors input:required:invalid,
 3845:         .client-form-has-errors select:required:invalid,
 3846:         .field-input-error {
 3847:           border: 2px solid #dc2626 !important;
 3848:           background: #fff1f2 !important;
 3849:           box-shadow: 0 0 0 1px rgba(220, 38, 38, 0.12);
```

### Context for 'client-profile-preview' around line 3838
```jsx
 3830:         }
 3831:         .client-profile-preview-header {
 3832:           display: flex;
 3833:           justify-content: space-between;
 3834:           align-items: center;
 3835:           gap: 10px;
 3836:           margin-bottom: 10px;
 3837:         }
 3838:         .client-profile-preview-grid {
 3839:           display: grid;
 3840:           grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
 3841:           gap: 10px;
 3842:           margin-bottom: 12px;
 3843:         }
 3844:         .client-form-has-errors input:required:invalid,
 3845:         .client-form-has-errors select:required:invalid,
 3846:         .field-input-error {
 3847:           border: 2px solid #dc2626 !important;
 3848:           background: #fff1f2 !important;
 3849:           box-shadow: 0 0 0 1px rgba(220, 38, 38, 0.12);
 3850:         }
 3851:         .field-error,
 3852:         .field-warning-message {
 3853:           display: block;
 3854:           color: #b91c1c;
 3855:           font-weight: 700;
 3856:           margin-top: 4px;
```

### Context for 'client-profile-preview' around line 4227
```jsx
 4219:                 <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
 4220:                 <span>{client.townCity || "No town/city"}</span>
 4221:               </span>
 4222:             </button>
 4223:           ))}
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
 4227:             <div className="client-profile-preview-card" style={{ display: "none" }}>
 4228:               <div className="client-profile-preview-header">
 4229:                 <h3>View Client Profile</h3>
 4230:                 <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>Close View</button>
 4231:               </div>
 4232:               <div className="client-profile-preview-grid">
 4233:                 <span><strong>Client ID</strong><br />{getClientId(viewingClientProfile) || "Not assigned"}</span>
 4234:                 <span><strong>Name</strong><br />{[viewingClientProfile.titlePrefix, viewingClientProfile.givenName, viewingClientProfile.surname].filter(Boolean).join(" ") || viewingClientProfile.name || "Unnamed client"}</span>
 4235:                 <span><strong>Email</strong><br />{viewingClientProfile.email || "No email recorded"}</span>
 4236:                 <span><strong>Phone</strong><br />{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || "No phone recorded"}</span>
 4237:                 <span><strong>Town / City</strong><br />{viewingClientProfile.townCity || "Not recorded"}</span>
 4238:                 <span><strong>Status</strong><br />{viewingClientProfile.verificationStatus || viewingClientProfile.documentStatus || "To be reviewed"}</span>
 4239:               </div>
 4240:               <div className="client-directory-result-actions">
 4241:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>Edit / Amend</button>
 4242:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => deleteClient(viewingClientProfile)}>Delete</button>
 4243:               </div>
 4244:             </div>
 4245:           )}
```

### Context for 'client-profile-preview' around line 4228
```jsx
 4220:                 <span>{client.townCity || "No town/city"}</span>
 4221:               </span>
 4222:             </button>
 4223:           ))}
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
 4227:             <div className="client-profile-preview-card" style={{ display: "none" }}>
 4228:               <div className="client-profile-preview-header">
 4229:                 <h3>View Client Profile</h3>
 4230:                 <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>Close View</button>
 4231:               </div>
 4232:               <div className="client-profile-preview-grid">
 4233:                 <span><strong>Client ID</strong><br />{getClientId(viewingClientProfile) || "Not assigned"}</span>
 4234:                 <span><strong>Name</strong><br />{[viewingClientProfile.titlePrefix, viewingClientProfile.givenName, viewingClientProfile.surname].filter(Boolean).join(" ") || viewingClientProfile.name || "Unnamed client"}</span>
 4235:                 <span><strong>Email</strong><br />{viewingClientProfile.email || "No email recorded"}</span>
 4236:                 <span><strong>Phone</strong><br />{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || "No phone recorded"}</span>
 4237:                 <span><strong>Town / City</strong><br />{viewingClientProfile.townCity || "Not recorded"}</span>
 4238:                 <span><strong>Status</strong><br />{viewingClientProfile.verificationStatus || viewingClientProfile.documentStatus || "To be reviewed"}</span>
 4239:               </div>
 4240:               <div className="client-directory-result-actions">
 4241:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>Edit / Amend</button>
 4242:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => deleteClient(viewingClientProfile)}>Delete</button>
 4243:               </div>
 4244:             </div>
 4245:           )}
 4246:         </div>
```

### Context for 'client-profile-preview' around line 4232
```jsx
 4224:           {filteredDirectoryClients.length === 0 && <p className="mandatory-note">No clients match the current search/filter.</p>}
 4225:
 4226:           {viewingClientProfile && (
 4227:             <div className="client-profile-preview-card" style={{ display: "none" }}>
 4228:               <div className="client-profile-preview-header">
 4229:                 <h3>View Client Profile</h3>
 4230:                 <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>Close View</button>
 4231:               </div>
 4232:               <div className="client-profile-preview-grid">
 4233:                 <span><strong>Client ID</strong><br />{getClientId(viewingClientProfile) || "Not assigned"}</span>
 4234:                 <span><strong>Name</strong><br />{[viewingClientProfile.titlePrefix, viewingClientProfile.givenName, viewingClientProfile.surname].filter(Boolean).join(" ") || viewingClientProfile.name || "Unnamed client"}</span>
 4235:                 <span><strong>Email</strong><br />{viewingClientProfile.email || "No email recorded"}</span>
 4236:                 <span><strong>Phone</strong><br />{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || "No phone recorded"}</span>
 4237:                 <span><strong>Town / City</strong><br />{viewingClientProfile.townCity || "Not recorded"}</span>
 4238:                 <span><strong>Status</strong><br />{viewingClientProfile.verificationStatus || viewingClientProfile.documentStatus || "To be reviewed"}</span>
 4239:               </div>
 4240:               <div className="client-directory-result-actions">
 4241:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>Edit / Amend</button>
 4242:                 <button type="button" className="btn btn-secondary btn-small" onClick={() => deleteClient(viewingClientProfile)}>Delete</button>
 4243:               </div>
 4244:             </div>
 4245:           )}
 4246:         </div>
 4247:       </div>
 4248:
 4249:       {/* L360_DASHBOARD_V3G2_VIEW_PROFILE_PANEL */}
 4250:       {viewingClientProfile && (
```

### Context for 'client-profile-form' around line 3648
```jsx
 3640:           ...normalizeClientTagList(client.clientTags || client.tags)
 3641:         ].filter(Boolean).join(" ").toLowerCase();
 3642:         return tagText.includes(manualTagQuery);
 3643:       })
 3644:       .sort((a, b) => getClientDirectoryName(a).localeCompare(getClientDirectoryName(b)));
 3645:   }, [filteredClients, activeAlphabetFilter, selectedClientTagFilter, manualClientTagSearch]);
 3646:
 3647:   return (
 3648:     <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
 3649:         /* L360_DASHBOARD_V3G2_FINAL_SEARCH_VIEW_CLEANUP */
 3650:         .client-contact-search-panel,
 3651:         .client-search-row {
 3652:           display: none !important;
 3653:         }
 3654:         .client-alphabet-filter.two-rows {
 3655:           display: grid;
 3656:           gap: 6px;
 3657:           justify-items: center;
 3658:         }
 3659:         .client-alphabet-filter.two-rows .alphabet-action-row {
 3660:           display: contents;
 3661:         }
 3662:         .client-alphabet-filter.two-rows .alphabet-row {
 3663:           display: flex;
 3664:           flex-wrap: wrap;
 3665:           justify-content: center;
 3666:           gap: 6px;
```

### Context for 'client-profile-form' around line 3726
```jsx
 3718:         .client-profile-view-grid strong,
 3719:         .client-profile-view-grid span {
 3720:           display: block;
 3721:         }
 3722:         .client-profile-view-grid .full {
 3723:           grid-column: 1 / -1;
 3724:         }
 3725:         /* L360_DASHBOARD_V3E_FINAL_CLEANUP */
 3726:         .client-profile-form-closed .client-form-v6,
 3727:         .client-profile-form-closed .client-validation-box {
 3728:           display: none !important;
 3729:         }
 3730:
 3731:         .client-directory-control-panel {
 3732:           display: flex !important;
 3733:           flex-direction: column !important;
 3734:           gap: 10px !important;
 3735:         }
 3736:
 3737:         .client-directory-summary-row {
 3738:           order: 2 !important;
 3739:         }
 3740:
 3741:         .client-directory-mini-list {
 3742:           order: 3 !important;
 3743:         }
 3744:
```

### Context for 'client-profile-form' around line 3727
```jsx
 3719:         .client-profile-view-grid span {
 3720:           display: block;
 3721:         }
 3722:         .client-profile-view-grid .full {
 3723:           grid-column: 1 / -1;
 3724:         }
 3725:         /* L360_DASHBOARD_V3E_FINAL_CLEANUP */
 3726:         .client-profile-form-closed .client-form-v6,
 3727:         .client-profile-form-closed .client-validation-box {
 3728:           display: none !important;
 3729:         }
 3730:
 3731:         .client-directory-control-panel {
 3732:           display: flex !important;
 3733:           flex-direction: column !important;
 3734:           gap: 10px !important;
 3735:         }
 3736:
 3737:         .client-directory-summary-row {
 3738:           order: 2 !important;
 3739:         }
 3740:
 3741:         .client-directory-mini-list {
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


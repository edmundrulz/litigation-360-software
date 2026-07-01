# Litigation 360 / LEOS 360
# Phase 14A Clients Navigation / Orientation Standardization Local Map

Date: 2026-06-30
Source:
frontend/src/pages/Clients.jsx

## 1. Purpose

This read-only map identifies exact Clients.jsx anchors before applying Clients-only navigation and orientation standardization.

No code changes are made by this map.

## 2. Landmark Search Results

### Pattern: client-module
- Line 1896: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 2033: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 3648: <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
- Line 3942: <div className="client-module-header">

### Pattern: client-module-header
- Line 1896: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 2033: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 3942: <div className="client-module-header">

### Pattern: Client Registration
- Line 3944: <h2>Client Registration / Full Client Profile</h2>

### Pattern: Full Client Profile
- Line 3944: <h2>Client Registration / Full Client Profile</h2>
- Line 3959: <h3>Full Client Profile Summary</h3>
- Line 4027: <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
- Line 5734: <h3 id="client-profile-review-heading">Review Full Client Profile Before Saving</h3>

### Pattern: Client Search
- Line 4191: <h3>Client Search / Contact Lookup</h3>
- Line 5807: Client Search

### Pattern: Duplicate Detection
- Not found

### Pattern: Stage 2
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

### Pattern: Client Gate
- Not found

### Pattern: Step 2
- Not found

### Pattern: Previous Page
- Not found

### Pattern: Home Main Page
- Not found

### Pattern: Continue to Next Step
- Not found

### Pattern: Go to Bottom
- Not found

### Pattern: End of Page
- Not found

### Pattern: Return to Stage 2 Matter Intake
- Line 3949: Use it for advanced profile management. This page is open in direct review mode. Use the fixed workflow navigation bars to continue the guided intake sequence, or return to Stage 2 Matter Intake when required.
- Line 3952: Return to Stage 2 Matter Intake

### Pattern: setModule
- Line 2229: export default function Clients({ setModule } = {}) {
- Line 3951: <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>

### Pattern: scrollIntoView
- Line 2330: document.querySelector(".client-form-v6")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 2365: document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3390: document.querySelector(".client-profile-view-card")?.scrollIntoView({

### Pattern: scrollTo
- Line 3415: window.scrollTo({ top: 0, behavior: "smooth" });

### Pattern: client-flow-bridge-panel
- Line 3945: <div className="client-flow-bridge-panel">

### Pattern: client-count-card
- Line 3987: <div className="client-count-card">

### Pattern: client-profile-completion-shell
- Line 1900: if (control.closest(".client-profile-completion-shell")) return false;
- Line 2037: if (control.closest(".client-profile-completion-shell")) return false;
- Line 3999: <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">

### Pattern: Client File Alert / Status
- Line 4002: <p className="client-profile-completion-kicker">Client File Alert / Status</p>

## 3. Context Windows

### Context for pattern client-module around line 1896
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern client-module around line 2033
TEXT_BLOCK_START
 2023:     { anchor: "client-contact-communication-preferences", label: "Contact / Communication" },
 2024:     { anchor: "client-address-service-location", label: "Address / Service Location" },
 2025:     { anchor: "client-emergency-next-of-kin", label: "Emergency / Next of Kin" },
 2026:     { anchor: "client-documentation-verification", label: "Documentation Verification" },
 2027:     { anchor: "client-internal-remarks-issues", label: "Remarks / Pending Info" },
 2028:   ];
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
 2056:       let complete = 0;
 2057:
TEXT_BLOCK_END

### Context for pattern client-module around line 3648
TEXT_BLOCK_START
 3638:           client.clientCategory,
 3639:           client.verificationStatus,
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
 3667:           width: 100%;
 3668:         }
 3669:         .client-alphabet-filter.two-rows button {
 3670:           flex: 0 0 auto;
 3671:           min-width: 42px;
 3672:           width: auto;
TEXT_BLOCK_END

### Context for pattern client-module around line 3942
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern client-module-header around line 1896
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern client-module-header around line 2033
TEXT_BLOCK_START
 2023:     { anchor: "client-contact-communication-preferences", label: "Contact / Communication" },
 2024:     { anchor: "client-address-service-location", label: "Address / Service Location" },
 2025:     { anchor: "client-emergency-next-of-kin", label: "Emergency / Next of Kin" },
 2026:     { anchor: "client-documentation-verification", label: "Documentation Verification" },
 2027:     { anchor: "client-internal-remarks-issues", label: "Remarks / Pending Info" },
 2028:   ];
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
 2056:       let complete = 0;
 2057:
TEXT_BLOCK_END

### Context for pattern client-module-header around line 3942
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern Client Registration around line 3944
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern Full Client Profile around line 3944
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern Full Client Profile around line 3959
TEXT_BLOCK_START
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
 3975:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3976:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3977:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3978:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3979:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3980:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3981:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3982:             </ol>
 3983:           </nav>
TEXT_BLOCK_END

### Context for pattern Full Client Profile around line 4027
TEXT_BLOCK_START
 4017:           <a href="#client-contact-communication-preferences">Contact</a>
 4018:           <a href="#client-address-service-location">Address</a>
 4019:           <a href="#client-documentation-verification">Documentation</a>
 4020:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4021:         </div>
 4022:       </section>
 4023: <div className="client-directory-control-panel">
 4024:         <div className="client-directory-header-row">
 4025:           <div>
 4026:             <h3>Advanced Client Directory / Manual Management</h3>
 4027:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4028:           </div>
 4029:           <div className="client-directory-actions">
 4030:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4031:               + Add/Create New Client Profile
 4032:             </button>
 4033:             {showClientProfileForm && (
 4034:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4035:                 Hide Client Profile Form
 4036:               </button>
 4037:             )}
 4038:           </div>
 4039:         </div>
 4040:
 4041:         <div className="inline-fields four-even">
 4042:           <label>
 4043:             Search By
 4044:             <select value={clientLookupSearchBy} onChange={(event) => setClientLookupSearchBy(event.target.value)}>
 4045:               {[
 4046:                 "All Fields",
 4047:                 "Client Name",
 4048:                 "Phone / WhatsApp",
 4049:                 "Email",
 4050:                 "NRIC / Passport",
 4051:                 "Date of Birth",
TEXT_BLOCK_END

### Context for pattern Full Client Profile around line 5734
TEXT_BLOCK_START
 5724:           {COUNTRY_CODE_OPTIONS.map((countryCode) => (
 5725:             <option key={countryCode} value={countryCode} />
 5726:           ))}
 5727:         </datalist>
 5728:
 5729:
 5730:         <section className="client-profile-review-panel" aria-labelledby="client-profile-review-heading">
 5731:           <div className="client-profile-review-header">
 5732:             <div>
 5733:               <p className="client-profile-review-kicker">Pre-Submission Review</p>
 5734:               <h3 id="client-profile-review-heading">Review Full Client Profile Before Saving</h3>
 5735:               <p>
 5736:                 Confirm the complete manual-management profile before creating or saving this client record.
 5737:                 This panel is informational only and does not replace the original validation, required fields,
 5738:                 backend checks, draft behaviour, or save controls.
 5739:               </p>
 5740:             </div>
 5741:             <span className="client-profile-review-status">Verify before saving</span>
 5742:           </div>
 5743:
 5744:           <div className="client-profile-review-grid">
 5745:             <article className="client-profile-review-card">
 5746:               <p className="client-profile-review-kicker">Identity</p>
 5747:               <h4>Client Identity Review</h4>
 5748:               <p>Confirm legal name, organisation details, client type, identification reference, and profile classification.</p>
 5749:               <a href="#client-profile-details" className="client-profile-review-link">Jump to Client Profile Details</a>
 5750:             </article>
 5751:
 5752:             <article className="client-profile-review-card">
 5753:               <p className="client-profile-review-kicker">Verification</p>
 5754:               <h4>Identification & Documentation</h4>
 5755:               <p>Check identification details, document status, pending document reasons, and verification notes.</p>
 5756:               <a href="#client-documentation-verification" className="client-profile-review-link">Jump to Documentation Verification</a>
 5757:             </article>
 5758:
TEXT_BLOCK_END

### Context for pattern Client Search around line 4191
TEXT_BLOCK_START
 4181:             <div><strong>Gender / Ethnicity</strong><span>{[viewingClientProfile.gender, viewingClientProfile.ethnicity].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4182:             <div><strong>Date / State of Birth</strong><span>{[viewingClientProfile.dateOfBirth, viewingClientProfile.stateOfBirth].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4183:             <div><strong>Document Status</strong><span>{[viewingClientProfile.documentType, viewingClientProfile.documentStatus, viewingClientProfile.verificationStatus].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4184:             <div className="full"><strong>Address</strong><span>{[viewingClientProfile.buildingHouseNo, viewingClientProfile.postcode, viewingClientProfile.district, viewingClientProfile.townCity, viewingClientProfile.stateProvinceTerritory || viewingClientProfile.state, viewingClientProfile.country].filter(Boolean).join(", ") || "No address recorded"}</span></div>
 4185:             <div className="full"><strong>Emergency Contact / Next of Kin</strong><span>{[viewingClientProfile.emergencyContactName, viewingClientProfile.emergencyContactRelationship, viewingClientProfile.emergencyContactNumber].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
 4186:             <div className="full"><strong>Remarks / Notes</strong><span>{viewingClientProfile.specialRemarksStaffLawyerNotes || viewingClientProfile.staffLawyerRemarks || viewingClientProfile.missingInformationNotes || "No remarks recorded"}</span></div>
 4187:           </div>
 4188:         </section>
 4189:       )}
 4190:       <div className="client-contact-search-panel">
 4191:         <h3>Client Search / Contact Lookup</h3>
 4192:         <p className="mandatory-note">
 4193:           Search by name, phone, WhatsApp, email, NRIC/passport, postcode, town, district, municipality, council, borough, state, or remarks before creating a duplicate profile.
 4194:         </p>
 4195:         <div className="inline-fields two-even">
 4196:           <input
 4197:             value={contactDatabaseSearch}
 4198:             onChange={(event) => setContactDatabaseSearch(event.target.value)}
 4199:             placeholder="Search local client contact database"
 4200:           />
 4201:           <input
 4202:             value={googleContactSearch}
 4203:             onChange={(event) => setGoogleContactSearch(event.target.value)}
 4204:             placeholder="Google Contacts search-ready field"
 4205:           />
 4206:         </div>
 4207:         <button type="button" className="btn btn-secondary" onClick={searchGoogleContacts}>Search Google Contacts Connector</button>
 4208:         {googleContactStatus && <small className="field-warning-message">{googleContactStatus}</small>}
 4209:         {contactDatabaseResults.length > 0 && (
 4210:           <div className="client-contact-result-list">
 4211:             {contactDatabaseResults.map((client) => (
 4212:               <div className="client-contact-result-card" key={getClientId(client) || client.email || client.phoneNumber}>
 4213:                 <span>
 4214:                   <strong>{[client.givenName, client.surname].filter(Boolean).join(" ") || client.name || "Unnamed client"}</strong><br />
 4215:                   <span className="client-contact-meta">
TEXT_BLOCK_END

### Context for pattern Client Search around line 5807
TEXT_BLOCK_START
 5797:           </button>
 5798:
 5799:           <button type="button" onClick={resetForm}>
 5800:             Clear Form
 5801:           </button>
 5802:         </div>
 5803:       </form>
 5804:
 5805:       <div className="client-search-row">
 5806:         <label>
 5807:           Client Search
 5808:           <input
 5809:             value={searchTerm}
 5810:             onChange={handleDirectorySearchChange}
 5811:             placeholder="Search name, title, NRIC/passport, document class, phone, email, status, remarks or verification flags"
 5812:           />
 5813:         </label>
 5814:       </div>
 5815:
 5816:       <div className="client-table-wrap">
 5817:         <table className="client-table">
 5818:           <thead>
 5819:             <tr>
 5820:               <th>Title</th>
 5821:               <th>Given Name</th>
 5822:               <th>Surname</th>
 5823:               <th>Gender</th>
 5824:               <th>Age Category</th>
 5825:               <th>Generation</th>
 5826:               <th>IC Colour / Class</th>
 5827:               <th>Employment</th>
 5828:               <th>Marital Status</th>
 5829:               <th>IC / Passport</th>
 5830:               <th>Email</th>
 5831:               <th>Primary Phone</th>
TEXT_BLOCK_END

### Context for pattern Stage 2 around line 3949
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern Stage 2 around line 3952
TEXT_BLOCK_START
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
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3971:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment Details</a></li>
 3972:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3973:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3974:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3975:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3976:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
TEXT_BLOCK_END

### Context for pattern Return to Stage 2 Matter Intake around line 3949
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern Return to Stage 2 Matter Intake around line 3952
TEXT_BLOCK_START
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
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3971:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment Details</a></li>
 3972:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3973:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3974:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3975:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3976:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
TEXT_BLOCK_END

### Context for pattern setModule around line 2229
TEXT_BLOCK_START
 2219:             <span className="client-section-completion-badge">{section.status}</span>
 2220:             <span className="client-section-completion-count">
 2221:               {section.required} required / {section.missing} missing
 2222:             </span>
 2223:           </a>
 2224:         ))}
 2225:       </div>
 2226:     </div>
 2227:   );
 2228: }
 2229: export default function Clients({ setModule } = {}) {
 2230:   const [clients, setClients] = useState([]);
 2231:   const [form, setForm] = useState(EMPTY_CLIENT);
 2232:   const [editingId, setEditingId] = useState("");
 2233:   const [searchTerm, setSearchTerm] = useState("");
 2234:   const [clientLookupSearchBy, setClientLookupSearchBy] = useState("All Fields");
 2235:   const [status, setStatus] = useState("");
 2236:   const [statusType, setStatusType] = useState("info");
 2237:   const [isSaving, setIsSaving] = useState(false);
 2238:   const [validationErrors, setValidationErrors] = useState([]);
 2239:   const [showExtendedContactChoices, setShowExtendedContactChoices] = useState(false);
 2240:   const [viewingClientProfile, setViewingClientProfile] = useState(null);
 2241:   const [showClientProfileForm, setShowClientProfileForm] = useState(false);
 2242:   const [activeAlphabetFilter, setActiveAlphabetFilter] = useState("All");
 2243:   const [clientSearchHistory, setClientSearchHistory] = useState([]);
 2244:   const [selectedClientTagFilter, setSelectedClientTagFilter] = useState("All");
 2245:   const [manualClientTagSearch, setManualClientTagSearch] = useState("");
 2246:   const [fieldErrors, setFieldErrors] = useState({});
 2247:   const CLIENT_ONBOARDING_DRAFT_KEY = "l360.clientOnboardingDraft.v1";
 2248:   const [draftSaveStatus, setDraftSaveStatus] = useState("Draft not saved yet.");
 2249:   const [lastDraftSavedAt, setLastDraftSavedAt] = useState("");
 2250:   const [hasRecoverableDraft, setHasRecoverableDraft] = useState(false);
 2251:   const [numericWarnings, setNumericWarnings] = useState({});
 2252:   const [contactChoiceNotice, setContactChoiceNotice] = useState("");
 2253:   const [contactDatabaseSearch, setContactDatabaseSearch] = useState("");
TEXT_BLOCK_END

### Context for pattern setModule around line 3951
TEXT_BLOCK_START
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
 3968:             <ol className="client-profile-summary-list">
 3969:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Profile Details</a></li>
 3970:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3971:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment Details</a></li>
 3972:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3973:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3974:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3975:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
TEXT_BLOCK_END

### Context for pattern scrollIntoView around line 2330
TEXT_BLOCK_START
 2320:   }
 2321:
 2322:   function showStatus(message, type = "info") {
 2323:     setStatus(message);
 2324:     setStatusType(type);
 2325:   }
 2326:   function openNewClientProfile() {
 2327:     resetForm();
 2328:     setShowClientProfileForm(true);
 2329:     window.setTimeout(() => {
 2330:       document.querySelector(".client-form-v6")?.scrollIntoView({ behavior: "smooth", block: "start" });
 2331:     }, 50);
 2332:   }
 2333:
 2334:   function closeClientProfileForm() {
 2335:     setShowClientProfileForm(false);
 2336:     setEditingId("");
 2337:     setValidationErrors([]);
 2338:   }
 2339:
 2340:   function handleDirectorySearchChange(event) {
 2341:     const value = event.target.value;
 2342:     setSearchTerm(value);
 2343:
 2344:     const trimmed = value.trim();
 2345:     if (trimmed.length >= 2) {
 2346:       setClientSearchHistory((previous) => [trimmed, ...previous.filter((item) => item !== trimmed)].slice(0, 8));
 2347:     }
 2348:   }
 2349:
 2350:   function selectClientFromDirectory(client) {
 2351:     const normalized = normalizeClient(client);
 2352:     const directoryName = getClientDirectoryName(normalized);
 2353:     const initial = getClientDirectoryInitial(normalized);
 2354:
TEXT_BLOCK_END

### Context for pattern scrollIntoView around line 2365
TEXT_BLOCK_START
 2355:     setSearchTerm(directoryName);
 2356:     setClientLookupSearchBy("Client Name");
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
 2384:     }
 2385:
 2386:     if (clientLookupSearchBy && clientLookupSearchBy !== "All Fields") {
 2387:       filters.push("Search By: " + clientLookupSearchBy);
 2388:     }
 2389:
TEXT_BLOCK_END

### Context for pattern scrollIntoView around line 3390
TEXT_BLOCK_START
 3380:       );
 3381:     } finally {
 3382:       setIsSaving(false);
 3383:     }
 3384:   }
 3385:
 3386:   function viewClientProfile(client) {
 3387:     const normalized = normalizeClient(client);
 3388:     setViewingClientProfile(normalized);
 3389:     window.setTimeout(() => {
 3390:       document.querySelector(".client-profile-view-card")?.scrollIntoView({
 3391:         behavior: "smooth",
 3392:         block: "start"
 3393:       });
 3394:     }, 50);
 3395:   }
 3396:
 3397:   function closeClientProfileView() {
 3398:     setViewingClientProfile(null);
 3399:   }
 3400:   function editClient(client) {
 3401:     /* L360_DASHBOARD_V3C_EDIT_REVEAL */
 3402:     setShowClientProfileForm(true);
 3403:     const normalized = normalizeClient(client);
 3404:
 3405:     setEditingId(getClientId(normalized));
 3406:     setForm({
 3407:       ...EMPTY_CLIENT,
 3408:       ...normalized,
 3409:       genderSource: normalized.gender ? "manual" : "auto"
 3410:     });
 3411:     setValidationErrors([]);
 3412:     setFieldErrors({});
 3413:     setNumericWarnings({});
 3414:     showStatus("Editing selected client. Modify the profile and click Save Modified Client.", "info");
TEXT_BLOCK_END

### Context for pattern scrollTo around line 3415
TEXT_BLOCK_START
 3405:     setEditingId(getClientId(normalized));
 3406:     setForm({
 3407:       ...EMPTY_CLIENT,
 3408:       ...normalized,
 3409:       genderSource: normalized.gender ? "manual" : "auto"
 3410:     });
 3411:     setValidationErrors([]);
 3412:     setFieldErrors({});
 3413:     setNumericWarnings({});
 3414:     showStatus("Editing selected client. Modify the profile and click Save Modified Client.", "info");
 3415:     window.scrollTo({ top: 0, behavior: "smooth" });
 3416:   }
 3417:
 3418:   async function deleteClient(client) {
 3419:     const normalized = normalizeClient(client);
 3420:     const id = getClientId(normalized);
 3421:
 3422:     if (!id) {
 3423:       showStatus("Cannot delete client because the record has no id.", "error");
 3424:       return;
 3425:     }
 3426:
 3427:     const confirmed = window.confirm("Delete this client record?");
 3428:
 3429:     if (!confirmed) {
 3430:       return;
 3431:     }
 3432:
 3433:     const nextClients = clients.filter((item) => getClientId(item) !== id);
 3434:     setClients(nextClients);
 3435:     writeLocalClients(nextClients);
 3436:
 3437:     try {
 3438:       const response = await fetch(API_URL + "/" + id, {
 3439:         method: "DELETE"
TEXT_BLOCK_END

### Context for pattern client-flow-bridge-panel around line 3945
TEXT_BLOCK_START
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
TEXT_BLOCK_END

### Context for pattern client-count-card around line 3987
TEXT_BLOCK_START
 3977:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3978:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3979:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3980:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3981:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3982:             </ol>
 3983:           </nav>
 3984: </aside>
 3985:         </div>
 3986:
 3987:         <div className="client-count-card">
 3988:           <strong>All Clients ({clients.length})</strong>
 3989:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3990:         </div>
 3991:       </div>
 3992:
 3993:       {status && (
 3994:         <p className={"client-status client-status-" + statusType}>
 3995:           {status}
 3996:         </p>
 3997:       )}
 3998:
 3999:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4000:         <div className="client-profile-completion-header">
 4001:           <div>
 4002:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4003:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4004:             <p>
 4005:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
 4006:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4007:             </p>
 4008:           </div>
 4009:         </div>
 4010:
 4011:         <ClientRequiredFieldCounter />
TEXT_BLOCK_END

### Context for pattern client-profile-completion-shell around line 1900
TEXT_BLOCK_START
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
 1921:           return groupControls.some((candidate) => candidate.checked);
 1922:         }
 1923:
 1924:         return control.checked;
TEXT_BLOCK_END

### Context for pattern client-profile-completion-shell around line 2037
TEXT_BLOCK_START
 2027:     { anchor: "client-internal-remarks-issues", label: "Remarks / Pending Info" },
 2028:   ];
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
 2056:       let complete = 0;
 2057:
 2058:       controls.forEach((control) => {
 2059:         const type = (control.getAttribute("type") || "").toLowerCase();
 2060:
 2061:         if (type === "checkbox" || type === "radio") {
TEXT_BLOCK_END

### Context for pattern client-profile-completion-shell around line 3999
TEXT_BLOCK_START
 3989:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3990:         </div>
 3991:       </div>
 3992:
 3993:       {status && (
 3994:         <p className={"client-status client-status-" + statusType}>
 3995:           {status}
 3996:         </p>
 3997:       )}
 3998:
 3999:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4000:         <div className="client-profile-completion-header">
 4001:           <div>
 4002:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4003:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4004:             <p>
 4005:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
 4006:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4007:             </p>
 4008:           </div>
 4009:         </div>
 4010:
 4011:         <ClientRequiredFieldCounter />
 4012:
 4013:         <ClientSectionCompletionStatus />
 4014:
 4015:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4016:           <a href="#client-profile-details">Identity</a>
 4017:           <a href="#client-contact-communication-preferences">Contact</a>
 4018:           <a href="#client-address-service-location">Address</a>
 4019:           <a href="#client-documentation-verification">Documentation</a>
 4020:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4021:         </div>
 4022:       </section>
 4023: <div className="client-directory-control-panel">
TEXT_BLOCK_END

### Context for pattern Client File Alert / Status around line 4002
TEXT_BLOCK_START
 3992:
 3993:       {status && (
 3994:         <p className={"client-status client-status-" + statusType}>
 3995:           {status}
 3996:         </p>
 3997:       )}
 3998:
 3999:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4000:         <div className="client-profile-completion-header">
 4001:           <div>
 4002:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4003:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4004:             <p>
 4005:               Static readiness shell. Existing Clients validation, required fields, backend checks, local fallback,
 4006:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4007:             </p>
 4008:           </div>
 4009:         </div>
 4010:
 4011:         <ClientRequiredFieldCounter />
 4012:
 4013:         <ClientSectionCompletionStatus />
 4014:
 4015:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4016:           <a href="#client-profile-details">Identity</a>
 4017:           <a href="#client-contact-communication-preferences">Contact</a>
 4018:           <a href="#client-address-service-location">Address</a>
 4019:           <a href="#client-documentation-verification">Documentation</a>
 4020:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4021:         </div>
 4022:       </section>
 4023: <div className="client-directory-control-panel">
 4024:         <div className="client-directory-header-row">
 4025:           <div>
 4026:             <h3>Advanced Client Directory / Manual Management</h3>
TEXT_BLOCK_END


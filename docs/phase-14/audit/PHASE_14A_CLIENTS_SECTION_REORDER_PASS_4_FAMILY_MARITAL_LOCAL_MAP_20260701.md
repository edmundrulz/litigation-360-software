# Litigation 360 / LEOS 360
# Phase 14A Clients Section Reorder Pass 4 Family / Marital Local Map

Date: 2026-07-01
Source:
frontend/src/pages/Clients.jsx

## 1. Purpose

This read-only map identifies exact Clients.jsx anchors before applying Pass 4 Family / Marital / Dependents alignment.

No code changes are made by this map.

## 2. Landmark Search Results

### Pattern: client-family-marital-details
- Line 2018: { anchor: "client-family-marital-details", label: "Family / Marital" },
- Line 3978: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
- Line 4479: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>

### Pattern: Family and Marital Details
- Line 3978: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
- Line 4479: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>

### Pattern: Family / Marital
- Line 1529: ["Family / Marital", form.maritalStatus],
- Line 2018: { anchor: "client-family-marital-details", label: "Family / Marital" },

### Pattern: Family
- Line 615: "Family Holiday",
- Line 1529: ["Family / Marital", form.maritalStatus],
- Line 2018: { anchor: "client-family-marital-details", label: "Family / Marital" },
- Line 3978: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
- Line 4479: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
- Line 4480: <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
- Line 4484: Marital / Family Status

### Pattern: Marital
- Line 87: maritalStatus: "To be confirmed",
- Line 547: const MARITAL_STATUS_OPTIONS = [
- Line 1318: maritalStatus: source.maritalStatus || "To be confirmed",
- Line 1529: ["Family / Marital", form.maritalStatus],
- Line 2018: { anchor: "client-family-marital-details", label: "Family / Marital" },
- Line 3484: normalized.maritalStatus,
- Line 3978: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
- Line 4479: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
- Line 4480: <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
- Line 4484: Marital / Family Status
- Line 4485: <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
- Line 4486: {MARITAL_STATUS_OPTIONS.map((option) => (
- Line 5834: <th>Marital Status</th>
- Line 5892: <td>{normalized.maritalStatus || "-"}</td>

### Pattern: maritalStatus
- Line 87: maritalStatus: "To be confirmed",
- Line 1318: maritalStatus: source.maritalStatus || "To be confirmed",
- Line 1529: ["Family / Marital", form.maritalStatus],
- Line 3484: normalized.maritalStatus,
- Line 4485: <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
- Line 5892: <td>{normalized.maritalStatus || "-"}</td>

### Pattern: MARITAL_STATUS_OPTIONS
- Line 547: const MARITAL_STATUS_OPTIONS = [
- Line 4486: {MARITAL_STATUS_OPTIONS.map((option) => (

### Pattern: hasDependents
- Line 88: hasDependents: false,
- Line 1319: hasDependents: Boolean(source.hasDependents),
- Line 2825: if (field === "hasDependents") {
- Line 2827: next.hasDependents = checked;
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 4495: checked={Boolean(form.hasDependents)}
- Line 4496: onChange={(event) => updateForm("hasDependents", event.target.checked)}
- Line 4501: {form.hasDependents && (

### Pattern: dependentsCount
- Line 89: dependentsCount: "",
- Line 1320: dependentsCount: source.dependentsCount || "",
- Line 2829: next.dependentsCount = "";
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 3194: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
- Line 4508: value={form.dependentsCount}
- Line 4509: onChange={(event) => updateForm("dependentsCount", event.target.value)}

### Pattern: dependentNotes
- Line 90: dependentNotes: "",
- Line 1321: dependentNotes: source.dependentNotes || "",
- Line 2830: next.dependentNotes = "";
- Line 4517: value={form.dependentNotes}
- Line 4518: onChange={(event) => updateForm("dependentNotes", event.target.value)}

### Pattern: dependents
- Line 88: hasDependents: false,
- Line 89: dependentsCount: "",
- Line 1319: hasDependents: Boolean(source.hasDependents),
- Line 1320: dependentsCount: source.dependentsCount || "",
- Line 2825: if (field === "hasDependents") {
- Line 2827: next.hasDependents = checked;
- Line 2829: next.dependentsCount = "";
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 3191: errors.push("Number of Dependents is required when Has Dependents is selected.");
- Line 3194: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
- Line 3195: errors.push("Number of Dependents cannot be negative.");
- Line 4495: checked={Boolean(form.hasDependents)}
- Line 4496: onChange={(event) => updateForm("hasDependents", event.target.checked)}
- Line 4498: Has Dependents?
- Line 4501: {form.hasDependents && (
- Line 4504: Number of Dependents
- Line 4508: value={form.dependentsCount}
- Line 4509: onChange={(event) => updateForm("dependentsCount", event.target.value)}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: Dependents
- Line 88: hasDependents: false,
- Line 89: dependentsCount: "",
- Line 1319: hasDependents: Boolean(source.hasDependents),
- Line 1320: dependentsCount: source.dependentsCount || "",
- Line 2825: if (field === "hasDependents") {
- Line 2827: next.hasDependents = checked;
- Line 2829: next.dependentsCount = "";
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 3191: errors.push("Number of Dependents is required when Has Dependents is selected.");
- Line 3194: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
- Line 3195: errors.push("Number of Dependents cannot be negative.");
- Line 4495: checked={Boolean(form.hasDependents)}
- Line 4496: onChange={(event) => updateForm("hasDependents", event.target.checked)}
- Line 4498: Has Dependents?
- Line 4501: {form.hasDependents && (
- Line 4504: Number of Dependents
- Line 4508: value={form.dependentsCount}
- Line 4509: onChange={(event) => updateForm("dependentsCount", event.target.value)}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: dependent
- Line 88: hasDependents: false,
- Line 89: dependentsCount: "",
- Line 90: dependentNotes: "",
- Line 508: "Dependent Pass",
- Line 524: "Dependent Pass",
- Line 689: "Dependent Pass",
- Line 1319: hasDependents: Boolean(source.hasDependents),
- Line 1320: dependentsCount: source.dependentsCount || "",
- Line 1321: dependentNotes: source.dependentNotes || "",
- Line 2825: if (field === "hasDependents") {
- Line 2827: next.hasDependents = checked;
- Line 2829: next.dependentsCount = "";
- Line 2830: next.dependentNotes = "";
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 3191: errors.push("Number of Dependents is required when Has Dependents is selected.");
- Line 3194: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
- Line 3195: errors.push("Number of Dependents cannot be negative.");
- Line 4495: checked={Boolean(form.hasDependents)}
- Line 4496: onChange={(event) => updateForm("hasDependents", event.target.checked)}
- Line 4498: Has Dependents?
- Line 4501: {form.hasDependents && (
- Line 4504: Number of Dependents
- Line 4508: value={form.dependentsCount}
- Line 4509: onChange={(event) => updateForm("dependentsCount", event.target.value)}
- Line 4515: Dependent Notes
- Line 4517: value={form.dependentNotes}
- Line 4518: onChange={(event) => updateForm("dependentNotes", event.target.value)}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: Dependent
- Line 88: hasDependents: false,
- Line 89: dependentsCount: "",
- Line 90: dependentNotes: "",
- Line 508: "Dependent Pass",
- Line 524: "Dependent Pass",
- Line 689: "Dependent Pass",
- Line 1319: hasDependents: Boolean(source.hasDependents),
- Line 1320: dependentsCount: source.dependentsCount || "",
- Line 1321: dependentNotes: source.dependentNotes || "",
- Line 2825: if (field === "hasDependents") {
- Line 2827: next.hasDependents = checked;
- Line 2829: next.dependentsCount = "";
- Line 2830: next.dependentNotes = "";
- Line 3190: if (payload.hasDependents && isBlank(payload.dependentsCount)) {
- Line 3191: errors.push("Number of Dependents is required when Has Dependents is selected.");
- Line 3194: if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
- Line 3195: errors.push("Number of Dependents cannot be negative.");
- Line 4495: checked={Boolean(form.hasDependents)}
- Line 4496: onChange={(event) => updateForm("hasDependents", event.target.checked)}
- Line 4498: Has Dependents?
- Line 4501: {form.hasDependents && (
- Line 4504: Number of Dependents
- Line 4508: value={form.dependentsCount}
- Line 4509: onChange={(event) => updateForm("dependentsCount", event.target.value)}
- Line 4515: Dependent Notes
- Line 4517: value={form.dependentNotes}
- Line 4518: onChange={(event) => updateForm("dependentNotes", event.target.value)}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: spouse
- Line 740: "Spouse",

### Pattern: Spouse
- Line 740: "Spouse",

### Pattern: husband
- Line 739: "Husband",

### Pattern: Husband
- Line 739: "Husband",

### Pattern: wife
- Line 738: "Wife",

### Pattern: Wife
- Line 738: "Wife",

### Pattern: child
- Line 1675: function FieldLabel({ children, required = false }) {
- Line 1678: {children}
- Line 1969: childList: true,
- Line 2172: childList: true,
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: Child
- Line 1675: function FieldLabel({ children, required = false }) {
- Line 1678: {children}
- Line 1969: childList: true,
- Line 2172: childList: true,
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: children
- Line 1675: function FieldLabel({ children, required = false }) {
- Line 1678: {children}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: Children
- Line 1675: function FieldLabel({ children, required = false }) {
- Line 1678: {children}
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: guardian
- Line 748: "Guardian",

### Pattern: Guardian
- Line 748: "Guardian",

### Pattern: parent
- Line 747: "Parent",
- Line 1896: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 1903: return Boolean(control.offsetParent || control.getClientRects().length);
- Line 2033: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 2040: return Boolean(control.offsetParent || control.getClientRects().length);
- Line 2126: anchorElement.parentElement ||
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: Parent
- Line 747: "Parent",
- Line 1896: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 1903: return Boolean(control.offsetParent || control.getClientRects().length);
- Line 2033: const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;
- Line 2040: return Boolean(control.offsetParent || control.getClientRects().length);
- Line 2126: anchorElement.parentElement ||
- Line 4519: placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."

### Pattern: custody
- Not found

### Pattern: Custody
- Not found

### Pattern: divorce
- Line 551: "Divorced",

### Pattern: Divorce
- Line 551: "Divorced",

### Pattern: marriage
- Line 555: "Customary / Traditional Marriage",

### Pattern: Marriage
- Line 555: "Customary / Traditional Marriage",

### Pattern: client-profile-summary-link
- Line 3975: <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
- Line 3976: <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
- Line 3977: <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
- Line 3978: <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
- Line 3979: <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
- Line 3980: <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
- Line 3981: <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
- Line 3982: <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
- Line 3983: <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
- Line 3984: <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
- Line 3985: <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
- Line 3986: <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
- Line 3987: <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>

### Pattern: client-form-v6
- Line 2330: document.querySelector(".client-form-v6")?.scrollIntoView({ behavior: "smooth", block: "start" });
- Line 3726: .client-profile-form-closed .client-form-v6,
- Line 3785: .client-form-v6 label.full > button.btn-small {
- Line 4249: <form className={"client-form client-form-v6" + (validationErrors.length > 0 ? " client-form-has-errors" : "")} onSubmit={saveClient} style={{ display: showClientProfileForm ? undefined : "none" }}>

### Pattern: client-profile-card-title
- Line 4284: <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
- Line 4358: <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
- Line 4464: <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
- Line 4479: <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
- Line 4528: <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
- Line 4622: <h3 id="client-will-estate-metadata"><span className="client-profile-card-kicker">Section 7</span><span className="client-profile-card-title">Will / Estate Handling Metadata</span><span className="client-profile-card-status">Specialist metadata</span></h3>
- Line 4685: <h3 id="client-health-oku-accommodation"><span className="client-profile-card-kicker">Section 8</span><span className="client-profile-card-title">Health / OKU / Disability and Accommodation Metadata</span><span className="client-profile-card-status">Accommodation</span></h3>
- Line 5019: <h3 id="client-address-service-location"><span className="client-profile-card-kicker">Section 10</span><span className="client-profile-card-title">Address and Service Location Details</span><span className="client-profile-card-status">Location</span></h3>
- Line 5574: <h3 id="client-emergency-next-of-kin"><span className="client-profile-card-kicker">Section 11</span><span className="client-profile-card-title">Emergency Contact / Next of Kin Details</span><span className="client-profile-card-status">Secondary contact</span></h3>
- Line 5624: <h3 id="client-documentation-verification"><span className="client-profile-card-kicker">Section 12</span><span className="client-profile-card-title">Documentation Verification Status</span><span className="client-profile-card-status">Compliance</span></h3>

### Pattern: client-profile-card-help
- Line 4285: <p className="client-profile-card-help">Core legal identity, name authority, title/gender authority, and profile classification information. Existing fields, validation, and handlers remain preserved.</p>
- Line 4359: <p className="client-profile-card-help">Identification, document status, date of birth, and verification-related details. Existing validation remains preserved.</p>
- Line 4465: <p className="client-profile-card-help">Employment and organisation-related status details. Existing employmentStatus field, options, rules, validation, and handlers remain preserved.</p>
- Line 4480: <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
- Line 4529: <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
- Line 4623: <p className="client-profile-card-help">Will, estate, probate, and inheritance handling metadata. Existing conditional handling remains preserved.</p>
- Line 4686: <p className="client-profile-card-help">Accommodation, accessibility, and communication support information. Existing requirements remain preserved.</p>
- Line 5020: <p className="client-profile-card-help">Address, correspondence, service location, and administrative-area details. Existing synchronization rules remain preserved.</p>
- Line 5575: <p className="client-profile-card-help">Emergency and next-of-kin information. Existing fields and handlers remain preserved.</p>
- Line 5625: <p className="client-profile-card-help">Document verification, status, pending reasons, retention notes, and review fields. Existing compliance process remains preserved.</p>

### Pattern: ClientRequiredFieldCounter
- Line 1888: function ClientRequiredFieldCounter() {
- Line 4017: <ClientRequiredFieldCounter />

### Pattern: ClientSectionCompletionStatus
- Line 2013: function ClientSectionCompletionStatus() {
- Line 4019: <ClientSectionCompletionStatus />

### Pattern: Save Modified Client
- Line 3414: showStatus("Editing selected client. Modify the profile and click Save Modified Client.", "info");
- Line 5802: {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Create New Client Profile"}

### Pattern: Create New Client Profile
- Line 4037: + Add/Create New Client Profile
- Line 5802: {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Create New Client Profile"}

## 3. Context Windows

### Context for pattern client-family-marital-details around line 2018
TEXT_BLOCK_START
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Identity & Authority" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment & Organisation" },
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
TEXT_BLOCK_END

### Context for pattern client-family-marital-details around line 3978
TEXT_BLOCK_START
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
TEXT_BLOCK_END

### Context for pattern client-family-marital-details around line 4479
TEXT_BLOCK_START
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
TEXT_BLOCK_END

### Context for pattern Family and Marital Details around line 3978
TEXT_BLOCK_START
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
TEXT_BLOCK_END

### Context for pattern Family and Marital Details around line 4479
TEXT_BLOCK_START
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
TEXT_BLOCK_END

### Context for pattern Family / Marital around line 1529
TEXT_BLOCK_START
 1519:     ["Given Name", form.givenName],
 1520:     ["Surname", form.surname],
 1521:     ["Gender", form.gender],
 1522:     ["Date of Birth / Age", form.dateOfBirth || form.ageCategory],
 1523:     ["ID / Passport", form.nricPassportNumber],
 1524:     ["Primary Phone", form.phoneNumber],
 1525:     ["Primary Contact Choice", form.preferredContact1],
 1526:     ["Address", form.streetAddress || form.townCity || form.country],
 1527:     ["Emergency Contact", form.emergencyContactName || form.emergencyContactNumber],
 1528:     ["Documentation", form.documentationVerificationCompleted || form.documentType || form.documentStatus],
 1529:     ["Family / Marital", form.maritalStatus],
 1530:     ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
 1531:     ["Client Tenure / Value", form.clientSince || form.clientValueTier],
 1532:     ["Health / Accommodation", form.healthDisabilityStatus || form.accommodationRequired],
 1533:     ["Will / Estate", form.willStatus]
 1534:   ];
 1535:
 1536:   const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;
 1537:   const total = checks.length;
 1538:   const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);
 1539:   const missing = checks.filter(([, value]) => !isCompletionValuePresent(value)).map(([label]) => label);
 1540:
 1541:   return {
 1542:     completed,
 1543:     total,
 1544:     percentage,
 1545:     missing
 1546:   };
 1547: }
 1548:
 1549: function buildAuditTrail(form, existingClient, now) {
 1550:   const existing = existingClient ? normalizeClient(existingClient) : null;
 1551:   const auditTrail = existing ? normalizeAuditTrail(existing.auditTrail) : [];
 1552:
 1553:   if (!existing) {
 1554:     return auditTrail;
 1555:   }
 1556:
 1557:   const watchedFields = [
TEXT_BLOCK_END

### Context for pattern Family / Marital around line 2018
TEXT_BLOCK_START
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Identity & Authority" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment & Organisation" },
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
TEXT_BLOCK_END

### Context for pattern Family around line 615
TEXT_BLOCK_START
  605:   "Emirate",
  606:   "Not Applicable / N/A",
  607:   "Unknown",
  608:   "To be confirmed",
  609:   "Other / Manual"
  610: ];
  611:
  612: const AVAILABILITY_REASON_OPTIONS = [
  613:   "Not Applicable / N/A",
  614:   "Funeral",
  615:   "Family Holiday",
  616:   "Personal",
  617:   "Business",
  618:   "Medical",
  619:   "Court / Legal Appointment",
  620:   "Overseas Travel",
  621:   "Other",
  622:   "Unknown",
  623:   "To be confirmed"
  624: ];
  625:
  626: const ADDRESS_TYPE_OPTIONS = [
  627:   "Not Applicable / N/A",
  628:   "Residential",
  629:   "Commercial",
  630:   "Registered Office",
  631:   "Correspondence",
  632:   "International",
  633:   "Temporary",
  634:   "Other",
  635:   "Unknown",
  636:   "To be confirmed"
  637: ];
  638:
  639: const WILL_STATUS_OPTIONS = ["Unknown", "No", "Yes"];
  640:
  641: const WILL_AUTHORIZED_PARTY_OPTIONS = [
  642:   "Lawyer",
  643:   "Client",
TEXT_BLOCK_END

### Context for pattern Family around line 1529
TEXT_BLOCK_START
 1519:     ["Given Name", form.givenName],
 1520:     ["Surname", form.surname],
 1521:     ["Gender", form.gender],
 1522:     ["Date of Birth / Age", form.dateOfBirth || form.ageCategory],
 1523:     ["ID / Passport", form.nricPassportNumber],
 1524:     ["Primary Phone", form.phoneNumber],
 1525:     ["Primary Contact Choice", form.preferredContact1],
 1526:     ["Address", form.streetAddress || form.townCity || form.country],
 1527:     ["Emergency Contact", form.emergencyContactName || form.emergencyContactNumber],
 1528:     ["Documentation", form.documentationVerificationCompleted || form.documentType || form.documentStatus],
 1529:     ["Family / Marital", form.maritalStatus],
 1530:     ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
 1531:     ["Client Tenure / Value", form.clientSince || form.clientValueTier],
 1532:     ["Health / Accommodation", form.healthDisabilityStatus || form.accommodationRequired],
 1533:     ["Will / Estate", form.willStatus]
 1534:   ];
 1535:
 1536:   const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;
 1537:   const total = checks.length;
 1538:   const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);
 1539:   const missing = checks.filter(([, value]) => !isCompletionValuePresent(value)).map(([label]) => label);
 1540:
 1541:   return {
 1542:     completed,
 1543:     total,
 1544:     percentage,
 1545:     missing
 1546:   };
 1547: }
 1548:
 1549: function buildAuditTrail(form, existingClient, now) {
 1550:   const existing = existingClient ? normalizeClient(existingClient) : null;
 1551:   const auditTrail = existing ? normalizeAuditTrail(existing.auditTrail) : [];
 1552:
 1553:   if (!existing) {
 1554:     return auditTrail;
 1555:   }
 1556:
 1557:   const watchedFields = [
TEXT_BLOCK_END

### Context for pattern Family around line 2018
TEXT_BLOCK_START
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Identity & Authority" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment & Organisation" },
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
TEXT_BLOCK_END

### Context for pattern Family around line 3978
TEXT_BLOCK_START
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
TEXT_BLOCK_END

### Context for pattern Family around line 4479
TEXT_BLOCK_START
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
TEXT_BLOCK_END

### Context for pattern Family around line 4480
TEXT_BLOCK_START
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
TEXT_BLOCK_END

### Context for pattern Family around line 4484
TEXT_BLOCK_START
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
TEXT_BLOCK_END

### Context for pattern Marital around line 87
TEXT_BLOCK_START
   77:
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
TEXT_BLOCK_END

### Context for pattern Marital around line 547
TEXT_BLOCK_START
  537:   "Homemaker",
  538:   "Business Owner",
  539:   "Company Director",
  540:   "Contract Worker",
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
TEXT_BLOCK_END

### Context for pattern Marital around line 1318
TEXT_BLOCK_START
 1308:
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
TEXT_BLOCK_END

### Context for pattern Marital around line 1529
TEXT_BLOCK_START
 1519:     ["Given Name", form.givenName],
 1520:     ["Surname", form.surname],
 1521:     ["Gender", form.gender],
 1522:     ["Date of Birth / Age", form.dateOfBirth || form.ageCategory],
 1523:     ["ID / Passport", form.nricPassportNumber],
 1524:     ["Primary Phone", form.phoneNumber],
 1525:     ["Primary Contact Choice", form.preferredContact1],
 1526:     ["Address", form.streetAddress || form.townCity || form.country],
 1527:     ["Emergency Contact", form.emergencyContactName || form.emergencyContactNumber],
 1528:     ["Documentation", form.documentationVerificationCompleted || form.documentType || form.documentStatus],
 1529:     ["Family / Marital", form.maritalStatus],
 1530:     ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
 1531:     ["Client Tenure / Value", form.clientSince || form.clientValueTier],
 1532:     ["Health / Accommodation", form.healthDisabilityStatus || form.accommodationRequired],
 1533:     ["Will / Estate", form.willStatus]
 1534:   ];
 1535:
 1536:   const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;
 1537:   const total = checks.length;
 1538:   const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);
 1539:   const missing = checks.filter(([, value]) => !isCompletionValuePresent(value)).map(([label]) => label);
 1540:
 1541:   return {
 1542:     completed,
 1543:     total,
 1544:     percentage,
 1545:     missing
 1546:   };
 1547: }
 1548:
 1549: function buildAuditTrail(form, existingClient, now) {
 1550:   const existing = existingClient ? normalizeClient(existingClient) : null;
 1551:   const auditTrail = existing ? normalizeAuditTrail(existing.auditTrail) : [];
 1552:
 1553:   if (!existing) {
 1554:     return auditTrail;
 1555:   }
 1556:
 1557:   const watchedFields = [
TEXT_BLOCK_END

### Context for pattern Marital around line 2018
TEXT_BLOCK_START
 2008:       </div>
 2009:     </div>
 2010:   );
 2011: }
 2012:
 2013: function ClientSectionCompletionStatus() {
 2014:   const sectionDefinitions = [
 2015:     { anchor: "client-profile-details", label: "Identity & Authority" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment & Organisation" },
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
TEXT_BLOCK_END

### Context for pattern Marital around line 3484
TEXT_BLOCK_START
 3474:         normalized.titleSuffix,
 3475:         normalized.initials,
 3476:         normalized.gender,
 3477:         normalized.givenName,
 3478:         normalized.surname,
 3479:         normalized.name,
 3480:         normalized.ageCategory,
 3481:         normalized.generation,
 3482:         normalized.stateOfBirth,
 3483:         normalized.employmentStatus,
 3484:         normalized.maritalStatus,
 3485:         normalized.ethnicity,
 3486:         normalized.nationality,
 3487:         normalized.residencyStatus,
 3488:         normalized.identificationKind,
 3489:         normalized.identityCardColour,
 3490:         normalized.nricPassportNumber,
 3491:         normalized.email,
 3492:         normalized.phoneCountryCode,
 3493:         normalized.phoneNumber,
 3494:         normalized.backupPhoneCountryCode,
 3495:         normalized.backupPhoneNumber,
 3496:         normalized.whatsappCountryCode,
 3497:         normalized.whatsappNumber,
 3498:         normalized.preferredContact1,
 3499:         normalized.preferredContact2,
 3500:         normalized.preferredContact3,
 3501:         normalized.preferredContact4,
 3502:         normalized.preferredContact5,
 3503:         normalized.preferredContactDetail1,
 3504:         normalized.preferredContactDetail2,
 3505:         normalized.preferredContactDetail3,
 3506:         normalized.preferredContactDetail4,
 3507:         normalized.preferredContactDetail5,
 3508:         normalized.emergencyContactName,
 3509:         normalized.emergencyContactRelationship,
 3510:         normalized.emergencyContactNumber,
 3511:         normalized.addressType,
 3512:         normalized.country,
TEXT_BLOCK_END

### Context for pattern Marital around line 3978
TEXT_BLOCK_START
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
TEXT_BLOCK_END

### Context for pattern Marital around line 4479
TEXT_BLOCK_START
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
TEXT_BLOCK_END

### Context for pattern Marital around line 4480
TEXT_BLOCK_START
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
TEXT_BLOCK_END

### Context for pattern Marital around line 4484
TEXT_BLOCK_START
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
TEXT_BLOCK_END

### Context for pattern Marital around line 4485
TEXT_BLOCK_START
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
TEXT_BLOCK_END

### Context for pattern Marital around line 4486
TEXT_BLOCK_START
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
TEXT_BLOCK_END

### Context for pattern Marital around line 5834
TEXT_BLOCK_START
 5824:           <thead>
 5825:             <tr>
 5826:               <th>Title</th>
 5827:               <th>Given Name</th>
 5828:               <th>Surname</th>
 5829:               <th>Gender</th>
 5830:               <th>Age Category</th>
 5831:               <th>Generation</th>
 5832:               <th>IC Colour / Class</th>
 5833:               <th>Employment</th>
 5834:               <th>Marital Status</th>
 5835:               <th>IC / Passport</th>
 5836:               <th>Email</th>
 5837:               <th>Primary Phone</th>
 5838:               <th>Backup Phone</th>
 5839:               <th>WhatsApp</th>
 5840:               <th>Availability</th>
 5841:               <th>Address</th>
 5842:               <th>Emergency / Next of Kin</th>
 5843:               <th>Review Status</th>
 5844:               <th>Notes / Flags</th>
 5845:               <th>Created On</th>
 5846:               <th>Modified On</th>
 5847:               <th>Actions</th>
 5848:             </tr>
 5849:           </thead>
 5850:
 5851:           <tbody>
 5852:             {filteredDirectoryClients.length === 0 && (
 5853:               <tr>
 5854:                 <td colSpan="22">
 5855:                   {getClientDirectoryEmptyStateMessage()}
 5856:                 </td>
 5857:               </tr>
 5858:             )}
 5859:
 5860:             {filteredDirectoryClients.map((client) => {
 5861:               const normalized = normalizeClient(client);
 5862:               const id = getClientId(normalized);
TEXT_BLOCK_END

### Context for pattern Marital around line 5892
TEXT_BLOCK_START
 5882:               return (
 5883:                 <tr key={id || normalized.email || normalized.phoneNumber || normalized.nricPassportNumber}>
 5884:                   <td>{normalized.titlePrefix || "-"}</td>
 5885:                   <td>{normalized.givenName || "-"}</td>
 5886:                   <td>{normalized.surname || "-"}</td>
 5887:                   <td>{normalized.gender || "-"}</td>
 5888:                   <td>{normalized.ageCategory || "-"}</td>
 5889:                   <td>{normalized.generation || "-"}</td>
 5890:                   <td>{normalized.identityCardColour || "-"}</td>
 5891:                   <td>{normalized.employmentStatus || "-"}</td>
 5892:                   <td>{normalized.maritalStatus || "-"}</td>
 5893:                   <td>{maskIdentification(normalized.nricPassportNumber, normalized.identificationKind)}</td>
 5894:                   <td>{normalized.email ? <a href={mailTo}>{normalized.email}</a> : "-"}</td>
 5895:                   <td>{phoneForLinks ? <a href={telLink}>{formatPhoneDisplay(normalized.phoneCountryCode, normalized.phoneNumber)}</a> : "-"}</td>
 5896:                   <td>
 5897:                     {backupPhoneForLinks ? <a href={backupTelLink}>{formatPhoneDisplay(normalized.backupPhoneCountryCode, normalized.backupPhoneNumber)}</a> : "-"}
 5898:                     {normalized.phoneHistory.length > 0 && (
 5899:                       <>
 5900:                         <br />
 5901:                         History: {normalized.phoneHistory.length}
 5902:                       </>
 5903:                     )}
 5904:                   </td>
 5905:                   <td>{whatsappForLinks ? <a href={whatsappDraftLink} target="_blank" rel="noreferrer">WhatsApp Draft</a> : "-"}</td>
 5906:                   <td>{getUnavailableStatus(normalized)}</td>
 5907:                   <td>{address || "-"}</td>
 5908:                   <td>
 5909:                     {normalized.emergencyContactName || "-"}
 5910:                     {emergencyPhoneForLinks && (
 5911:                       <>
 5912:                         <br />
 5913:                         <a href={emergencyTelLink}>{formatPhoneDisplay(normalized.emergencyContactCountryCode, normalized.emergencyContactNumber)}</a>
 5914:                       </>
 5915:                     )}
 5916:                   </td>
 5917:                   <td>{normalized.verificationStatus || "-"}</td>
 5918:                   <td>
 5919:                     {normalized.verificationFlags.length > 0 ? normalized.verificationFlags.join("; ") : normalized.specialRemarksStaffLawyerNotes || "-"}
 5920:                   </td>
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 87
TEXT_BLOCK_START
   77:
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 1318
TEXT_BLOCK_START
 1308:
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 1529
TEXT_BLOCK_START
 1519:     ["Given Name", form.givenName],
 1520:     ["Surname", form.surname],
 1521:     ["Gender", form.gender],
 1522:     ["Date of Birth / Age", form.dateOfBirth || form.ageCategory],
 1523:     ["ID / Passport", form.nricPassportNumber],
 1524:     ["Primary Phone", form.phoneNumber],
 1525:     ["Primary Contact Choice", form.preferredContact1],
 1526:     ["Address", form.streetAddress || form.townCity || form.country],
 1527:     ["Emergency Contact", form.emergencyContactName || form.emergencyContactNumber],
 1528:     ["Documentation", form.documentationVerificationCompleted || form.documentType || form.documentStatus],
 1529:     ["Family / Marital", form.maritalStatus],
 1530:     ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
 1531:     ["Client Tenure / Value", form.clientSince || form.clientValueTier],
 1532:     ["Health / Accommodation", form.healthDisabilityStatus || form.accommodationRequired],
 1533:     ["Will / Estate", form.willStatus]
 1534:   ];
 1535:
 1536:   const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;
 1537:   const total = checks.length;
 1538:   const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);
 1539:   const missing = checks.filter(([, value]) => !isCompletionValuePresent(value)).map(([label]) => label);
 1540:
 1541:   return {
 1542:     completed,
 1543:     total,
 1544:     percentage,
 1545:     missing
 1546:   };
 1547: }
 1548:
 1549: function buildAuditTrail(form, existingClient, now) {
 1550:   const existing = existingClient ? normalizeClient(existingClient) : null;
 1551:   const auditTrail = existing ? normalizeAuditTrail(existing.auditTrail) : [];
 1552:
 1553:   if (!existing) {
 1554:     return auditTrail;
 1555:   }
 1556:
 1557:   const watchedFields = [
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 3484
TEXT_BLOCK_START
 3474:         normalized.titleSuffix,
 3475:         normalized.initials,
 3476:         normalized.gender,
 3477:         normalized.givenName,
 3478:         normalized.surname,
 3479:         normalized.name,
 3480:         normalized.ageCategory,
 3481:         normalized.generation,
 3482:         normalized.stateOfBirth,
 3483:         normalized.employmentStatus,
 3484:         normalized.maritalStatus,
 3485:         normalized.ethnicity,
 3486:         normalized.nationality,
 3487:         normalized.residencyStatus,
 3488:         normalized.identificationKind,
 3489:         normalized.identityCardColour,
 3490:         normalized.nricPassportNumber,
 3491:         normalized.email,
 3492:         normalized.phoneCountryCode,
 3493:         normalized.phoneNumber,
 3494:         normalized.backupPhoneCountryCode,
 3495:         normalized.backupPhoneNumber,
 3496:         normalized.whatsappCountryCode,
 3497:         normalized.whatsappNumber,
 3498:         normalized.preferredContact1,
 3499:         normalized.preferredContact2,
 3500:         normalized.preferredContact3,
 3501:         normalized.preferredContact4,
 3502:         normalized.preferredContact5,
 3503:         normalized.preferredContactDetail1,
 3504:         normalized.preferredContactDetail2,
 3505:         normalized.preferredContactDetail3,
 3506:         normalized.preferredContactDetail4,
 3507:         normalized.preferredContactDetail5,
 3508:         normalized.emergencyContactName,
 3509:         normalized.emergencyContactRelationship,
 3510:         normalized.emergencyContactNumber,
 3511:         normalized.addressType,
 3512:         normalized.country,
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 4485
TEXT_BLOCK_START
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
TEXT_BLOCK_END

### Context for pattern maritalStatus around line 5892
TEXT_BLOCK_START
 5882:               return (
 5883:                 <tr key={id || normalized.email || normalized.phoneNumber || normalized.nricPassportNumber}>
 5884:                   <td>{normalized.titlePrefix || "-"}</td>
 5885:                   <td>{normalized.givenName || "-"}</td>
 5886:                   <td>{normalized.surname || "-"}</td>
 5887:                   <td>{normalized.gender || "-"}</td>
 5888:                   <td>{normalized.ageCategory || "-"}</td>
 5889:                   <td>{normalized.generation || "-"}</td>
 5890:                   <td>{normalized.identityCardColour || "-"}</td>
 5891:                   <td>{normalized.employmentStatus || "-"}</td>
 5892:                   <td>{normalized.maritalStatus || "-"}</td>
 5893:                   <td>{maskIdentification(normalized.nricPassportNumber, normalized.identificationKind)}</td>
 5894:                   <td>{normalized.email ? <a href={mailTo}>{normalized.email}</a> : "-"}</td>
 5895:                   <td>{phoneForLinks ? <a href={telLink}>{formatPhoneDisplay(normalized.phoneCountryCode, normalized.phoneNumber)}</a> : "-"}</td>
 5896:                   <td>
 5897:                     {backupPhoneForLinks ? <a href={backupTelLink}>{formatPhoneDisplay(normalized.backupPhoneCountryCode, normalized.backupPhoneNumber)}</a> : "-"}
 5898:                     {normalized.phoneHistory.length > 0 && (
 5899:                       <>
 5900:                         <br />
 5901:                         History: {normalized.phoneHistory.length}
 5902:                       </>
 5903:                     )}
 5904:                   </td>
 5905:                   <td>{whatsappForLinks ? <a href={whatsappDraftLink} target="_blank" rel="noreferrer">WhatsApp Draft</a> : "-"}</td>
 5906:                   <td>{getUnavailableStatus(normalized)}</td>
 5907:                   <td>{address || "-"}</td>
 5908:                   <td>
 5909:                     {normalized.emergencyContactName || "-"}
 5910:                     {emergencyPhoneForLinks && (
 5911:                       <>
 5912:                         <br />
 5913:                         <a href={emergencyTelLink}>{formatPhoneDisplay(normalized.emergencyContactCountryCode, normalized.emergencyContactNumber)}</a>
 5914:                       </>
 5915:                     )}
 5916:                   </td>
 5917:                   <td>{normalized.verificationStatus || "-"}</td>
 5918:                   <td>
 5919:                     {normalized.verificationFlags.length > 0 ? normalized.verificationFlags.join("; ") : normalized.specialRemarksStaffLawyerNotes || "-"}
 5920:                   </td>
TEXT_BLOCK_END

### Context for pattern MARITAL_STATUS_OPTIONS around line 547
TEXT_BLOCK_START
  537:   "Homemaker",
  538:   "Business Owner",
  539:   "Company Director",
  540:   "Contract Worker",
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
TEXT_BLOCK_END

### Context for pattern MARITAL_STATUS_OPTIONS around line 4486
TEXT_BLOCK_START
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
TEXT_BLOCK_END

### Context for pattern hasDependents around line 88
TEXT_BLOCK_START
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
TEXT_BLOCK_END

### Context for pattern hasDependents around line 1319
TEXT_BLOCK_START
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
TEXT_BLOCK_END

### Context for pattern hasDependents around line 2825
TEXT_BLOCK_START
 2815:       setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
 2816:     }
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
TEXT_BLOCK_END

### Context for pattern hasDependents around line 2827
TEXT_BLOCK_START
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
TEXT_BLOCK_END

### Context for pattern hasDependents around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern hasDependents around line 4495
TEXT_BLOCK_START
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
TEXT_BLOCK_END

### Context for pattern hasDependents around line 4496
TEXT_BLOCK_START
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
TEXT_BLOCK_END

### Context for pattern hasDependents around line 4501
TEXT_BLOCK_START
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 89
TEXT_BLOCK_START
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 1320
TEXT_BLOCK_START
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 2829
TEXT_BLOCK_START
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 3194
TEXT_BLOCK_START
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 4508
TEXT_BLOCK_START
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern dependentsCount around line 4509
TEXT_BLOCK_START
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern dependentNotes around line 90
TEXT_BLOCK_START
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
  118:   preferredContact2: "Phone Call",
TEXT_BLOCK_END

### Context for pattern dependentNotes around line 1321
TEXT_BLOCK_START
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
 1349:     preferredContact2: source.preferredContact2 || "Phone Call",
TEXT_BLOCK_END

### Context for pattern dependentNotes around line 2830
TEXT_BLOCK_START
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
 2858:       if (field === "isClientUnavailable") {
TEXT_BLOCK_END

### Context for pattern dependentNotes around line 4517
TEXT_BLOCK_START
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern dependentNotes around line 4518
TEXT_BLOCK_START
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern dependents around line 88
TEXT_BLOCK_START
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
TEXT_BLOCK_END

### Context for pattern dependents around line 89
TEXT_BLOCK_START
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependents around line 1319
TEXT_BLOCK_START
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
TEXT_BLOCK_END

### Context for pattern dependents around line 1320
TEXT_BLOCK_START
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependents around line 2825
TEXT_BLOCK_START
 2815:       setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
 2816:     }
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
TEXT_BLOCK_END

### Context for pattern dependents around line 2827
TEXT_BLOCK_START
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
TEXT_BLOCK_END

### Context for pattern dependents around line 2829
TEXT_BLOCK_START
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
TEXT_BLOCK_END

### Context for pattern dependents around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern dependents around line 3191
TEXT_BLOCK_START
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
TEXT_BLOCK_END

### Context for pattern dependents around line 3194
TEXT_BLOCK_START
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
TEXT_BLOCK_END

### Context for pattern dependents around line 3195
TEXT_BLOCK_START
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
 3223:
TEXT_BLOCK_END

### Context for pattern dependents around line 4495
TEXT_BLOCK_START
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
TEXT_BLOCK_END

### Context for pattern dependents around line 4496
TEXT_BLOCK_START
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
TEXT_BLOCK_END

### Context for pattern dependents around line 4498
TEXT_BLOCK_START
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
TEXT_BLOCK_END

### Context for pattern dependents around line 4501
TEXT_BLOCK_START
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
TEXT_BLOCK_END

### Context for pattern dependents around line 4504
TEXT_BLOCK_START
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
TEXT_BLOCK_END

### Context for pattern dependents around line 4508
TEXT_BLOCK_START
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern dependents around line 4509
TEXT_BLOCK_START
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern dependents around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern Dependents around line 88
TEXT_BLOCK_START
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
TEXT_BLOCK_END

### Context for pattern Dependents around line 89
TEXT_BLOCK_START
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern Dependents around line 1319
TEXT_BLOCK_START
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
TEXT_BLOCK_END

### Context for pattern Dependents around line 1320
TEXT_BLOCK_START
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern Dependents around line 2825
TEXT_BLOCK_START
 2815:       setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
 2816:     }
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
TEXT_BLOCK_END

### Context for pattern Dependents around line 2827
TEXT_BLOCK_START
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
TEXT_BLOCK_END

### Context for pattern Dependents around line 2829
TEXT_BLOCK_START
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
TEXT_BLOCK_END

### Context for pattern Dependents around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern Dependents around line 3191
TEXT_BLOCK_START
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
TEXT_BLOCK_END

### Context for pattern Dependents around line 3194
TEXT_BLOCK_START
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
TEXT_BLOCK_END

### Context for pattern Dependents around line 3195
TEXT_BLOCK_START
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
 3223:
TEXT_BLOCK_END

### Context for pattern Dependents around line 4495
TEXT_BLOCK_START
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
TEXT_BLOCK_END

### Context for pattern Dependents around line 4496
TEXT_BLOCK_START
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
TEXT_BLOCK_END

### Context for pattern Dependents around line 4498
TEXT_BLOCK_START
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
TEXT_BLOCK_END

### Context for pattern Dependents around line 4501
TEXT_BLOCK_START
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
TEXT_BLOCK_END

### Context for pattern Dependents around line 4504
TEXT_BLOCK_START
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
TEXT_BLOCK_END

### Context for pattern Dependents around line 4508
TEXT_BLOCK_START
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern Dependents around line 4509
TEXT_BLOCK_START
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern Dependents around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern dependent around line 88
TEXT_BLOCK_START
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
TEXT_BLOCK_END

### Context for pattern dependent around line 89
TEXT_BLOCK_START
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependent around line 90
TEXT_BLOCK_START
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
  118:   preferredContact2: "Phone Call",
TEXT_BLOCK_END

### Context for pattern dependent around line 508
TEXT_BLOCK_START
  498:   "Malaysian Citizen",
  499:   "Malaysia Permanent Resident",
  500:   "Temporary Resident / MyKAS",
  501:   "Singapore Citizen",
  502:   "Singapore Permanent Resident",
  503:   "Foreigner",
  504:   "Employment Pass",
  505:   "Work Permit",
  506:   "Professional Visit Pass",
  507:   "Student Pass",
  508:   "Dependent Pass",
  509:   "Long Term Social Visit Pass",
  510:   "MM2H / Long Stay",
  511:   "Other Immigration / Documented Status",
  512:   "Unknown",
  513:   "To be confirmed"
  514: ];
  515:
  516: const IDENTIFICATION_KIND_OPTIONS = [
  517:   "Not Applicable / N/A",
  518:   "Malaysian NRIC",
  519:   "Singapore NRIC / FIN",
  520:   "Passport",
  521:   "Permanent Resident Document",
  522:   "Work Visa / Work Permit",
  523:   "Student Pass",
  524:   "Dependent Pass",
  525:   "Other Official ID",
  526:   "Unknown",
  527:   "To be confirmed"
  528: ];
  529:
  530: const EMPLOYMENT_STATUS_OPTIONS = [
  531:   "Not Applicable / N/A",
  532:   "Employed",
  533:   "Self-Employed",
  534:   "Unemployed",
  535:   "Retired",
  536:   "Student",
TEXT_BLOCK_END

### Context for pattern dependent around line 524
TEXT_BLOCK_START
  514: ];
  515:
  516: const IDENTIFICATION_KIND_OPTIONS = [
  517:   "Not Applicable / N/A",
  518:   "Malaysian NRIC",
  519:   "Singapore NRIC / FIN",
  520:   "Passport",
  521:   "Permanent Resident Document",
  522:   "Work Visa / Work Permit",
  523:   "Student Pass",
  524:   "Dependent Pass",
  525:   "Other Official ID",
  526:   "Unknown",
  527:   "To be confirmed"
  528: ];
  529:
  530: const EMPLOYMENT_STATUS_OPTIONS = [
  531:   "Not Applicable / N/A",
  532:   "Employed",
  533:   "Self-Employed",
  534:   "Unemployed",
  535:   "Retired",
  536:   "Student",
  537:   "Homemaker",
  538:   "Business Owner",
  539:   "Company Director",
  540:   "Contract Worker",
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
TEXT_BLOCK_END

### Context for pattern dependent around line 689
TEXT_BLOCK_START
  679:   "Not Applicable / N/A",
  680:   "NRIC",
  681:   "NRIC Front",
  682:   "NRIC Back",
  683:   "Passport Bio Page",
  684:   "Passport Visa Page",
  685:   "Permanent Resident Document",
  686:   "Citizen / PR Proof",
  687:   "Work Visa / Work Permit",
  688:   "Student Pass",
  689:   "Dependent Pass",
  690:   "Address Proof",
  691:   "Other Supporting Document",
  692:   "Unknown",
  693:   "To be confirmed"
  694: ];
  695:
  696: const DOCUMENT_STATUS_OPTIONS = [
  697:   "Not Applicable / N/A",
  698:   "Pending Verification",
  699:   "Verified",
  700:   "Rejected / Needs Resubmission",
  701:   "Expired",
  702:   "Not Required",
  703:   "Unknown",
  704:   "To be confirmed"
  705: ];
  706:
  707: const REVIEW_STATUS_OPTIONS = [
  708:   "Pending Review",
  709:   "Verified",
  710:   "Review Required",
  711:   "Discrepancy Detected",
  712:   "Documents Pending",
  713:   "Rejected / Needs Correction"
  714: ];
  715:
  716: const RELATIONSHIP_OPTIONS = [
  717:   "Not Applicable / N/A",
TEXT_BLOCK_END

### Context for pattern dependent around line 1319
TEXT_BLOCK_START
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
TEXT_BLOCK_END

### Context for pattern dependent around line 1320
TEXT_BLOCK_START
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern dependent around line 1321
TEXT_BLOCK_START
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
 1349:     preferredContact2: source.preferredContact2 || "Phone Call",
TEXT_BLOCK_END

### Context for pattern dependent around line 2825
TEXT_BLOCK_START
 2815:       setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
 2816:     }
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
TEXT_BLOCK_END

### Context for pattern dependent around line 2827
TEXT_BLOCK_START
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
TEXT_BLOCK_END

### Context for pattern dependent around line 2829
TEXT_BLOCK_START
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
TEXT_BLOCK_END

### Context for pattern dependent around line 2830
TEXT_BLOCK_START
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
 2858:       if (field === "isClientUnavailable") {
TEXT_BLOCK_END

### Context for pattern dependent around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern dependent around line 3191
TEXT_BLOCK_START
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
TEXT_BLOCK_END

### Context for pattern dependent around line 3194
TEXT_BLOCK_START
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
TEXT_BLOCK_END

### Context for pattern dependent around line 3195
TEXT_BLOCK_START
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
 3223:
TEXT_BLOCK_END

### Context for pattern dependent around line 4495
TEXT_BLOCK_START
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
TEXT_BLOCK_END

### Context for pattern dependent around line 4496
TEXT_BLOCK_START
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
TEXT_BLOCK_END

### Context for pattern dependent around line 4498
TEXT_BLOCK_START
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
TEXT_BLOCK_END

### Context for pattern dependent around line 4501
TEXT_BLOCK_START
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
TEXT_BLOCK_END

### Context for pattern dependent around line 4504
TEXT_BLOCK_START
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
TEXT_BLOCK_END

### Context for pattern dependent around line 4508
TEXT_BLOCK_START
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern dependent around line 4509
TEXT_BLOCK_START
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern dependent around line 4515
TEXT_BLOCK_START
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
TEXT_BLOCK_END

### Context for pattern dependent around line 4517
TEXT_BLOCK_START
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern dependent around line 4518
TEXT_BLOCK_START
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern dependent around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern Dependent around line 88
TEXT_BLOCK_START
   78:   gender: "",
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
TEXT_BLOCK_END

### Context for pattern Dependent around line 89
TEXT_BLOCK_START
   79:   genderSource: "auto",
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern Dependent around line 90
TEXT_BLOCK_START
   80:   dateOfBirth: "",
   81:   age: "",
   82:   ageCategory: "",
   83:   generation: "",
   84:   stateOfBirth: "",
   85:
   86:   employmentStatus: "To be confirmed",
   87:   maritalStatus: "To be confirmed",
   88:   hasDependents: false,
   89:   dependentsCount: "",
   90:   dependentNotes: "",
   91:
   92:   ethnicity: "",
   93:   ethnicityOther: "",
   94:   nationality: "",
   95:   residencyStatus: "Malaysian Citizen",
   96:   identificationKind: "Malaysian NRIC",
   97:   identityCardColour: "Blue - Malaysian Citizen / MyKad",
   98:   nricPassportNumber: "",
   99:
  100:   email: "",
  101:
  102:   phoneCountryCode: "+60 Malaysia",
  103:   phoneNumber: "",
  104:   backupPhoneCountryCode: "+60 Malaysia",
  105:   backupPhoneNumber: "",
  106:   phoneHistory: [],
  107:
  108:   whatsappSameAsPhone: true,
  109:   whatsappCountryCode: "+60 Malaysia",
  110:   whatsappNumber: "",
  111:   whatsappMessageTemplate: "General follow-up",
  112:   whatsappCustomMessage: "",
  113:   hasSecondWhatsapp: false,
  114:   whatsapp2CountryCode: "+60 Malaysia",
  115:   whatsapp2Number: "",
  116:
  117:   preferredContact1: "WhatsApp Message",
  118:   preferredContact2: "Phone Call",
TEXT_BLOCK_END

### Context for pattern Dependent around line 508
TEXT_BLOCK_START
  498:   "Malaysian Citizen",
  499:   "Malaysia Permanent Resident",
  500:   "Temporary Resident / MyKAS",
  501:   "Singapore Citizen",
  502:   "Singapore Permanent Resident",
  503:   "Foreigner",
  504:   "Employment Pass",
  505:   "Work Permit",
  506:   "Professional Visit Pass",
  507:   "Student Pass",
  508:   "Dependent Pass",
  509:   "Long Term Social Visit Pass",
  510:   "MM2H / Long Stay",
  511:   "Other Immigration / Documented Status",
  512:   "Unknown",
  513:   "To be confirmed"
  514: ];
  515:
  516: const IDENTIFICATION_KIND_OPTIONS = [
  517:   "Not Applicable / N/A",
  518:   "Malaysian NRIC",
  519:   "Singapore NRIC / FIN",
  520:   "Passport",
  521:   "Permanent Resident Document",
  522:   "Work Visa / Work Permit",
  523:   "Student Pass",
  524:   "Dependent Pass",
  525:   "Other Official ID",
  526:   "Unknown",
  527:   "To be confirmed"
  528: ];
  529:
  530: const EMPLOYMENT_STATUS_OPTIONS = [
  531:   "Not Applicable / N/A",
  532:   "Employed",
  533:   "Self-Employed",
  534:   "Unemployed",
  535:   "Retired",
  536:   "Student",
TEXT_BLOCK_END

### Context for pattern Dependent around line 524
TEXT_BLOCK_START
  514: ];
  515:
  516: const IDENTIFICATION_KIND_OPTIONS = [
  517:   "Not Applicable / N/A",
  518:   "Malaysian NRIC",
  519:   "Singapore NRIC / FIN",
  520:   "Passport",
  521:   "Permanent Resident Document",
  522:   "Work Visa / Work Permit",
  523:   "Student Pass",
  524:   "Dependent Pass",
  525:   "Other Official ID",
  526:   "Unknown",
  527:   "To be confirmed"
  528: ];
  529:
  530: const EMPLOYMENT_STATUS_OPTIONS = [
  531:   "Not Applicable / N/A",
  532:   "Employed",
  533:   "Self-Employed",
  534:   "Unemployed",
  535:   "Retired",
  536:   "Student",
  537:   "Homemaker",
  538:   "Business Owner",
  539:   "Company Director",
  540:   "Contract Worker",
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
TEXT_BLOCK_END

### Context for pattern Dependent around line 689
TEXT_BLOCK_START
  679:   "Not Applicable / N/A",
  680:   "NRIC",
  681:   "NRIC Front",
  682:   "NRIC Back",
  683:   "Passport Bio Page",
  684:   "Passport Visa Page",
  685:   "Permanent Resident Document",
  686:   "Citizen / PR Proof",
  687:   "Work Visa / Work Permit",
  688:   "Student Pass",
  689:   "Dependent Pass",
  690:   "Address Proof",
  691:   "Other Supporting Document",
  692:   "Unknown",
  693:   "To be confirmed"
  694: ];
  695:
  696: const DOCUMENT_STATUS_OPTIONS = [
  697:   "Not Applicable / N/A",
  698:   "Pending Verification",
  699:   "Verified",
  700:   "Rejected / Needs Resubmission",
  701:   "Expired",
  702:   "Not Required",
  703:   "Unknown",
  704:   "To be confirmed"
  705: ];
  706:
  707: const REVIEW_STATUS_OPTIONS = [
  708:   "Pending Review",
  709:   "Verified",
  710:   "Review Required",
  711:   "Discrepancy Detected",
  712:   "Documents Pending",
  713:   "Rejected / Needs Correction"
  714: ];
  715:
  716: const RELATIONSHIP_OPTIONS = [
  717:   "Not Applicable / N/A",
TEXT_BLOCK_END

### Context for pattern Dependent around line 1319
TEXT_BLOCK_START
 1309:     gender,
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
TEXT_BLOCK_END

### Context for pattern Dependent around line 1320
TEXT_BLOCK_START
 1310:     genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
TEXT_BLOCK_END

### Context for pattern Dependent around line 1321
TEXT_BLOCK_START
 1311:     dateOfBirth,
 1312:     age,
 1313:     ageCategory,
 1314:     generation,
 1315:     stateOfBirth,
 1316:
 1317:     employmentStatus: source.employmentStatus || "To be confirmed",
 1318:     maritalStatus: source.maritalStatus || "To be confirmed",
 1319:     hasDependents: Boolean(source.hasDependents),
 1320:     dependentsCount: source.dependentsCount || "",
 1321:     dependentNotes: source.dependentNotes || "",
 1322:
 1323:     ethnicity: source.ethnicity || "",
 1324:     ethnicityOther: source.ethnicityOther || "",
 1325:     nationality: source.nationality || "",
 1326:     residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
 1327:     identificationKind,
 1328:     identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
 1329:     nricPassportNumber,
 1330:
 1331:     email: source.email || "",
 1332:
 1333:     phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1334:     phoneNumber: source.phoneNumber || source.phone || "",
 1335:     backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
 1336:     backupPhoneNumber: source.backupPhoneNumber || "",
 1337:     phoneHistory: normalizePhoneHistory(source.phoneHistory),
 1338:
 1339:     whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
 1340:     whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
 1341:     whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
 1342:     whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
 1343:     whatsappCustomMessage: source.whatsappCustomMessage || "",
 1344:     hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
 1345:     whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
 1346:     whatsapp2Number: source.whatsapp2Number || "",
 1347:
 1348:     preferredContact1: source.preferredContact1 || "WhatsApp Message",
 1349:     preferredContact2: source.preferredContact2 || "Phone Call",
TEXT_BLOCK_END

### Context for pattern Dependent around line 2825
TEXT_BLOCK_START
 2815:       setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
 2816:     }
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
TEXT_BLOCK_END

### Context for pattern Dependent around line 2827
TEXT_BLOCK_START
 2817:
 2818:     setFieldErrors((previous) => ({ ...previous, [field]: undefined }));
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
TEXT_BLOCK_END

### Context for pattern Dependent around line 2829
TEXT_BLOCK_START
 2819:
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
TEXT_BLOCK_END

### Context for pattern Dependent around line 2830
TEXT_BLOCK_START
 2820:     setForm((previous) => {
 2821:       const next = {
 2822:         ...previous,
 2823:         [field]: safeValue
 2824:       };
 2825:       if (field === "hasDependents") {
 2826:         const checked = Boolean(value);
 2827:         next.hasDependents = checked;
 2828:         if (!checked) {
 2829:           next.dependentsCount = "";
 2830:           next.dependentNotes = "";
 2831:         }
 2832:       }
 2833:
 2834:       if (field === "willStatus" && value !== "Yes") {
 2835:         next.willReferenceNotes = "";
 2836:         next.willRestrictedAccess = false;
 2837:         next.willAuthorizedParties = [];
 2838:       }
 2839:
 2840:       if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
 2841:         next.previousFirmName = "";
 2842:       }
 2843:
 2844:       if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
 2845:         next.coCounselNotes = "";
 2846:       }
 2847:
 2848:       if (field === "accommodationRequired") {
 2849:         const checked = Boolean(value);
 2850:         next.accommodationRequired = checked;
 2851:         if (!checked) next.accommodationNotes = "";
 2852:       }
 2853:
 2854:       if (field === "healthDisabilityStatus" && value === "None") {
 2855:         next.accommodationRequired = false;
 2856:         next.accommodationNotes = "";
 2857:       }
 2858:       if (field === "isClientUnavailable") {
TEXT_BLOCK_END

### Context for pattern Dependent around line 3190
TEXT_BLOCK_START
 3180:         if (isBlank(payload[fieldName])) {
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
TEXT_BLOCK_END

### Context for pattern Dependent around line 3191
TEXT_BLOCK_START
 3181:           errors.push(label + " is required when correspondence address differs from residential address.");
 3182:         }
 3183:       });
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
TEXT_BLOCK_END

### Context for pattern Dependent around line 3194
TEXT_BLOCK_START
 3184:
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
TEXT_BLOCK_END

### Context for pattern Dependent around line 3195
TEXT_BLOCK_START
 3185:       if (!payload.correspondenceDifferenceConfirmed) {
 3186:         errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
 3187:       }
 3188:     }
 3189:
 3190:     if (payload.hasDependents && isBlank(payload.dependentsCount)) {
 3191:       errors.push("Number of Dependents is required when Has Dependents is selected.");
 3192:     }
 3193:
 3194:     if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
 3195:       errors.push("Number of Dependents cannot be negative.");
 3196:     }
 3197:
 3198:     if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
 3199:       errors.push("Total Matters / Cases Count cannot be negative.");
 3200:     }
 3201:
 3202:     if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
 3203:       errors.push("Email Address format is invalid. Example: client@example.com.");
 3204:     }
 3205:
 3206:     if (showNationalityField && isBlank(payload.nationality)) {
 3207:       errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
 3208:     }
 3209:
 3210:     if (isNricKind(payload.identificationKind)) {
 3211:       const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
 3212:       const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
 3213:       const age = calculateAge(dob);
 3214:       const ageNumber = Number(age);
 3215:
 3216:       if (!dob) {
 3217:         errors.push("NRIC date of birth could not be read. Check the first six digits.");
 3218:       }
 3219:
 3220:       if (Number.isFinite(ageNumber) && ageNumber < 18) {
 3221:         errors.push("Client is below 18. This client profile system is configured for adult clients only.");
 3222:       }
 3223:
TEXT_BLOCK_END

### Context for pattern Dependent around line 4495
TEXT_BLOCK_START
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
TEXT_BLOCK_END

### Context for pattern Dependent around line 4496
TEXT_BLOCK_START
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
TEXT_BLOCK_END

### Context for pattern Dependent around line 4498
TEXT_BLOCK_START
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
TEXT_BLOCK_END

### Context for pattern Dependent around line 4501
TEXT_BLOCK_START
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
TEXT_BLOCK_END

### Context for pattern Dependent around line 4504
TEXT_BLOCK_START
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
TEXT_BLOCK_END

### Context for pattern Dependent around line 4508
TEXT_BLOCK_START
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern Dependent around line 4509
TEXT_BLOCK_START
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern Dependent around line 4515
TEXT_BLOCK_START
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
TEXT_BLOCK_END

### Context for pattern Dependent around line 4517
TEXT_BLOCK_START
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
TEXT_BLOCK_END

### Context for pattern Dependent around line 4518
TEXT_BLOCK_START
 4508:                     value={form.dependentsCount}
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
TEXT_BLOCK_END

### Context for pattern Dependent around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern spouse around line 740
TEXT_BLOCK_START
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
TEXT_BLOCK_END

### Context for pattern Spouse around line 740
TEXT_BLOCK_START
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
TEXT_BLOCK_END

### Context for pattern husband around line 739
TEXT_BLOCK_START
  729:   "Grandaunty",
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
TEXT_BLOCK_END

### Context for pattern Husband around line 739
TEXT_BLOCK_START
  729:   "Grandaunty",
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
TEXT_BLOCK_END

### Context for pattern wife around line 738
TEXT_BLOCK_START
  728:   "Granduncle",
  729:   "Grandaunty",
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
TEXT_BLOCK_END

### Context for pattern Wife around line 738
TEXT_BLOCK_START
  728:   "Granduncle",
  729:   "Grandaunty",
  730:   "Grand-aunt",
  731:   "Step-father",
  732:   "Step-mother",
  733:   "Step-sister",
  734:   "Step-brother",
  735:   "Representative",
  736:   "Legal Representative",
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
TEXT_BLOCK_END

### Context for pattern child around line 1675
TEXT_BLOCK_START
 1665:       responseData.data ||
 1666:       responseData.record ||
 1667:       responseData.result ||
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
TEXT_BLOCK_END

### Context for pattern child around line 1678
TEXT_BLOCK_START
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
 1704:   state: "correspondenceState"
 1705: };
 1706:
TEXT_BLOCK_END

### Context for pattern child around line 1969
TEXT_BLOCK_START
 1959:     };
 1960:
 1961:     collectRequiredState();
 1962:
 1963:     const root = getRoot();
 1964:     root.addEventListener("input", collectRequiredState, true);
 1965:     root.addEventListener("change", collectRequiredState, true);
 1966:
 1967:     const observer = new MutationObserver(collectRequiredState);
 1968:     observer.observe(root, {
 1969:       childList: true,
 1970:       subtree: true,
 1971:       attributes: true,
 1972:       attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
 1973:     });
 1974:
 1975:     return () => {
 1976:       root.removeEventListener("input", collectRequiredState, true);
 1977:       root.removeEventListener("change", collectRequiredState, true);
 1978:       observer.disconnect();
 1979:     };
 1980:   }, []);
 1981:
 1982:   const hasRequiredFields = snapshot.total > 0;
 1983:   const isClear = hasRequiredFields && snapshot.missing === 0;
 1984:
 1985:   return (
 1986:     <div className="client-required-field-counter" aria-live="polite">
 1987:       <div>
 1988:         <p className="client-profile-completion-kicker">Existing Required Fields</p>
 1989:         <h4>{isClear ? "No Visible Required Field Gaps Detected" : "Visible Required Fields Need Review"}</h4>
 1990:         <p>
 1991:           Counter reads currently rendered required controls only. Existing Clients validation and save/create checks remain authoritative.
 1992:         </p>
 1993:       </div>
 1994:
 1995:       <div className="client-required-field-counter-metrics">
 1996:         <span>
 1997:           <strong>{snapshot.total}</strong>
TEXT_BLOCK_END

### Context for pattern child around line 2172
TEXT_BLOCK_START
 2162:     };
 2163:
 2164:     collectSections();
 2165:
 2166:     const root = getRoot();
 2167:     root.addEventListener("input", collectSections, true);
 2168:     root.addEventListener("change", collectSections, true);
 2169:
 2170:     const observer = new MutationObserver(collectSections);
 2171:     observer.observe(root, {
 2172:       childList: true,
 2173:       subtree: true,
 2174:       attributes: true,
 2175:       attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
 2176:     });
 2177:
 2178:     return () => {
 2179:       root.removeEventListener("input", collectSections, true);
 2180:       root.removeEventListener("change", collectSections, true);
 2181:       observer.disconnect();
 2182:     };
 2183:   }, []);
 2184:
 2185:   const totalMissing = sections.reduce((sum, section) => sum + section.missing, 0);
 2186:   const reviewSections = sections.filter((section) => section.tone === "review" || section.tone === "pending").length;
 2187:
 2188:   return (
 2189:     <div className="client-section-completion-status" aria-live="polite">
 2190:       <div className="client-section-completion-header">
 2191:         <div>
 2192:           <p className="client-profile-completion-kicker">Section-Level Completion</p>
 2193:           <h4>Full Profile Section Readiness</h4>
 2194:           <p>
 2195:             Section statuses read existing visible required fields and entered values only. Existing Clients validation remains authoritative.
 2196:           </p>
 2197:         </div>
 2198:
 2199:         <div className="client-section-completion-summary">
 2200:           <span>
TEXT_BLOCK_END

### Context for pattern child around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern Child around line 1675
TEXT_BLOCK_START
 1665:       responseData.data ||
 1666:       responseData.record ||
 1667:       responseData.result ||
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
TEXT_BLOCK_END

### Context for pattern Child around line 1678
TEXT_BLOCK_START
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
 1704:   state: "correspondenceState"
 1705: };
 1706:
TEXT_BLOCK_END

### Context for pattern Child around line 1969
TEXT_BLOCK_START
 1959:     };
 1960:
 1961:     collectRequiredState();
 1962:
 1963:     const root = getRoot();
 1964:     root.addEventListener("input", collectRequiredState, true);
 1965:     root.addEventListener("change", collectRequiredState, true);
 1966:
 1967:     const observer = new MutationObserver(collectRequiredState);
 1968:     observer.observe(root, {
 1969:       childList: true,
 1970:       subtree: true,
 1971:       attributes: true,
 1972:       attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
 1973:     });
 1974:
 1975:     return () => {
 1976:       root.removeEventListener("input", collectRequiredState, true);
 1977:       root.removeEventListener("change", collectRequiredState, true);
 1978:       observer.disconnect();
 1979:     };
 1980:   }, []);
 1981:
 1982:   const hasRequiredFields = snapshot.total > 0;
 1983:   const isClear = hasRequiredFields && snapshot.missing === 0;
 1984:
 1985:   return (
 1986:     <div className="client-required-field-counter" aria-live="polite">
 1987:       <div>
 1988:         <p className="client-profile-completion-kicker">Existing Required Fields</p>
 1989:         <h4>{isClear ? "No Visible Required Field Gaps Detected" : "Visible Required Fields Need Review"}</h4>
 1990:         <p>
 1991:           Counter reads currently rendered required controls only. Existing Clients validation and save/create checks remain authoritative.
 1992:         </p>
 1993:       </div>
 1994:
 1995:       <div className="client-required-field-counter-metrics">
 1996:         <span>
 1997:           <strong>{snapshot.total}</strong>
TEXT_BLOCK_END

### Context for pattern Child around line 2172
TEXT_BLOCK_START
 2162:     };
 2163:
 2164:     collectSections();
 2165:
 2166:     const root = getRoot();
 2167:     root.addEventListener("input", collectSections, true);
 2168:     root.addEventListener("change", collectSections, true);
 2169:
 2170:     const observer = new MutationObserver(collectSections);
 2171:     observer.observe(root, {
 2172:       childList: true,
 2173:       subtree: true,
 2174:       attributes: true,
 2175:       attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
 2176:     });
 2177:
 2178:     return () => {
 2179:       root.removeEventListener("input", collectSections, true);
 2180:       root.removeEventListener("change", collectSections, true);
 2181:       observer.disconnect();
 2182:     };
 2183:   }, []);
 2184:
 2185:   const totalMissing = sections.reduce((sum, section) => sum + section.missing, 0);
 2186:   const reviewSections = sections.filter((section) => section.tone === "review" || section.tone === "pending").length;
 2187:
 2188:   return (
 2189:     <div className="client-section-completion-status" aria-live="polite">
 2190:       <div className="client-section-completion-header">
 2191:         <div>
 2192:           <p className="client-profile-completion-kicker">Section-Level Completion</p>
 2193:           <h4>Full Profile Section Readiness</h4>
 2194:           <p>
 2195:             Section statuses read existing visible required fields and entered values only. Existing Clients validation remains authoritative.
 2196:           </p>
 2197:         </div>
 2198:
 2199:         <div className="client-section-completion-summary">
 2200:           <span>
TEXT_BLOCK_END

### Context for pattern Child around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern children around line 1675
TEXT_BLOCK_START
 1665:       responseData.data ||
 1666:       responseData.record ||
 1667:       responseData.result ||
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
TEXT_BLOCK_END

### Context for pattern children around line 1678
TEXT_BLOCK_START
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
 1704:   state: "correspondenceState"
 1705: };
 1706:
TEXT_BLOCK_END

### Context for pattern children around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern Children around line 1675
TEXT_BLOCK_START
 1665:       responseData.data ||
 1666:       responseData.record ||
 1667:       responseData.result ||
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
TEXT_BLOCK_END

### Context for pattern Children around line 1678
TEXT_BLOCK_START
 1668:       responseData
 1669:   );
 1670: }
 1671:
 1672: function RequiredMark() {
 1673:   return <span className="field-required">*</span>;
 1674: }
 1675: function FieldLabel({ children, required = false }) {
 1676:   return (
 1677:     <span className="field-label-line">
 1678:       {children}
 1679:       {required && <span className="leos-required-marker">*</span>}
 1680:     </span>
 1681:   );
 1682: }
 1683:
 1684: const MINIMUM_CONTACT_DIGITS = 9;
 1685:
 1686: const CANONICAL_CONTACT_METHODS = new Set([
 1687:   "Email",
 1688:   "WhatsApp Message",
 1689:   "WhatsApp Call",
 1690:   "Phone Call",
 1691:   "SMS"
 1692: ]);
 1693:
 1694: const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
 1695:   addressType: "correspondenceAddressType",
 1696:   country: "correspondenceCountry",
 1697:   continent: "correspondenceContinent",
 1698:   region: "correspondenceRegion",
 1699:   buildingHouseNo: "correspondenceBuildingHouseNo",
 1700:   buildingHouseName: "correspondenceBuildingHouseName",
 1701:   postcode: "correspondencePostcode",
 1702:   streetAddress: "correspondenceStreetAddress",
 1703:   townCity: "correspondenceTownCity",
 1704:   state: "correspondenceState"
 1705: };
 1706:
TEXT_BLOCK_END

### Context for pattern Children around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern guardian around line 748
TEXT_BLOCK_START
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
  769:
  770: const MALAYSIA_NRIC_STATE_CODE_MAP = {
  771:   "01": "Johor", "21": "Johor", "22": "Johor", "23": "Johor", "24": "Johor",
  772:   "02": "Kedah", "25": "Kedah", "26": "Kedah", "27": "Kedah",
  773:   "03": "Kelantan", "28": "Kelantan", "29": "Kelantan",
  774:   "04": "Melaka", "30": "Melaka",
  775:   "05": "Negeri Sembilan", "31": "Negeri Sembilan", "59": "Negeri Sembilan",
  776:   "06": "Pahang", "32": "Pahang", "33": "Pahang",
TEXT_BLOCK_END

### Context for pattern Guardian around line 748
TEXT_BLOCK_START
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
  769:
  770: const MALAYSIA_NRIC_STATE_CODE_MAP = {
  771:   "01": "Johor", "21": "Johor", "22": "Johor", "23": "Johor", "24": "Johor",
  772:   "02": "Kedah", "25": "Kedah", "26": "Kedah", "27": "Kedah",
  773:   "03": "Kelantan", "28": "Kelantan", "29": "Kelantan",
  774:   "04": "Melaka", "30": "Melaka",
  775:   "05": "Negeri Sembilan", "31": "Negeri Sembilan", "59": "Negeri Sembilan",
  776:   "06": "Pahang", "32": "Pahang", "33": "Pahang",
TEXT_BLOCK_END

### Context for pattern parent around line 747
TEXT_BLOCK_START
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
  769:
  770: const MALAYSIA_NRIC_STATE_CODE_MAP = {
  771:   "01": "Johor", "21": "Johor", "22": "Johor", "23": "Johor", "24": "Johor",
  772:   "02": "Kedah", "25": "Kedah", "26": "Kedah", "27": "Kedah",
  773:   "03": "Kelantan", "28": "Kelantan", "29": "Kelantan",
  774:   "04": "Melaka", "30": "Melaka",
  775:   "05": "Negeri Sembilan", "31": "Negeri Sembilan", "59": "Negeri Sembilan",
TEXT_BLOCK_END

### Context for pattern parent around line 1896
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
 1921:           return groupControls.some((candidate) => candidate.checked);
 1922:         }
 1923:
 1924:         return control.checked;
TEXT_BLOCK_END

### Context for pattern parent around line 1903
TEXT_BLOCK_START
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
 1925:       }
 1926:
 1927:       return String(control.value || "").trim().length > 0;
 1928:     };
 1929:
 1930:     const collectRequiredState = () => {
 1931:       const root = getRoot();
TEXT_BLOCK_END

### Context for pattern parent around line 2033
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
 2058:       controls.forEach((control) => {
 2059:         const type = (control.getAttribute("type") || "").toLowerCase();
 2060:
 2061:         if (type === "checkbox" || type === "radio") {
TEXT_BLOCK_END

### Context for pattern parent around line 2040
TEXT_BLOCK_START
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
 2062:           const name = control.getAttribute("name");
 2063:
 2064:           if (name) {
 2065:             const groupKey = type + ":" + name;
 2066:
 2067:             if (countedGroups.has(groupKey)) {
 2068:               return;
TEXT_BLOCK_END

### Context for pattern parent around line 2126
TEXT_BLOCK_START
 2116:           tone: "optional",
 2117:           required: 0,
 2118:           complete: 0,
 2119:           missing: 0,
 2120:           active: false,
 2121:         };
 2122:       }
 2123:
 2124:       const sectionRoot =
 2125:         anchorElement.closest(".client-profile-card, .client-profile-section, .client-form-section, .form-section, section, article, fieldset") ||
 2126:         anchorElement.parentElement ||
 2127:         anchorElement;
 2128:
 2129:       const controls = Array.from(sectionRoot.querySelectorAll("input, select, textarea")).filter(isVisible);
 2130:       const requiredControls = controls.filter((control) => control.matches("[required], [aria-required='true']"));
 2131:       const counts = countRequiredControls(requiredControls, sectionRoot);
 2132:       const active = controls.some(hasValue);
 2133:
 2134:       let status = "Optional";
 2135:       let tone = "optional";
 2136:
 2137:       if (counts.required > 0 && counts.missing === 0) {
 2138:         status = "Complete";
 2139:         tone = "complete";
 2140:       } else if (counts.required > 0 && counts.complete > 0) {
 2141:         status = "Review Required";
 2142:         tone = "review";
 2143:       } else if (counts.required > 0) {
 2144:         status = "Pending";
 2145:         tone = "pending";
 2146:       } else if (active) {
 2147:         status = "Review Required";
 2148:         tone = "review";
 2149:       }
 2150:
 2151:       return {
 2152:         ...section,
 2153:         ...counts,
 2154:         active,
TEXT_BLOCK_END

### Context for pattern parent around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern Parent around line 747
TEXT_BLOCK_START
  737:   "Authorised Representative",
  738:   "Wife",
  739:   "Husband",
  740:   "Spouse",
  741:   "Relative",
  742:   "Cousin",
  743:   "Nephew",
  744:   "Niece",
  745:   "Son",
  746:   "Daughter",
  747:   "Parent",
  748:   "Guardian",
  749:   "Executor",
  750:   "Administrator",
  751:   "Trustee",
  752:   "Power of Attorney Holder",
  753:   "Company Contact Person",
  754:   "Employer",
  755:   "Employee",
  756:   "Friend",
  757:   "Other / Manual",
  758:   "Unknown",
  759:   "To be confirmed"
  760: ];
  761: const WHATSAPP_MESSAGE_TEMPLATES = {
  762:   "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  763:   "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  764:   "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  765:   "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  766:   "Custom message": ""
  767: };
  768:
  769:
  770: const MALAYSIA_NRIC_STATE_CODE_MAP = {
  771:   "01": "Johor", "21": "Johor", "22": "Johor", "23": "Johor", "24": "Johor",
  772:   "02": "Kedah", "25": "Kedah", "26": "Kedah", "27": "Kedah",
  773:   "03": "Kelantan", "28": "Kelantan", "29": "Kelantan",
  774:   "04": "Melaka", "30": "Melaka",
  775:   "05": "Negeri Sembilan", "31": "Negeri Sembilan", "59": "Negeri Sembilan",
TEXT_BLOCK_END

### Context for pattern Parent around line 1896
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
 1921:           return groupControls.some((candidate) => candidate.checked);
 1922:         }
 1923:
 1924:         return control.checked;
TEXT_BLOCK_END

### Context for pattern Parent around line 1903
TEXT_BLOCK_START
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
 1925:       }
 1926:
 1927:       return String(control.value || "").trim().length > 0;
 1928:     };
 1929:
 1930:     const collectRequiredState = () => {
 1931:       const root = getRoot();
TEXT_BLOCK_END

### Context for pattern Parent around line 2033
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
 2058:       controls.forEach((control) => {
 2059:         const type = (control.getAttribute("type") || "").toLowerCase();
 2060:
 2061:         if (type === "checkbox" || type === "radio") {
TEXT_BLOCK_END

### Context for pattern Parent around line 2040
TEXT_BLOCK_START
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
 2062:           const name = control.getAttribute("name");
 2063:
 2064:           if (name) {
 2065:             const groupKey = type + ":" + name;
 2066:
 2067:             if (countedGroups.has(groupKey)) {
 2068:               return;
TEXT_BLOCK_END

### Context for pattern Parent around line 2126
TEXT_BLOCK_START
 2116:           tone: "optional",
 2117:           required: 0,
 2118:           complete: 0,
 2119:           missing: 0,
 2120:           active: false,
 2121:         };
 2122:       }
 2123:
 2124:       const sectionRoot =
 2125:         anchorElement.closest(".client-profile-card, .client-profile-section, .client-form-section, .form-section, section, article, fieldset") ||
 2126:         anchorElement.parentElement ||
 2127:         anchorElement;
 2128:
 2129:       const controls = Array.from(sectionRoot.querySelectorAll("input, select, textarea")).filter(isVisible);
 2130:       const requiredControls = controls.filter((control) => control.matches("[required], [aria-required='true']"));
 2131:       const counts = countRequiredControls(requiredControls, sectionRoot);
 2132:       const active = controls.some(hasValue);
 2133:
 2134:       let status = "Optional";
 2135:       let tone = "optional";
 2136:
 2137:       if (counts.required > 0 && counts.missing === 0) {
 2138:         status = "Complete";
 2139:         tone = "complete";
 2140:       } else if (counts.required > 0 && counts.complete > 0) {
 2141:         status = "Review Required";
 2142:         tone = "review";
 2143:       } else if (counts.required > 0) {
 2144:         status = "Pending";
 2145:         tone = "pending";
 2146:       } else if (active) {
 2147:         status = "Review Required";
 2148:         tone = "review";
 2149:       }
 2150:
 2151:       return {
 2152:         ...section,
 2153:         ...counts,
 2154:         active,
TEXT_BLOCK_END

### Context for pattern Parent around line 4519
TEXT_BLOCK_START
 4509:                     onChange={(event) => updateForm("dependentsCount", event.target.value)}
 4510:                     placeholder="Example: 2"
 4511:                   />
 4512:                 </label>
 4513:
 4514:                 <label className="full">
 4515:                   Dependent Notes
 4516:                   <textarea
 4517:                     value={form.dependentNotes}
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
TEXT_BLOCK_END

### Context for pattern divorce around line 551
TEXT_BLOCK_START
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
  576:   "District Council",
  577:   "Local Council",
  578:   "Borough",
  579:   "District",
TEXT_BLOCK_END

### Context for pattern Divorce around line 551
TEXT_BLOCK_START
  541:   "Part-Time",
  542:   "Foreign Worker",
  543:   "Unknown",
  544:   "To be confirmed"
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
  576:   "District Council",
  577:   "Local Council",
  578:   "Borough",
  579:   "District",
TEXT_BLOCK_END

### Context for pattern marriage around line 555
TEXT_BLOCK_START
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
  576:   "District Council",
  577:   "Local Council",
  578:   "Borough",
  579:   "District",
  580:   "Town",
  581:   "City",
  582:   "Village",
  583:   "Township",
TEXT_BLOCK_END

### Context for pattern Marriage around line 555
TEXT_BLOCK_START
  545: ];
  546:
  547: const MARITAL_STATUS_OPTIONS = [
  548:   "Not Applicable / N/A",
  549:   "Single",
  550:   "Married",
  551:   "Divorced",
  552:   "Widowed",
  553:   "Separated",
  554:   "Annulled",
  555:   "Customary / Traditional Marriage",
  556:   "Unknown",
  557:   "To be confirmed"
  558: ];
  559:
  560: const CONTACT_METHOD_OPTIONS = [
  561:   "Not Applicable / N/A",
  562:   "WhatsApp Message",
  563:   "WhatsApp Call",
  564:   "Phone Call",
  565:   "SMS",
  566:   "Email",
  567:   "Postal Mail",
  568:   "Emergency / Next of Kin Only",
  569:   "Unknown",
  570:   "To be confirmed"
  571: ];
  572: const LOCATION_ADMIN_TYPE_OPTIONS = [
  573:   "Municipality",
  574:   "Municipal Council",
  575:   "City Council",
  576:   "District Council",
  577:   "Local Council",
  578:   "Borough",
  579:   "District",
  580:   "Town",
  581:   "City",
  582:   "Village",
  583:   "Township",
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3975
TEXT_BLOCK_START
 3965:             <h3>Client Summary Dashboard</h3>
 3966:             <p>
 3967:               Summary navigation for the preserved Clients workflow. Original fields, validation, backend checks,
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3976
TEXT_BLOCK_START
 3966:             <p>
 3967:               Summary navigation for the preserved Clients workflow. Original fields, validation, backend checks,
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3977
TEXT_BLOCK_START
 3967:               Summary navigation for the preserved Clients workflow. Original fields, validation, backend checks,
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3978
TEXT_BLOCK_START
 3968:               local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3979
TEXT_BLOCK_START
 3969:             </p>
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3980
TEXT_BLOCK_START
 3970:           </div>
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3981
TEXT_BLOCK_START
 3971:
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3982
TEXT_BLOCK_START
 3972:           <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3983
TEXT_BLOCK_START
 3973:             <p className="client-profile-summary-kicker">Section Checklist</p>
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3984
TEXT_BLOCK_START
 3974:             <ol className="client-profile-summary-list">
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3985
TEXT_BLOCK_START
 3975:               <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4013:             </p>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3986
TEXT_BLOCK_START
 3976:               <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4013:             </p>
 4014:           </div>
TEXT_BLOCK_END

### Context for pattern client-profile-summary-link around line 3987
TEXT_BLOCK_START
 3977:               <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
 3978:               <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
 3979:               <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
 3980:               <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
 3981:               <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
 3982:               <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
 3983:               <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
 3984:               <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
 3985:               <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
 3986:               <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
 3987:               <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
 3988:             </ol>
 3989:           </nav>
 3990: </aside>
 3991:         </div>
 3992:
 3993:         <div className="client-count-card">
 3994:           <strong>All Clients ({clients.length})</strong>
 3995:           <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
 3996:         </div>
 3997:       </div>
 3998:
 3999:       {status && (
 4000:         <p className={"client-status client-status-" + statusType}>
 4001:           {status}
 4002:         </p>
 4003:       )}
 4004:
 4005:       <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
 4006:         <div className="client-profile-completion-header">
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4013:             </p>
 4014:           </div>
 4015:         </div>
TEXT_BLOCK_END

### Context for pattern client-form-v6 around line 2330
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
 2355:     setSearchTerm(directoryName);
 2356:     setClientLookupSearchBy("Client Name");
 2357:     setActiveAlphabetFilter(initial || "All");
 2358:     setSelectedClientTagFilter("All");
TEXT_BLOCK_END

### Context for pattern client-form-v6 around line 3726
TEXT_BLOCK_START
 3716:           background: rgba(248, 250, 252, 0.72);
 3717:         }
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
TEXT_BLOCK_END

### Context for pattern client-form-v6 around line 3785
TEXT_BLOCK_START
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
 3800:           justify-content: center !important;
 3801:           align-items: center !important;
 3802:           gap: 6px !important;
 3803:           width: 100%;
 3804:         }
 3805:         .client-alphabet-filter.two-rows .alphabet-action-row button,
 3806:         .client-alphabet-filter.two-rows button {
 3807:           width: auto !important;
 3808:           flex: 0 0 auto !important;
 3809:           min-width: 42px;
 3810:           max-width: 180px;
 3811:           white-space: nowrap;
 3812:         }
 3813:         .client-alphabet-filter.two-rows .alphabet-action-row button {
TEXT_BLOCK_END

### Context for pattern client-form-v6 around line 4249
TEXT_BLOCK_START
 4239:         <div className="client-validation-box">
 4240:           <strong>Validation / Compliance Issues</strong>
 4241:           <ul>
 4242:             {validationErrors.map((error) => (
 4243:               <li key={error}>{error}</li>
 4244:             ))}
 4245:           </ul>
 4246:         </div>
 4247:       )}
 4248:
 4249:       <form className={"client-form client-form-v6" + (validationErrors.length > 0 ? " client-form-has-errors" : "")} onSubmit={saveClient} style={{ display: showClientProfileForm ? undefined : "none" }}>
 4250:         <div className="client-draft-save-panel">
 4251:           <div>
 4252:             <strong>Draft Protection</strong>
 4253:             <small>{draftSaveStatus}</small>
 4254:             {lastDraftSavedAt && (
 4255:               <small>Last saved: {new Date(lastDraftSavedAt).toLocaleString()}</small>
 4256:             )}
 4257:           </div>
 4258:           <div className="inline-actions">
 4259:             <button type="button" className="btn btn-secondary btn-small" onClick={saveClientDraftManually}>Manual Save Draft</button>
 4260:             <button type="button" className="btn btn-secondary btn-small" onClick={restoreClientDraft} disabled={!hasRecoverableDraft}>Restore Draft</button>
 4261:             <button type="button" className="btn btn-secondary btn-small" onClick={clearClientDraft} disabled={!hasRecoverableDraft}>Clear Draft</button>
 4262:           </div>
 4263:           <small className="field-warning-message">Drafts are saved locally in this browser to protect against refresh, accidental navigation, browser crash, or timeout.</small>
 4264:         </div>
 4265:         {(() => {
 4266:           const progress = getClientFormCompletionProgress(form);
 4267:           return (
 4268:             <div className="form-section client-form-progress-card">
 4269:               <h3>Client Form Completion Progress</h3>
 4270:               <p className="mandatory-note">
 4271:                 {progress.percentage}% completed ({progress.completed} of {progress.total} key sections captured).
 4272:               </p>
 4273:               <div className="client-form-progress-track" aria-label="Client form completion progress">
 4274:                 <div className="client-form-progress-fill" style={{ width: progress.percentage + "%" }} />
 4275:               </div>
 4276:               {progress.missing.length > 0 && (
 4277:                 <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4284
TEXT_BLOCK_START
 4274:                 <div className="client-form-progress-fill" style={{ width: progress.percentage + "%" }} />
 4275:               </div>
 4276:               {progress.missing.length > 0 && (
 4277:                 <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
 4278:               )}
 4279:             </div>
 4280:           );
 4281:         })()}
 4282:
 4283:                 <div className="form-section">
 4284:           <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
 4285:           <p className="client-profile-card-help">Core legal identity, name authority, title/gender authority, and profile classification information. Existing fields, validation, and handlers remain preserved.</p>
 4286:
 4287:           <div className="smart-grid two name-lock-grid">
 4288:             <label>
 4289:               Title Prefix
 4290:               <select required value={form.titlePrefix} onChange={(event) => updateForm("titlePrefix", event.target.value)}>
 4291:                 <option value="">Select title</option>
 4292:                 {TITLE_PREFIX_OPTIONS.map((option) => (
 4293:                   <option key={option} value={option}>{option}</option>
 4294:                 ))}
 4295:               </select>
 4296:             </label>
 4297:
 4298:             <label>
 4299:               Initials
 4300:               <input value={form.initials || "Auto"} readOnly />
 4301:             </label>
 4302:
 4303:             <label>
 4304:               Given Name
 4305:               <input
 4306:                 className="single-line-input"
 4307:                 value={form.givenName}
 4308:                 onChange={(event) => updateForm("givenName", event.target.value)}
 4309:                 placeholder="Given name"
 4310:                 required
 4311:               />
 4312:             </label>
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4358
TEXT_BLOCK_START
 4348:                 <textarea
 4349:                   value={form.titleOverrideReason}
 4350:                   onChange={(event) => updateForm("titleOverrideReason", event.target.value)}
 4351:                   placeholder="Record verified reason for title/gender override."
 4352:                 />
 4353:               </label>
 4354:             )}
 4355:           </div>
 4356:         </div>
 4357:         <div className="form-section">
 4358:           <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
 4359:           <p className="client-profile-card-help">Identification, document status, date of birth, and verification-related details. Existing validation remains preserved.</p>
 4360:
 4361:           <div className="smart-grid two identity-grid">
 4362:             <label>
 4363:               Immigration / Documented Status
 4364:               <select required value={form.residencyStatus} onChange={(event) => updateForm("residencyStatus", event.target.value)}>
 4365:                 {RESIDENCY_STATUS_OPTIONS.map((option) => (
 4366:                   <option key={option} value={option}>{option}</option>
 4367:                 ))}
 4368:               </select>
 4369:             </label>
 4370:
 4371:             <label>
 4372:               ID Type
 4373:               <select required value={form.identificationKind} onChange={(event) => updateForm("identificationKind", event.target.value)}>
 4374:                 {IDENTIFICATION_KIND_OPTIONS.map((option) => (
 4375:                   <option key={option} value={option}>{option}</option>
 4376:                 ))}
 4377:               </select>
 4378:             </label>
 4379:
 4380:             <label>
 4381:               Identity Card Colour / Document Class
 4382:               <select required value={form.identityCardColour} onChange={(event) => updateForm("identityCardColour", event.target.value)}>
 4383:                 {IDENTITY_CARD_COLOUR_OPTIONS.map((option) => (
 4384:                   <option key={option} value={option}>{option}</option>
 4385:                 ))}
 4386:               </select>
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4464
TEXT_BLOCK_START
 4454:                 <input
 4455:                   value={form.ethnicityOther}
 4456:                   onChange={(event) => updateForm("ethnicityOther", event.target.value)}
 4457:                   placeholder="Describe ethnicity"
 4458:                 />
 4459:               </label>
 4460:             )}
 4461:           </div>
 4462:         </div>
 4463:         <div className="form-section">
 4464:           <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
 4465:           <p className="client-profile-card-help">Employment and organisation-related status details. Existing employmentStatus field, options, rules, validation, and handlers remain preserved.</p>
 4466:
 4467:           <div className="smart-grid two">
 4468:             <label>
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4479
TEXT_BLOCK_START
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4528
TEXT_BLOCK_START
 4518:                     onChange={(event) => updateForm("dependentNotes", event.target.value)}
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
 4548:               </select>
 4549:             </label>
 4550:
 4551:             {form.caseOriginType === "Inherited / Taken Over from Another Firm" && (
 4552:               <label className="full">
 4553:                 Previous Firm
 4554:                 <input
 4555:                   value={form.previousFirmName}
 4556:                   onChange={(event) => updateForm("previousFirmName", event.target.value)}
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4622
TEXT_BLOCK_START
 4612:               <textarea
 4613:                 value={form.clientValueNotes}
 4614:                 onChange={(event) => updateForm("clientValueNotes", event.target.value)}
 4615:                 placeholder="Manual notes only. Example: repeat client, multiple matters, strategic client, high-touch account."
 4616:               />
 4617:             </label>
 4618:           </div>
 4619:         </div>
 4620:
 4621:         <div className="form-section">
 4622:           <h3 id="client-will-estate-metadata"><span className="client-profile-card-kicker">Section 7</span><span className="client-profile-card-title">Will / Estate Handling Metadata</span><span className="client-profile-card-status">Specialist metadata</span></h3>
 4623:           <p className="client-profile-card-help">Will, estate, probate, and inheritance handling metadata. Existing conditional handling remains preserved.</p>
 4624:           <p className="mandatory-note">Frontend indicator only; enforce access via backend RBAC in future phase.</p>
 4625:
 4626:           <div className="smart-grid two">
 4627:             <label>
 4628:               Will Status
 4629:               <select value={form.willStatus} onChange={(event) => updateForm("willStatus", event.target.value)}>
 4630:                 {WILL_STATUS_OPTIONS.map((option) => (
 4631:                   <option key={option} value={option}>{option}</option>
 4632:                 ))}
 4633:               </select>
 4634:             </label>
 4635:
 4636:             {form.willStatus === "Yes" && (
 4637:               <>
 4638:                 <label className="full">
 4639:                   Will Reference Notes
 4640:                   <textarea
 4641:                     value={form.willReferenceNotes}
 4642:                     onChange={(event) => updateForm("willReferenceNotes", event.target.value)}
 4643:                     placeholder="Example: will exists, held by client, executor named, copy requested, court access may be required."
 4644:                   />
 4645:                 </label>
 4646:
 4647:                 <label className="checkbox-tile full">
 4648:                   <input
 4649:                     type="checkbox"
 4650:                     checked={Boolean(form.willRestrictedAccess)}
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 4685
TEXT_BLOCK_START
 4675:                       );
 4676:                     })}
 4677:                   </div>
 4678:                 </div>
 4679:               </>
 4680:             )}
 4681:           </div>
 4682:         </div>
 4683:
 4684:         <div className="form-section">
 4685:           <h3 id="client-health-oku-accommodation"><span className="client-profile-card-kicker">Section 8</span><span className="client-profile-card-title">Health / OKU / Disability and Accommodation Metadata</span><span className="client-profile-card-status">Accommodation</span></h3>
 4686:           <p className="client-profile-card-help">Accommodation, accessibility, and communication support information. Existing requirements remain preserved.</p>
 4687:           <p className="mandatory-note">Use respectful, neutral wording. Treat accommodation details as sensitive frontend metadata.</p>
 4688:
 4689:           <div className="smart-grid two">
 4690:             <label>
 4691:               Health / Disability Status
 4692:               <select value={form.healthDisabilityStatus} onChange={(event) => updateForm("healthDisabilityStatus", event.target.value)}>
 4693:                 {HEALTH_DISABILITY_STATUS_OPTIONS.map((option) => (
 4694:                   <option key={option} value={option}>{option}</option>
 4695:                 ))}
 4696:               </select>
 4697:             </label>
 4698:
 4699:             <label className="checkbox-tile">
 4700:               <input
 4701:                 type="checkbox"
 4702:                 checked={Boolean(form.accommodationRequired)}
 4703:                 onChange={(event) => updateForm("accommodationRequired", event.target.checked)}
 4704:               />
 4705:               Communication Accommodation Required
 4706:             </label>
 4707:
 4708:             {(form.accommodationRequired || form.healthDisabilityStatus !== "None") && (
 4709:               <label className="full">
 4710:                 Accommodation Notes
 4711:                 <textarea
 4712:                   value={form.accommodationNotes}
 4713:                   onChange={(event) => updateForm("accommodationNotes", event.target.value)}
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 5019
TEXT_BLOCK_START
 5009:                   value={form.communicationTimingNotes}
 5010:                   onChange={(event) => updateForm("communicationTimingNotes", event.target.value)}
 5011:                   placeholder="Example: reachable after 6pm, WhatsApp only, overseas number active on weekends."
 5012:                 />
 5013:               </label>
 5014:             )}
 5015:           </div>
 5016:         </div>
 5017:
 5018:                 <div className="form-section">
 5019:           <h3 id="client-address-service-location"><span className="client-profile-card-kicker">Section 10</span><span className="client-profile-card-title">Address and Service Location Details</span><span className="client-profile-card-status">Location</span></h3>
 5020:           <p className="client-profile-card-help">Address, correspondence, service location, and administrative-area details. Existing synchronization rules remain preserved.</p>
 5021:           <p className="mandatory-note">Use this section for residential, business, local, overseas, correspondence, courier and service-location details.</p>
 5022:           <p className="mandatory-note">
 5023:             <a
 5024:               href={"https://www.google.com/maps/search/?api=1&query=" + encodeURIComponent([form.streetAddress, form.townCity, form.postcode, form.country].filter(Boolean).join(", "))}
 5025:               target="_blank"
 5026:               rel="noreferrer"
 5027:             >
 5028:               Open entered address in Google Maps
 5029:             </a>
 5030:             <br />
 5031:             GPS Latitude / GPS Longitude auto-population should be implemented in a later Google Maps API-safe phase without overwriting the typed legal address.
 5032:           </p>
 5033:           <div className="smart-grid two address-grid">
 5034:             {/* L360_FINAL_ADDRESS_LOCATION_CONTROL_AREA_REPLACEMENT */}
 5035:             <label>
 5036:               Address Type
 5037:               <select value={form.addressType} onChange={(event) => updateForm("addressType", event.target.value)}>
 5038:                 {ADDRESS_TYPE_OPTIONS.map((option) => (
 5039:                   <option key={option} value={option}>{option}</option>
 5040:                 ))}
 5041:               </select>
 5042:             </label>
 5043:
 5044:             <label>
 5045:               Country
 5046:               <input
 5047:                 list="client-country-options"
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 5574
TEXT_BLOCK_START
 5564:             </datalist>
 5565:             <datalist id="l360-council-options">
 5566:               {Array.from(new Set(clients.map((client) => normalizeClient(client).council).filter(Boolean))).map((option) => <option key={option} value={option} />)}
 5567:             </datalist>
 5568:             <datalist id="l360-borough-options">
 5569:               {Array.from(new Set(clients.map((client) => normalizeClient(client).borough).filter(Boolean))).map((option) => <option key={option} value={option} />)}
 5570:             </datalist>
 5571:           </div>
 5572:         </div>
 5573: <div className="form-section">
 5574:           <h3 id="client-emergency-next-of-kin"><span className="client-profile-card-kicker">Section 11</span><span className="client-profile-card-title">Emergency Contact / Next of Kin Details</span><span className="client-profile-card-status">Secondary contact</span></h3>
 5575:           <p className="client-profile-card-help">Emergency and next-of-kin information. Existing fields and handlers remain preserved.</p>
 5576:
 5577:           <div className="smart-grid two">
 5578:             <label>
 5579:               Emergency Contact Name
 5580:               <input value={form.emergencyContactName} onChange={(event) => updateForm("emergencyContactName", event.target.value)} placeholder="Name" />
 5581:             </label>
 5582:
 5583:             <label>
 5584:               Relationship to Client
 5585:               <input
 5586:                 list="client-relationship-options"
 5587:                 value={form.emergencyContactRelationship}
 5588:                 onChange={(event) => updateForm("emergencyContactRelationship", event.target.value)}
 5589:                 placeholder="Search/select or type relationship"
 5590:               />
 5591:               <datalist id="client-relationship-options">
 5592:                 {RELATIONSHIP_OPTIONS.map((relationship) => (
 5593:                   <option key={relationship} value={relationship} />
 5594:                 ))}
 5595:               </datalist>
 5596:               <small>Searchable list with manual free-text entry for unlisted relationships.</small>
 5597:             </label>
 5598:
 5599:             <label className="full">
 5600:               Emergency Contact Number
 5601:               <div className="inline-fields code-and-number">
 5602:                 <input
TEXT_BLOCK_END

### Context for pattern client-profile-card-title around line 5624
TEXT_BLOCK_START
 5614:             </label>
 5615:
 5616:             <label>
 5617:               Emergency Contact Email
 5618:               <input type="email" value={form.emergencyContactEmail} onChange={(event) => updateForm("emergencyContactEmail", event.target.value)} placeholder="email@example.com" />
 5619:             </label>
 5620:           </div>
 5621:         </div>
 5622:
 5623:         <div className="form-section">
 5624:           <h3 id="client-documentation-verification"><span className="client-profile-card-kicker">Section 12</span><span className="client-profile-card-title">Documentation Verification Status</span><span className="client-profile-card-status">Compliance</span></h3>
 5625:           <p className="client-profile-card-help">Document verification, status, pending reasons, retention notes, and review fields. Existing compliance process remains preserved.</p>
 5626:           <p className="mandatory-note">Tracks document type, document receipt status, verification status and digital copy handling.</p>
 5627:
 5628:                     <div className="smart-grid two">
 5629:             <label className="full">
 5630:               Documentation Verification Completion
 5631:               <select
 5632:                 value={form.documentationVerificationCompleted ? "done" : "not_done"}
 5633:                 onChange={(event) => updateForm("documentationVerificationCompleted", event.target.value === "done")}
 5634:               >
 5635:                 <option value="not_done">Not Yet / Not Completed ❌</option>
 5636:                 <option value="done">Documentation Verification Status Done ✅</option>
 5637:               </select>
 5638:             </label>
 5639:
 5640:             {!form.documentationVerificationCompleted && (
 5641:               <>
 5642:                 <label>
 5643:                   Document Type *
 5644:                   <select value={form.documentType} onChange={(event) => updateForm("documentType", event.target.value)}>
 5645:                     {DOCUMENT_TYPE_OPTIONS.map((option) => (
 5646:                       <option key={option} value={option}>{option}</option>
 5647:                     ))}
 5648:                   </select>
 5649:                 </label>
 5650:
 5651:                 <label>
 5652:                   Document Status *
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4285
TEXT_BLOCK_START
 4275:               </div>
 4276:               {progress.missing.length > 0 && (
 4277:                 <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
 4278:               )}
 4279:             </div>
 4280:           );
 4281:         })()}
 4282:
 4283:                 <div className="form-section">
 4284:           <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
 4285:           <p className="client-profile-card-help">Core legal identity, name authority, title/gender authority, and profile classification information. Existing fields, validation, and handlers remain preserved.</p>
 4286:
 4287:           <div className="smart-grid two name-lock-grid">
 4288:             <label>
 4289:               Title Prefix
 4290:               <select required value={form.titlePrefix} onChange={(event) => updateForm("titlePrefix", event.target.value)}>
 4291:                 <option value="">Select title</option>
 4292:                 {TITLE_PREFIX_OPTIONS.map((option) => (
 4293:                   <option key={option} value={option}>{option}</option>
 4294:                 ))}
 4295:               </select>
 4296:             </label>
 4297:
 4298:             <label>
 4299:               Initials
 4300:               <input value={form.initials || "Auto"} readOnly />
 4301:             </label>
 4302:
 4303:             <label>
 4304:               Given Name
 4305:               <input
 4306:                 className="single-line-input"
 4307:                 value={form.givenName}
 4308:                 onChange={(event) => updateForm("givenName", event.target.value)}
 4309:                 placeholder="Given name"
 4310:                 required
 4311:               />
 4312:             </label>
 4313:
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4359
TEXT_BLOCK_START
 4349:                   value={form.titleOverrideReason}
 4350:                   onChange={(event) => updateForm("titleOverrideReason", event.target.value)}
 4351:                   placeholder="Record verified reason for title/gender override."
 4352:                 />
 4353:               </label>
 4354:             )}
 4355:           </div>
 4356:         </div>
 4357:         <div className="form-section">
 4358:           <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
 4359:           <p className="client-profile-card-help">Identification, document status, date of birth, and verification-related details. Existing validation remains preserved.</p>
 4360:
 4361:           <div className="smart-grid two identity-grid">
 4362:             <label>
 4363:               Immigration / Documented Status
 4364:               <select required value={form.residencyStatus} onChange={(event) => updateForm("residencyStatus", event.target.value)}>
 4365:                 {RESIDENCY_STATUS_OPTIONS.map((option) => (
 4366:                   <option key={option} value={option}>{option}</option>
 4367:                 ))}
 4368:               </select>
 4369:             </label>
 4370:
 4371:             <label>
 4372:               ID Type
 4373:               <select required value={form.identificationKind} onChange={(event) => updateForm("identificationKind", event.target.value)}>
 4374:                 {IDENTIFICATION_KIND_OPTIONS.map((option) => (
 4375:                   <option key={option} value={option}>{option}</option>
 4376:                 ))}
 4377:               </select>
 4378:             </label>
 4379:
 4380:             <label>
 4381:               Identity Card Colour / Document Class
 4382:               <select required value={form.identityCardColour} onChange={(event) => updateForm("identityCardColour", event.target.value)}>
 4383:                 {IDENTITY_CARD_COLOUR_OPTIONS.map((option) => (
 4384:                   <option key={option} value={option}>{option}</option>
 4385:                 ))}
 4386:               </select>
 4387:               <small>Blue auto-confirms Malaysian Citizen.</small>
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4465
TEXT_BLOCK_START
 4455:                   value={form.ethnicityOther}
 4456:                   onChange={(event) => updateForm("ethnicityOther", event.target.value)}
 4457:                   placeholder="Describe ethnicity"
 4458:                 />
 4459:               </label>
 4460:             )}
 4461:           </div>
 4462:         </div>
 4463:         <div className="form-section">
 4464:           <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
 4465:           <p className="client-profile-card-help">Employment and organisation-related status details. Existing employmentStatus field, options, rules, validation, and handlers remain preserved.</p>
 4466:
 4467:           <div className="smart-grid two">
 4468:             <label>
 4469:               Employment Status
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4480
TEXT_BLOCK_START
 4470:               <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
 4471:                 {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
 4472:                   <option key={option} value={option}>{option}</option>
 4473:                 ))}
 4474:               </select>
 4475:             </label>
 4476:           </div>
 4477:         </div>
 4478:         <div className="form-section">
 4479:           <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
 4480:           <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>
 4481:
 4482:           <div className="smart-grid two">
 4483:             <label>
 4484:               Marital / Family Status
 4485:               <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
 4486:                 {MARITAL_STATUS_OPTIONS.map((option) => (
 4487:                   <option key={option} value={option}>{option}</option>
 4488:                 ))}
 4489:               </select>
 4490:             </label>
 4491:
 4492:             <label className="checkbox-tile">
 4493:               <input
 4494:                 type="checkbox"
 4495:                 checked={Boolean(form.hasDependents)}
 4496:                 onChange={(event) => updateForm("hasDependents", event.target.checked)}
 4497:               />
 4498:               Has Dependents?
 4499:             </label>
 4500:
 4501:             {form.hasDependents && (
 4502:               <>
 4503:                 <label>
 4504:                   Number of Dependents
 4505:                   <input
 4506:                     type="number"
 4507:                     min="0"
 4508:                     value={form.dependentsCount}
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4529
TEXT_BLOCK_START
 4519:                     placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
 4520:                   />
 4521:                 </label>
 4522:               </>
 4523:             )}
 4524:           </div>
 4525:         </div>
 4526:
 4527:         <div className="form-section">
 4528:           <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
 4529:           <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
 4530:           <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>
 4531:
 4532:           <div className="smart-grid two">
 4533:             <label>
 4534:               Client Role in Matter
 4535:               <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
 4536:                 {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
 4537:                   <option key={option} value={option}>{option}</option>
 4538:                 ))}
 4539:               </select>
 4540:             </label>
 4541:
 4542:             <label>
 4543:               Case Origin
 4544:               <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
 4545:                 {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
 4546:                   <option key={option} value={option}>{option}</option>
 4547:                 ))}
 4548:               </select>
 4549:             </label>
 4550:
 4551:             {form.caseOriginType === "Inherited / Taken Over from Another Firm" && (
 4552:               <label className="full">
 4553:                 Previous Firm
 4554:                 <input
 4555:                   value={form.previousFirmName}
 4556:                   onChange={(event) => updateForm("previousFirmName", event.target.value)}
 4557:                   placeholder="Previous firm name, if known"
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4623
TEXT_BLOCK_START
 4613:                 value={form.clientValueNotes}
 4614:                 onChange={(event) => updateForm("clientValueNotes", event.target.value)}
 4615:                 placeholder="Manual notes only. Example: repeat client, multiple matters, strategic client, high-touch account."
 4616:               />
 4617:             </label>
 4618:           </div>
 4619:         </div>
 4620:
 4621:         <div className="form-section">
 4622:           <h3 id="client-will-estate-metadata"><span className="client-profile-card-kicker">Section 7</span><span className="client-profile-card-title">Will / Estate Handling Metadata</span><span className="client-profile-card-status">Specialist metadata</span></h3>
 4623:           <p className="client-profile-card-help">Will, estate, probate, and inheritance handling metadata. Existing conditional handling remains preserved.</p>
 4624:           <p className="mandatory-note">Frontend indicator only; enforce access via backend RBAC in future phase.</p>
 4625:
 4626:           <div className="smart-grid two">
 4627:             <label>
 4628:               Will Status
 4629:               <select value={form.willStatus} onChange={(event) => updateForm("willStatus", event.target.value)}>
 4630:                 {WILL_STATUS_OPTIONS.map((option) => (
 4631:                   <option key={option} value={option}>{option}</option>
 4632:                 ))}
 4633:               </select>
 4634:             </label>
 4635:
 4636:             {form.willStatus === "Yes" && (
 4637:               <>
 4638:                 <label className="full">
 4639:                   Will Reference Notes
 4640:                   <textarea
 4641:                     value={form.willReferenceNotes}
 4642:                     onChange={(event) => updateForm("willReferenceNotes", event.target.value)}
 4643:                     placeholder="Example: will exists, held by client, executor named, copy requested, court access may be required."
 4644:                   />
 4645:                 </label>
 4646:
 4647:                 <label className="checkbox-tile full">
 4648:                   <input
 4649:                     type="checkbox"
 4650:                     checked={Boolean(form.willRestrictedAccess)}
 4651:                     onChange={(event) => updateForm("willRestrictedAccess", event.target.checked)}
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 4686
TEXT_BLOCK_START
 4676:                     })}
 4677:                   </div>
 4678:                 </div>
 4679:               </>
 4680:             )}
 4681:           </div>
 4682:         </div>
 4683:
 4684:         <div className="form-section">
 4685:           <h3 id="client-health-oku-accommodation"><span className="client-profile-card-kicker">Section 8</span><span className="client-profile-card-title">Health / OKU / Disability and Accommodation Metadata</span><span className="client-profile-card-status">Accommodation</span></h3>
 4686:           <p className="client-profile-card-help">Accommodation, accessibility, and communication support information. Existing requirements remain preserved.</p>
 4687:           <p className="mandatory-note">Use respectful, neutral wording. Treat accommodation details as sensitive frontend metadata.</p>
 4688:
 4689:           <div className="smart-grid two">
 4690:             <label>
 4691:               Health / Disability Status
 4692:               <select value={form.healthDisabilityStatus} onChange={(event) => updateForm("healthDisabilityStatus", event.target.value)}>
 4693:                 {HEALTH_DISABILITY_STATUS_OPTIONS.map((option) => (
 4694:                   <option key={option} value={option}>{option}</option>
 4695:                 ))}
 4696:               </select>
 4697:             </label>
 4698:
 4699:             <label className="checkbox-tile">
 4700:               <input
 4701:                 type="checkbox"
 4702:                 checked={Boolean(form.accommodationRequired)}
 4703:                 onChange={(event) => updateForm("accommodationRequired", event.target.checked)}
 4704:               />
 4705:               Communication Accommodation Required
 4706:             </label>
 4707:
 4708:             {(form.accommodationRequired || form.healthDisabilityStatus !== "None") && (
 4709:               <label className="full">
 4710:                 Accommodation Notes
 4711:                 <textarea
 4712:                   value={form.accommodationNotes}
 4713:                   onChange={(event) => updateForm("accommodationNotes", event.target.value)}
 4714:                   placeholder="Example: prefers written communication, mobility access, hearing/visual support, medical sensitivity, appointment timing needs."
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 5020
TEXT_BLOCK_START
 5010:                   onChange={(event) => updateForm("communicationTimingNotes", event.target.value)}
 5011:                   placeholder="Example: reachable after 6pm, WhatsApp only, overseas number active on weekends."
 5012:                 />
 5013:               </label>
 5014:             )}
 5015:           </div>
 5016:         </div>
 5017:
 5018:                 <div className="form-section">
 5019:           <h3 id="client-address-service-location"><span className="client-profile-card-kicker">Section 10</span><span className="client-profile-card-title">Address and Service Location Details</span><span className="client-profile-card-status">Location</span></h3>
 5020:           <p className="client-profile-card-help">Address, correspondence, service location, and administrative-area details. Existing synchronization rules remain preserved.</p>
 5021:           <p className="mandatory-note">Use this section for residential, business, local, overseas, correspondence, courier and service-location details.</p>
 5022:           <p className="mandatory-note">
 5023:             <a
 5024:               href={"https://www.google.com/maps/search/?api=1&query=" + encodeURIComponent([form.streetAddress, form.townCity, form.postcode, form.country].filter(Boolean).join(", "))}
 5025:               target="_blank"
 5026:               rel="noreferrer"
 5027:             >
 5028:               Open entered address in Google Maps
 5029:             </a>
 5030:             <br />
 5031:             GPS Latitude / GPS Longitude auto-population should be implemented in a later Google Maps API-safe phase without overwriting the typed legal address.
 5032:           </p>
 5033:           <div className="smart-grid two address-grid">
 5034:             {/* L360_FINAL_ADDRESS_LOCATION_CONTROL_AREA_REPLACEMENT */}
 5035:             <label>
 5036:               Address Type
 5037:               <select value={form.addressType} onChange={(event) => updateForm("addressType", event.target.value)}>
 5038:                 {ADDRESS_TYPE_OPTIONS.map((option) => (
 5039:                   <option key={option} value={option}>{option}</option>
 5040:                 ))}
 5041:               </select>
 5042:             </label>
 5043:
 5044:             <label>
 5045:               Country
 5046:               <input
 5047:                 list="client-country-options"
 5048:                 value={form.country}
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 5575
TEXT_BLOCK_START
 5565:             <datalist id="l360-council-options">
 5566:               {Array.from(new Set(clients.map((client) => normalizeClient(client).council).filter(Boolean))).map((option) => <option key={option} value={option} />)}
 5567:             </datalist>
 5568:             <datalist id="l360-borough-options">
 5569:               {Array.from(new Set(clients.map((client) => normalizeClient(client).borough).filter(Boolean))).map((option) => <option key={option} value={option} />)}
 5570:             </datalist>
 5571:           </div>
 5572:         </div>
 5573: <div className="form-section">
 5574:           <h3 id="client-emergency-next-of-kin"><span className="client-profile-card-kicker">Section 11</span><span className="client-profile-card-title">Emergency Contact / Next of Kin Details</span><span className="client-profile-card-status">Secondary contact</span></h3>
 5575:           <p className="client-profile-card-help">Emergency and next-of-kin information. Existing fields and handlers remain preserved.</p>
 5576:
 5577:           <div className="smart-grid two">
 5578:             <label>
 5579:               Emergency Contact Name
 5580:               <input value={form.emergencyContactName} onChange={(event) => updateForm("emergencyContactName", event.target.value)} placeholder="Name" />
 5581:             </label>
 5582:
 5583:             <label>
 5584:               Relationship to Client
 5585:               <input
 5586:                 list="client-relationship-options"
 5587:                 value={form.emergencyContactRelationship}
 5588:                 onChange={(event) => updateForm("emergencyContactRelationship", event.target.value)}
 5589:                 placeholder="Search/select or type relationship"
 5590:               />
 5591:               <datalist id="client-relationship-options">
 5592:                 {RELATIONSHIP_OPTIONS.map((relationship) => (
 5593:                   <option key={relationship} value={relationship} />
 5594:                 ))}
 5595:               </datalist>
 5596:               <small>Searchable list with manual free-text entry for unlisted relationships.</small>
 5597:             </label>
 5598:
 5599:             <label className="full">
 5600:               Emergency Contact Number
 5601:               <div className="inline-fields code-and-number">
 5602:                 <input
 5603:                   list="client-country-code-options"
TEXT_BLOCK_END

### Context for pattern client-profile-card-help around line 5625
TEXT_BLOCK_START
 5615:
 5616:             <label>
 5617:               Emergency Contact Email
 5618:               <input type="email" value={form.emergencyContactEmail} onChange={(event) => updateForm("emergencyContactEmail", event.target.value)} placeholder="email@example.com" />
 5619:             </label>
 5620:           </div>
 5621:         </div>
 5622:
 5623:         <div className="form-section">
 5624:           <h3 id="client-documentation-verification"><span className="client-profile-card-kicker">Section 12</span><span className="client-profile-card-title">Documentation Verification Status</span><span className="client-profile-card-status">Compliance</span></h3>
 5625:           <p className="client-profile-card-help">Document verification, status, pending reasons, retention notes, and review fields. Existing compliance process remains preserved.</p>
 5626:           <p className="mandatory-note">Tracks document type, document receipt status, verification status and digital copy handling.</p>
 5627:
 5628:                     <div className="smart-grid two">
 5629:             <label className="full">
 5630:               Documentation Verification Completion
 5631:               <select
 5632:                 value={form.documentationVerificationCompleted ? "done" : "not_done"}
 5633:                 onChange={(event) => updateForm("documentationVerificationCompleted", event.target.value === "done")}
 5634:               >
 5635:                 <option value="not_done">Not Yet / Not Completed ❌</option>
 5636:                 <option value="done">Documentation Verification Status Done ✅</option>
 5637:               </select>
 5638:             </label>
 5639:
 5640:             {!form.documentationVerificationCompleted && (
 5641:               <>
 5642:                 <label>
 5643:                   Document Type *
 5644:                   <select value={form.documentType} onChange={(event) => updateForm("documentType", event.target.value)}>
 5645:                     {DOCUMENT_TYPE_OPTIONS.map((option) => (
 5646:                       <option key={option} value={option}>{option}</option>
 5647:                     ))}
 5648:                   </select>
 5649:                 </label>
 5650:
 5651:                 <label>
 5652:                   Document Status *
 5653:                   <select value={form.documentStatus} onChange={(event) => updateForm("documentStatus", event.target.value)}>
TEXT_BLOCK_END

### Context for pattern ClientRequiredFieldCounter around line 1888
TEXT_BLOCK_START
 1878:     return {
 1879:       ...withCanonicalContacts,
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
TEXT_BLOCK_END

### Context for pattern ClientRequiredFieldCounter around line 4017
TEXT_BLOCK_START
 4007:           <div>
 4008:             <p className="client-profile-completion-kicker">Client File Alert / Status</p>
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4013:             </p>
 4014:           </div>
 4015:         </div>
 4016:
 4017:         <ClientRequiredFieldCounter />
 4018:
 4019:         <ClientSectionCompletionStatus />
 4020:
 4021:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4022:           <a href="#client-profile-details">Identity & Authority</a>
 4023:           <a href="#client-contact-communication-preferences">Contact</a>
 4024:           <a href="#client-address-service-location">Address</a>
 4025:           <a href="#client-documentation-verification">Documentation</a>
 4026:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4027:         </div>
 4028:       </section>
 4029: <div className="client-directory-control-panel">
 4030:         <div className="client-directory-header-row">
 4031:           <div>
 4032:             <h3>Advanced Client Directory / Manual Management</h3>
 4033:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4034:           </div>
 4035:           <div className="client-directory-actions">
 4036:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4037:               + Add/Create New Client Profile
 4038:             </button>
 4039:             {showClientProfileForm && (
 4040:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4041:                 Hide Client Profile Form
 4042:               </button>
 4043:             )}
 4044:           </div>
 4045:         </div>
TEXT_BLOCK_END

### Context for pattern ClientSectionCompletionStatus around line 2013
TEXT_BLOCK_START
 2003:         </span>
 2004:         <span className={snapshot.missing > 0 ? "needs-review" : "is-clear"}>
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
 2015:     { anchor: "client-profile-details", label: "Identity & Authority" },
 2016:     { anchor: "client-identification-details", label: "Identification" },
 2017:     { anchor: "client-employment-details", label: "Employment & Organisation" },
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
TEXT_BLOCK_END

### Context for pattern ClientSectionCompletionStatus around line 4019
TEXT_BLOCK_START
 4009:             <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
 4010:             <p>
 4011:               Existing Clients validation, required fields, backend checks, local fallback,
 4012:               draft behaviour, create/save controls, and manual-management protocols remain authoritative.
 4013:             </p>
 4014:           </div>
 4015:         </div>
 4016:
 4017:         <ClientRequiredFieldCounter />
 4018:
 4019:         <ClientSectionCompletionStatus />
 4020:
 4021:         <div className="client-profile-completion-links" aria-label="Completion review jump links">
 4022:           <a href="#client-profile-details">Identity & Authority</a>
 4023:           <a href="#client-contact-communication-preferences">Contact</a>
 4024:           <a href="#client-address-service-location">Address</a>
 4025:           <a href="#client-documentation-verification">Documentation</a>
 4026:           <a href="#client-internal-remarks-issues">Pending Info</a>
 4027:         </div>
 4028:       </section>
 4029: <div className="client-directory-control-panel">
 4030:         <div className="client-directory-header-row">
 4031:           <div>
 4032:             <h3>Advanced Client Directory / Manual Management</h3>
 4033:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4034:           </div>
 4035:           <div className="client-directory-actions">
 4036:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4037:               + Add/Create New Client Profile
 4038:             </button>
 4039:             {showClientProfileForm && (
 4040:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4041:                 Hide Client Profile Form
 4042:               </button>
 4043:             )}
 4044:           </div>
 4045:         </div>
 4046:
 4047:         <div className="inline-fields four-even">
TEXT_BLOCK_END

### Context for pattern Save Modified Client around line 3414
TEXT_BLOCK_START
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
 3440:       });
 3441:
 3442:       if (!response.ok) {
TEXT_BLOCK_END

### Context for pattern Save Modified Client around line 5802
TEXT_BLOCK_START
 5792:           </div>
 5793:
 5794:           <div className="client-profile-review-footer">
 5795:             <strong>Preservation notice:</strong>
 5796:             Existing required markers, validation rules, backend/local fallback warnings, draft controls,
 5797:             create/save actions, and manual-management protocols remain authoritative.
 5798:           </div>
 5799:         </section>
 5800: <div className="client-form-actions">
 5801:           <button type="submit" disabled={isSaving}>
 5802:             {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Create New Client Profile"}
 5803:           </button>
 5804:
 5805:           <button type="button" onClick={resetForm}>
 5806:             Clear Form
 5807:           </button>
 5808:         </div>
 5809:       </form>
 5810:
 5811:       <div className="client-search-row">
 5812:         <label>
 5813:           Client Search
 5814:           <input
 5815:             value={searchTerm}
 5816:             onChange={handleDirectorySearchChange}
 5817:             placeholder="Search name, title, NRIC/passport, document class, phone, email, status, remarks or verification flags"
 5818:           />
 5819:         </label>
 5820:       </div>
 5821:
 5822:       <div className="client-table-wrap">
 5823:         <table className="client-table">
 5824:           <thead>
 5825:             <tr>
 5826:               <th>Title</th>
 5827:               <th>Given Name</th>
 5828:               <th>Surname</th>
 5829:               <th>Gender</th>
 5830:               <th>Age Category</th>
TEXT_BLOCK_END

### Context for pattern Create New Client Profile around line 4037
TEXT_BLOCK_START
 4027:         </div>
 4028:       </section>
 4029: <div className="client-directory-control-panel">
 4030:         <div className="client-directory-header-row">
 4031:           <div>
 4032:             <h3>Advanced Client Directory / Manual Management</h3>
 4033:             <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
 4034:           </div>
 4035:           <div className="client-directory-actions">
 4036:             <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
 4037:               + Add/Create New Client Profile
 4038:             </button>
 4039:             {showClientProfileForm && (
 4040:               <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
 4041:                 Hide Client Profile Form
 4042:               </button>
 4043:             )}
 4044:           </div>
 4045:         </div>
 4046:
 4047:         <div className="inline-fields four-even">
 4048:           <label>
 4049:             Search By
 4050:             <select value={clientLookupSearchBy} onChange={(event) => setClientLookupSearchBy(event.target.value)}>
 4051:               {[
 4052:                 "All Fields",
 4053:                 "Client Name",
 4054:                 "Phone / WhatsApp",
 4055:                 "Email",
 4056:                 "NRIC / Passport",
 4057:                 "Date of Birth",
 4058:                 "State of Birth",
 4059:                 "Gender",
 4060:                 "Ethnicity",
 4061:                 "Nationality / Residency",
 4062:                 "Document Status",
 4063:                 "Postcode",
 4064:                 "Administrative Location",
 4065:                 "Category / Tag",
TEXT_BLOCK_END

### Context for pattern Create New Client Profile around line 5802
TEXT_BLOCK_START
 5792:           </div>
 5793:
 5794:           <div className="client-profile-review-footer">
 5795:             <strong>Preservation notice:</strong>
 5796:             Existing required markers, validation rules, backend/local fallback warnings, draft controls,
 5797:             create/save actions, and manual-management protocols remain authoritative.
 5798:           </div>
 5799:         </section>
 5800: <div className="client-form-actions">
 5801:           <button type="submit" disabled={isSaving}>
 5802:             {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Create New Client Profile"}
 5803:           </button>
 5804:
 5805:           <button type="button" onClick={resetForm}>
 5806:             Clear Form
 5807:           </button>
 5808:         </div>
 5809:       </form>
 5810:
 5811:       <div className="client-search-row">
 5812:         <label>
 5813:           Client Search
 5814:           <input
 5815:             value={searchTerm}
 5816:             onChange={handleDirectorySearchChange}
 5817:             placeholder="Search name, title, NRIC/passport, document class, phone, email, status, remarks or verification flags"
 5818:           />
 5819:         </label>
 5820:       </div>
 5821:
 5822:       <div className="client-table-wrap">
 5823:         <table className="client-table">
 5824:           <thead>
 5825:             <tr>
 5826:               <th>Title</th>
 5827:               <th>Given Name</th>
 5828:               <th>Surname</th>
 5829:               <th>Gender</th>
 5830:               <th>Age Category</th>
TEXT_BLOCK_END


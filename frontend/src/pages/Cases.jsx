import { assignCaseToStaff } from "../services/assignmentService";
import { fetchAllStaff } from "../services/staffService";
import { fetchAllClients } from "../services/clientService";
import { autoAssignCase } from "../rules/assignmentEngine";

import React, { useState, useEffect } from "react";

import {
  fetchAllCases,
  addCase,
  editCase,
  removeCase
} from "../services/caseService";

import { formatStatus } from "../utils/formatters";
import WorkflowProgressDashboard from "../components/workflow/WorkflowProgressDashboard";

const EMPTY_MATTER_FORM = {
  case_number: "",
  title: "",
  client_id: "",
  status: "NEW",
  description: "",
  opened_date: ""
};

function getClientDisplayName(client) {
  if (!client) return "-";

  return (
    client.full_name ||
    client.fullName ||
    [client.givenName, client.surname].filter(Boolean).join(" ") ||
    client.name ||
    client.email ||
    "Unnamed client"
  );
}

function getMatterStatusSlug(status) {
  return String(status || "unknown")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "") || "unknown";
}

export default function Cases() {
  const [cases, setCases] = useState([]);
  const [clients, setClients] = useState([]);
  const [staffList, setStaffList] = useState([]);

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);

  const [successMsg, setSuccessMsg] = useState(null);
  const [errorMsg, setErrorMsg] = useState(null);

  const [formData, setFormData] = useState(EMPTY_MATTER_FORM);

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      setLoading(true);
      setErrorMsg(null);

      const [casesData, staffData, clientsData] = await Promise.all([
        fetchAllCases(),
        fetchAllStaff(),
        fetchAllClients()
      ]);

      setCases(Array.isArray(casesData) ? casesData : []);
      setStaffList(Array.isArray(staffData) ? staffData : []);
      setClients(Array.isArray(clientsData) ? clientsData : []);
    } catch (err) {
      setErrorMsg("Failed to load matters. Please refresh or check the backend connection.");
      console.error("Matter load error:", err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    if (!successMsg) return undefined;

    const timer = setTimeout(() => setSuccessMsg(null), 3000);
    return () => clearTimeout(timer);
  }, [successMsg]);

  function handleChange(e) {
    const { name, value } = e.target;

    setFormData((prev) => ({
      ...prev,
      [name]: name === "client_id" ? (value === "" ? "" : Number(value)) : value
    }));
  }

  async function handleSubmit(e) {
    e.preventDefault();

    if (saving) return;

    try {
      setSaving(true);
      setErrorMsg(null);

      const payload = {
        ...formData,
        title: formData.title.trim(),
        description: formData.description.trim(),
        client_id: formData.client_id === "" ? null : Number(formData.client_id)
      };

      let savedCase;

      if (editingId) {
        await editCase(editingId, payload);
        savedCase = { ...payload, id: editingId };
        setSuccessMsg("Matter updated successfully.");
      } else {
        savedCase = await addCase(payload);
        setSuccessMsg("Matter created successfully.");
      }

      const result = autoAssignCase(savedCase, staffList);

      if (result?.assigned && result.staff?.id) {
        await assignCaseToStaff(savedCase.id, result.staff.id);
      }

      resetForm();
      await loadData();
    } catch (err) {
      setErrorMsg("Failed to save matter. Please check required fields and try again.");
      console.error("Matter submit error:", err);
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(matter) {
    const title = matter?.title || "this matter";
    const confirmed = window.confirm(`Delete matter "${title}"? This action cannot be undone.`);

    if (!confirmed) return;

    try {
      setErrorMsg(null);
      await removeCase(matter.id);
      setSuccessMsg("Matter deleted successfully.");
      await loadData();
    } catch (err) {
      setErrorMsg("Failed to delete matter. Please try again.");
      console.error("Matter delete error:", err);
    }
  }

  function handleEdit(c) {
    setFormData({
      case_number: c.case_number || "",
      title: c.title || "",
      client_id: c.client_id || "",
      status: c.status || "NEW",
      description: c.description || "",
      opened_date: c.opened_date || ""
    });

    setEditingId(c.id);
    setShowForm(true);
    setErrorMsg(null);
  }

  function resetForm() {
    setFormData(EMPTY_MATTER_FORM);
    setEditingId(null);
    setShowForm(false);
  }

  const safeCases = Array.isArray(cases) ? cases : [];
  const safeClients = Array.isArray(clients) ? clients : [];
  const linkedClientIds = new Set(
    safeClients
      .map((client) => Number(client.id))
      .filter((id) => Number.isFinite(id))
  );
  const caseTitleComplete = String(formData.title || "").trim().length > 0;
  const caseStatusComplete = String(formData.status || "").trim().length > 0;
  const caseDescriptionComplete = String(formData.description || "").trim().length > 0;
  const caseClientState = safeClients.length === 0
    ? "blocked"
    : formData.client_id === ""
      ? "pending"
      : linkedClientIds.has(Number(formData.client_id))
        ? "completed"
        : "blocked";
  const caseFormFieldStates = [
    caseTitleComplete ? "completed" : "pending",
    caseClientState,
    caseStatusComplete ? "completed" : "pending",
    caseDescriptionComplete ? "completed" : "pending"
  ];
  const caseFormTotalCount = caseFormFieldStates.length;
  const caseFormCompletedCount = caseFormFieldStates.filter((state) => state === "completed").length;
  const caseFormBlockedCount = caseFormFieldStates.filter((state) => state === "blocked").length;
  const caseFormRawPendingCount = caseFormFieldStates.filter((state) => state === "pending").length;
  const caseFormInProgressCount = showForm && caseFormCompletedCount > 0 && caseFormRawPendingCount > 0 ? 1 : 0;
  const caseFormPendingCount = Math.max(caseFormRawPendingCount - caseFormInProgressCount, 0);
  const caseFormProgressNote =
    "Live Page 4 field completion: " +
    caseFormCompletedCount +
    " of " +
    caseFormTotalCount +
    " tracked matter fields complete. Records loaded: " +
    safeCases.length +
    " matters and " +
    safeClients.length +
    " clients.";

  if (loading) {
    return (
      <div className="loading" role="status" aria-live="polite">
        Loading matters...
      </div>
    );
  }

  return (
    <div className="matter-page l360-workspace-page">
      <div className="matter-page-header">
        <div>
          <h2>Matter Details</h2>
          <p>Manage legal matters linked to client profiles.</p>
        </div>
      </div>

      <WorkflowProgressDashboard
        title="Case / Matter Workflow Progress"
        stepLabel="Page 4 of 6 · Case / Matter Details"
        completedCount={caseFormCompletedCount}
        inProgressCount={caseFormInProgressCount}
        pendingCount={caseFormPendingCount}
        blockedCount={caseFormBlockedCount}
        totalCount={caseFormTotalCount}
        notes={caseFormProgressNote}
      />

      {successMsg && <div className="matter-success" role="status">{successMsg}</div>}
      {errorMsg && <div className="matter-error" role="alert">{errorMsg}</div>}

      <div className="matter-toolbar l360-page-toolbar">
        <button
          className="matter-button matter-button-primary l360-primary-action"
          type="button"
          onClick={() => setShowForm((current) => !current)}
        >
          {showForm ? "Close Matter Form" : "+ Create New Matter"}
        </button>
      </div>

      {showForm && (
        <form onSubmit={handleSubmit} className="matter-form l360-editor-card">
          <label>
            <span>Matter Title *</span>
            <input
              name="title"
              value={formData.title}
              onChange={handleChange}
              placeholder="Matter title"
              required
            />
          </label>

          <label>
            <span>Linked Client *</span>
            <select
              name="client_id"
              value={formData.client_id}
              onChange={handleChange}
              required
            >
              <option value="">Select linked client</option>
              {safeClients.map((client) => (
                <option key={client.id} value={client.id}>
                  {getClientDisplayName(client)}
                </option>
              ))}
            </select>
          </label>

          <label>
            <span>Status *</span>
            <select
              name="status"
              value={formData.status}
              onChange={handleChange}
              required
            >
              <option value="NEW">Open</option>
              <option value="ACTIVE">Active</option>
              <option value="PENDING_CLIENT">Pending Client</option>
              <option value="PENDING_COURT">Pending Court</option>
              <option value="ON_HOLD">On Hold</option>
              <option value="CLOSED">Closed</option>
              <option value="ARCHIVED">Archived</option>
            </select>
          </label>

          <label className="matter-form-wide">
            <span>Matter Description / Summary *</span>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              placeholder="Matter description or summary"
              rows="4"
              required
            />
          </label>

          <div className="l360-form-actions matter-form-wide">
            <button className="matter-button matter-button-success l360-primary-action" type="submit" disabled={saving}>
              {saving ? "Saving..." : editingId ? "Update Matter" : "Create Matter"}
            </button>
            <button className="matter-button matter-button-secondary l360-secondary-action" type="button" onClick={resetForm}>
              Cancel
            </button>
          </div>
        </form>
      )}

      <div className="l360-table-scroll matter-table-wrap">
        <table className="matter-table l360-data-table" aria-label="Matters table">
          <thead>
            <tr>
              <th>Matter Title</th>
              <th>Client</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {safeCases.length === 0 ? (
              <tr>
                <td colSpan="4" className="l360-empty-state">
                  No matters loaded yet.
                </td>
              </tr>
            ) : (
              safeCases.map((matter) => {
                const client = safeClients.find((item) => Number(item.id) === Number(matter.client_id));
                const statusLabel = formatStatus(matter.status);
                const statusSlug = getMatterStatusSlug(matter.status || statusLabel);

                return (
                  <tr key={matter.id}>
                    <td>
                      <strong className="l360-table-primary-text" title={matter.title || "Untitled matter"}>
                        {matter.title || "Untitled matter"}
                      </strong>
                      {matter.case_number ? <span className="l360-table-subtext">Case no: {matter.case_number}</span> : null}
                    </td>
                    <td>
                      <span className="l360-table-secondary-text" title={getClientDisplayName(client)}>
                        {getClientDisplayName(client)}
                      </span>
                    </td>
                    <td>
                      <span className={`matter-status-badge status-${statusSlug}`}>
                        {statusLabel}
                      </span>
                    </td>
                    <td>
                      <div className="l360-actions-cell">
                        <button className="matter-button matter-button-secondary l360-secondary-action" type="button" onClick={() => handleEdit(matter)}>
                          Edit
                        </button>
                        <button className="matter-button matter-button-danger l360-danger-action" type="button" onClick={() => handleDelete(matter)}>
                          Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

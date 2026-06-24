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

export default function Cases() {

  const [cases, setCases] = useState([]);
  const [clients, setClients] = useState([]);
  const [staffList, setStaffList] = useState([]);

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);

  const [successMsg, setSuccessMsg] = useState(null);

  const [formData, setFormData] = useState({
    case_number: "",
    title: "",
    client_id: "",
    status: "NEW",
    description: "",
    opened_date: ""
  });

  // =======================
  // LOAD DATA
  // =======================
  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      setLoading(true);

      const [casesData, staffData, clientsData] = await Promise.all([
        fetchAllCases(),
        fetchAllStaff(),
        fetchAllClients()
      ]);

      setCases(casesData);
      setStaffList(staffData);
      setClients(clientsData);

          console.error("Load error:", err);
    } finally {
      setLoading(false);
    }
  }

  // =======================
  // CLEAR MESSAGE
  // =======================
  useEffect(() => {
    if (!successMsg) return;
    const t = setTimeout(() => setSuccessMsg(null), 3000);
    return () => clearTimeout(t);
  }, [successMsg]);

  // =======================
  // INPUT HANDLER
  // =======================
  function handleChange(e) {
    const { name, value } = e.target;

    setFormData(prev => ({
      ...prev,
      [name]:
        name === "client_id"
          ? (value === "" ? "" : Number(value))
          : value
    }));
  }

  // =======================
  // SUBMIT
  // =======================
  async function handleSubmit(e) {
  e.preventDefault();

  if (saving) return;

  try {
    setSaving(true);

    const payload = {
      ...formData,
      client_id:
        formData.client_id === "" ? null : Number(formData.client_id)
    };

    let savedCase;

    if (editingId) {
      await editCase(editingId, payload);
      savedCase = { ...payload, id: editingId };
      setSuccessMsg("Matter updated");
    } else {
      savedCase = await addCase(payload);
      setSuccessMsg("Matter created");
    }

    const result = autoAssignCase(savedCase, staffList);

    if (result.assigned) {
      await assignCaseToStaff(savedCase.id, result.staff.id);
    }

    resetForm();

    // SAFE DELAYED REFRESH (CLEAN + CLOSED PROPERLY)
    setTimeout(() => {
      loadData();
    }, 300);

  } catch (err) {
    console.error("SUBMIT ERROR:", err);
  } finally {
    setSaving(false);
  }
}

  // =======================
  // DELETE
  // =======================
  async function handleDelete(id) {
    if (!window.confirm("Delete this case?")) return;

    await removeCase(id);
    setSuccessMsg("Matter deleted");
    await loadData();
  }

  // =======================
  // EDIT
  // =======================
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
  }

  // =======================
  // RESET
  // =======================
  function resetForm() {
    setFormData({
      case_number: "",
      title: "",
      client_id: "",
      status: "NEW",
      description: "",
      opened_date: ""
    });

    setEditingId(null);
    setShowForm(false);
  }
  const safeCases = Array.isArray(cases) ? cases : [];
  const safeClients = Array.isArray(clients) ? clients : [];

  if (loading) return <div>Loading...</div>;

  return (
    <div className="matter-page">
      <style>{`
        .matter-page {
          padding: 24px;
          max-width: 1200px;
          margin: 0 auto;
          font-family: Arial, sans-serif;
          color: #0f172a;
        }

        .matter-page h2 {
          margin: 0 0 8px 0;
          font-size: 30px;
          font-weight: 700;
        }

        .matter-page p {
          margin: 0 0 18px 0;
          color: #475569;
          font-size: 16px;
        }

        .matter-toolbar {
          margin-bottom: 16px;
        }

        .matter-form {
          display: grid;
          grid-template-columns: repeat(2, minmax(240px, 1fr));
          gap: 14px;
          padding: 18px;
          margin: 16px 0 22px 0;
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 12px;
          box-shadow: 0 1px 3px rgba(15, 23, 42, 0.08);
        }

        .matter-form input,
        .matter-form select,
        .matter-form textarea {
          width: 100%;
          box-sizing: border-box;
          padding: 10px 12px;
          border: 1px solid #cbd5e1;
          border-radius: 8px;
          font-size: 14px;
          background: #ffffff;
        }

        .matter-form textarea {
          grid-column: 1 / -1;
          min-height: 90px;
          resize: vertical;
        }

        .matter-button {
          border: none;
          border-radius: 8px;
          padding: 9px 14px;
          font-size: 14px;
          cursor: pointer;
        }

        .matter-button-primary {
          background: #1d4ed8;
          color: #ffffff;
        }

        .matter-button-success {
          background: #15803d;
          color: #ffffff;
          justify-self: start;
        }

        .matter-button-secondary {
          background: #e2e8f0;
          color: #0f172a;
          margin-right: 8px;
        }

        .matter-button-danger {
          background: #fee2e2;
          color: #991b1b;
        }

        .matter-table {
          width: 100%;
          border-collapse: collapse;
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 1px 3px rgba(15, 23, 42, 0.08);
        }

        .matter-table th {
          text-align: left;
          padding: 12px;
          background: #f8fafc;
          border-bottom: 1px solid #e2e8f0;
          font-size: 14px;
        }

        .matter-table td {
          padding: 12px;
          border-bottom: 1px solid #e2e8f0;
          font-size: 14px;
        }

        .matter-table tr:last-child td {
          border-bottom: none;
        }

        .matter-success {
          margin-bottom: 14px;
          padding: 10px 12px;
          border-radius: 8px;
          background: #dcfce7;
          color: #166534;
          border: 1px solid #bbf7d0;
        }
      `}</style>

      
      <h2>Matter Details</h2>
      <p>Manage legal matters linked to client profiles.</p>
{successMsg && <div className="matter-success">{successMsg}</div>}

      <div className="matter-toolbar"><button className="matter-button matter-button-primary" onClick={() => setShowForm(true)}>Create New Matter</button></div>

      {showForm && (
        <form onSubmit={handleSubmit} className="matter-form">

          <input
            name="title"
            value={formData.title}
            onChange={handleChange}
            placeholder="Matter Title"
          />

          <select
            name="client_id"
            value={formData.client_id}
            onChange={handleChange}
            required
          >
            <option value="">Linked Client</option>

            {safeClients.map(c => (
              <option key={c.id} value={c.id}>
                {c.full_name}
              </option>
            ))}
          </select>

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

          <textarea
            name="description"
            value={formData.description}
            onChange={handleChange}
            placeholder="Matter Description / Summary"
            rows="4"
          />

          <button className="matter-button matter-button-success" type="submit" disabled={saving}>
            {saving ? "Saving..." : editingId ? "Update Matter" : "Create Matter"}
          </button>

        </form>
      )}

      <table className="matter-table">
        <thead>
          <tr>
            <th>Matter Title</th>
            <th>Client</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
          {safeCases.map(c => (
            <tr key={c.id}>
              <td>{c.title}</td>
              <td>
                {safeClients.find(client => Number(client.id) === Number(c.client_id))?.full_name || "-"}
              </td>
              <td>{formatStatus(c.status)}</td>
              <td>
                <button className="matter-button matter-button-secondary" onClick={() => handleEdit(c)}>Edit</button>
                <button className="matter-button matter-button-danger" onClick={() => handleDelete(c.id)}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>

      </table>

    </div>
  );
}


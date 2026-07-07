import React, { useState, useEffect } from 'react';
import { getDeadlines, getCases, createDeadline, updateDeadline, deleteDeadline } from '../api';

const EMPTY_FORM = {
  title: '',
  deadline_date: '',
  case_id: '',
  reminder_days: 7,
  notes: ''
};

function formatDate(value) {
  if (!value) return '—';

  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    return String(value);
  }

  return date.toLocaleDateString(undefined, {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  });
}

function getDaysUntil(dateStr) {
  const deadline = new Date(dateStr);
  const today = new Date();

  if (Number.isNaN(deadline.getTime())) {
    return null;
  }

  today.setHours(0, 0, 0, 0);
  deadline.setHours(0, 0, 0, 0);

  return Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));
}

function getDeadlineState(deadline) {
  const daysUntil = getDaysUntil(deadline.deadline_date);

  if (deadline.is_complete) {
    return {
      daysUntil,
      daysLabel: 'Completed',
      label: 'Completed',
      slug: 'completed'
    };
  }

  if (daysUntil === null) {
    return {
      daysUntil,
      daysLabel: 'Date missing',
      label: 'Needs date',
      slug: 'missing'
    };
  }

  if (daysUntil < 0) {
    return {
      daysUntil,
      daysLabel: `${Math.abs(daysUntil)} day${Math.abs(daysUntil) === 1 ? '' : 's'} overdue`,
      label: 'Overdue',
      slug: 'overdue'
    };
  }

  if (daysUntil === 0) {
    return {
      daysUntil,
      daysLabel: 'Due today',
      label: 'Urgent',
      slug: 'urgent'
    };
  }

  if (daysUntil <= 3) {
    return {
      daysUntil,
      daysLabel: `${daysUntil} day${daysUntil === 1 ? '' : 's'}`,
      label: 'Urgent',
      slug: 'urgent'
    };
  }

  if (daysUntil <= 7) {
    return {
      daysUntil,
      daysLabel: `${daysUntil} days`,
      label: 'Due soon',
      slug: 'due-soon'
    };
  }

  return {
    daysUntil,
    daysLabel: `${daysUntil} days`,
    label: 'On track',
    slug: 'on-track'
  };
}

export default function Deadlines() {
  const [deadlines, setDeadlines] = useState([]);
  const [cases, setCases] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [filterStatus, setFilterStatus] = useState('all');
  const [formData, setFormData] = useState(EMPTY_FORM);
  const [successMsg, setSuccessMsg] = useState(null);

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      setLoading(true);
      setError(null);

      const [deadlinesData, casesData] = await Promise.all([
        getDeadlines(),
        getCases()
      ]);

      setDeadlines(Array.isArray(deadlinesData) ? deadlinesData : []);
      setCases(Array.isArray(casesData) ? casesData : []);
    } catch (err) {
      setError('Failed to load deadline data. Please refresh or check the backend connection.');
      console.error('Deadline load error:', err);
    } finally {
      setLoading(false);
    }
  }

  function resetForm() {
    setFormData(EMPTY_FORM);
    setEditingId(null);
    setShowForm(false);
  }

  function handleInputChange(e) {
    const { name, value } = e.target;

    setFormData((prev) => ({
      ...prev,
      [name]: name === 'reminder_days' ? Number(value) : value
    }));
  }

  async function handleSubmit(e) {
    e.preventDefault();

    const payload = {
      ...formData,
      title: formData.title.trim(),
      case_id: formData.case_id || null,
      reminder_days: Number(formData.reminder_days) || 0,
      notes: formData.notes.trim()
    };

    try {
      setError(null);

      if (editingId) {
        await updateDeadline(editingId, payload);
        setSuccessMsg('Deadline updated successfully.');
      } else {
        await createDeadline(payload);
        setSuccessMsg('Deadline created successfully.');
      }

      resetForm();
      await loadData();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to save deadline. Please check the required fields and try again.');
      console.error('Deadline save error:', err);
    }
  }

  function handleEdit(deadline) {
    setFormData({
      title: deadline.title || '',
      deadline_date: deadline.deadline_date || '',
      case_id: deadline.case_id || '',
      reminder_days: deadline.reminder_days ?? 7,
      notes: deadline.notes || ''
    });
    setEditingId(deadline.id);
    setShowForm(true);
    setError(null);
  }

  async function handleDelete(deadline) {
    const title = deadline?.title || 'this deadline';
    const confirmed = window.confirm(`Delete deadline "${title}"? This action cannot be undone.`);

    if (!confirmed) return;

    try {
      setError(null);
      await deleteDeadline(deadline.id);
      setSuccessMsg('Deadline deleted successfully.');
      await loadData();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to delete deadline. Please try again.');
      console.error('Deadline delete error:', err);
    }
  }

  function getCaseName(caseId) {
    const caseItem = cases.find((caseRecord) => Number(caseRecord.id) === Number(caseId));
    return caseItem ? caseItem.title : '—';
  }

  const filteredDeadlines = deadlines
    .filter((deadline) => {
      const state = getDeadlineState(deadline);

      if (filterStatus === 'all') return true;
      if (filterStatus === 'overdue') return state.slug === 'overdue';
      if (filterStatus === 'urgent') return state.slug === 'urgent';
      if (filterStatus === 'upcoming') return ['due-soon', 'on-track'].includes(state.slug);
      if (filterStatus === 'completed') return state.slug === 'completed';

      return true;
    })
    .sort((a, b) => new Date(a.deadline_date) - new Date(b.deadline_date));

  if (loading) {
    return (
      <div className="loading" role="status" aria-live="polite">
        <div className="spinner" /> Loading deadlines...
      </div>
    );
  }

  return (
    <div className="deadlines-page l360-workspace-page">
      {successMsg && <div className="alert alert-success" role="status">{successMsg}</div>}
      {error && <div className="alert alert-error" role="alert">{error}</div>}

      <div className="l360-page-toolbar deadlines-toolbar" aria-label="Deadline controls">
        {!showForm ? (
          <button className="btn btn-primary l360-primary-action" type="button" onClick={() => setShowForm(true)}>
            + Add Deadline
          </button>
        ) : (
          <button className="btn btn-secondary l360-secondary-action" type="button" onClick={resetForm}>
            Cancel
          </button>
        )}

        <label className="l360-filter-control">
          <span>Filter</span>
          <select
            className="l360-select"
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
          >
            <option value="all">All Deadlines</option>
            <option value="overdue">Overdue</option>
            <option value="urgent">Urgent (≤3 days)</option>
            <option value="upcoming">Upcoming</option>
            <option value="completed">Completed</option>
          </select>
        </label>
      </div>

      {showForm && (
        <div className="card l360-editor-card">
          <h3>{editingId ? 'Edit Deadline' : 'Add New Deadline'}</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label htmlFor="deadline-title">Deadline Title *</label>
              <input
                id="deadline-title"
                type="text"
                name="title"
                value={formData.title}
                onChange={handleInputChange}
                placeholder="e.g., File Motion for Summary Judgment"
                required
              />
            </div>

            <div className="l360-form-grid two">
              <div className="form-group">
                <label htmlFor="deadline-date">Due Date *</label>
                <input
                  id="deadline-date"
                  type="date"
                  name="deadline_date"
                  value={formData.deadline_date}
                  onChange={handleInputChange}
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="deadline-case">Associated Case</label>
                <select
                  id="deadline-case"
                  name="case_id"
                  value={formData.case_id}
                  onChange={handleInputChange}
                >
                  <option value="">Select a case (optional)</option>
                  {cases.map((caseRecord) => (
                    <option key={caseRecord.id} value={caseRecord.id}>{caseRecord.title}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="deadline-reminder">Reminder (days before deadline)</label>
              <input
                id="deadline-reminder"
                type="number"
                name="reminder_days"
                value={formData.reminder_days}
                onChange={handleInputChange}
                min="0"
                max="60"
              />
              <small className="l360-field-help">
                System will remind you {formData.reminder_days} day(s) before the deadline.
              </small>
            </div>

            <div className="form-group">
              <label htmlFor="deadline-notes">Notes</label>
              <textarea
                id="deadline-notes"
                name="notes"
                value={formData.notes}
                onChange={handleInputChange}
                placeholder="Additional notes for this deadline..."
              />
            </div>

            <div className="l360-form-actions">
              <button type="submit" className="btn btn-primary l360-primary-action">
                {editingId ? 'Update Deadline' : 'Create Deadline'}
              </button>
              <button type="button" className="btn btn-secondary l360-secondary-action" onClick={resetForm}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="card l360-data-card">
        <div className="l360-card-header-row">
          <h3>Deadlines ({filteredDeadlines.length})</h3>
          <span className="l360-card-meta">Court dates and reminder readiness</span>
        </div>

        {filteredDeadlines.length === 0 ? (
          <p className="l360-empty-state">No deadlines match the current filter.</p>
        ) : (
          <div className="table-container l360-table-scroll">
            <table className="data-table l360-data-table deadlines-table" aria-label="Deadlines table">
              <thead>
                <tr>
                  <th>Deadline</th>
                  <th>Due Date</th>
                  <th>Days Until</th>
                  <th>Associated Case</th>
                  <th>Reminder Set</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredDeadlines.map((deadline) => {
                  const state = getDeadlineState(deadline);

                  return (
                    <tr key={deadline.id}>
                      <td>
                        <strong className="l360-table-primary-text" title={deadline.title || 'Untitled deadline'}>
                          {deadline.title || 'Untitled deadline'}
                        </strong>
                      </td>
                      <td className="l360-nowrap">{formatDate(deadline.deadline_date)}</td>
                      <td>
                        <span className={`deadline-days-badge deadline-days-${state.slug}`}>
                          {state.daysLabel}
                        </span>
                      </td>
                      <td>
                        <span className="l360-table-secondary-text" title={getCaseName(deadline.case_id)}>
                          {getCaseName(deadline.case_id)}
                        </span>
                      </td>
                      <td className="l360-nowrap">{deadline.reminder_days ? `${deadline.reminder_days} days` : '—'}</td>
                      <td>
                        <span className={`status-badge status-${state.slug}`}>
                          {state.label}
                        </span>
                      </td>
                      <td>
                        <div className="l360-actions-cell">
                          <button
                            className="btn btn-secondary btn-small l360-secondary-action"
                            type="button"
                            onClick={() => handleEdit(deadline)}
                          >
                            Edit
                          </button>
                          <button
                            className="btn btn-danger btn-small l360-danger-action"
                            type="button"
                            onClick={() => handleDelete(deadline)}
                          >
                            Delete
                          </button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

import React, { useState, useEffect } from 'react';
import { getDeadlines, getCases, createDeadline, updateDeadline, deleteDeadline } from '../api';

export default function Deadlines() {
  const [deadlines, setDeadlines] = useState([]);
  const [cases, setCases] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [filterStatus, setFilterStatus] = useState('all');
  const [formData, setFormData] = useState({
    title: '',
    deadline_date: '',
    case_id: '',
    reminder_days: 7,
    notes: ''
  });
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
      setDeadlines(deadlinesData);
      setCases(casesData);
    } catch (err) {
      setError('Failed to load data');
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  function handleInputChange(e) {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    try {
      if (editingId) {
        await updateDeadline(editingId, formData);
        setSuccessMsg('Deadline updated successfully');
      } else {
        await createDeadline(formData);
        setSuccessMsg('Deadline created successfully');
      }
      setFormData({
        title: '',
        deadline_date: '',
        case_id: '',
        reminder_days: 7,
        notes: ''
      });
      setEditingId(null);
      setShowForm(false);
      await loadData();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to save deadline');
      console.error(err);
    }
  }

  function handleEdit(deadline) {
    setFormData({
      title: deadline.title,
      deadline_date: deadline.deadline_date,
      case_id: deadline.case_id || '',
      reminder_days: deadline.reminder_days || 7,
      notes: deadline.notes || ''
    });
    setEditingId(deadline.id);
    setShowForm(true);
  }

  async function handleDelete(deadlineId) {
    if (window.confirm('Are you sure you want to delete this deadline?')) {
      try {
        await deleteDeadline(deadlineId);
        setSuccessMsg('Deadline deleted successfully');
        await loadData();
        setTimeout(() => setSuccessMsg(null), 3000);
      } catch (err) {
        setError('Failed to delete deadline');
        console.error(err);
      }
    }
  }

  function handleCancel() {
    setShowForm(false);
    setEditingId(null);
    setFormData({
      title: '',
      deadline_date: '',
      case_id: '',
      reminder_days: 7,
      notes: ''
    });
  }

  function getCaseName(caseId) {
    const caseItem = cases.find(c => c.id === caseId);
    return caseItem ? caseItem.title : '—';
  }

  function getDaysUntil(dateStr) {
    const deadline = new Date(dateStr);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    deadline.setHours(0, 0, 0, 0);
    return Math.ceil((deadline - today) / (1000 * 60 * 60 * 24));
  }

  function getStatusColor(daysUntil, isComplete) {
    if (isComplete) return '#9ca3af';
    if (daysUntil < 0) return '#dc2626';
    if (daysUntil <= 3) return '#dc2626';
    if (daysUntil <= 7) return '#f59e0b';
    return '#16a34a';
  }

  const filteredDeadlines = deadlines.filter(d => {
    if (filterStatus === 'all') return true;
    if (filterStatus === 'overdue') return getDaysUntil(d.deadline_date) < 0 && !d.is_complete;
    if (filterStatus === 'urgent') return getDaysUntil(d.deadline_date) <= 3 && !d.is_complete;
    if (filterStatus === 'upcoming') return getDaysUntil(d.deadline_date) > 3 && !d.is_complete;
    if (filterStatus === 'completed') return d.is_complete;
    return true;
  }).sort((a, b) => new Date(a.deadline_date) - new Date(b.deadline_date));

  if (loading) return <div className="loading"><div className="spinner"></div> Loading deadlines...</div>;

  return (
    <div className="deadlines-page">
      {successMsg && <div className="alert alert-success">{successMsg}</div>}
      {error && <div className="alert alert-error">{error}</div>}

      <div style={{ marginBottom: '20px', display: 'flex', gap: '10px', alignItems: 'center' }}>
        {!showForm ? (
          <button className="btn btn-primary" onClick={() => setShowForm(true)}>
            + Add Deadline
          </button>
        ) : (
          <button className="btn btn-secondary" onClick={handleCancel}>
            ✕ Cancel
          </button>
        )}
        
        <select 
          value={filterStatus}
          onChange={(e) => setFilterStatus(e.target.value)}
          style={{
            padding: '10px 12px',
            border: '1px solid var(--border)',
            borderRadius: '6px',
            fontSize: '14px',
            fontFamily: 'var(--sans)',
            background: 'white',
            cursor: 'pointer'
          }}
        >
          <option value="all">All Deadlines</option>
          <option value="overdue">Overdue</option>
          <option value="urgent">Urgent (≤3 days)</option>
          <option value="upcoming">Upcoming</option>
          <option value="completed">Completed</option>
        </select>
      </div>

      {/* ADD/EDIT FORM */}
      {showForm && (
        <div className="card">
          <h3>{editingId ? 'Edit Deadline' : 'Add New Deadline'}</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Deadline Title *</label>
              <input
                type="text"
                name="title"
                value={formData.title}
                onChange={handleInputChange}
                placeholder="e.g., File Motion for Summary Judgment"
                required
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
              <div className="form-group">
                <label>Due Date *</label>
                <input
                  type="date"
                  name="deadline_date"
                  value={formData.deadline_date}
                  onChange={handleInputChange}
                  required
                />
              </div>
              <div className="form-group">
                <label>Associated Case</label>
                <select
                  name="case_id"
                  value={formData.case_id}
                  onChange={handleInputChange}
                >
                  <option value="">Select a case (optional)</option>
                  {cases.map(c => (
                    <option key={c.id} value={c.id}>{c.title}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="form-group">
              <label>Reminder (days before deadline)</label>
              <input
                type="number"
                name="reminder_days"
                value={formData.reminder_days}
                onChange={handleInputChange}
                min="0"
                max="60"
              />
              <small style={{ color: 'var(--text)', display: 'block', marginTop: '4px' }}>
                System will remind you {formData.reminder_days} day(s) before the deadline
              </small>
            </div>

            <div className="form-group">
              <label>Notes</label>
              <textarea
                name="notes"
                value={formData.notes}
                onChange={handleInputChange}
                placeholder="Additional notes for this deadline..."
              />
            </div>

            <div style={{ display: 'flex', gap: '10px' }}>
              <button type="submit" className="btn btn-primary">
                {editingId ? 'Update Deadline' : 'Create Deadline'}
              </button>
              <button type="button" className="btn btn-secondary" onClick={handleCancel}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* DEADLINES TABLE */}
      <div className="card">
        <h3>Deadlines ({filteredDeadlines.length})</h3>
        {filteredDeadlines.length === 0 ? (
          <p style={{ color: 'var(--text)', margin: '20px 0' }}>No deadlines matching filter.</p>
        ) : (
          <div className="table-container">
            <table className="data-table">
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
                {filteredDeadlines.map(deadline => {
                  const daysUntil = getDaysUntil(deadline.deadline_date);
                  let statusLabel = '';
                  if (deadline.is_complete) statusLabel = 'Completed';
                  else if (daysUntil < 0) statusLabel = 'Overdue';
                  else if (daysUntil <= 3) statusLabel = 'Urgent';
                  else statusLabel = 'On Track';

                  return (
                    <tr key={deadline.id}>
                      <td><strong>{deadline.title}</strong></td>
                      <td>{new Date(deadline.deadline_date).toLocaleDateString()}</td>
                      <td style={{ color: getStatusColor(daysUntil, deadline.is_complete), fontWeight: 'bold' }}>
                        {daysUntil < 0 ? `${Math.abs(daysUntil)} overdue` : `${daysUntil} days`}
                      </td>
                      <td>{getCaseName(deadline.case_id)}</td>
                      <td>{deadline.reminder_days ? `${deadline.reminder_days} days` : '—'}</td>
                      <td>
                        <span className={`status-badge status-${statusLabel.toLowerCase()}`}>
                          {statusLabel}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="btn btn-secondary btn-small"
                          onClick={() => handleEdit(deadline)}
                          style={{ marginRight: '8px' }}
                        >
                          Edit
                        </button>
                        <button 
                          className="btn btn-danger btn-small"
                          onClick={() => handleDelete(deadline.id)}
                        >
                          Delete
                        </button>
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

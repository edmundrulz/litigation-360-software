import React, { useState, useEffect } from 'react';
import { getClients, createClient, updateClient, deleteClient } from '../api';

export default function Clients() {
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [formData, setFormData] = useState({
    full_name: '',
    email: '',
    phone: '',
    address: ''
  });
  const [successMsg, setSuccessMsg] = useState(null);

  useEffect(() => {
    loadClients();
  }, []);

  async function loadClients() {
    try {
      setLoading(true);
      setError(null);
      const data = await getClients();
      setClients(data);
    } catch (err) {
      setError('Failed to load clients');
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
        await updateClient(editingId, formData);
        setSuccessMsg('Client updated successfully');
      } else {
        await createClient(formData);
        setSuccessMsg('Client created successfully');
      }
      setFormData({ full_name: '', email: '', phone: '', address: '' });
      setEditingId(null);
      setShowForm(false);
      await loadClients();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to save client');
      console.error(err);
    }
  }

  function handleEdit(client) {
    setFormData({
      full_name: client.full_name,
      email: client.email || '',
      phone: client.phone || '',
      address: client.address || ''
    });
    setEditingId(client.id);
    setShowForm(true);
  }

  async function handleDelete(clientId) {
    if (window.confirm('Are you sure you want to delete this client?')) {
      try {
        await deleteClient(clientId);
        setSuccessMsg('Client deleted successfully');
        await loadClients();
        setTimeout(() => setSuccessMsg(null), 3000);
      } catch (err) {
        setError('Failed to delete client');
        console.error(err);
      }
    }
  }

  function handleCancel() {
    setShowForm(false);
    setEditingId(null);
    setFormData({ full_name: '', email: '', phone: '', address: '' });
  }

  if (loading) return <div className="loading"><div className="spinner"></div> Loading clients...</div>;

  return (
    <div className="clients-page">
      {successMsg && <div className="alert alert-success">{successMsg}</div>}
      {error && <div className="alert alert-error">{error}</div>}

      <div style={{ marginBottom: '20px' }}>
        {!showForm ? (
          <button className="btn btn-primary" onClick={() => setShowForm(true)}>
            + Add New Client
          </button>
        ) : (
          <button className="btn btn-secondary" onClick={handleCancel}>
            ✕ Cancel
          </button>
        )}
      </div>

      {/* ADD/EDIT FORM */}
      {showForm && (
        <div className="card">
          <h3>{editingId ? 'Edit Client' : 'Add New Client'}</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Full Name *</label>
              <input
                type="text"
                name="full_name"
                value={formData.full_name}
                onChange={handleInputChange}
                placeholder="John Doe"
                required
              />
            </div>
            <div className="form-group">
              <label>Email</label>
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                placeholder="john@example.com"
              />
            </div>
            <div className="form-group">
              <label>Phone</label>
              <input
                type="tel"
                name="phone"
                value={formData.phone}
                onChange={handleInputChange}
                placeholder="(555) 123-4567"
              />
            </div>
            <div className="form-group">
              <label>Address</label>
              <textarea
                name="address"
                value={formData.address}
                onChange={handleInputChange}
                placeholder="123 Main Street, City, State 12345"
              />
            </div>
            <div style={{ display: 'flex', gap: '10px' }}>
              <button type="submit" className="btn btn-primary">
                {editingId ? 'Update Client' : 'Create Client'}
              </button>
              <button type="button" className="btn btn-secondary" onClick={handleCancel}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* CLIENTS TABLE */}
      <div className="card">
        <h3>All Clients ({clients.length})</h3>
        {clients.length === 0 ? (
          <p style={{ color: 'var(--text)', margin: '20px 0' }}>No clients yet.</p>
        ) : (
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Address</th>
                  <th>Created</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {clients.map(client => (
                  <tr key={client.id}>
                    <td><strong>{client.full_name}</strong></td>
                    <td>{client.email || '—'}</td>
                    <td>{client.phone || '—'}</td>
                    <td style={{ maxWidth: '200px', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                      {client.address || '—'}
                    </td>
                    <td>{new Date(client.created_at).toLocaleDateString()}</td>
                    <td>
                      <button 
                        className="btn btn-secondary btn-small"
                        onClick={() => handleEdit(client)}
                        style={{ marginRight: '8px' }}
                      >
                        Edit
                      </button>
                      <button 
                        className="btn btn-danger btn-small"
                        onClick={() => handleDelete(client.id)}
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}

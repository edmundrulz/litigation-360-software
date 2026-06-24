import React, { useState, useEffect } from 'react';
import { getDocuments, getCases, createDocument, deleteDocument } from '../api';

export default function Documents() {
  const [documents, setDocuments] = useState([]);
  const [cases, setCases] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    file_name: '',
    case_id: '',
    document_type: 'Other'
  });
  const [successMsg, setSuccessMsg] = useState(null);

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      setLoading(true);
      setError(null);
      const [docsData, casesData] = await Promise.all([
        getDocuments(),
        getCases()
      ]);
      setDocuments(docsData);
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
      await createDocument(formData);
      setSuccessMsg('Document record created successfully');
      setFormData({
        file_name: '',
        case_id: '',
        document_type: 'Other'
      });
      setShowForm(false);
      await loadData();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to create document record');
      console.error(err);
    }
  }

  async function handleDelete(docId) {
    if (window.confirm('Are you sure you want to delete this document record?')) {
      try {
        await deleteDocument(docId);
        setSuccessMsg('Document deleted successfully');
        await loadData();
        setTimeout(() => setSuccessMsg(null), 3000);
      } catch (err) {
        setError('Failed to delete document');
        console.error(err);
      }
    }
  }

  function handleCancel() {
    setShowForm(false);
    setFormData({
      file_name: '',
      case_id: '',
      document_type: 'Other'
    });
  }

  function getCaseName(caseId) {
    const caseItem = cases.find(c => c.id === caseId);
    return caseItem ? caseItem.title : '—';
  }

  const documentTypes = [
    'Contract',
    'Complaint',
    'Motion',
    'Brief',
    'Deposition',
    'Discovery',
    'Settlement',
    'Court Order',
    'Evidence',
    'Correspondence',
    'Other'
  ];

  if (loading) return <div className="loading"><div className="spinner"></div> Loading documents...</div>;

  return (
    <div className="documents-page">
      {successMsg && <div className="alert alert-success">{successMsg}</div>}
      {error && <div className="alert alert-error">{error}</div>}

      <div style={{ marginBottom: '20px' }}>
        {!showForm ? (
          <button className="btn btn-primary" onClick={() => setShowForm(true)}>
            + Add Document
          </button>
        ) : (
          <button className="btn btn-secondary" onClick={handleCancel}>
            ✕ Cancel
          </button>
        )}
      </div>

      {/* ADD FORM */}
      {showForm && (
        <div className="card">
          <h3>Add Document Record</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>File Name *</label>
              <input
                type="text"
                name="file_name"
                value={formData.file_name}
                onChange={handleInputChange}
                placeholder="e.g., Motion_for_Summary_Judgment_2024.pdf"
                required
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
              <div className="form-group">
                <label>Document Type</label>
                <select
                  name="document_type"
                  value={formData.document_type}
                  onChange={handleInputChange}
                >
                  {documentTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
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

            <div style={{ display: 'flex', gap: '10px' }}>
              <button type="submit" className="btn btn-primary">
                Add Document
              </button>
              <button type="button" className="btn btn-secondary" onClick={handleCancel}>
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      {/* DOCUMENTS TABLE */}
      <div className="card">
        <h3>All Documents ({documents.length})</h3>
        {documents.length === 0 ? (
          <p style={{ color: 'var(--text)', margin: '20px 0' }}>No documents recorded yet.</p>
        ) : (
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>File Name</th>
                  <th>Type</th>
                  <th>Associated Case</th>
                  <th>Uploaded</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {documents.map(doc => (
                  <tr key={doc.id}>
                    <td>
                      <code style={{ background: 'var(--code-bg)', padding: '2px 6px', borderRadius: '3px', fontSize: '12px' }}>
                        {doc.file_name}
                      </code>
                    </td>
                    <td>
                      <span style={{
                        background: '#f0f4ff',
                        color: '#2563eb',
                        padding: '4px 8px',
                        borderRadius: '4px',
                        fontSize: '12px',
                        fontWeight: '500'
                      }}>
                        {doc.document_type || 'Other'}
                      </span>
                    </td>
                    <td>{getCaseName(doc.case_id)}</td>
                    <td>{new Date(doc.uploaded_at).toLocaleDateString()}</td>
                    <td>
                      <button 
                        className="btn btn-danger btn-small"
                        onClick={() => handleDelete(doc.id)}
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

      {/* DOCUMENT STATS */}
      <div className="card" style={{ marginTop: '20px' }}>
        <h3>Document Statistics</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: '16px' }}>
          {documentTypes.map(type => {
            const count = documents.filter(d => d.document_type === type).length;
            return (
              <div key={type} style={{
                background: '#f9fafb',
                padding: '12px',
                borderRadius: '6px',
                borderLeft: '3px solid #2563eb'
              }}>
                <div style={{ fontSize: '12px', color: 'var(--text)' }}>{type}</div>
                <div style={{ fontSize: '20px', fontWeight: 'bold', color: 'var(--text-h)', marginTop: '4px' }}>
                  {count}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

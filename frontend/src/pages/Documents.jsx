import { useState, useEffect } from 'react';
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
  const [searchTerm, setSearchTerm] = useState('');
  const [typeFilter, setTypeFilter] = useState('All');
  const [sortOrder, setSortOrder] = useState('date-desc');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [deletingId, setDeletingId] = useState(null);

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

  function normalizeComparableValue(value) {
    return String(value ?? '').trim();
  }

  function formatUploadedAt(value) {
    if (!value) {
      return '—';
    }

    const parsedDate = new Date(value);
    if (Number.isNaN(parsedDate.getTime())) {
      return '—';
    }

    return parsedDate.toLocaleDateString();
  }

  function getCaseName(caseId) {
    const caseItem = cases.find(c => String(c.id) === String(caseId));
    return caseItem ? caseItem.title : '—';
  }

  async function handleSubmit(e) {
    e.preventDefault();

    if (isSubmitting) {
      return;
    }

    setIsSubmitting(true);
    setError(null);

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
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleDelete(docId) {
    if (!window.confirm('Are you sure you want to delete this document record?')) {
      return;
    }

    if (deletingId === docId) {
      return;
    }

    setDeletingId(docId);
    setError(null);

    try {
      await deleteDocument(docId);
      setSuccessMsg('Document deleted successfully');
      await loadData();
      setTimeout(() => setSuccessMsg(null), 3000);
    } catch (err) {
      setError('Failed to delete document');
      console.error(err);
    } finally {
      setDeletingId(null);
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

  const filteredDocuments = [...documents]
    .filter(doc => {
      const fileName = normalizeComparableValue(doc.file_name).toLowerCase();
      const search = normalizeComparableValue(searchTerm).toLowerCase();
      const docType = doc.document_type || 'Other';

      const matchesSearch = search === '' || fileName.includes(search);
      const matchesType = typeFilter === 'All' || docType === typeFilter;

      return matchesSearch && matchesType;
    })
    .sort((a, b) => {
      if (sortOrder === 'name-asc' || sortOrder === 'name-desc') {
        const aName = normalizeComparableValue(a.file_name).toLowerCase();
        const bName = normalizeComparableValue(b.file_name).toLowerCase();
        return sortOrder === 'name-asc' ? aName.localeCompare(bName) : bName.localeCompare(aName);
      }

      const aTime = new Date(a.uploaded_at).getTime();
      const bTime = new Date(b.uploaded_at).getTime();
      const safeATime = Number.isNaN(aTime) ? 0 : aTime;
      const safeBTime = Number.isNaN(bTime) ? 0 : bTime;

      return sortOrder === 'date-asc' ? safeATime - safeBTime : safeBTime - safeATime;
    });

  if (loading) return <div className="loading"><div className="spinner"></div> Loading documents...</div>;

  return (
    <div className="documents-page">
      {successMsg && <div className="alert alert-success">{successMsg}</div>}
      {error && <div className="alert alert-error">{error}</div>}

      <div style={{ marginBottom: '20px', display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
        {!showForm ? (
          <button className="btn btn-primary" onClick={() => setShowForm(true)}>
            + Add Document
          </button>
        ) : (
          <button className="btn btn-secondary" onClick={handleCancel}>
            ✕ Cancel
          </button>
        )}
        <button
          type="button"
          className="btn btn-secondary"
          onClick={loadData}
          disabled={loading || isSubmitting}
        >
          Refresh
        </button>
      </div>

      <div className="card" style={{ marginBottom: '20px' }}>
        <h3>Document Controls</h3>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '16px' }}>
          <div className="form-group">
            <label>Search by File Name</label>
            <input
              type="text"
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
              placeholder="Filter by filename..."
            />
          </div>

          <div className="form-group">
            <label>Filter by Type</label>
            <select value={typeFilter} onChange={e => setTypeFilter(e.target.value)}>
              <option value="All">All types</option>
              {documentTypes.map(type => (
                <option key={type} value={type}>{type}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Sort</label>
            <select value={sortOrder} onChange={e => setSortOrder(e.target.value)}>
              <option value="date-desc">Uploaded newest first</option>
              <option value="date-asc">Uploaded oldest first</option>
              <option value="name-asc">File name A-Z</option>
              <option value="name-desc">File name Z-A</option>
            </select>
          </div>
        </div>
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
                  placeholder="Enter the filename stored with this document record"
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
              <button type="submit" className="btn btn-primary" disabled={isSubmitting}>
                {isSubmitting ? 'Adding...' : 'Add Document'}
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
        <h3>All Documents ({filteredDocuments.length})</h3>
        {documents.length === 0 ? (
          <p style={{ color: 'var(--text)', margin: '20px 0' }}>No documents recorded yet.</p>
        ) : filteredDocuments.length === 0 ? (
          <p style={{ color: 'var(--text)', margin: '20px 0' }}>No documents match the current search, type filter, or sort view.</p>
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
                {filteredDocuments.map(doc => (
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
                    <td>{formatUploadedAt(doc.uploaded_at)}</td>
                    <td>
                      <button
                        className="btn btn-danger btn-small"
                        onClick={() => handleDelete(doc.id)}
                        disabled={deletingId === doc.id}
                      >
                        {deletingId === doc.id ? 'Deleting...' : 'Delete'}
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

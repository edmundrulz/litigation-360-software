// api.js - Backend API connection layer
// All requests go through here for consistency and error handling

const API_URL = 'http://localhost:5000/api';

function authHeaders() {
  const token = localStorage.getItem("token");
  const headers = { "Content-Type": "application/json" };

  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }

  return headers;
}


// ===== CLIENTS =====
export async function getClients() {
  try {
    const response = await fetch(`${API_URL}/clients`);
    if (!response.ok) throw new Error('Failed to fetch clients');
    return await response.json();
  } catch (error) {
    console.error('getClients error:', error);
    return [];
  }
}

export async function createClient(clientData) {
  try {
    const response = await fetch(`${API_URL}/clients`, {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify(clientData)
    });
    if (!response.ok) throw new Error('Failed to create client');
    return await response.json();
  } catch (error) {
    console.error('createClient error:', error);
    throw error;
  }
}

export async function updateClient(clientId, clientData) {
  try {
    const response = await fetch(`${API_URL}/clients/${clientId}`, {
      method: 'PUT',
      headers: authHeaders(),
      body: JSON.stringify(clientData)
    });
    if (!response.ok) throw new Error('Failed to update client');
    return await response.json();
  } catch (error) {
    console.error('updateClient error:', error);
    throw error;
  }
}

export async function deleteClient(clientId) {
  try {
    const response = await fetch(`${API_URL}/clients/${clientId}`, {
      method: 'DELETE',
      headers: authHeaders()
    });
    if (!response.ok) throw new Error('Failed to delete client');
    return { success: true };
  } catch (error) {
    console.error('deleteClient error:', error);
    throw error;
  }
}

// ===== CASES/MATTERS =====
export async function getCases() {
  try {
    const response = await fetch(`${API_URL}/cases`);
    if (!response.ok) throw new Error('Failed to fetch cases');
    return await response.json();
  } catch (error) {
    console.error('getCases error:', error);
    return [];
  }
}

export async function createCase(caseData) {
  try {
    const response = await fetch(`${API_URL}/cases`, {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify(caseData)
    });
    if (!response.ok) throw new Error('Failed to create case');
    return await response.json();
  } catch (error) {
    console.error('createCase error:', error);
    throw error;
  }
}

export async function updateCase(caseId, caseData) {
  try {
    const response = await fetch(`${API_URL}/cases/${caseId}`, {
      method: 'PUT',
      headers: authHeaders(),
      body: JSON.stringify(caseData)
    });
    if (!response.ok) throw new Error('Failed to update case');
    return await response.json();
  } catch (error) {
    console.error('updateCase error:', error);
    throw error;
  }
}

export async function deleteCase(caseId) {
  try {
    const response = await fetch(`${API_URL}/cases/${caseId}`, {
      method: 'DELETE',
      headers: authHeaders()
    });
    if (!response.ok) throw new Error('Failed to delete case');
    return { success: true };
  } catch (error) {
    console.error('deleteCase error:', error);
    throw error;
  }
}

// ===== DEADLINES =====
export async function getDeadlines() {
  try {
    const response = await fetch(`${API_URL}/deadlines`);
    if (!response.ok) throw new Error('Failed to fetch deadlines');
    return await response.json();
  } catch (error) {
    console.error('getDeadlines error:', error);
    return [];
  }
}

export async function createDeadline(deadlineData) {
  try {
    const response = await fetch(`${API_URL}/deadlines`, {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify(deadlineData)
    });
    if (!response.ok) throw new Error('Failed to create deadline');
    return await response.json();
  } catch (error) {
    console.error('createDeadline error:', error);
    throw error;
  }
}

export async function updateDeadline(deadlineId, deadlineData) {
  try {
    const response = await fetch(`${API_URL}/deadlines/${deadlineId}`, {
      method: 'PUT',
      headers: authHeaders(),
      body: JSON.stringify(deadlineData)
    });
    if (!response.ok) throw new Error('Failed to update deadline');
    return await response.json();
  } catch (error) {
    console.error('updateDeadline error:', error);
    throw error;
  }
}

export async function deleteDeadline(deadlineId) {
  try {
    const response = await fetch(`${API_URL}/deadlines/${deadlineId}`, {
      method: 'DELETE',
      headers: authHeaders()
    });
    if (!response.ok) throw new Error('Failed to delete deadline');
    return { success: true };
  } catch (error) {
    console.error('deleteDeadline error:', error);
    throw error;
  }
}

// ===== DOCUMENTS =====
export async function getDocuments() {
  try {
    const response = await fetch(`${API_URL}/documents`);
    if (!response.ok) throw new Error('Failed to fetch documents');
    return await response.json();
  } catch (error) {
    console.error('getDocuments error:', error);
    return [];
  }
}

export async function createDocument(documentData) {
  try {
    const response = await fetch(`${API_URL}/documents`, {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify(documentData)
    });
    if (!response.ok) throw new Error('Failed to create document');
    return await response.json();
  } catch (error) {
    console.error('createDocument error:', error);
    throw error;
  }
}

export async function deleteDocument(documentId) {
  try {
    const response = await fetch(`${API_URL}/documents/${documentId}`, {
      method: 'DELETE',
      headers: authHeaders()
    });
    if (!response.ok) throw new Error('Failed to delete document');
    return { success: true };
  } catch (error) {
    console.error('deleteDocument error:', error);
    throw error;
  }
}

// ===== HEALTH CHECK =====
export async function healthCheck() {
  try {
    const response = await fetch(`${API_URL}/health`);
    return response.ok;
  } catch (error) {
    return false;
  }
}



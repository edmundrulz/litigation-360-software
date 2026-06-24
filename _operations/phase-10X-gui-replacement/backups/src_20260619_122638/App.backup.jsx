import React, { useState } from 'react';
import './App.css';
import Dashboard from './pages/Dashboard';
import Clients from './pages/Clients';
import Cases from './pages/Cases';
import Deadlines from './pages/Deadlines';
import Documents from './pages/Documents';
import Staff from './pages/Staff';

export default function App() {
  const [currentPage, setCurrentPage] = useState('dashboard');
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className="app-container">
      {/* SIDEBAR NAVIGATION */}
      <nav className="sidebar">
        <div className="sidebar-header">
          <h2>⚖️ Litigation 360</h2>
          <button 
            className="sidebar-toggle"
            onClick={() => setSidebarOpen(!sidebarOpen)}
          >
            {sidebarOpen ? '×' : '☰'}
          </button>
        </div>

        <ul className="nav-menu">
          <li>
            <button 
              className={`nav-link ${currentPage === 'dashboard' ? 'active' : ''}`}
              onClick={() => setCurrentPage('dashboard')}
            >
              📊 Dashboard
            </button>
          </li>
          <li>
            <button 
              className={`nav-link ${currentPage === 'clients' ? 'active' : ''}`}
              onClick={() => setCurrentPage('clients')}
            >
              👥 Clients
            </button>
          </li>
          <li>
            <button
              className={`nav-link ${currentPage === 'staff' ? 'active' : ''}`}
              onClick={() => setCurrentPage('staff')}
            >
              👨‍💼 Staff
            </button>
          </li>
          <li>
            <button 
              className={`nav-link ${currentPage === 'cases' ? 'active' : ''}`}
              onClick={() => setCurrentPage('cases')}
            >
              📋 Cases/Matters
            </button>
          </li>
          <li>
            <button 
              className={`nav-link ${currentPage === 'deadlines' ? 'active' : ''}`}
              onClick={() => setCurrentPage('deadlines')}
            >
              ⏰ Deadlines
            </button>
          </li>
          <li>
            <button 
              className={`nav-link ${currentPage === 'documents' ? 'active' : ''}`}
              onClick={() => setCurrentPage('documents')}
            >
              📄 Documents
            </button>
          </li>
        </ul>

        <div className="sidebar-footer">
          <small>Connected to Backend ✓</small>
        </div>
      </nav>

      {/* MAIN CONTENT */}
      <main className="main-content">
        <div className="page-header">
          <h1>{getPageTitle(currentPage)}</h1>
        </div>

        {currentPage === 'dashboard' && <Dashboard />}
        {currentPage === 'clients' && <Clients />}
        {currentPage === 'staff' && <Staff />} 
        {currentPage === 'cases' && <Cases />}
        {currentPage === 'deadlines' && <Deadlines />}
        {currentPage === 'documents' && <Documents />}
      </main>
    </div>
  );
}

function getPageTitle(page) {
  const titles = {
    dashboard: '📊 Dashboard Overview',
    clients: '👥 Client Management',
    staff: '👨‍💼 Staff Management',
    cases: '📋 Cases & Matters',
    deadlines: '⏰ Deadline Tracking',
    documents: '📄 Document Management'
  };
  return titles[page] || 'Litigation 360';
}
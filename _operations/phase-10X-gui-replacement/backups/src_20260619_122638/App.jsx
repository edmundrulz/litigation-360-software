import React, { useState } from "react";
import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";
import FrontendBackendConnectivityValidator from "./enterprise/pages/FrontendBackendConnectivityValidator";

function LegacyHome() {
  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Litigation 360</h1>
      <p>Frontend shell active.</p>
      <p>Use the buttons above to open the Enterprise Dashboard or Connectivity Validator.</p>
    </div>
  );
}

export default function App() {
  const [view, setView] = useState("enterprise");

  return (
    <div>
      <div style={{
        display: "flex",
        gap: 12,
        alignItems: "center",
        padding: "12px 18px",
        borderBottom: "1px solid #ddd",
        fontFamily: "Arial, sans-serif",
        background: "#f8fafc",
        position: "sticky",
        top: 0,
        zIndex: 10
      }}>
        <strong>Litigation 360</strong>
        <button onClick={() => setView("enterprise")}>Enterprise Dashboard</button>
        <button onClick={() => setView("connectivity")}>Connectivity Validator</button>
        <button onClick={() => setView("home")}>Home</button>
        <span style={{ marginLeft: "auto", fontSize: 12 }}>
          Phase 10U Frontend Backend Connectivity
        </span>
      </div>

      {view === "enterprise" ? (
        <EnterpriseOperationsDashboard />
      ) : view === "connectivity" ? (
        <FrontendBackendConnectivityValidator />
      ) : (
        <LegacyHome />
      )}
    </div>
  );
}

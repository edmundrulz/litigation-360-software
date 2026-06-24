import React from "react";

export default function BackendConnectivityPanel({ report }) {
  if (!report) {
    return <div>Connectivity report not generated yet.</div>;
  }

  return (
    <div style={{ marginTop: 24 }}>
      <h2>Backend Connectivity Report</h2>
      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
        gap: 12
      }}>
        {report.results.map((item) => (
          <div key={item.key} style={{
            border: "1px solid #ddd",
            borderRadius: 10,
            padding: 12,
            background: item.ok ? "#d1fae5" : "#fee2e2"
          }}>
            <strong>{item.label}</strong>
            <div>Status: {item.status}</div>
            <div>HTTP: {item.httpStatus}</div>
            <div>Time: {item.durationMs} ms</div>
            <div style={{ fontSize: 11, marginTop: 6 }}>{item.path}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

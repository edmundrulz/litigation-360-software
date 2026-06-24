import React from "react";

export default function EnterpriseStatusCard({ title, status, value }) {
  const normalized = String(status || "UNKNOWN").toUpperCase();
  const background =
    normalized === "HEALTHY" || normalized === "READY" || normalized === "PASS"
      ? "#d1fae5"
      : normalized === "ATTENTION" || normalized === "WARNING"
      ? "#fef3c7"
      : "#fee2e2";

  return (
    <div style={{ border: "1px solid #ddd", borderRadius: 12, padding: 16, background, minHeight: 110 }}>
      <h3 style={{ margin: "0 0 8px 0" }}>{title}</h3>
      <div style={{ fontSize: 20, fontWeight: 700 }}>{status || "UNKNOWN"}</div>
      {value !== undefined && <div style={{ marginTop: 6 }}>{value}</div>}
    </div>
  );
}

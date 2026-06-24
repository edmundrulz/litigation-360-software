import React, { useEffect, useState } from "react";

export default function SystemDashboard() {

  const [data, setData] = useState(null);

  async function load() {
    try {
      const res = await fetch("/api/monitor");
      const json = await res.json();
      setData(json);
    } catch (err) {
      console.error("Dashboard error:", err);
    }
  }

  useEffect(() => {
    load();
    const t = setInterval(load, 3000);
    return () => clearInterval(t);
  }, []);

  if (!data) return <div>Loading system...</div>;

  return (
    <div style={{ padding: 20 }}>

      <h2>🧠 SYSTEM CONTROL CENTER</h2>

      <h3>Status: {data.status}</h3>
      <p>Uptime: {Math.floor(data.uptime)}s</p>
      <p>Total Errors: {data.errorCount}</p>
      <p>Critical: {data.criticalCount}</p>

      <h4>Memory</h4>
      <pre>{JSON.stringify(data.memory, null, 2)}</pre>

      <h4>Recent Errors</h4>
      <pre>{JSON.stringify(data.lastErrors, null, 2)}</pre>

    </div>
  );
}
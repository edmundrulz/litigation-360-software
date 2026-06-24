import React, { useEffect, useState } from "react";
import { fetchAllCases } from "../services/caseService";
import { fetchAllStaff } from "../services/staffService";
import { fetchAllClients } from "../services/clientService";

export default function ProjectDashboard() {

  const [cases, setCases] = useState([]);
  const [staff, setStaff] = useState([]);
  const [clients, setClients] = useState([]);

  const [loading, setLoading] = useState(true);

  useEffect(() => {
    load();
  }, []);

  async function load() {
    try {
      setLoading(true);

      const [c, s, cl] = await Promise.all([
        fetchAllCases(),
        fetchAllStaff(),
        fetchAllClients()
      ]);

      setCases(c);
      setStaff(s);
      setClients(cl);

    } catch (err) {
      console.error("Dashboard load error:", err);
    } finally {
      setLoading(false);
    }
  }

  const completedCases = cases.filter(c => c.status === "CLOSED").length;
  const openCases = cases.length - completedCases;

  const totalWorkload = staff.reduce((sum, s) => sum + (s.workload || 0), 0);

  const completionRate =
    cases.length === 0 ? 0 : Math.round((completedCases / cases.length) * 100);

  if (loading) return <div>Loading Dashboard...</div>;

  return (
    <div style={{ padding: 20 }}>

      <h2>📊 Project Dashboard</h2>

      {/* KPI CARDS */}
      <div style={{ display: "flex", gap: 20 }}>

        <div>
          <h3>Cases</h3>
          <p>Total: {cases.length}</p>
          <p>Open: {openCases}</p>
          <p>Closed: {completedCases}</p>
        </div>

        <div>
          <h3>Clients</h3>
          <p>Total: {clients.length}</p>
        </div>

        <div>
          <h3>Staff</h3>
          <p>Total: {staff.length}</p>
          <p>Workload: {totalWorkload}</p>
        </div>

        <div>
          <h3>Progress</h3>
          <p>{completionRate}% Complete</p>
        </div>

      </div>

      {/* VISUAL BAR */}
      <div style={{ marginTop: 20 }}>
        <div style={{
          width: "100%",
          background: "#ddd",
          height: 20
        }}>
          <div style={{
            width: `${completionRate}%`,
            background: "green",
            height: "100%"
          }} />
        </div>
      </div>

    </div>
  );
}
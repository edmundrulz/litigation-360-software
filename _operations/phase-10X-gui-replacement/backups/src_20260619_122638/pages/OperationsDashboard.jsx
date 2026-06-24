import React, { useEffect, useState } from "react";
import {
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer
} from "recharts";

export default function OperationsDashboard() {
  const [data, setData] = useState(null);

  async function loadDashboard() {
    try {
      const res = await fetch("/api/dashboard");
      const json = await res.json();
      setData(json);
    } catch (err) {
      console.error("Dashboard load error:", err);
    }
  }

  useEffect(() => {
    loadDashboard();
    const timer = setInterval(loadDashboard, 10000);
    return () => clearInterval(timer);
  }, []);

  if (!data) {
    return <div style={pageStyle}>Loading Operations Dashboard...</div>;
  }

  const green = "#16a34a";
  const orange = "#f59e0b";
  const red = "#dc2626";
  const blue = "#2563eb";

  function getColor(value) {
    if (value >= 80) return green;
    if (value >= 50) return orange;
    return red;
  }

  function Card({ title, value, icon }) {
    return (
      <div style={cardStyle}>
        <div style={cardTitleStyle}>
          <span>{icon}</span>
          <span>{title}</span>
        </div>
        <div style={cardValueStyle}>{value}</div>
      </div>
    );
  }

  function Gauge({ label, value }) {
    const color = getColor(value);

    return (
      <div style={gaugeCardStyle}>
        <div
          style={{
            ...gaugeCircleStyle,
            borderColor: color
          }}
        >
          <span style={gaugeValueStyle}>{value}%</span>
        </div>

        <div style={gaugeLabelStyle}>{label}</div>
      </div>
    );
  }

  function ProgressBar({ label, value }) {
    return (
      <div style={progressWrapperStyle}>
        <div style={progressHeaderStyle}>
          <span>{label}</span>
          <span>{value}%</span>
        </div>

        <div style={progressTrackStyle}>
          <div
            style={{
              ...progressFillStyle,
              width: `${value}%`,
              background: getColor(value)
            }}
          />
        </div>
      </div>
    );
  }

  const progressData = [
    { name: "Backend", value: data.progress.backendFoundation },
    { name: "Database", value: data.progress.databaseLayer },
    { name: "Monitoring", value: data.progress.monitoringLayer },
    { name: "Integrity", value: data.progress.integrityLayer },
    { name: "Auto-Heal", value: data.progress.autoHealLayer },
    { name: "Dashboard", value: data.progress.operationsDashboard },
    { name: "Security", value: data.progress.securityLayer },
    { name: "AI", value: data.progress.aiLayer }
  ];

  const casePieData = [
    { name: "Open", value: data.counts.openCases },
    { name: "Closed", value: data.counts.closedCases }
  ];

  const errorPieData = [
    { name: "Errors", value: data.errors.total },
    { name: "Healthy", value: data.errors.total === 0 ? 1 : 0 }
  ];

  return (
    <div style={pageStyle}>
      <section style={heroStyle}>
        <div>
          <div style={smallLabelStyle}>Operations Command Center</div>
          <h2 style={titleStyle}>Litigation 360 System Control</h2>
        </div>

        <div style={statusBoxStyle}>
          <div style={statusTextStyle}>
            {data.system.status === "HEALTHY" ? "🟢" : "🔴"} {data.system.status}
          </div>
          <div style={updatedStyle}>
            Updated: {new Date(data.timestamp).toLocaleString()}
          </div>
        </div>
      </section>

      <section style={sectionStyle}>
        <div style={gaugeGridStyle}>
          <Gauge label="Health Score" value={data.system.healthScore} />
          <Gauge label="Integrity Score" value={data.system.integrityScore} />
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Live System Counters</h3>

        <div style={counterGridStyle}>
          <Card title="Cases" value={data.counts.totalCases} icon="📋" />
          <Card title="Clients" value={data.counts.totalClients} icon="👥" />
          <Card title="Staff" value={data.counts.totalStaff} icon="👨‍💼" />
          <Card title="Assignments" value={data.counts.totalAssignments} icon="🔗" />
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Charts</h3>

        <div style={chartGridStyle}>
          <div style={panelStyle}>
            <h4 style={panelTitleStyle}>📊 Case Status</h4>
            <ResponsiveContainer width="100%" height={260}>
              <PieChart>
                <Pie data={casePieData} dataKey="value" nameKey="name" outerRadius={90} label>
                  <Cell fill={orange} />
                  <Cell fill={green} />
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>

          <div style={panelStyle}>
            <h4 style={panelTitleStyle}>🛡 Error Status</h4>
            <ResponsiveContainer width="100%" height={260}>
              <PieChart>
                <Pie data={errorPieData} dataKey="value" nameKey="name" outerRadius={90} label>
                  <Cell fill={red} />
                  <Cell fill={green} />
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Enterprise Progress Chart</h3>

        <div style={panelStyle}>
          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={progressData}>
              <XAxis dataKey="name" />
              <YAxis domain={[0, 100]} />
              <Tooltip />
              <Bar dataKey="value" fill={blue} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Progress Bars</h3>

        <div style={panelStyle}>
          {progressData.map(item => (
            <ProgressBar key={item.name} label={item.name} value={item.value} />
          ))}
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Scheduler / Self-Monitoring</h3>

        <div style={counterGridStyle}>
          <Card title="Integrity Runs" value={data.scheduler.integrityRuns} icon="🔍" />
          <Card title="Auto-Heal Runs" value={data.scheduler.autoHealRuns} icon="🛠️" />
          <Card title="Repairs Done" value={data.scheduler.repairsPerformed} icon="✅" />
          <Card title="Memory MB" value={data.system.memoryMb} icon="💾" />
        </div>

        <div style={panelStyle}>
          <p>Last Integrity Scan: {data.scheduler.lastIntegrityScan || "Not yet"}</p>
          <p>Last Auto-Heal: {data.scheduler.lastAutoHeal || "Not yet"}</p>
          <p>Uptime: {Math.floor(data.system.uptimeSeconds)} seconds</p>
        </div>
      </section>

      <section style={sectionStyle}>
        <h3 style={sectionTitleStyle}>Alerts</h3>

        <div
          style={{
            ...panelStyle,
            background: data.errors.total === 0 ? "#dcfce7" : "#fee2e2"
          }}
        >
          {data.errors.total === 0 ? (
            <h3 style={{ margin: 0 }}>🟢 No system errors detected</h3>
          ) : (
            <>
              <h3>🔴 {data.errors.total} error(s) detected</h3>
              <pre>{JSON.stringify(data.errors.latest, null, 2)}</pre>
            </>
          )}
        </div>
      </section>
    </div>
  );
}

const pageStyle = {
  width: "100%",
  maxWidth: 1200,
  margin: "0 auto",
  padding: "24px",
  fontFamily: "Arial, sans-serif",
  background: "#f8fafc",
  boxSizing: "border-box",
  overflowX: "hidden"
};

const heroStyle = {
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center",
  gap: 20,
  padding: "20px 24px",
  background: "#fff",
  border: "1px solid #e5e7eb",
  borderRadius: 18,
  marginBottom: 28
};

const smallLabelStyle = {
  fontSize: 14,
  fontWeight: 700,
  color: "#64748b",
  textTransform: "uppercase",
  letterSpacing: 1,
  marginBottom: 6
};

const titleStyle = {
  fontSize: 34,
  lineHeight: 1.15,
  margin: 0,
  color: "#0f172a"
};

const statusBoxStyle = {
  minWidth: 230,
  textAlign: "right"
};

const statusTextStyle = {
  fontSize: 24,
  fontWeight: 800,
  color: "#0f172a"
};

const updatedStyle = {
  fontSize: 14,
  color: "#64748b",
  marginTop: 6
};

const sectionStyle = {
  marginBottom: 34
};

const sectionTitleStyle = {
  fontSize: 24,
  lineHeight: 1.2,
  margin: "0 0 16px 0",
  color: "#0f172a"
};

const gaugeGridStyle = {
  display: "grid",
  gridTemplateColumns: "repeat(2, minmax(0, 1fr))",
  gap: 24
};

const counterGridStyle = {
  display: "grid",
  gridTemplateColumns: "repeat(4, minmax(0, 1fr))",
  gap: 20
};

const chartGridStyle = {
  display: "grid",
  gridTemplateColumns: "repeat(2, minmax(0, 1fr))",
  gap: 24
};

const panelStyle = {
  background: "#fff",
  border: "1px solid #e5e7eb",
  borderRadius: 16,
  padding: 22,
  boxSizing: "border-box"
};

const panelTitleStyle = {
  margin: "0 0 14px 0",
  fontSize: 20,
  color: "#0f172a"
};

const gaugeCardStyle = {
  ...panelStyle,
  minHeight: 260,
  display: "flex",
  flexDirection: "column",
  alignItems: "center",
  justifyContent: "center"
};

const gaugeCircleStyle = {
  width: 150,
  height: 150,
  borderRadius: "50%",
  border: "16px solid #16a34a",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  boxSizing: "border-box"
};

const gaugeValueStyle = {
  fontSize: 30,
  fontWeight: 800,
  color: "#0f172a"
};

const gaugeLabelStyle = {
  marginTop: 18,
  fontSize: 20,
  fontWeight: 700,
  color: "#334155"
};

const cardStyle = {
  background: "#fff",
  border: "1px solid #e5e7eb",
  borderRadius: 16,
  padding: 20,
  minHeight: 145,
  display: "flex",
  flexDirection: "column",
  alignItems: "center",
  justifyContent: "space-between",
  textAlign: "center",
  boxSizing: "border-box"
};

const cardTitleStyle = {
  minHeight: 48,
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  gap: 8,
  fontSize: 20,
  fontWeight: 700,
  color: "#334155",
  textAlign: "center"
};

const cardValueStyle = {
  fontSize: 54,
  lineHeight: 1,
  fontWeight: 800,
  color: "#0f172a"
};

const progressWrapperStyle = {
  marginBottom: 16
};

const progressHeaderStyle = {
  display: "flex",
  justifyContent: "space-between",
  marginBottom: 6,
  fontSize: 15,
  color: "#0f172a"
};

const progressTrackStyle = {
  background: "#e5e7eb",
  height: 16,
  borderRadius: 999,
  overflow: "hidden"
};

const progressFillStyle = {
  height: "100%",
  borderRadius: 999
};
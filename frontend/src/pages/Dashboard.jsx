export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>

      <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: "10px" }}>

        <Card title="Open Matters" value="--" />
        <Card title="Pending" value="--" />
        <Card title="Clients" value="--" />
        <Card title="Invoices" value="--" />

      </div>
    </div>
  );
}

function Card({ title, value }) {
  return (
    <div style={{
      background: "white",
      padding: "15px",
      borderRadius: "8px"
    }}>
      <h4>{title}</h4>
      <h2>{value}</h2>
    </div>
  );
}
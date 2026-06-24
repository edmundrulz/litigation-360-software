import { Link, Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <div style={{ display: "flex", height: "100vh" }}>

      {/* Sidebar */}
      <div style={{
        width: "220px",
        background: "#111827",
        color: "white",
        padding: "20px"
      }}>
        <h2>⚖️ Litigation 360</h2>

        <nav style={{ marginTop: "20px", display: "flex", flexDirection: "column", gap: "10px" }}>
          <Link to="/" style={{ color: "white" }}>Dashboard</Link>
          <Link to="/matters" style={{ color: "white" }}>Matters</Link>
          <Link to="/clients" style={{ color: "white" }}>Clients</Link>
        </nav>
      </div>

      {/* Main Content */}
      <div style={{ flex: 1, padding: "20px", background: "#f3f4f6" }}>
        <Outlet />
      </div>

    </div>
  );
}
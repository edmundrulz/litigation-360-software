import { Link, Outlet, useLocation } from "react-router-dom";
import "../App.css";

const navItems = [
  { to: "/", label: "Dashboard" },
  { to: "/matters", label: "Matters" },
  { to: "/clients", label: "Clients" },
];

export default function Layout() {
  const location = useLocation();

  return (
    <div className="shell">
      <aside className="sidebar">
        <div className="brand">Litigation 360</div>

        <nav className="sidebar-nav" aria-label="Main navigation">
          {navItems.map(({ to, label }) => {
            const isActive =
              to === "/"
                ? location.pathname === "/"
                : location.pathname.startsWith(to);

            return (
              <Link
                key={to}
                to={to}
                className={`sidebar-nav-item${isActive ? " active" : ""}`}
              >
                {label}
              </Link>
            );
          })}
        </nav>
      </aside>

      <main className="main">
        <Outlet />
      </main>
    </div>
  );
}

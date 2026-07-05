import React, { useEffect, useState } from "react";

function Staff() {
  const [staff, setStaff] = useState([]);
  const [search, setSearch] = useState("");
  const [form, setForm] = useState({
    full_name: "",
    role: "",
    email: "",
    phone: "",
    nric: "",
  });

  useEffect(() => {
    loadStaff();
  }, []);

  const loadStaff = async () => {
    const res = await fetch("http://localhost:5000/api/staff");
    const data = await res.json();
    setStaff(data);
  };

  const addStaff = async () => {
    const res = await fetch("http://localhost:5000/api/staff", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(form),
    });

    const data = await res.json();

    if (data.error) {
      alert(data.error);
      return;
    }

    setForm({
      full_name: "",
      role: "",
      email: "",
      phone: "",
      nric: "",
    });

    loadStaff();
  };

  const filteredStaff = staff.filter((member) => {
    const searchValue = search.toLowerCase();

    return (
      member.full_name?.toLowerCase().includes(searchValue) ||
      member.role?.toLowerCase().includes(searchValue) ||
      member.email?.toLowerCase().includes(searchValue)
    );
  });

  return (
    <div className="staff-page">
      <div className="staff-header">
        <div>
          <p className="staff-kicker">Administration</p>
          <h2>👨‍💼 Staff Registry</h2>
          <p className="staff-subtitle">
            Manage staff records, roles, and contact visibility from one controlled registry.
          </p>
        </div>

        <div className="staff-summary-card">
          <span className="staff-summary-label">Total Staff</span>
          <strong>{staff.length}</strong>
          <span className="staff-summary-note">
            {filteredStaff.length} currently shown
          </span>
        </div>
      </div>

      <div className="staff-card staff-toolbar-card">
        <div>
          <h3>Search Staff</h3>
          <p>Filter staff by name, role, or email without changing stored records.</p>
        </div>

        <input
          className="staff-search-input"
          placeholder="Search staff by name, role, or email..."
          value={search}
          onChange={(event) => setSearch(event.target.value)}
        />
      </div>

      <div className="staff-card">
        <div className="staff-section-heading">
          <h3>Add Staff</h3>
          <p>Create a new staff registry entry using the existing approved fields.</p>
        </div>

        <div className="staff-form-grid">
          <label>
            <span>Full Name</span>
            <input
              placeholder="Full Name"
              value={form.full_name}
              onChange={(event) =>
                setForm({ ...form, full_name: event.target.value })
              }
            />
          </label>

          <label>
            <span>Role</span>
            <select
              value={form.role}
              onChange={(event) => setForm({ ...form, role: event.target.value })}
            >
              <option value="">Select Role</option>
              <option value="administrator">Administrator</option>
              <option value="managing_partner">Managing Partner</option>
              <option value="senior_lawyer">Senior Lawyer</option>
              <option value="junior_lawyer">Junior Lawyer</option>
              <option value="external_consultant">External Consultant</option>
              <option value="legal_assistant">Legal Assistant</option>
              <option value="chambering_student">Chambering Student</option>
              <option value="accountant_auditor">Accountant / Auditor</option>
              <option value="guest">Guest</option>
            </select>
          </label>

          <label>
            <span>Email</span>
            <input
              placeholder="Email"
              value={form.email}
              onChange={(event) => setForm({ ...form, email: event.target.value })}
            />
          </label>

          <label>
            <span>Phone</span>
            <input
              placeholder="Phone"
              value={form.phone}
              onChange={(event) => setForm({ ...form, phone: event.target.value })}
            />
          </label>

          <label>
            <span>NRIC</span>
            <input
              placeholder="NRIC"
              value={form.nric}
              onChange={(event) => setForm({ ...form, nric: event.target.value })}
            />
          </label>
        </div>

        <div className="staff-actions">
          <button className="staff-primary-button" type="button" onClick={addStaff}>
            Add Staff
          </button>
        </div>
      </div>

      <div className="staff-card">
        <div className="staff-section-heading">
          <h3>Staff Members</h3>
          <p>Review the current staff list and contact details.</p>
        </div>

        <div className="staff-table-wrap">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Role</th>
                <th>Email</th>
                <th>Phone</th>
              </tr>
            </thead>

            <tbody>
              {filteredStaff.length === 0 ? (
                <tr>
                  <td colSpan="4">
                    <div className="staff-empty-state">
                      No staff records match the current search.
                    </div>
                  </td>
                </tr>
              ) : (
                filteredStaff.map((member) => (
                  <tr key={member.id}>
                    <td>{member.full_name}</td>
                    <td>{member.role}</td>
                    <td>{member.email}</td>
                    <td>{member.phone}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default Staff;

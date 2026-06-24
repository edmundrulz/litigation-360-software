import { useEffect, useState } from 'react';

export default function Staff() {
  const [staff, setStaff] = useState([]);
  const [search, setSearch] = useState('');

  const [form, setForm] = useState({
    full_name: '',
    role: '',
    email: '',
    phone: '',
    nric: ''
  });

  useEffect(() => {
    loadStaff();
  }, []);

  const loadStaff = async () => {
    try {
      const response = await fetch(
        'http://localhost:5000/api/staff'
      );

      const data = await response.json();

      setStaff(data);
    } catch (error) {
      console.error(error);
    }
  };

  const addStaff = async () => {
    try {
      const response = await fetch(
        'http://localhost:5000/api/staff',
        {
          method: 'POST',
          headers: {
            'Content-Type':
              'application/json'
          },
          body: JSON.stringify(form)
        }
      );

      const data =
        await response.json();

      if (data.error) {
        alert(data.error);
        return;
      }

      setForm({
        full_name: '',
        role: '',
        email: '',
        phone: '',
        nric: ''
      });

      loadStaff();

    } catch (error) {
      console.error(error);
    }
  };

  const filteredStaff =
    staff.filter((person) => {

      const searchTerm =
        search.toLowerCase();

      return (
        person.full_name
          ?.toLowerCase()
          .includes(searchTerm) ||

        person.role
          ?.toLowerCase()
          .includes(searchTerm) ||

        person.email
          ?.toLowerCase()
          .includes(searchTerm)
      );
    });

  return (
    <div>

      <h2>👨‍💼 Staff Registry</h2>

      <br />

      <input
        type="text"
        placeholder="Search Staff..."
        value={search}
        onChange={(e) =>
          setSearch(e.target.value)
        }
      />

<hr />

<h3>Add Staff</h3>

<input
  placeholder="Full Name"
  value={form.full_name}
  onChange={(e) =>
    setForm({
      ...form,
      full_name: e.target.value
    })
  }
/>

<select
  value={form.role}
  onChange={(e) =>
    setForm({
      ...form,
      role: e.target.value
    })
  }
>
  <option value="">
    Select Role
  </option>

  <option value="administrator">
    Administrator
  </option>

  <option value="managing_partner">
    Managing Partner
  </option>

  <option value="senior_lawyer">
    Senior Lawyer
  </option>

  <option value="junior_lawyer">
    Junior Lawyer
  </option>

  <option value="external_consultant">
    External Legal Collaborating Consultant
  </option>

  <option value="legal_assistant">
    Legal Assistant Clerk
  </option>

  <option value="chambering_student">
    Chambering Student
  </option>

  <option value="accountant_auditor">
    Accountant / Auditor
  </option>

  <option value="guest">
    Guest User
  </option>
</select>

      <input
        placeholder="Email"
        value={form.email}
        onChange={(e) =>
          setForm({
            ...form,
            email:
              e.target.value
          })
        }
      />

      <input
        placeholder="Phone"
        value={form.phone}
        onChange={(e) =>
          setForm({
            ...form,
            phone:
              e.target.value
          })
        }
      />

      <input
        placeholder="NRIC"
        value={form.nric}
        onChange={(e) =>
          setForm({
            ...form,
            nric:
              e.target.value
          })
        }
      />

      <button onClick={addStaff}>
        Add Staff
      </button>

      <hr />

      <h3>Staff Members</h3>

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

          {filteredStaff.map(
            (person) => (
              <tr key={person.id}>
                <td>
                  {person.full_name}
                </td>

                <td>
                  {person.role}
                </td>

                <td>
                  {person.email}
                </td>

                <td>
                  {person.phone}
                </td>
              </tr>
            )
          )}

        </tbody>
      </table>

    </div>
  );
}
import { useEffect, useState } from "react";
import api from "../services/api";

export default function Matters() {
  const [matters, setMatters] = useState([]);

  useEffect(() => {
    api.get("/matters")
      .then(res => setMatters(res.data.data))
      .catch(err => console.log(err));
  }, []);

  return (
    <div>
      <h1>Matters</h1>

      <table border="1" cellPadding="10" style={{ background: "white" }}>
        <thead>
          <tr>
            <th>Title</th>
            <th>Status</th>
            <th>Practice Area</th>
            <th>Court</th>
          </tr>
        </thead>

        <tbody>
          {matters.map(m => (
            <tr key={m.id}>
              <td>{m.title}</td>
              <td>{m.status}</td>
              <td>{m.practiceArea}</td>
              <td>{m.courtName}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
import axios from "axios";

const API_URL = "/api";

export async function fetchAllStaff() {
  const res = await axios.get(`${API_URL}/staff`);
  return res.data;
}
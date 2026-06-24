import axios from "axios";

const API_URL = "/api";

export async function assignCaseToStaff(caseId, staffId) {
  const res = await axios.post(
    `${API_URL}/cases/assign`,
    {
      case_id: caseId,
      staff_id: staffId
    }
  );

  return res.data;
}
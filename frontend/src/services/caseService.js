import {
  getCases,
  createCase,
  updateCase,
  deleteCase
} from "../api";

// PURE DATA LAYER (NO UI LOGIC)

export async function fetchAllCases() {
  return await getCases();
}

export async function addCase(data) {
  return await createCase(data);
}

export async function editCase(id, data) {
  return await updateCase(id, data);
}

export async function removeCase(id) {
  return await deleteCase(id);
}
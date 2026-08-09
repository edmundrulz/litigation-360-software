const BASE_URL = "http://localhost:5000/api/legal-authorities";

function headers(json = false) {
  const token = window.sessionStorage.getItem("l360_adaptive_auth_token");
  return { ...(json ? { "Content-Type": "application/json" } : {}), ...(token ? { Authorization: `Bearer ${token}` } : {}) };
}

async function request(path, options = {}) {
  const response = await fetch(`${BASE_URL}${path}`, { ...options, headers: { ...headers(Boolean(options.body)), ...(options.headers || {}) } });
  const body = await response.json().catch(() => ({}));
  if (!response.ok) { const error = new Error(body.error || `Request failed (${response.status})`); error.status = response.status; error.code = body.code; throw error; }
  return body;
}

export const legalAuthoritiesApi = {
  health: () => request("/health"), summary: () => request("/summary"),
  sources: (query = "") => request(`/sources${query ? `?q=${encodeURIComponent(query)}` : ""}`),
  authorityTypes: () => request("/authority-types"),
  seedFoundation: () => request("/admin/seed-foundation", { method: "POST" }),
  updateSource: (sourceId, patch) => request(`/admin/sources/${encodeURIComponent(sourceId)}`, { method: "PATCH", body: JSON.stringify(patch) }),
};

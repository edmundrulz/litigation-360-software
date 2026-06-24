const BASE_URL = "/api/enterprise/operations-analytics";

async function readJson(path) {
  const response = await fetch(`${BASE_URL}${path}`);
  if (!response.ok) throw new Error(`Operations analytics API failed: ${response.status}`);
  return response.json();
}

export const operationsAnalyticsApi = {
  health: () => readJson("/health"),
  metrics: () => readJson("/metrics"),
  snapshot: () => readJson("/snapshot"),
  dashboard: () => readJson("/dashboard"),
  performance: () => readJson("/performance"),
  courts: () => readJson("/courts"),
  deployment: () => readJson("/deployment"),
  reports: () => readJson("/reports")
};

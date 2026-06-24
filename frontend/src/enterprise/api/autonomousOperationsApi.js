const BASE_URL = '/api/enterprise/autonomous';

export async function getAutonomousHealth() {
  const response = await fetch(`${BASE_URL}/health`);
  return response.json();
}

export async function getAutonomousMetrics() {
  const response = await fetch(`${BASE_URL}/metrics`);
  return response.json();
}

export async function getAutonomousDashboard() {
  const response = await fetch(`${BASE_URL}/dashboard`);
  return response.json();
}

export async function getAutonomousDecisions() {
  const response = await fetch(`${BASE_URL}/decisions`);
  return response.json();
}

export async function getAutonomousWatchdog() {
  const response = await fetch(`${BASE_URL}/watchdog`);
  return response.json();
}

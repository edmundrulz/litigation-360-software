export function formatClientName(clients, clientId) {
  const client = clients.find(c => String(c.id) === String(clientId));
  return client ? client.full_name : "—";
}

export function formatStatus(status) {
  return (status || "UNKNOWN")
    .toUpperCase()
    .replace(/\s+/g, "_");
}
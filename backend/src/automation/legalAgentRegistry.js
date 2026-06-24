const agents = [
  { id: "AGT-LEGAL-OPS", name: "Legal Operations Agent", status: "READY" },
  { id: "AGT-COURT", name: "Court Operations Agent", status: "READY" },
  { id: "AGT-INDUSTRIAL-COURT", name: "Industrial Court Agent", status: "READY" },
  { id: "AGT-PERKESO", name: "PERKESO Agent", status: "READY" },
  { id: "AGT-DOCUMENT", name: "Document Intelligence Agent", status: "READY" },
  { id: "AGT-GOVERNANCE", name: "Governance Agent", status: "READY" },
  { id: "AGT-EXECUTIVE", name: "Executive Command Agent", status: "READY" }
];

function listAgents() {
  return agents;
}

function agentDashboard() {
  return {
    totalAgents: agents.length,
    readyAgents: agents.filter(a => a.status === "READY").length,
    agents
  };
}

module.exports = { listAgents, agentDashboard };

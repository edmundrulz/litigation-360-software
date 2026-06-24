function forecastWorkload() {
  return {
    currentMatters: 42,
    expectedNext30Days: 61,
    increasePercent: 45,
    recommendation: "Allocate additional legal operations capacity"
  };
}

function forecastCourtDeadlines() {
  return {
    industrialCourt: {
      location: "Industrial Court Kuala Lumpur",
      riskScore: 92,
      reminders: ["hearing", "filing", "attendance", "navigation departure"]
    },
    perkeso: {
      locations: ["PERKESO Kuala Lumpur / Jalan Tun Razak", "PERKESO Headquarters / Jalan Ampang"],
      riskScore: 88,
      reminders: ["meeting", "submission", "appointment", "navigation"]
    }
  };
}

function forecastDeployment() {
  return {
    successProbability: 84,
    risk: "MEDIUM",
    recommendation: "Run deployment gatekeeper and release validator"
  };
}

module.exports = { forecastWorkload, forecastCourtDeadlines, forecastDeployment };

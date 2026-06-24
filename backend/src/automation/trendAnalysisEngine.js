function analyseTrends() {
  return {
    trendId: "TRD-10Z3-001",
    status: "ACTIVE",
    trends: [
      { area: "WORKLOAD", direction: "INCREASING", riskScore: 72 },
      { area: "COURT_DEADLINES", direction: "INCREASING", riskScore: 91 },
      { area: "PERKESO_SUBMISSIONS", direction: "INCREASING", riskScore: 88 },
      { area: "DEPLOYMENT", direction: "STABLE", riskScore: 76 },
      { area: "PERFORMANCE", direction: "INCREASING", riskScore: 71 }
    ]
  };
}

module.exports = { analyseTrends };

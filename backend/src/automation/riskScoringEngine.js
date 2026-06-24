function classifyRisk(score) {
  const s = Number(score || 0);
  if (s >= 90) return "CRITICAL";
  if (s >= 70) return "HIGH";
  if (s >= 40) return "MEDIUM";
  return "LOW";
}

function scoreRisk(input = {}) {
  const base = Number(input.base || 50);
  const urgency = Number(input.urgency || 0);
  const impact = Number(input.impact || 0);
  const score = Math.max(0, Math.min(100, base + urgency + impact));
  return {
    score,
    severity: classifyRisk(score),
    executiveAttention: score >= 90
  };
}

module.exports = { classifyRisk, scoreRisk };

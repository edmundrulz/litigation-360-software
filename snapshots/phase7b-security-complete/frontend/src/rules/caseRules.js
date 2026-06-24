export function calculateCasePriority(caseData, clientData) {
  let score = 0;

  // Retainer client
  if (clientData?.is_retainer) {
    score += 30;
  }

  // High value client
  if (clientData?.lifetime_value > 10000) {
    score += 20;
  }

  // Referral client
  if (clientData?.is_referral) {
    score += 10;
  }

  // Case urgency
  if (caseData?.priority === "HIGH") {
    score += 25;
  }

  // Case type weighting
  if (caseData?.type === "litigation") {
    score += 15;
  }

  // Risk penalty
  if (clientData?.late_payments > 2) {
    score -= 20;
  }

  return Math.max(0, Math.min(100, score));
}
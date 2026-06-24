export function calculateCasePriority(caseData, clientData = {}) {
  let score = 0;

  if (clientData.is_retainer) score += 30;
  if (clientData.lifetime_value > 10000) score += 20;
  if (clientData.is_referral) score += 10;
  if (clientData.late_payments > 2) score -= 20;

  if (caseData.priority === "HIGH") score += 25;
  if (caseData.type === "litigation") score += 15;

  return Math.max(0, Math.min(100, score));
}

export function findBestStaff(caseData, staffList = []) {

  if (!staffList.length) {
    return null;
  }

  const scoredStaff = staffList
    .filter(staff => staff.is_active)
    .map(staff => {

      let score = 0;

      // Skills module not implemented yet
      score += 0;

      // Workload balancing
      if (staff.workload <= 2) {
        score += 30;
      } else if (staff.workload <= 5) {
        score += 10;
      } else {
        score -= 20;
      }

      // Bonus for completely free staff
      if (staff.workload === 0) {
        score += 10;
      }

      return {
        staff,
        score
      };
    });

  scoredStaff.sort((a, b) => b.score - a.score);

  return scoredStaff[0]?.staff || null;
}

export function autoAssignCase(caseData, staffList) {

  const bestStaff = findBestStaff(
    caseData,
    staffList
  );

  if (!bestStaff) {
    return {
      assigned: false,
      staff: null,
      reason: "No suitable staff available"
    };
  }

  return {
    assigned: true,
    staff: bestStaff,
    reason: "Auto-assigned using workload balancing"
  };
}
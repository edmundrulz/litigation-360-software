function classifyMatter(input) {
  const matterType = String(input.matterType || "").trim().toUpperCase();

  const allowed = ["LIT", "CIV", "FAM", "CORP"];

  if (!allowed.includes(matterType)) {
    return {
      valid: false,
      departmentCode: null,
      message: "Invalid or missing matter type"
    };
  }

  return {
    valid: true,
    departmentCode: matterType,
    message: "Matter classification valid"
  };
}

function decideIntakeReadiness(identityResult, conflictResult, classificationResult) {
  if (!classificationResult.valid) {
    return {
      ready: false,
      status: "BLOCKED",
      reason: "Matter classification invalid"
    };
  }

  if (conflictResult.rating === "RED") {
    return {
      ready: false,
      status: "BLOCKED",
      reason: "Conflict detected"
    };
  }

  if (conflictResult.rating === "AMBER") {
    return {
      ready: false,
      status: "REVIEW_REQUIRED",
      reason: "Possible conflict requires review"
    };
  }

  if (identityResult.bestMatch) {
    return {
      ready: false,
      status: "REVIEW_REQUIRED",
      reason: "Possible duplicate client requires review"
    };
  }

  return {
    ready: true,
    status: "READY",
    reason: "Matter intake may proceed"
  };
}

module.exports = {
  classifyMatter,
  decideIntakeReadiness
};
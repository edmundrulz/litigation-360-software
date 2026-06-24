function normalizeValue(value) {
  return String(value || "").trim().toLowerCase();
}

function scoreConflict(input, record) {
  let score = 0;
  const reasons = [];

  const inputClient = normalizeValue(input.clientName);
  const inputOpponent = normalizeValue(input.opposingParty);
  const inputMatter = normalizeValue(input.matterTitle);

  const recordClient = normalizeValue(record.clientName);
  const recordOpponent = normalizeValue(record.opposingParty);
  const recordMatter = normalizeValue(record.matterTitle);

  if (inputClient && recordClient && inputClient === recordClient) {
    score += 50;
    reasons.push("Existing client name match");
  }

  if (inputOpponent && recordClient && inputOpponent === recordClient) {
    score += 100;
    reasons.push("Opposing party is existing client");
  }

  if (inputClient && recordOpponent && inputClient === recordOpponent) {
    score += 90;
    reasons.push("New client was opposing party in existing matter");
  }

  if (inputMatter && recordMatter && inputMatter === recordMatter) {
    score += 20;
    reasons.push("Matter title match");
  }

  let rating = "GREEN";
  let action = "ALLOW";

  if (score >= 90) {
    rating = "RED";
    action = "BLOCK_PENDING_REVIEW";
  } else if (score >= 40) {
    rating = "AMBER";
    action = "REVIEW_REQUIRED";
  }

  return {
    score,
    rating,
    action,
    reasons
  };
}

module.exports = {
  normalizeValue,
  scoreConflict
};
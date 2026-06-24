function normalizeValue(value) {
  return String(value || "").trim().toLowerCase();
}

function scoreClientIdentity(input, existingClient) {
  let score = 0;
  const reasons = [];

  const inputName = normalizeValue(input.name);
  const existingName = normalizeValue(existingClient.name);

  const inputEmail = normalizeValue(input.email);
  const existingEmail = normalizeValue(existingClient.email);

  const inputPhone = normalizeValue(input.phone);
  const existingPhone = normalizeValue(existingClient.phone);

  if (inputEmail && inputEmail === existingEmail) {
    score += 40;
    reasons.push("Email exact match");
  }

  if (inputPhone && inputPhone === existingPhone) {
    score += 35;
    reasons.push("Phone exact match");
  }

  if (inputName && inputName === existingName) {
    score += 30;
    reasons.push("Name exact match");
  }

  let rating = "NO_MATCH";

  if (score >= 70) {
    rating = "LIKELY_MATCH";
  } else if (score >= 30) {
    rating = "POSSIBLE_MATCH";
  }

  return {
    score,
    rating,
    reasons
  };
}

module.exports = {
  normalizeValue,
  scoreClientIdentity
};
function isBasicEmailValid(email) {
  if (typeof email !== "string") return false;

  const value = email.trim();

  if (!value) return false;
  if (/\s/.test(value)) return false;

  const atMatches = value.match(/@/g) || [];
  if (atMatches.length !== 1) return false;

  const [localPart, domain] = value.split("@");

  if (!localPart || !domain) return false;
  if (!domain.includes(".")) return false;
  if (domain.startsWith(".") || domain.endsWith(".")) return false;

  const domainParts = domain.split(".");
  const tld = domainParts[domainParts.length - 1];

  if (!tld || tld.length < 2) return false;

  return true;
}

function getEmailDomain(email) {
  if (typeof email !== "string") return "";

  const parts = email.trim().split("@");

  if (parts.length !== 2) return "";

  return parts[1] || "";
}

function getEmailWarnings(email) {
  if (typeof email !== "string") {
    return ["Email must be text."];
  }

  const value = email.trim();
  const warnings = [];

  if (!value) {
    return [];
  }

  if (/\s/.test(value)) {
    warnings.push("Email should not contain spaces.");
  }

  const atMatches = value.match(/@/g) || [];

  if (atMatches.length === 0) {
    warnings.push("Email is missing @.");
    return warnings;
  }

  if (atMatches.length > 1) {
    warnings.push("Email should contain only one @.");
    return warnings;
  }

  const [localPart, domain] = value.split("@");

  if (!localPart) {
    warnings.push("Email is missing the name before @.");
  }

  if (!domain) {
    warnings.push("Email is missing the domain after @.");
    return warnings;
  }

  if (!domain.includes(".")) {
    warnings.push("Domain looks incomplete. Example: gmail.com or company.com.my.");
    return warnings;
  }

  if (domain.startsWith(".")) {
    warnings.push("Domain should not start with a dot.");
  }

  if (domain.endsWith(".")) {
    warnings.push("Domain ending looks incomplete.");
  }

  const domainParts = domain.split(".");
  const tld = domainParts[domainParts.length - 1];

  if (tld && tld.length === 1) {
    warnings.push("Domain ending looks too short.");
  }

  return warnings;
}

export {
  isBasicEmailValid,
  getEmailDomain,
  getEmailWarnings,
};

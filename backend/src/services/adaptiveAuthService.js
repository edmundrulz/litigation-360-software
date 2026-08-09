const DAY_MS = 24 * 60 * 60 * 1000;

function planAuthentication(policy, user, context) {
  const reasons = [];
  let riskScore = 0;

  const addRisk = (signal, reason) => {
    riskScore += policy.riskSignals[signal] || 0;
    reasons.push(reason);
  };

  if (["revoked", "expired", "suspended"].includes(user.status)) {
    addRisk("revokedOrExpiredAccess", `User status is ${user.status}`);
  }

  if (user.status === "limited" || user.status === "pending_review") {
    addRisk("sensitiveModule", `User status requires review: ${user.status}`);
  }

  if (!context.deviceTrusted) addRisk("unknownDevice", "Device is not trusted");
  if (!context.countryKnown) addRisk("newCountry", "Country has not been seen before");
  if (!context.ipRangeKnown) addRisk("newIpRange", "Network range is unfamiliar");
  if (context.outsideWorkingHours) addRisk("outsideWorkingHours", "Login is outside working hours");

  if (context.failedAttemptsLastHour > 0) {
    riskScore += context.failedAttemptsLastHour * (policy.riskSignals.failedAttempts || 0);
    reasons.push(`${context.failedAttemptsLastHour} failed attempt(s) in the last hour`);
  }

  if (policy.privilegedRoles.includes(user.roleCode)) {
    addRisk("privilegedRole", "Privileged role requires stronger authentication");
  }

  if (context.requestedModule && policy.sensitiveModules.includes(context.requestedModule)) {
    addRisk("sensitiveModule", `Requested module is sensitive: ${context.requestedModule}`);
  }

  if (isStepUpDue(user, context.now)) {
    addRisk(user.stepUpCadence === "weekly" ? "weeklyChallengeDue" : "monthlyChallengeDue", "Scheduled extra verification is due");
  }

  if (riskScore >= policy.riskThresholds.block) {
    return buildPlan("block", 4, riskScore, reasons, [], false);
  }

  if (riskScore >= policy.riskThresholds.restricted) {
    return buildPlan(
      "restricted",
      3,
      riskScore,
      reasons,
      chooseStrongFactors(user.enabledFactors),
      user.status === "limited" || user.status === "pending_review"
    );
  }

  if (riskScore >= policy.riskThresholds.stepUp) {
    return buildPlan(
      "step_up",
      2,
      riskScore,
      reasons,
      chooseStepUpFactors(user.enabledFactors),
      user.status === "limited"
    );
  }

  return buildPlan(
    "allow",
    1,
    riskScore,
    reasons.length ? reasons : ["Standard trusted login"],
    choosePrimaryFactors(user.enabledFactors),
    user.status === "limited"
  );
}

function identityMatches(user, submitted) {
  const checks = [
    equals(user.username, submitted.username),
    equals(user.email, submitted.email),
    contains(user.emailAliases, submitted.email),
    contains(user.emailAliases, submitted.username),
    equals(user.phoneNumber, submitted.phoneNumber),
    equals(user.legalName, submitted.legalName),
    equals(user.initials, submitted.initials),
    equals(user.nricLast4, submitted.nricLast4)
  ];

  return checks.filter(Boolean).length >= 2;
}

function buildSecurityDisplay(date = new Date()) {
  const phrases = ["Clear Ledger", "North Gate", "Silver Seal", "True Matter", "Green Vault", "Safe Harbor"];
  const colours = ["green", "gold", "steel", "white", "black", "blue"];
  const seed = Math.floor(date.getTime() / DAY_MS);

  return {
    phrase: phrases[seed % phrases.length],
    colour: colours[(seed * 3) % colours.length],
    numberCode: String((seed * 7919) % 1000000).padStart(6, "0")
  };
}

function canAccessModule(user, moduleCode, requiredClearance) {
  if (["revoked", "expired", "suspended", "pending_review"].includes(user.status)) return false;
  if (user.status === "limited" && ["finance", "hr", "legal_records", "system_settings"].includes(moduleCode)) return false;
  return user.clearanceLevel >= requiredClearance;
}

function normalizeSqliteUser(row) {
  if (!row) return null;

  return {
    userId: String(row.id),
    username: row.username || row.email,
    email: row.email,
    emailAliases: parseList(row.email_aliases),
    phoneNumber: row.phone_number || null,
    legalName: row.full_name,
    initials: row.initials || null,
    nricLast4: row.nric_last4 || null,
    status: row.is_active === 1 ? (row.access_status || "active") : "suspended",
    roleCode: row.role || "legal_assistant_clerk",
    clearanceLevel: row.clearance_level || 1,
    stepUpCadence: row.step_up_cadence || "monthly",
    lastStepUpAt: row.last_step_up_at ? new Date(row.last_step_up_at) : null,
    enabledFactors: parseFactors(row.enabled_factors)
  };
}

function isOutsideWorkingHours(now = new Date()) {
  const hour = now.getHours();
  return hour < 7 || hour > 20;
}

function buildPlan(decision, assuranceLevel, riskScore, reasons, requiredFactors, limitedAccess) {
  return {
    decision,
    assuranceLevel,
    riskScore,
    reasons,
    requiredFactors,
    limitedAccess
  };
}

function isStepUpDue(user, now) {
  if (user.stepUpCadence === "every_login") return true;
  if (!user.lastStepUpAt) return true;

  const elapsedDays = Math.floor((now.getTime() - user.lastStepUpAt.getTime()) / DAY_MS);
  return user.stepUpCadence === "weekly" ? elapsedDays >= 7 : elapsedDays >= 30;
}

function choosePrimaryFactors(enabled) {
  if (enabled.includes("passkey")) return ["passkey"];
  if (enabled.includes("password")) return ["password"];
  return enabled[0] ? [enabled[0]] : ["password"];
}

function chooseStepUpFactors(enabled) {
  const primary = choosePrimaryFactors(enabled)[0];
  const second = enabled.find((factor) => ["otp", "qr_approval", "pin"].includes(factor) && factor !== primary);
  return second ? [primary, second] : [primary, "otp"];
}

function chooseStrongFactors(enabled) {
  const phishingResistant = enabled.find((factor) => ["passkey", "security_key"].includes(factor));
  const possession = enabled.find((factor) => ["otp", "qr_approval"].includes(factor));
  const fallback = chooseStepUpFactors(enabled);
  return phishingResistant && possession ? [phishingResistant, possession] : fallback;
}

function parseFactors(value) {
  if (!value) return ["password", "otp"];
  if (Array.isArray(value)) return value;

  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) && parsed.length ? parsed : ["password", "otp"];
  } catch (error) {
    return String(value)
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);
  }
}

function parseList(value) {
  if (!value) return [];
  if (Array.isArray(value)) return value;

  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed : [];
  } catch (error) {
    return String(value)
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);
  }
}

function equals(a, b) {
  return Boolean(a && b && String(a).trim().toLowerCase() === String(b).trim().toLowerCase());
}

function contains(list, value) {
  if (!value || !Array.isArray(list)) return false;
  return list.some((item) => equals(item, value));
}

module.exports = {
  buildSecurityDisplay,
  canAccessModule,
  identityMatches,
  isOutsideWorkingHours,
  normalizeSqliteUser,
  planAuthentication
};

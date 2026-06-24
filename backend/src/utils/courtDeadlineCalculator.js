const DEADLINE_RULES = {
  FILING: 14,
  SERVICE: 7,
  REPLY: 14,
  REVIEW: 30,
  COMPLIANCE: 21
};

function isValidDate(date) {
  return date instanceof Date && !Number.isNaN(date.getTime());
}

function addDays(date, days) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function adjustWeekend(date) {
  const result = new Date(date);
  const day = result.getDay();

  if (day === 6) {
    result.setDate(result.getDate() + 2);
  }

  if (day === 0) {
    result.setDate(result.getDate() + 1);
  }

  return result;
}

function calculateDeadline(input) {
  const deadlineType = String(input.deadlineType || "").trim().toUpperCase();
  const triggerDate = new Date(input.triggerDate);

  if (!DEADLINE_RULES[deadlineType]) {
    return {
      success: false,
      message: "Invalid deadline type"
    };
  }

  if (!isValidDate(triggerDate)) {
    return {
      success: false,
      message: "Invalid trigger date"
    };
  }

  const rawDeadline = addDays(triggerDate, DEADLINE_RULES[deadlineType]);
  const adjustedDeadline = adjustWeekend(rawDeadline);

  return {
    success: true,
    deadlineType,
    triggerDate: triggerDate.toISOString().slice(0, 10),
    daysAdded: DEADLINE_RULES[deadlineType],
    rawDeadline: rawDeadline.toISOString().slice(0, 10),
    adjustedDeadline: adjustedDeadline.toISOString().slice(0, 10),
    weekendAdjusted: rawDeadline.toISOString().slice(0, 10) !== adjustedDeadline.toISOString().slice(0, 10),
    riskStatus: "CALCULATED"
  };
}

module.exports = {
  DEADLINE_RULES,
  isValidDate,
  addDays,
  adjustWeekend,
  calculateDeadline
};
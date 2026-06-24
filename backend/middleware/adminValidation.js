const allowedPlans = [
  "STARTER",
  "PROFESSIONAL",
  "BUSINESS",
  "ENTERPRISE",
  "GROUND_ZERO"
];

function validateRequired(fields) {
  return function (req, res, next) {
    const missing = [];

    for (const field of fields) {
      if (!req.body || req.body[field] === undefined || req.body[field] === null || req.body[field] === "") {
        missing.push(field);
      }
    }

    if (missing.length > 0) {
      return res.status(400).json({
        success: false,
        error: "MISSING_REQUIRED_PARAMETERS",
        missing
      });
    }

    next();
  };
}

function validatePlan(req, res, next) {
  const plan = req.body?.plan;

  if (!allowedPlans.includes(plan)) {
    return res.status(400).json({
      success: false,
      error: "INVALID_PLAN",
      allowedPlans
    });
  }

  next();
}

function validateTrialDays(req, res, next) {
  const days = Number(req.body?.days || 30);

  if (Number.isNaN(days) || days < 1 || days > 90) {
    return res.status(400).json({
      success: false,
      error: "INVALID_TRIAL_DAYS",
      message: "Trial days must be between 1 and 90."
    });
  }

  req.body.days = days;
  next();
}

module.exports = {
  validateRequired,
  validatePlan,
  validateTrialDays
};

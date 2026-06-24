function mockGroundZero(req, res, next) {
  req.user = {
    id: "USER_GROUND_ZERO_OWNER",
    name: "Ground Zero Owner",
    role: "OWNER",
    feature_overrides: []
  };

  req.firm = {
    id: "FIRM_GROUND_ZERO",
    name: "Fathers Firm Ground Zero",
    license_type: "UNLIMITED_FOUNDING_CLIENT",
    all_features_unlocked: true,
    subscription_plan: "GROUND_ZERO",
    trial_active: false,
    trial_expired: false
  };

  next();
}

function mockStarterFirm(req, res, next) {
  req.user = {
    id: "USER_STARTER",
    name: "Starter User",
    role: "LAWYER",
    feature_overrides: []
  };

  req.firm = {
    id: "FIRM_STARTER",
    name: "Starter Firm",
    license_type: "STANDARD_CLIENT",
    all_features_unlocked: false,
    subscription_plan: "STARTER",
    trial_active: false,
    trial_expired: false
  };

  next();
}

function mockTrialFirm(req, res, next) {
  req.user = {
    id: "USER_TRIAL",
    name: "Trial User",
    role: "LAWYER",
    feature_overrides: []
  };

  req.firm = {
    id: "FIRM_TRIAL",
    name: "Trial Firm",
    license_type: "STANDARD_CLIENT",
    all_features_unlocked: false,
    subscription_plan: "STARTER",
    trial_active: true,
    trial_expired: false
  };

  next();
}

module.exports = {
  mockGroundZero,
  mockStarterFirm,
  mockTrialFirm
};

function hasFeatureAccess(user, firm, featureKey, plans) {
  // 1. Ground Zero override
  if (
    firm &&
    firm.license_type === "UNLIMITED_FOUNDING_CLIENT" &&
    firm.all_features_unlocked === true
  ) {
    return true;
  }

  // 2. Manual admin override
  if (user && user.feature_overrides && user.feature_overrides.includes(featureKey)) {
    return true;
  }

  // 3. Trial full-access check
  if (firm && firm.trial_active === true && firm.trial_expired !== true) {
    return true;
  }

  // 4. Subscription plan check
  const plan = firm.subscription_plan;
  const allowedFeatures = plans[plan] || [];

  if (allowedFeatures.includes(featureKey)) {
    return true;
  }

  // 5. Otherwise locked
  return false;
}

function shouldShowFeature(user, firm, featureKey, plans) {
  return hasFeatureAccess(user, firm, featureKey, plans);
}

function shouldHideFeature(user, firm, featureKey, plans) {
  return !hasFeatureAccess(user, firm, featureKey, plans);
}

module.exports = {
  hasFeatureAccess,
  shouldShowFeature,
  shouldHideFeature
};

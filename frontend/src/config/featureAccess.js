export function canShowFeature(user, firm, featureKey, plans) {
  if (
    firm?.license_type === "UNLIMITED_FOUNDING_CLIENT" &&
    firm?.all_features_unlocked === true
  ) {
    return true;
  }

  if (user?.feature_overrides?.includes(featureKey)) {
    return true;
  }

  if (firm?.trial_active === true && firm?.trial_expired !== true) {
    return true;
  }

  const allowedFeatures = plans?.[firm?.subscription_plan] || [];
  return allowedFeatures.includes(featureKey);
}

export function featureDisplayMode(user, firm, featureKey, plans) {
  const allowed = canShowFeature(user, firm, featureKey, plans);

  if (allowed) {
    return "VISIBLE";
  }

  return "HIDDEN";
}

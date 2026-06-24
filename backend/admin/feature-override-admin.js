const fs = require("fs");
const path = require("path");

const overrideFile = path.join(__dirname, "feature-overrides.json");
const auditFile = path.join(__dirname, "admin-actions-audit.log");

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2));
}

function audit(action, payload) {
  fs.appendFileSync(
    auditFile,
    JSON.stringify({
      timestamp: new Date().toISOString(),
      action,
      payload
    }) + "\n"
  );
}

function ensureOverrideRoot(data) {
  if (!data.manual_feature_overrides) {
    data.manual_feature_overrides = {};
  }
  return data;
}

function grantFeatureOverride(firmId, userId, featureKey) {
  const data = ensureOverrideRoot(readJson(overrideFile));

  if (!data.manual_feature_overrides[firmId]) {
    data.manual_feature_overrides[firmId] = {};
  }

  if (!data.manual_feature_overrides[firmId][userId]) {
    data.manual_feature_overrides[firmId][userId] = [];
  }

  if (!data.manual_feature_overrides[firmId][userId].includes(featureKey)) {
    data.manual_feature_overrides[firmId][userId].push(featureKey);
  }

  writeJson(overrideFile, data);
  audit("GRANT_FEATURE_OVERRIDE_HARDENED", { firmId, userId, featureKey });

  return data.manual_feature_overrides[firmId][userId];
}

function revokeFeatureOverride(firmId, userId, featureKey) {
  const data = ensureOverrideRoot(readJson(overrideFile));

  if (
    !data.manual_feature_overrides[firmId] ||
    !data.manual_feature_overrides[firmId][userId]
  ) {
    audit("REVOKE_FEATURE_OVERRIDE_NO_EXISTING_OVERRIDE", { firmId, userId, featureKey });
    return [];
  }

  data.manual_feature_overrides[firmId][userId] =
    data.manual_feature_overrides[firmId][userId].filter(
      item => item !== featureKey
    );

  writeJson(overrideFile, data);
  audit("REVOKE_FEATURE_OVERRIDE_HARDENED", { firmId, userId, featureKey });

  return data.manual_feature_overrides[firmId][userId];
}

function listFeatureOverrides(firmId, userId) {
  const data = ensureOverrideRoot(readJson(overrideFile));

  if (firmId && userId) {
    return data.manual_feature_overrides[firmId]?.[userId] || [];
  }

  if (firmId) {
    return data.manual_feature_overrides[firmId] || {};
  }

  return data.manual_feature_overrides;
}

function featureOverrideStatus(firmId, userId, featureKey) {
  const features = listFeatureOverrides(firmId, userId);

  return {
    firmId,
    userId,
    featureKey,
    override_active: Array.isArray(features) && features.includes(featureKey)
  };
}

module.exports = {
  grantFeatureOverride,
  revokeFeatureOverride,
  listFeatureOverrides,
  featureOverrideStatus
};

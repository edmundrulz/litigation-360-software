const fs = require("fs");
const path = require("path");

const featuresPath = path.join(__dirname, "../licensing/features.json");

function loadFeatures() {
  return JSON.parse(fs.readFileSync(featuresPath, "utf8"));
}

function validateFeatureKey(req, res, next) {
  const featureKey = req.body?.featureKey || req.query?.featureKey;
  const features = loadFeatures();

  if (!featureKey) {
    return res.status(400).json({
      success: false,
      error: "MISSING_FEATURE_KEY",
      required: ["featureKey"]
    });
  }

  if (!features[featureKey]) {
    return res.status(400).json({
      success: false,
      error: "INVALID_FEATURE_KEY",
      featureKey,
      message: "Feature key does not exist in backend/licensing/features.json"
    });
  }

  next();
}

module.exports = {
  validateFeatureKey
};

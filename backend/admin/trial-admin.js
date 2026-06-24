const fs = require("fs");
const path = require("path");

const trialFile = path.join(__dirname, "trial-controls.json");
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

function ensureTrialRoot(data) {
  if (!data.trial_defaults) {
    data.trial_defaults = {
      trial_days: 30,
      trial_unlocks_all_standard_features: true,
      trial_excludes: ["GOVERNMENT_INTEGRATIONS", "MARKETPLACE"]
    };
  }

  if (!data.active_trials) {
    data.active_trials = {};
  }

  return data;
}

function startTrial(firmId, days = 30) {
  const trials = ensureTrialRoot(readJson(trialFile));

  const start = new Date();
  const end = new Date();
  end.setDate(start.getDate() + Number(days));

  trials.active_trials[firmId] = {
    firmId,
    trial_active: true,
    trial_expired: false,
    trial_start: start.toISOString(),
    trial_end: end.toISOString(),
    trial_days: Number(days),
    trial_status: "ACTIVE"
  };

  writeJson(trialFile, trials);
  audit("TRIAL_START_HARDENED", { firmId, days });

  return trials.active_trials[firmId];
}

function endTrial(firmId, reason = "ADMIN_ENDED") {
  const trials = ensureTrialRoot(readJson(trialFile));

  if (!trials.active_trials[firmId]) {
    trials.active_trials[firmId] = {
      firmId,
      trial_active: false,
      trial_expired: true,
      trial_start: null,
      trial_end: new Date().toISOString(),
      trial_days: 0,
      trial_status: "ENDED",
      end_reason: reason
    };
  } else {
    trials.active_trials[firmId].trial_active = false;
    trials.active_trials[firmId].trial_expired = true;
    trials.active_trials[firmId].trial_status = "ENDED";
    trials.active_trials[firmId].ended_at = new Date().toISOString();
    trials.active_trials[firmId].end_reason = reason;
  }

  writeJson(trialFile, trials);
  audit("TRIAL_END_HARDENED", { firmId, reason });

  return trials.active_trials[firmId];
}

function getTrialStatus(firmId) {
  const trials = ensureTrialRoot(readJson(trialFile));
  const trial = trials.active_trials[firmId];

  if (!trial) {
    return {
      firmId,
      trial_active: false,
      trial_expired: false,
      trial_status: "NO_TRIAL_FOUND"
    };
  }

  const now = new Date();
  const end = trial.trial_end ? new Date(trial.trial_end) : null;

  const expiredByDate = end ? now > end : false;

  return {
    ...trial,
    calculated_expired_by_date: expiredByDate,
    days_remaining: end
      ? Math.max(0, Math.ceil((end - now) / (1000 * 60 * 60 * 24)))
      : 0
  };
}

function listTrials() {
  const trials = ensureTrialRoot(readJson(trialFile));
  return trials.active_trials;
}

function refreshTrialExpiries() {
  const trials = ensureTrialRoot(readJson(trialFile));
  const now = new Date();
  const changed = [];

  for (const firmId of Object.keys(trials.active_trials)) {
    const trial = trials.active_trials[firmId];

    if (trial.trial_active && trial.trial_end) {
      const end = new Date(trial.trial_end);

      if (now > end) {
        trial.trial_active = false;
        trial.trial_expired = true;
        trial.trial_status = "EXPIRED";
        trial.expired_at = now.toISOString();
        changed.push(firmId);
      }
    }
  }

  writeJson(trialFile, trials);
  audit("TRIAL_EXPIRY_REFRESH", { expired_firms: changed });

  return {
    expired_count: changed.length,
    expired_firms: changed
  };
}

module.exports = {
  startTrial,
  endTrial,
  getTrialStatus,
  listTrials,
  refreshTrialExpiries
};

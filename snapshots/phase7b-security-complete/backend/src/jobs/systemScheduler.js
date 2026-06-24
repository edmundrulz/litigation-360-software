const db = require("../database");
const { autoHeal } = require("../services/autoHealService");

let schedulerStats = {
  startedAt: new Date().toISOString(),
  lastIntegrityScan: null,
  lastAutoHeal: null,
  integrityRuns: 0,
  autoHealRuns: 0,
  repairsPerformed: 0
};

function runIntegrityScan() {

  try {

    const issues = [];

    // Missing Clients
    const orphanCases = db.prepare(`
      SELECT c.id
      FROM cases c
      LEFT JOIN clients cl
      ON c.client_id = cl.id
      WHERE c.client_id IS NOT NULL
      AND cl.id IS NULL
    `).all();

    if (orphanCases.length > 0) {
      issues.push(...orphanCases);
    }

    schedulerStats.lastIntegrityScan =
      new Date().toISOString();

    schedulerStats.integrityRuns++;

    console.log(
      `🔍 Integrity Scan Complete | Issues: ${issues.length}`
    );

    return issues;

  } catch (err) {

    console.error(
      "Integrity Scan Failure:",
      err.message
    );

    return [];

  }

}

function runAutoHeal() {

  try {

    const result = autoHeal();

    schedulerStats.lastAutoHeal =
      new Date().toISOString();

    schedulerStats.autoHealRuns++;

    if (
      result.repairs &&
      result.repairs.length > 0
    ) {

      schedulerStats.repairsPerformed +=
        result.repairs.reduce(
          (sum, r) => sum + r.repaired,
          0
        );

    }

    console.log(
      `🛠 Auto Heal Complete`
    );

    return result;

  } catch (err) {

    console.error(
      "Auto Heal Failure:",
      err.message
    );
  }

}

function startScheduler() {

  console.log(
    "🚀 Enterprise Scheduler Started"
  );

  // Every 5 Minutes
  setInterval(() => {

    runIntegrityScan();

  }, 5 * 60 * 1000);

  // Every 5 Minutes
  setInterval(() => {

    runAutoHeal();

  }, 5 * 60 * 1000);

}

function getSchedulerStats() {

  return schedulerStats;

}

module.exports = {
  startScheduler,
  getSchedulerStats
};
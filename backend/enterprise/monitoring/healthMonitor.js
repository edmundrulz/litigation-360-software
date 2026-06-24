function createHealthMonitor(checks) {
  const registeredChecks = checks || {};

  function run() {
    const results = [];
    const names = Object.keys(registeredChecks);

    names.forEach(function(name) {
      try {
        const result = registeredChecks[name]();
        results.push({ name: name, status: result === false ? "FAIL" : "PASS" });
      } catch (err) {
        results.push({ name: name, status: "FAIL", error: err.message });
      }
    });

    const failed = results.filter(function(r) { return r.status === "FAIL"; });

    return {
      status: failed.length === 0 ? "HEALTHY" : "DEGRADED",
      total_checks: results.length,
      failed_checks: failed.length,
      results: results,
      checked_at: new Date().toISOString()
    };
  }

  return { run };
}

module.exports = { createHealthMonitor };

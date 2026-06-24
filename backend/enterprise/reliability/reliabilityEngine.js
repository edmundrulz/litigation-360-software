function createReliabilityEngine(options) {
  const config = options || {};

  function safeRun(name, fn) {
    if (!name) throw new Error("operation name is required");
    if (typeof fn !== "function") throw new Error("operation function is required");

    try {
      const result = fn();
      return {
        operation: name,
        status: "SUCCESS",
        result: result,
        error: null,
        completed_at: new Date().toISOString()
      };
    } catch (err) {
      return {
        operation: name,
        status: "FAILED",
        result: null,
        error: err.message,
        completed_at: new Date().toISOString()
      };
    }
  }

  function requiresReview(result) {
    return !result || result.status !== "SUCCESS";
  }

  return { safeRun, requiresReview };
}

module.exports = { createReliabilityEngine };

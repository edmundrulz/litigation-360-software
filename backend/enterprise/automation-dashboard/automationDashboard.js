function createAutomationDashboard(db) {
  if (!db) throw new Error('AutomationDashboard requires database instance');
  function count(sql) { return db.prepare(sql).get().total; }
  function getMetrics() {
    return {
      published: count("SELECT COUNT(*) total FROM automation_events"),
      completed: count("SELECT COUNT(*) total FROM automation_events WHERE status='COMPLETED'"),
      failed: count("SELECT COUNT(*) total FROM automation_events WHERE status='FAILED'"),
      pending: count("SELECT COUNT(*) total FROM automation_events WHERE status='PENDING'"),
      deadLetters: count("SELECT COUNT(*) total FROM automation_dead_letters")
    };
  }
  return { getMetrics };
}
module.exports = { createAutomationDashboard };

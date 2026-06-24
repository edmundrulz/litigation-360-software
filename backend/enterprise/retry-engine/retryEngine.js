function createRetryEngine(db) {
  if (!db) throw new Error('RetryEngine requires database instance');
  function processFailed() {
    const event = db.prepare('SELECT * FROM automation_events WHERE status = ? AND retry_count < max_retries ORDER BY id ASC LIMIT 1').get('FAILED');
    if (!event) return { status: 'NO_RETRY_EVENTS' };
    const nextRetry = event.retry_count + 1;
    db.prepare('UPDATE automation_events SET status=?, retry_count=?, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('PENDING', nextRetry, event.event_id);
    db.prepare('INSERT INTO automation_event_history (event_id, old_status, new_status, action, message, created_by) VALUES (?, ?, ?, ?, ?, ?)').run(event.event_id, 'FAILED', 'PENDING', 'RETRY_SCHEDULED', 'Retry scheduled', 'RETRY_ENGINE');
    return { status: 'RETRY_SCHEDULED', event_id: event.event_id, retry_count: nextRetry };
  }
  return { processFailed };
}
module.exports = { createRetryEngine };

function createDeadLetterEngine(db) {
  if (!db) throw new Error('DeadLetterEngine requires database instance');
  function processDeadLetters() {
    const event = db.prepare('SELECT * FROM automation_events WHERE status = ? AND retry_count >= max_retries ORDER BY id ASC LIMIT 1').get('FAILED');
    if (!event) return { status: 'NO_DLQ_EVENTS' };
    const reason = event.failure_reason ? event.failure_reason : 'Unknown failure';
    db.prepare('INSERT INTO automation_dead_letters (event_id, event_type, source_module, payload_json, failure_reason, retry_count, created_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)').run(event.event_id, event.event_type, event.source_module, event.payload_json, reason, event.retry_count);
    db.prepare('UPDATE automation_events SET status=?, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('DEAD_LETTER', event.event_id);
    db.prepare('INSERT INTO automation_event_history (event_id, old_status, new_status, action, message, created_by) VALUES (?, ?, ?, ?, ?, ?)').run(event.event_id, 'FAILED', 'DEAD_LETTER', 'DLQ_TRANSFER', 'Moved to dead letter queue', 'DLQ_ENGINE');
    return { status: 'DEAD_LETTER_CREATED', event_id: event.event_id };
  }
  return { processDeadLetters };
}
module.exports = { createDeadLetterEngine };

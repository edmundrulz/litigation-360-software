function createAutomationConsumerEngine(db, handlers) {
  if (!db) throw new Error('ConsumerEngine requires database instance');
  const eventHandlers = handlers || {};
  function processNext() {
    const event = db.prepare('SELECT * FROM automation_events WHERE status = ? ORDER BY id ASC LIMIT 1').get('PENDING');
    if (!event) return { status: 'NO_EVENTS' };
    const handler = eventHandlers[event.event_type];
    if (!handler) { db.prepare('UPDATE automation_events SET status=?, failure_reason=?, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('FAILED', 'No handler registered', event.event_id); db.prepare('INSERT INTO automation_event_history (event_id, old_status, new_status, action, message, created_by) VALUES (?, ?, ?, ?, ?, ?)').run(event.event_id, 'PENDING', 'FAILED', 'NO_HANDLER', 'No handler registered', 'CONSUMER_ENGINE'); return { status: 'FAILED', reason: 'NO_HANDLER', event_id: event.event_id }; }
    try {
      db.prepare('UPDATE automation_events SET status=?, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('PROCESSING', event.event_id);
      const payload = JSON.parse(event.payload_json || '{}');
      const result = handler(event, payload);
      db.prepare('UPDATE automation_events SET status=?, processed_at=CURRENT_TIMESTAMP, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('COMPLETED', event.event_id);
      db.prepare('INSERT INTO automation_event_history (event_id, old_status, new_status, action, message, created_by) VALUES (?, ?, ?, ?, ?, ?)').run(event.event_id, 'PROCESSING', 'COMPLETED', 'CONSUME', 'Event consumed successfully', 'CONSUMER_ENGINE');
      return { status: 'COMPLETED', event_id: event.event_id, result: result };
    } catch (err) {
      db.prepare('UPDATE automation_events SET status=?, failure_reason=?, updated_at=CURRENT_TIMESTAMP WHERE event_id=?').run('FAILED', err.message, event.event_id);
      db.prepare('INSERT INTO automation_event_history (event_id, old_status, new_status, action, message, created_by) VALUES (?, ?, ?, ?, ?, ?)').run(event.event_id, 'PROCESSING', 'FAILED', 'CONSUME_FAILED', err.message, 'CONSUMER_ENGINE');
      return { status: 'FAILED', event_id: event.event_id, reason: err.message };
    }
  }
  return { processNext };
}
module.exports = { createAutomationConsumerEngine };

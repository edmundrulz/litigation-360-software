function clientCreatedHandler(event, payload) {
  if (!event) throw new Error('event is required');
  if (!payload) throw new Error('payload is required');
  const clientId = payload.client_id ? payload.client_id : null;
  return {
    handled: true,
    event_type: event.event_type,
    source_module: event.source_module,
    client_id: clientId,
    next_actions: ['verify_client_identity', 'check_duplicate_client', 'create_client_timeline_entry'],
    message: 'CLIENT_CREATED automation handler executed'
  };
}
module.exports = { clientCreatedHandler };

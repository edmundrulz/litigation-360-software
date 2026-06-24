function matterCreatedHandler(event, payload) {
  if (!event) throw new Error('event is required');
  if (!payload) throw new Error('payload is required');
  const matterId = payload.matter_id ? payload.matter_id : null;
  return {
    handled: true,
    event_type: event.event_type,
    source_module: event.source_module,
    matter_id: matterId,
    next_actions: ['create_matter_timeline', 'generate_matter_reference', 'assign_responsible_lawyer'],
    message: 'MATTER_CREATED automation handler executed'
  };
}
module.exports = { matterCreatedHandler };

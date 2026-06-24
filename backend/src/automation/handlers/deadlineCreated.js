module.exports = async function deadlineCreated(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "DEADLINE_CREATED",
    handler: "deadlineCreated",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

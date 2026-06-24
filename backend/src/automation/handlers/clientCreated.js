module.exports = async function clientCreated(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "CLIENT_CREATED",
    handler: "clientCreated",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

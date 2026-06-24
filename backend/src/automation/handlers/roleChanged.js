module.exports = async function roleChanged(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "ROLE_CHANGED",
    handler: "roleChanged",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

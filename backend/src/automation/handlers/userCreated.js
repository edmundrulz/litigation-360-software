module.exports = async function userCreated(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "USER_CREATED",
    handler: "userCreated",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

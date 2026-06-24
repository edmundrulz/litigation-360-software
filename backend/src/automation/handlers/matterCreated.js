module.exports = async function matterCreated(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "MATTER_CREATED",
    handler: "matterCreated",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

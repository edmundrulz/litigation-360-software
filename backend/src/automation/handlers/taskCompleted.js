module.exports = async function taskCompleted(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "TASK_COMPLETED",
    handler: "taskCompleted",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

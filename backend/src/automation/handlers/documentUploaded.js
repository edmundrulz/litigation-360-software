module.exports = async function documentUploaded(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "DOCUMENT_UPLOADED",
    handler: "documentUploaded",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

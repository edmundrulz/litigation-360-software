module.exports = async function invoiceCreated(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "INVOICE_CREATED",
    handler: "invoiceCreated",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

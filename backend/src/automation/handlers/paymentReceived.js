module.exports = async function paymentReceived(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "PAYMENT_RECEIVED",
    handler: "paymentReceived",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};

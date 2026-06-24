const channels = [
  "DASHBOARD",
  "LOG",
  "EMAIL_PLACEHOLDER",
  "SMS_PLACEHOLDER",
  "WHATSAPP_PLACEHOLDER"
];

const notifications = [];

function nextId() {
  return `NTF-${String(notifications.length + 1).padStart(6, "0")}`;
}

function createNotification(input = {}) {
  const channel = channels.includes(input.channel) ? input.channel : "DASHBOARD";
  const notification = {
    notificationId: nextId(),
    alertId: input.alertId || "ALT-UNKNOWN",
    channel,
    recipient: input.recipient || "OPERATIONS",
    message: input.message || "Alert notification created.",
    status: "QUEUED",
    createdAt: new Date().toISOString(),
    realSendingEnabled: false
  };

  notifications.push(notification);
  return notification;
}

function notifyForAlert(alert, channel = "DASHBOARD") {
  return createNotification({
    alertId: alert.alertId,
    channel,
    recipient: alert.severity === "CRITICAL" ? "EXECUTIVE" : "OPERATIONS",
    message: `${alert.severity}: ${alert.title} - ${alert.message}`
  });
}

function listNotifications() {
  return notifications;
}

function getMetrics() {
  return {
    phase: "10Z.1",
    totalNotifications: notifications.length,
    queuedNotifications: notifications.filter((item) => item.status === "QUEUED").length,
    channels,
    realSendingEnabled: false,
    generatedAt: new Date().toISOString()
  };
}

function getHealth() {
  return {
    status: "HEALTHY",
    service: "Notification Engine",
    phase: "10Z.1",
    metrics: getMetrics(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  channels,
  createNotification,
  notifyForAlert,
  listNotifications,
  getMetrics,
  getHealth
};

const notificationStore = [];

const notificationMetrics = {
  created: 0,
  read: 0,
  unread: 0,
  critical: 0,
  warning: 0,
  info: 0
};

const VALID_LEVELS = ["INFO", "WARNING", "CRITICAL", "SYSTEM", "COURT", "DEADLINE", "TASK", "FINANCE"];

function normalizeLevel(level = "INFO") {
  const upper = String(level || "INFO").toUpperCase();
  return VALID_LEVELS.includes(upper) ? upper : "INFO";
}

function createNotification({
  title,
  message,
  level = "INFO",
  source = "SYSTEM",
  eventType = null,
  matterId = null,
  userId = null,
  payload = {}
} = {}) {
  const normalizedLevel = normalizeLevel(level);

  if (!title) {
    title = "System Notification";
  }

  if (!message) {
    message = "A system notification was created.";
  }

  const notification = {
    id: `NTF-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    title,
    message,
    level: normalizedLevel,
    source,
    eventType,
    matterId,
    userId,
    payload,
    read: false,
    createdAt: new Date().toISOString(),
    readAt: null
  };

  notificationStore.push(notification);

  notificationMetrics.created += 1;
  notificationMetrics.unread += 1;

  if (normalizedLevel === "CRITICAL") notificationMetrics.critical += 1;
  if (normalizedLevel === "WARNING") notificationMetrics.warning += 1;
  if (normalizedLevel === "INFO") notificationMetrics.info += 1;

  return notification;
}

function createNotificationFromEvent(event = {}) {
  return createNotification({
    title: `Event: ${event.eventType || "UNKNOWN"}`,
    message: `Event ${event.eventType || "UNKNOWN"} was processed with status ${event.status || "UNKNOWN"}.`,
    level: event.status === "FAILED" || event.status === "UNHANDLED" ? "WARNING" : "INFO",
    source: "EVENT_BUS",
    eventType: event.eventType || null,
    payload: event
  });
}

function markNotificationRead(id) {
  const notification = notificationStore.find(n => n.id === id);

  if (!notification) {
    return {
      ok: false,
      error: "Notification not found"
    };
  }

  if (!notification.read) {
    notification.read = true;
    notification.readAt = new Date().toISOString();
    notificationMetrics.read += 1;
    notificationMetrics.unread = Math.max(0, notificationMetrics.unread - 1);
  }

  return {
    ok: true,
    notification
  };
}

function getNotifications({ limit = 25, unreadOnly = false, level = null } = {}) {
  let items = [...notificationStore];

  if (unreadOnly) {
    items = items.filter(n => !n.read);
  }

  if (level) {
    const normalizedLevel = normalizeLevel(level);
    items = items.filter(n => n.level === normalizedLevel);
  }

  return items.slice(-limit).reverse();
}

function getNotificationMetrics() {
  return {
    ...notificationMetrics,
    storedNotifications: notificationStore.length,
    status: notificationMetrics.critical > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getNotificationHealth() {
  const metrics = getNotificationMetrics();

  return {
    module: "Notification Framework",
    status: metrics.status,
    created: metrics.created,
    unread: metrics.unread,
    read: metrics.read,
    critical: metrics.critical,
    warning: metrics.warning,
    info: metrics.info,
    storedNotifications: metrics.storedNotifications,
    timestamp: metrics.timestamp
  };
}

function resetNotificationsForTestOnly() {
  notificationStore.length = 0;
  notificationMetrics.created = 0;
  notificationMetrics.read = 0;
  notificationMetrics.unread = 0;
  notificationMetrics.critical = 0;
  notificationMetrics.warning = 0;
  notificationMetrics.info = 0;
}

module.exports = {
  createNotification,
  createNotificationFromEvent,
  markNotificationRead,
  getNotifications,
  getNotificationMetrics,
  getNotificationHealth,
  resetNotificationsForTestOnly
};

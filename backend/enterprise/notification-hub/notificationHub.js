function createNotificationHub(automationBus) {
  function notify(data) {
    if (!data.title) throw new Error("notification title is required");
    if (!data.message) throw new Error("notification message is required");

    const notification = {
      type: data.type || "DASHBOARD",
      level: data.level || "LOW",
      title: data.title,
      message: data.message,
      target_user: data.target_user || null,
      related_module: data.related_module || null,
      related_record_id: data.related_record_id || null,
      next_action: data.next_action || "REVIEW",
      created_at: new Date().toISOString()
    };

    if (automationBus && automationBus.publishEvent) {
      automationBus.publishEvent({
        event_type: "NOTIFICATION_CREATED",
        source_module: "NOTIFICATION_HUB",
        priority: notification.level === "CRITICAL" ? "CRITICAL" : "NORMAL",
        payload: notification,
        created_by: "SYSTEM"
      });
    }

    return notification;
  }

  return { notify };
}

module.exports = { createNotificationHub };

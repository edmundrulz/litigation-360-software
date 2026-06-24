const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10C-notification-framework", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const notificationPath = path.join(srcRoot, "automation", "notificationService.js");
const notificationRoutesPath = path.join(srcRoot, "routes", "notificationRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(notificationPath)) {
  console.log("Notification Service file missing. Run APPLY mode.");
  process.exit(1);
}

const notificationService = require(notificationPath);

notificationService.resetNotificationsForTestOnly();

const infoNotification = notificationService.createNotification({
  title: "Validation Info Notification",
  message: "Phase 10C info validation notification.",
  level: "INFO",
  source: "PHASE_10C_VALIDATION"
});

const criticalNotification = notificationService.createNotification({
  title: "Validation Critical Notification",
  message: "Phase 10C critical validation notification.",
  level: "CRITICAL",
  source: "PHASE_10C_VALIDATION"
});

const readResult = notificationService.markNotificationRead(infoNotification.id);
const metrics = notificationService.getNotificationMetrics();
const health = notificationService.getNotificationHealth();
const unread = notificationService.getNotifications({ unreadOnly: true });
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10C",
  module: "Notification Framework",
  timestamp: new Date().toISOString(),
  files: {
    notificationServiceExists: fs.existsSync(notificationPath),
    notificationRoutesExists: fs.existsSync(notificationRoutesPath),
    routeMountedInIndex: indexText.includes("notificationRoutes")
  },
  tests: {
    infoNotificationCreated: !!infoNotification.id,
    criticalNotificationCreated: !!criticalNotification.id,
    readResultOk: readResult.ok === true,
    unreadCount: unread.length
  },
  metrics,
  health,
  status: (
    fs.existsSync(notificationPath) &&
    fs.existsSync(notificationRoutesPath) &&
    indexText.includes("notificationRoutes") &&
    !!infoNotification.id &&
    !!criticalNotification.id &&
    readResult.ok === true &&
    metrics.created === 2 &&
    metrics.read === 1 &&
    metrics.unread === 1 &&
    metrics.critical === 1
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10C-notification-framework-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10C NOTIFICATION FRAMEWORK REPORT",
  "========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Notification Service Exists: " + report.files.notificationServiceExists,
  "Notification Routes Exists: " + report.files.notificationRoutesExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Created Notifications: " + metrics.created,
  "Read Notifications: " + metrics.read,
  "Unread Notifications: " + metrics.unread,
  "Critical Notifications: " + metrics.critical,
  "Warning Notifications: " + metrics.warning,
  "Info Notifications: " + metrics.info,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10C-notification-framework-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10C-notification-framework"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10C-notification-framework-log.txt"

function Log($Text) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -LiteralPath $LogFile -Value "[$stamp] $Text"
}

function Backup-IfExists($Path) {
    if (Test-Path -LiteralPath $Path) {
        $name = Split-Path $Path -Leaf
        $dest = Join-Path $Backups ($name + "." + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak")
        Copy-Item -LiteralPath $Path -Destination $dest -Force
        Log "Backup created: $Path --> $dest"
    }
}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10C NOTIFICATION FRAMEWORK"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10C NOTIFICATION FRAMEWORK START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath $IndexPath)) {
    Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
    Log "ERROR: index.js missing"
    Read-Host "Press Enter to close"
    exit 1
}

if (!(Test-Path -LiteralPath (Join-Path $Automation "eventBus.js"))) {
    Write-Host "ERROR: Phase 10B eventBus.js missing. Complete Phase 10B first." -ForegroundColor Red
    Log "ERROR: eventBus.js missing"
    Read-Host "Press Enter to close"
    exit 1
}

$NotificationServicePath = Join-Path $Automation "notificationService.js"
$NotificationRoutesPath = Join-Path $Routes "notificationRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $NotificationServicePath
    Backup-IfExists $NotificationRoutesPath
    Backup-IfExists $IndexPath

@'
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
'@ | Out-File -LiteralPath $NotificationServicePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  createNotification,
  markNotificationRead,
  getNotifications,
  getNotificationMetrics,
  getNotificationHealth
} = require("../automation/notificationService");

router.get("/health", (req, res) => {
  res.json(getNotificationHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getNotificationMetrics());
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const unreadOnly = String(req.query.unreadOnly || "false").toLowerCase() === "true";
  const level = req.query.level || null;

  res.json({
    notifications: getNotifications({ limit, unreadOnly, level }),
    timestamp: new Date().toISOString()
  });
});

router.post("/create", (req, res) => {
  try {
    const notification = createNotification(req.body || {});
    res.status(201).json({
      ok: true,
      notification
    });
  } catch (err) {
    res.status(500).json({
      ok: false,
      error: err.message,
      timestamp: new Date().toISOString()
    });
  }
});

router.post("/:id/read", (req, res) => {
  const result = markNotificationRead(req.params.id);
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/test", (req, res) => {
  const notification = createNotification({
    title: "Phase 10C Test Notification",
    message: "Notification Framework test completed.",
    level: "INFO",
    source: "PHASE_10C_TEST",
    payload: {
      test: true
    }
  });

  res.json({
    ok: true,
    notification
  });
});

router.get("/test-critical", (req, res) => {
  const notification = createNotification({
    title: "Phase 10C Critical Test",
    message: "Critical notification route test completed.",
    level: "CRITICAL",
    source: "PHASE_10C_TEST",
    payload: {
      test: true,
      severity: "critical"
    }
  });

  res.json({
    ok: true,
    notification
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $NotificationRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/notifications", require("./routes/notificationRoutes"));'

    if ($indexText -notlike '*notificationRoutes*') {
        if ($indexText -like '*eventBusRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/events",\s*require\("\./routes/eventBusRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10C Notification Framework Route`r`n" + $mountLine + "`r`n"
        }

        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Notification route in index.js"
    } else {
        Log "notificationRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10C-notification-framework.js"

@'
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
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10C NOTIFICATION FRAMEWORK PROTOCOL

## Purpose
Create a system-wide notification framework for dashboard alerts, warnings, critical notices, court reminders, task alerts, deadline alerts, and system health alerts.

## Why
The Event Bus moves information. The Notification Framework makes important information visible.

## Created Files
- backend\src\automation\notificationService.js
- backend\src\routes\notificationRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/notifications/health
- GET /api/enterprise/notifications/metrics
- GET /api/enterprise/notifications/list
- POST /api/enterprise/notifications/create
- POST /api/enterprise/notifications/:id/read
- GET /api/enterprise/notifications/test
- GET /api/enterprise/notifications/test-critical

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/notifications/health
- http://localhost:5000/api/enterprise/notifications/test
- http://localhost:5000/api/enterprise/notifications/list

## Rules
- No deletion.
- Backup before modification.
- Every notification must have title, message, level, source, createdAt, and read status.
- Critical notifications must be visible in metrics.
- Notification health must expose status, unread count, critical count, and stored notification count.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10C-NOTIFICATION-FRAMEWORK-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit = $LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if ($exit -eq 0) {
    Write-Host "PHASE 10C NOTIFICATION FRAMEWORK STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10C NOTIFICATION FRAMEWORK PASS"
} else {
    Write-Host "PHASE 10C NOTIFICATION FRAMEWORK STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10C NOTIFICATION FRAMEWORK FAIL"
}

Read-Host "Press Enter to close"
exit $exit

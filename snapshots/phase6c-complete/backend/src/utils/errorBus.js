const fs = require("fs");
const path = require("path");

// ======================
// LOG STORAGE
// ======================
const LOG_FILE = path.join(__dirname, "../logs/error.log");

// ensure folder exists
const logDir = path.dirname(LOG_FILE);
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

// in-memory buffer (for dashboard)
const errorStore = [];

// ======================
// MAIN LOGGER
// ======================
function logError(error) {

  const entry = {
    id: Date.now().toString(),
    timestamp: new Date().toISOString(),
    message: error.message || "Unknown error",
    stack: error.stack || null,
    route: error.route || null,
    method: error.method || null,
    type: error.type || "SYSTEM_ERROR"
  };

  // store in memory
  errorStore.push(entry);

  // keep memory safe
  if (errorStore.length > 200) {
    errorStore.shift();
  }

  // persistent log file
  try {
    fs.appendFileSync(LOG_FILE, JSON.stringify(entry) + "\n");
  } catch (fileErr) {
    console.error("⚠️ Failed writing error log:", fileErr.message);
  }

  console.error("🔥 ERROR CAPTURED:", entry.message);

  return entry;
}

// ======================
// READ LOGS (FOR FUTURE DASHBOARD)
// ======================
function getErrors() {
  return errorStore;
}

// ======================
// CLEAR LOGS
// ======================
function clearErrors() {
  errorStore.length = 0;
}

module.exports = {
  logError,
  getErrors,
  clearErrors
};
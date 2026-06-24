function auditLog(data = {}) {
  console.log(
    `[AUDIT] ${new Date().toISOString()} - ${
      data.action || 'UNKNOWN_ACTION'
    }`
  );

  console.log(data);
}

function log(message, data = null) {
  console.log(`[LOG] ${new Date().toISOString()} - ${message}`);
  if (data) console.log(data);
}

function info(message, data = null) {
  console.info(`[INFO] ${new Date().toISOString()} - ${message}`);
  if (data) console.info(data);
}

function warn(message, data = null) {
  console.warn(`[WARN] ${new Date().toISOString()} - ${message}`);
  if (data) console.warn(data);
}

function error(message, data = null) {
  console.error(`[ERROR] ${new Date().toISOString()} - ${message}`);
  if (data) console.error(data);
}

function debug(message, data = null) {
  console.debug(`[DEBUG] ${new Date().toISOString()} - ${message}`);
  if (data) console.debug(data);
}

auditLog.log = log;
auditLog.info = info;
auditLog.warn = warn;
auditLog.error = error;
auditLog.debug = debug;

module.exports = auditLog;
const fs = require('fs');
const path = require('path');

const logsDir = path.join(__dirname, '../../logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

const log = (level, message) => {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${level}: ${message}`;
  console.log(logMessage);
  
  const logFile = path.join(logsDir, `${level.toLowerCase()}.log`);
  fs.appendFileSync(logFile, logMessage + '\n');
};

module.exports = {
  info: (msg) => log('INFO', msg),
  error: (msg) => log('ERROR', msg),
  debug: (msg) => log('DEBUG', msg),
  warn: (msg) => log('WARN', msg)
};

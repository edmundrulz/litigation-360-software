const fs = require("fs");

function log(type, message, data = null) {

  const entry = {
    time: new Date().toISOString(),
    type,
    message,
    data
  };

  console.log(`[${type}]`, message);

  fs.appendFileSync(
    "system_log.json",
    JSON.stringify(entry) + "\n"
  );
}

module.exports = { log };
const { log } = require("../core/logger");
const { recordError } = require("../core/systemScore");

module.exports = (err, req, res, next) => {

  recordError();

  log("ERROR", err.message, err.stack);

  res.status(500).json({
    error: "System Failure",
    message: err.message
  });
};
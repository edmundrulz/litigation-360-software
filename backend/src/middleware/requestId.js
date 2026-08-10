const { randomUUID } = require("crypto");

const REQUEST_ID_PATTERN = /^[A-Za-z0-9._:-]+$/;
const REQUEST_ID_MAX_LENGTH = 128;

function normalizeRequestId(value) {
  if (typeof value !== "string") return null;
  const trimmed = value.trim();
  if (!trimmed || trimmed.length > REQUEST_ID_MAX_LENGTH) return null;
  return REQUEST_ID_PATTERN.test(trimmed) ? trimmed : null;
}

function requestId(req, res, next) {
  const supplied = normalizeRequestId(req && req.headers ? req.headers["x-request-id"] : null);
  const id = supplied || randomUUID();

  req.requestId = id;
  res.locals = res.locals || {};
  res.locals.requestId = id;
  res.setHeader("X-Request-ID", id);

  const originalJson = res.json;
  if (typeof originalJson === "function") {
    res.json = function jsonWithRequestId(body) {
      let nextBody = body;
      if (
        res.statusCode >= 400 &&
        body &&
        typeof body === "object" &&
        !Array.isArray(body) &&
        !Object.prototype.hasOwnProperty.call(body, "requestId")
      ) {
        nextBody = { ...body, requestId: id };
      }
      return originalJson.call(this, nextBody);
    };
  }

  next();
}

module.exports = requestId;
module.exports.requestId = requestId;
module.exports.normalizeRequestId = normalizeRequestId;
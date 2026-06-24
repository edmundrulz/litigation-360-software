function apiGuard(req, res, next) {
  try {
    console.log("📡 API CALL:", {
      method: req.method,
      url: req.originalUrl,
      body: req.body
    });

    next();
  } catch (err) {
    console.error("🚨 API GUARD ERROR:", err);

    res.status(500).json({
      error: "Internal API guard failure"
    });
  }
}

module.exports = apiGuard;
function requireAdmin(req, res, next) {
  const user = req.user || {};

  const allowedRoles = [
    "OWNER",
    "SUPER_ADMIN",
    "ADMIN"
  ];

  if (!allowedRoles.includes(user.role)) {
    return res.status(403).json({
      success: false,
      error: "ADMIN_ACCESS_REQUIRED",
      message: "This endpoint requires admin access."
    });
  }

  next();
}

module.exports = {
  requireAdmin
};

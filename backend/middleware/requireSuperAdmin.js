function requireSuperAdmin(req, res, next) {
  const user = req.user || {};

  const allowedRoles = [
    "OWNER",
    "SUPER_ADMIN"
  ];

  if (!allowedRoles.includes(user.role)) {
    return res.status(403).json({
      success: false,
      error: "SUPER_ADMIN_ACCESS_REQUIRED",
      message: "This endpoint requires owner or super admin access."
    });
  }

  next();
}

module.exports = {
  requireSuperAdmin
};

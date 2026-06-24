function requireRole(...allowedRoles) {
  return (req, res, next) => {
    const user = req.user || req.userData || req.currentUser || null;

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized: authentication required"
      });
    }

    const role = user.role || user.userRole || user.type;

    if (!allowedRoles.includes(role)) {
      return res.status(403).json({
        success: false,
        message: "Forbidden: insufficient permission",
        requiredRoles: allowedRoles,
        currentRole: role || "unknown"
      });
    }

    next();
  };
}

module.exports = { requireRole };
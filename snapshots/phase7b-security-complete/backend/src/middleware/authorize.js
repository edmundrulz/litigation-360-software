// authorize.js
function authorize(allowedRoles) {
  return (req, res, next) => {
    // req.user is set by your auth middleware (auth.js)
    if (!req.user || !req.user.role) {
      return res.status(401).json({ error: 'Unauthorized: User role missing' });
    }
    const userRole = req.user.role;
    // Check if the user's role is allowed for this route
    if (allowedRoles.includes(userRole)) {
      next(); // allow access
    } else {
      return res.status(403).json({ error: 'Forbidden: Access denied' });
    }
  };
}

module.exports = authorize;

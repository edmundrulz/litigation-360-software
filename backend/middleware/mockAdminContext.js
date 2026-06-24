function mockOwner(req, res, next) {
  req.user = {
    id: "OWNER_001",
    name: "System Owner",
    role: "OWNER"
  };
  next();
}

function mockSuperAdmin(req, res, next) {
  req.user = {
    id: "SUPER_ADMIN_001",
    name: "Super Admin",
    role: "SUPER_ADMIN"
  };
  next();
}

function mockNormalUser(req, res, next) {
  req.user = {
    id: "USER_001",
    name: "Normal User",
    role: "LAWYER"
  };
  next();
}

module.exports = {
  mockOwner,
  mockSuperAdmin,
  mockNormalUser
};

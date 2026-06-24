const express = require("express");
const adminRoutes = require("../../backend/routes/admin-control-routes");
const commercialRoutes = require("../../backend/routes/commercial-monitoring-routes");

const {
  mockOwner,
  mockSuperAdmin,
  mockNormalUser
} = require("../../backend/middleware/mockAdminContext");

const app = express();

app.use(express.json());

app.use(function (err, req, res, next) {
  if (err instanceof SyntaxError && err.status === 400 && "body" in err) {
    return res.status(400).json({
      success: false,
      error: "INVALID_JSON_BODY",
      message: "Request body is not valid JSON."
    });
  }
  next(err);
});

app.use("/test/admin/owner", mockOwner, adminRoutes);
app.use("/test/admin/super", mockSuperAdmin, adminRoutes);
app.use("/test/admin/user", mockNormalUser, adminRoutes);

app.use("/test/admin/owner", mockOwner, commercialRoutes);
app.use("/test/admin/super", mockSuperAdmin, commercialRoutes);
app.use("/test/admin/user", mockNormalUser, commercialRoutes);

const PORT = 5061;

app.listen(PORT, function () {
  console.log("??? Phase 10ZZG Admin API test server running on port 5061");
  console.log("Health test:");
  console.log("http://localhost:5061/test/admin/owner/health");
  console.log("Commercial dashboard:");
  console.log("http://localhost:5061/test/admin/owner/dashboard");
});

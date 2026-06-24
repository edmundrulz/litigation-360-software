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

app.use("/test/admin/owner", mockOwner, adminRoutes);
app.use("/test/admin/super", mockSuperAdmin, adminRoutes);
app.use("/test/admin/user", mockNormalUser, adminRoutes);

app.use("/test/admin/owner", mockOwner, commercialRoutes);
app.use("/test/admin/super", mockSuperAdmin, commercialRoutes);
app.use("/test/admin/user", mockNormalUser, commercialRoutes);

const PORT = 5062;

app.listen(PORT, function () {
  console.log("??? Commercial Monitoring Test Server running on port 5062");
  console.log("Dashboard: http://localhost:5062/test/admin/owner/dashboard");
});

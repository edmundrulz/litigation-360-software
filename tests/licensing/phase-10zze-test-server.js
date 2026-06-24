const express = require("express");
const protectedRoutes = require("../../backend/routes/protected-feature-routes");
const {
  mockGroundZero,
  mockStarterFirm,
  mockTrialFirm
} = require("../../backend/middleware/mockFirmContext");

const app = express();

app.use(express.json());

app.use("/test/ground-zero", mockGroundZero, protectedRoutes);
app.use("/test/starter", mockStarterFirm, protectedRoutes);
app.use("/test/trial", mockTrialFirm, protectedRoutes);

const PORT = 5050;

app.listen(PORT, function () {
  console.log("??? Phase 10ZZE test server running on port " + PORT);
  console.log("Ground Zero test: http://localhost:5050/test/ground-zero/legal-ai");
  console.log("Starter locked test: http://localhost:5050/test/starter/legal-ai");
  console.log("Trial test: http://localhost:5050/test/trial/legal-ai");
});

const express = require('express');
const cors = require("cors");
const dotenv = require('dotenv');
const apiGuard = require("./utils/apiGuard");
const enterpriseRoutes = require("./routes/enterpriseRoutes");
dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use("/api/enterprise", enterpriseRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'Backend running' });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;

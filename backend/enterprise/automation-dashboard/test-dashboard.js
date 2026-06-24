const Database = require("better-sqlite3");
const { createAutomationDashboard } = require("./automationDashboard");
const db = new Database("litigation360.db");
const dashboard = createAutomationDashboard(db);
console.log(dashboard.getMetrics());
db.close();

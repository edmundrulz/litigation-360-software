const { createHealthMonitor } = require("./healthMonitor"); 
const monitor = createHealthMonitor({ database: function() { return true; }, automationBus: function() { return true; } }); 
const result = monitor.run(); 
if (result.status !== "HEALTHY") { console.error("TEST FAILED"); process.exit(1); } 
console.log("TEST SUCCESS: Health monitor passed"); 
console.log("STATUS:", result.status); 
console.log("TOTAL CHECKS:", result.total_checks); 

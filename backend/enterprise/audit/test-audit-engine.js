const { createAuditEngine } = require("./auditEngine"); 
const audit = createAuditEngine({}); 
const record = audit.record({ action: "TEST_AUDIT", module: "PHASE_09_5", record_id: "TEST-001", user: "SYSTEM_TEST", message: "Audit engine smoke test" }); 
if (!record.action || record.action !== "TEST_AUDIT") { console.error("TEST FAILED"); process.exit(1); } 
console.log("TEST SUCCESS: Audit record created"); 
console.log("ACTION:", record.action); 
console.log("MODULE:", record.module); 

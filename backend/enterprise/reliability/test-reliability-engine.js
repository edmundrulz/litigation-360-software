const { createReliabilityEngine } = require("./reliabilityEngine"); 
const reliability = createReliabilityEngine(); 
const ok = reliability.safeRun("SUCCESS_TEST", function() { return "OK"; }); 
const fail = reliability.safeRun("FAIL_TEST", function() { throw new Error("Expected failure"); }); 
if (ok.status !== "SUCCESS" || fail.status !== "FAILED") { console.error("TEST FAILED"); process.exit(1); } 
console.log("TEST SUCCESS: Reliability engine passed"); 
console.log("SUCCESS STATUS:", ok.status); 
console.log("FAIL STATUS:", fail.status); 

const { createNotificationHub } = require("./notificationHub"); 
const fakeBus = { published: [], publishEvent: function(event) { this.published.push(event); return "TEST-EVENT-ID"; } }; 
const hub = createNotificationHub(fakeBus); 
const notice = hub.notify({ level: "CRITICAL", title: "Test Alert", message: "Notification hub smoke test", related_module: "TEST", next_action: "REVIEW_TEST" }); 
if (!notice.title || fakeBus.published.length !== 1) { console.error("TEST FAILED"); process.exit(1); } 
console.log("TEST SUCCESS: Notification created and event published"); 
console.log("TITLE:", notice.title); 
console.log("LEVEL:", notice.level); 
console.log("EVENT TYPE:", fakeBus.published[0].event_type); 

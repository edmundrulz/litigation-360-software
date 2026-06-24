const crypto = require("crypto"); 
 
function createAutomationBus(db) { 
  if (!db) throw new Error("AutomationBus requires database instance"); 
 
  function publishEvent(event) { 
    if (!event.event_type) throw new Error("event_type is required"); 
    if (!event.source_module) throw new Error("source_module is required"); 
 
    const eventId = event.event_id || crypto.randomUUID(); 
    const payload = JSON.stringify(event.payload || {}); 
 
    db.prepare(`INSERT INTO automation_events (event_id,event_type,source_module,source_record_id,priority,payload_json,status,retry_count,max_retries,correlation_id,created_by) VALUES (@event_id,@event_type,@source_module,@source_record_id,@priority,@payload_json,'PENDING',0,@max_retries,@correlation_id,@created_by)`).run({ 
      event_id: eventId, 
      event_type: event.event_type, 
      source_module: event.source_module, 
      source_record_id: event.source_record_id || null, 
      priority: event.priority || "NORMAL", 
      payload_json: payload, 
      max_retries: event.max_retries || 3, 
      correlation_id: event.correlation_id || eventId, 
      created_by: event.created_by || "SYSTEM" 
    }); 
 
    db.prepare(`INSERT INTO automation_event_history (event_id,old_status,new_status,action,message,created_by) VALUES (@event_id,NULL,'PENDING','PUBLISH','Event published',@created_by)`).run({ 
      event_id: eventId, 
      created_by: event.created_by || "SYSTEM" 
    }); 
 
    return eventId; 
  } 
 
  function listEvents(limit = 50) { 
    return db.prepare("SELECT * FROM automation_events ORDER BY id DESC LIMIT ?").all(limit); 
  } 
 
  function getEvent(eventId) { 
    return db.prepare("SELECT * FROM automation_events WHERE event_id = ?").get(eventId); 
  } 
 
  return { publishEvent, listEvents, getEvent }; 
} 
 
module.exports = { createAutomationBus }; 

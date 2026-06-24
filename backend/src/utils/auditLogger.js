const db = require('../database');

function auditLog({
  userEmail,
  action,
  entityType,
  entityId,
  oldValue = null,
  newValue = null,
  ipAddress = null
}) {
  try {
    db.prepare(`
      INSERT INTO audit_logs (
        user_email,
        action,
        entity_type,
        entity_id,
        old_value,
        new_value,
        ip_address
      )
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `).run(
      userEmail,
      action,
      entityType,
      entityId,
      JSON.stringify(oldValue),
      JSON.stringify(newValue),
      ipAddress
    );
  } catch (error) {
    console.error(
      'Audit Log Error:',
      error.message
    );
  }
}

module.exports = auditLog;
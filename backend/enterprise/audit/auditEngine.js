function createAuditEngine(db) {
  if (!db) throw new Error("AuditEngine requires database instance");

  function record(data) {
    if (!data.action) throw new Error("audit action is required");
    if (!data.module) throw new Error("audit module is required");

    return {
      action: data.action,
      module: data.module,
      record_id: data.record_id || null,
      user: data.user || "SYSTEM",
      message: data.message || null,
      created_at: new Date().toISOString()
    };
  }

  return { record };
}

module.exports = { createAuditEngine };

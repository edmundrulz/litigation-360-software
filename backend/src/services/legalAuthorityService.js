const crypto = require("crypto");
const db = require("../database");
const sourceSeeds = require("../seeds/legalAuthoritySources");
const taxonomySeeds = require("../seeds/legalAuthorityTaxonomy");

const ALLOWED_SOURCE_FIELDS = new Set(["source_name", "provider_name", "base_url", "source_category", "authority_rank", "access_type", "authentication_required", "licence_type", "integration_mode", "api_available", "bulk_download_available", "scraping_status", "robots_review_status", "terms_review_status", "full_text_storage_allowed", "metadata_storage_allowed", "deep_linking_allowed", "update_frequency", "last_verified_at", "verification_status", "enabled", "notes"]);

function schemaReady() {
  return Boolean(db.prepare("SELECT 1 FROM sqlite_master WHERE type='table' AND name='legal_sources'").get());
}

function requireSchema() {
  if (!schemaReady()) {
    const error = new Error("Legal Authorities schema is not installed. Apply migration 025 to an approved database environment.");
    error.code = "LEGAL_SCHEMA_REQUIRED";
    throw error;
  }
}

function seedFoundation(actorId = "system") {
  requireSchema();
  const insertSource = db.prepare(`INSERT OR IGNORE INTO legal_sources (${Object.keys(sourceSeeds[0]).join(",")}) VALUES (${Object.keys(sourceSeeds[0]).map(() => "?").join(",")})`);
  const insertType = db.prepare("INSERT OR IGNORE INTO legal_authority_types (authority_type,display_name,description,category_group,enabled,display_order) VALUES (@authority_type,@display_name,@description,@category_group,@enabled,@display_order)");
  const insertJurisdiction = db.prepare("INSERT OR IGNORE INTO legal_jurisdictions (jurisdiction_id,display_name,country_code) VALUES ('MY','Malaysia','MY')");
  const transaction = db.transaction(() => {
    insertJurisdiction.run();
    sourceSeeds.forEach((source) => insertSource.run(...Object.values(source)));
    taxonomySeeds.forEach((type) => insertType.run(type));
    writeAudit(actorId, "FOUNDATION_SEEDED", "legal_registry", "MY", null, { sources: sourceSeeds.length, authorityTypes: taxonomySeeds.length });
  });
  transaction();
  return getSummary();
}

function listSources(filters = {}) {
  requireSchema();
  const clauses = []; const values = [];
  if (filters.category) { clauses.push("source_category = ?"); values.push(filters.category); }
  if (filters.access) { clauses.push("access_type = ?"); values.push(filters.access); }
  if (filters.enabled !== undefined) { clauses.push("enabled = ?"); values.push(filters.enabled ? 1 : 0); }
  if (filters.q) { clauses.push("(source_name LIKE ? OR provider_name LIKE ? OR notes LIKE ?)"); const q = `%${filters.q}%`; values.push(q, q, q); }
  const where = clauses.length ? `WHERE ${clauses.join(" AND ")}` : "";
  return db.prepare(`SELECT * FROM legal_sources ${where} ORDER BY authority_rank, source_name`).all(...values);
}

function listAuthorityTypes() {
  requireSchema();
  return db.prepare("SELECT * FROM legal_authority_types ORDER BY category_group, display_order, display_name").all();
}

function updateSource(sourceId, patch, actor) {
  requireSchema();
  const before = db.prepare("SELECT * FROM legal_sources WHERE source_id = ?").get(sourceId);
  if (!before) return null;
  const entries = Object.entries(patch || {}).filter(([key]) => ALLOWED_SOURCE_FIELDS.has(key));
  if (!entries.length) return before;
  const assignments = entries.map(([key]) => `${key} = ?`).join(", ");
  db.prepare(`UPDATE legal_sources SET ${assignments}, updated_at = CURRENT_TIMESTAMP WHERE source_id = ?`).run(...entries.map(([, value]) => value), sourceId);
  const after = db.prepare("SELECT * FROM legal_sources WHERE source_id = ?").get(sourceId);
  writeAudit(actor.userId, "SOURCE_UPDATED", "legal_source", sourceId, before, after, actor.ipAddress);
  return after;
}

function getSummary() {
  requireSchema();
  return {
    sources: db.prepare("SELECT COUNT(*) count FROM legal_sources").get().count,
    enabledSources: db.prepare("SELECT COUNT(*) count FROM legal_sources WHERE enabled = 1").get().count,
    authorityTypes: db.prepare("SELECT COUNT(*) count FROM legal_authority_types").get().count,
    authorities: db.prepare("SELECT COUNT(*) count FROM legal_authorities").get().count,
    pendingVerification: db.prepare("SELECT COUNT(*) count FROM legal_sources WHERE verification_status != 'verified'").get().count
  };
}

function writeAudit(actorId, action, entityType, entityId, before, after, ipAddress = null) {
  db.prepare("INSERT INTO legal_authority_audit_events (audit_id,actor_id,action,entity_type,entity_id,before_json,after_json,ip_address) VALUES (?,?,?,?,?,?,?,?)")
    .run(crypto.randomUUID(), actorId || "unknown", action, entityType, entityId, before ? JSON.stringify(before) : null, after ? JSON.stringify(after) : null, ipAddress);
}

module.exports = { getSummary, listAuthorityTypes, listSources, schemaReady, seedFoundation, updateSource };

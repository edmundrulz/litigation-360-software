PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS legal_sources (
  source_id TEXT PRIMARY KEY,
  source_name TEXT NOT NULL,
  provider_name TEXT NOT NULL,
  base_url TEXT NOT NULL,
  jurisdiction TEXT NOT NULL DEFAULT 'Malaysia',
  source_category TEXT NOT NULL,
  authority_rank TEXT NOT NULL,
  access_type TEXT NOT NULL,
  authentication_required INTEGER NOT NULL DEFAULT 0 CHECK(authentication_required IN (0,1)),
  licence_type TEXT NOT NULL,
  integration_mode TEXT NOT NULL,
  api_available INTEGER NOT NULL DEFAULT 0 CHECK(api_available IN (0,1)),
  bulk_download_available INTEGER NOT NULL DEFAULT 0 CHECK(bulk_download_available IN (0,1)),
  scraping_status TEXT NOT NULL DEFAULT 'disabled',
  robots_review_status TEXT NOT NULL DEFAULT 'not_reviewed',
  terms_review_status TEXT NOT NULL DEFAULT 'not_reviewed',
  full_text_storage_allowed INTEGER NOT NULL DEFAULT 0 CHECK(full_text_storage_allowed IN (0,1)),
  metadata_storage_allowed INTEGER NOT NULL DEFAULT 1 CHECK(metadata_storage_allowed IN (0,1)),
  deep_linking_allowed INTEGER NOT NULL DEFAULT 1 CHECK(deep_linking_allowed IN (0,1)),
  update_frequency TEXT,
  last_verified_at TEXT,
  verification_status TEXT NOT NULL DEFAULT 'pending_review',
  enabled INTEGER NOT NULL DEFAULT 1 CHECK(enabled IN (0,1)),
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_authority_types (
  authority_type TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  description TEXT NOT NULL,
  category_group TEXT NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1 CHECK(enabled IN (0,1)),
  display_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_jurisdictions (
  jurisdiction_id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  country_code TEXT,
  parent_jurisdiction_id TEXT REFERENCES legal_jurisdictions(jurisdiction_id),
  enabled INTEGER NOT NULL DEFAULT 1 CHECK(enabled IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_institutions (
  institution_id TEXT PRIMARY KEY,
  institution_type TEXT NOT NULL,
  display_name TEXT NOT NULL,
  jurisdiction_id TEXT REFERENCES legal_jurisdictions(jurisdiction_id),
  official_url TEXT,
  enabled INTEGER NOT NULL DEFAULT 1 CHECK(enabled IN (0,1)),
  metadata_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_authorities (
  authority_id TEXT PRIMARY KEY,
  public_identifier TEXT NOT NULL UNIQUE,
  authority_type TEXT NOT NULL REFERENCES legal_authority_types(authority_type),
  jurisdiction_id TEXT NOT NULL REFERENCES legal_jurisdictions(jurisdiction_id),
  sub_jurisdiction TEXT,
  title TEXT NOT NULL,
  short_title TEXT,
  alternative_titles_json TEXT NOT NULL DEFAULT '[]',
  official_number TEXT,
  citation TEXT,
  neutral_citation TEXT,
  report_citation TEXT,
  court_or_issuer TEXT,
  authority_rank TEXT NOT NULL DEFAULT 'unverified',
  publication_date TEXT,
  decision_date TEXT,
  commencement_date TEXT,
  effective_from TEXT,
  effective_to TEXT,
  repeal_date TEXT,
  status TEXT NOT NULL DEFAULT 'unknown',
  language TEXT,
  summary TEXT,
  official_text TEXT,
  source_id TEXT NOT NULL REFERENCES legal_sources(source_id),
  source_url TEXT NOT NULL,
  retrieval_date TEXT NOT NULL,
  last_verified_at TEXT,
  licence_class TEXT NOT NULL,
  full_text_storage_allowed INTEGER NOT NULL DEFAULT 0 CHECK(full_text_storage_allowed IN (0,1)),
  is_official INTEGER NOT NULL DEFAULT 0 CHECK(is_official IN (0,1)),
  is_current INTEGER NOT NULL DEFAULT 0 CHECK(is_current IN (0,1)),
  is_redacted INTEGER NOT NULL DEFAULT 0 CHECK(is_redacted IN (0,1)),
  is_restricted INTEGER NOT NULL DEFAULT 0 CHECK(is_restricted IN (0,1)),
  parent_authority_id TEXT REFERENCES legal_authorities(authority_id),
  root_authority_id TEXT REFERENCES legal_authorities(authority_id),
  checksum TEXT,
  metadata_json TEXT NOT NULL DEFAULT '{}',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_authority_versions (
  version_id TEXT PRIMARY KEY,
  authority_id TEXT NOT NULL REFERENCES legal_authorities(authority_id),
  version_number TEXT NOT NULL,
  version_date TEXT NOT NULL,
  effective_from TEXT,
  effective_to TEXT,
  version_status TEXT NOT NULL,
  source_url TEXT NOT NULL,
  checksum TEXT,
  change_summary TEXT,
  amendment_authority_id TEXT REFERENCES legal_authorities(authority_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(authority_id, version_number)
);

CREATE TABLE IF NOT EXISTS legal_authority_hierarchy (
  hierarchy_id TEXT PRIMARY KEY,
  parent_authority_id TEXT NOT NULL REFERENCES legal_authorities(authority_id),
  child_authority_id TEXT NOT NULL REFERENCES legal_authorities(authority_id),
  relationship_type TEXT NOT NULL,
  display_order INTEGER NOT NULL DEFAULT 0,
  effective_from TEXT,
  effective_to TEXT,
  UNIQUE(parent_authority_id, child_authority_id, relationship_type)
);

CREATE TABLE IF NOT EXISTS legal_authority_relationships (
  relationship_id TEXT PRIMARY KEY,
  from_authority_id TEXT NOT NULL REFERENCES legal_authorities(authority_id),
  relationship_type TEXT NOT NULL,
  to_authority_id TEXT NOT NULL REFERENCES legal_authorities(authority_id),
  pinpoint_reference TEXT,
  source_id TEXT REFERENCES legal_sources(source_id),
  source_url TEXT,
  confidence TEXT NOT NULL DEFAULT 'unverified',
  verification_status TEXT NOT NULL DEFAULT 'pending_review',
  verified_by TEXT,
  verified_at TEXT,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(from_authority_id, relationship_type, to_authority_id, pinpoint_reference)
);

CREATE TABLE IF NOT EXISTS legal_source_verifications (
  verification_id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES legal_sources(source_id),
  verification_type TEXT NOT NULL,
  status TEXT NOT NULL,
  evidence TEXT,
  verified_by TEXT,
  verified_at TEXT,
  expires_at TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_licence_controls (
  licence_id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES legal_sources(source_id),
  licence_class TEXT NOT NULL,
  metadata_storage_allowed INTEGER NOT NULL DEFAULT 1,
  full_text_storage_allowed INTEGER NOT NULL DEFAULT 0,
  excerpt_allowed INTEGER NOT NULL DEFAULT 0,
  export_allowed INTEGER NOT NULL DEFAULT 0,
  expires_at TEXT,
  approved_by TEXT,
  approved_at TEXT,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS legal_authority_audit_events (
  audit_id TEXT PRIMARY KEY,
  actor_id TEXT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  before_json TEXT,
  after_json TEXT,
  ip_address TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_legal_sources_category ON legal_sources(source_category);
CREATE INDEX IF NOT EXISTS idx_legal_sources_verification ON legal_sources(verification_status, enabled);
CREATE INDEX IF NOT EXISTS idx_legal_types_group ON legal_authority_types(category_group, enabled);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_title ON legal_authorities(title);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_type ON legal_authorities(authority_type);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_citation ON legal_authorities(citation);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_official_number ON legal_authorities(official_number);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_status ON legal_authorities(status, is_current);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_source ON legal_authorities(source_id);
CREATE INDEX IF NOT EXISTS idx_legal_authorities_parent ON legal_authorities(parent_authority_id);
CREATE INDEX IF NOT EXISTS idx_legal_relationships_from ON legal_authority_relationships(from_authority_id);
CREATE INDEX IF NOT EXISTS idx_legal_relationships_to ON legal_authority_relationships(to_authority_id);
CREATE INDEX IF NOT EXISTS idx_legal_audit_entity ON legal_authority_audit_events(entity_type, entity_id, created_at);

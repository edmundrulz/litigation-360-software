-- Litigation 360 Phase 9.5
-- Automation Bus Database Schema v1.0
-- Safe additive schema only. Does not delete existing tables.

CREATE TABLE IF NOT EXISTS automation_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL UNIQUE,
  event_type TEXT NOT NULL,
  source_module TEXT NOT NULL,
  source_record_id TEXT,
  priority TEXT NOT NULL DEFAULT 'NORMAL',
  payload_json TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING',
  retry_count INTEGER NOT NULL DEFAULT 0,
  max_retries INTEGER NOT NULL DEFAULT 3,
  correlation_id TEXT,
  created_by TEXT,
  failure_reason TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT,
  processed_at TEXT
);

CREATE TABLE IF NOT EXISTS automation_event_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL,
  old_status TEXT,
  new_status TEXT NOT NULL,
  action TEXT NOT NULL,
  message TEXT,
  created_by TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS automation_dead_letters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  source_module TEXT NOT NULL,
  payload_json TEXT,
  failure_reason TEXT NOT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TEXT,
  resolved_by TEXT,
  resolution_notes TEXT
);

CREATE TABLE IF NOT EXISTS automation_consumers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  consumer_name TEXT NOT NULL UNIQUE,
  event_type TEXT NOT NULL,
  target_module TEXT NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1,
  priority TEXT NOT NULL DEFAULT 'NORMAL',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS automation_retry_rules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  event_type TEXT NOT NULL UNIQUE,
  max_retries INTEGER NOT NULL DEFAULT 3,
  retry_delay_seconds INTEGER NOT NULL DEFAULT 60,
  escalation_required INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_automation_events_status ON automation_events(status);
CREATE INDEX IF NOT EXISTS idx_automation_events_type ON automation_events(event_type);
CREATE INDEX IF NOT EXISTS idx_automation_events_priority ON automation_events(priority);
CREATE INDEX IF NOT EXISTS idx_automation_events_created_at ON automation_events(created_at);
CREATE INDEX IF NOT EXISTS idx_automation_history_event_id ON automation_event_history(event_id);
CREATE INDEX IF NOT EXISTS idx_automation_dead_letters_event_id ON automation_dead_letters(event_id);

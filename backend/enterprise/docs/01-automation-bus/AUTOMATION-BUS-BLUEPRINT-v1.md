# Litigation 360 Phase 9.5
# Package A - Master Automation Bus Enterprise Blueprint v1.0

STATUS: Mandatory Core Infrastructure

PURPOSE:
The Automation Bus is the central nervous system of Litigation 360.
Every important action must create an event.
Every event must be traceable, retryable, auditable, and recoverable.

CORE RULE:
No major module should directly trigger another module manually.
Modules must publish events.
Other modules must consume events.

EXAMPLE:
MATTER_CREATED
triggers:
- conflict check
- matter number assignment
- folder creation
- task generation
- deadline generation
- calendar entry
- notification
- audit log
- dashboard update

REQUIRED DATABASE TABLES:
1. automation_events
2. automation_event_history
3. automation_dead_letters
4. automation_consumers
5. automation_retry_rules

EVENT STATUS:
PENDING
PROCESSING
COMPLETED
FAILED
RETRYING
DEAD_LETTER
HUMAN_REVIEW
CANCELLED

EVENT PRIORITY:
LOW
NORMAL
HIGH
CRITICAL

REQUIRED EVENT FIELDS:
event_id
event_type
source_module
source_record_id
priority
payload_json
status
retry_count
max_retries
created_at
updated_at
processed_at
failure_reason
correlation_id
created_by

CHECKS AND BALANCES:
- Event must have event_type
- Event must have source_module
- Event must have payload_json
- Failed event must have failure_reason
- Critical event cannot be silently dismissed
- Dead-letter event must be visible on dashboard
- Every retry must be logged

TESTING REQUIREMENTS:
1. Publish event test
2. Consume event test
3. Retry failed event test
4. Dead-letter routing test
5. Audit history test
6. Invalid event rejection test
7. Dashboard visibility test

READINESS CLASSIFICATION:
READY = Working schema + publish + consume + retry + audit
PARTIAL = Some logic exists but incomplete
BROKEN = Code exists but fails
PLACEHOLDER = Comment-only or empty file

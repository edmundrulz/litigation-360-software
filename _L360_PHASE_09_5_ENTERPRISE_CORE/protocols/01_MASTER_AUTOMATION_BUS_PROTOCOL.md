# Master Automation Bus Protocol

Every important system action must publish an event.

Required event fields:
- event_id
- event_type
- source_module
- priority
- payload_json
- status
- retry_count
- created_at
- processed_at
- failure_reason

Status values:
PENDING, PROCESSING, COMPLETED, FAILED, DEAD_LETTER, HUMAN_REVIEW

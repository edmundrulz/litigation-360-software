LITIGATION 360
PHASE 13D COMMUNICATION & FEEDBACK LAYER

Purpose:
Add three urgent pre-frontend communication features:

1. Internal Staff Communication
2. Client Contact Platform
3. Direct Feedback / Request Submission Platform

Architecture:
Build one shared Communication Core.

Do not create three separate duplicated chat systems.

Shared Core:
- conversations
- participants
- messages
- attachments
- read receipts
- presence
- notifications
- feedback requests
- audit logs

Implementation Rule:
Backend first.
Database second.
RBAC third.
Audit fourth.
Frontend last.

Status:
SPECIFICATION / SAFE SCAFFOLD ONLY

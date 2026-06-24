# Phase 9G Court Deadline Calculator Blueprint

Status: Commencing

## Objective
Calculate legal and court-related deadlines to reduce missed-deadline risk.

## Initial Deadline Types
- Filing deadline
- Service deadline
- Reply deadline
- Review deadline
- Compliance deadline

## Initial Rules
- Add days from trigger date
- Weekend-aware adjustment
- Basic Malaysia public-holiday placeholder
- Return calculated deadline and risk status

## API Target
POST /api/court-deadline/calculate

## Safeguards
- Invalid date rejected
- Invalid deadline type rejected
- Weekend dates adjusted to next Monday

## Exit Criteria
Court Deadline Calculator can calculate, adjust, and return deadline results.

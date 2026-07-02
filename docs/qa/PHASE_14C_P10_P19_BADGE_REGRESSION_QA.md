# Phase 14C P10-P19 Badge Regression QA

## Issue
P10-P19 roadmap badges were visually wrapping as P1 plus the second digit on a new line.

## Root Cause
The roadmap sequence label used .card-meta, but CSS forced the badge to a narrow fixed circular width that could not hold three-character labels.

## Fix
Added a CSS guard to keep .card-meta badges non-wrapping with flexible pill width.

## Acceptance Criteria
- P10 renders as P10
- P11 renders as P11
- P12 renders as P12
- P13 renders as P13
- P14 renders as P14
- P15 renders as P15
- P16 renders as P16
- P17 renders as P17
- P18 renders as P18
- P19 renders as P19
- No digit drops to a second line
- Frontend build passes

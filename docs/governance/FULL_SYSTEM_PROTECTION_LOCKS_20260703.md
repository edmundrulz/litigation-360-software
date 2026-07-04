# FULL SYSTEM PROTECTION LOCKS

Project:
Litigation 360 / LEOS

Date:
2026-07-03

Status:
ACTIVE

## Purpose

This document explains why earlier protection output only showed Page 3-specific locks and defines the expanded full-system lock coverage.

## Previous Gap

The earlier protection output showed:

- PROTECTED DELETION CHECK PASSED
- PAGE 3 REQUIRED COUNTER LOCK PASSED
- PAGE 3 ALPHABET FILTER LOCK PASSED
- PAGE 3 REAL PERCENTAGE LOCK PASSED

That meant:

1. deletion protection existed generally,
2. detailed Page 3 lock scripts existed,
3. but other system areas did not yet have detailed named lock checks.

## Corrected Protection Model

The protection system now includes:

1. General deletion / rename protection
2. Source baseline file existence lock
3. Page 3 structural/content locks
4. Page 4+ progress calculator locks
5. Phase 14 audit / closeout / integration documentation locks
6. Governance policy locks
7. Tooling existence locks

## Main Script

tools/verify-protected-system-locks.ps1

## Pre-Commit Protection Entry Point

tools/protection-pre-commit-check.ps1

## Expected Output

A proper full protection run should now show:

- PROTECTED DELETION CHECK PASSED
- PAGE 3 REQUIRED COUNTER LOCK PASSED
- PAGE 3 ALPHABET FILTER LOCK PASSED
- PAGE 3 REAL PERCENTAGE LOCK PASSED
- SOURCE BASELINE LOCK PASSED
- PAGE 3 STRUCTURAL LOCK PASSED
- PAGE 4+ PROGRESS CALCULATOR LOCK PASSED
- PHASE 14 AUDIT / CLOSEOUT LOCK PASSED
- GOVERNANCE POLICY LOCK PASSED
- TOOLING LOCK PASSED
- FULL PROTECTED SYSTEM LOCK PASSED
- PROTECTION PRE-COMMIT CHECK PASSED

## Important Limitation

These local lock scripts protect against accidental deletion, missing files, and missing required markers.

They do not replace remote repository protections.

For true long-term protection, also configure:

- GitHub protected branches
- disabled force-push
- required pull request review
- required status checks
- protected release tags
- external backups or git bundles

## Final Rule

Page 3 is no longer the only locked area.

All completed system work listed in the protected register is now covered by the expanded full-system lock check.

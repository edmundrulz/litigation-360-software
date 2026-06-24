# Client Profile V8.2 Mandatory Field + Single-Line Label Report

Generated: 2026-06-22 13:41:23

## Modified Files

- C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx
- C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css

## Backups

- C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Clients.jsx.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_MANDATORY_FIX_20260622-134122
- C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\App.css.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_MANDATORY_FIX_20260622-134122

## Fixed

1. Given Name required marker now stays on one line: Given Name *
2. NRIC No. / Passport No. required marker now stays on one line.
3. Normal labels no longer use flex-column behavior that forces * onto a separate line.
4. Core inputs remain single-line.
5. Mandatory fields strengthened.

## Mandatory Field Rules Added

Mandatory:
- Title Prefix
- Given Name
- Gender
- Immigration / Documented Status
- ID Type
- Identity Card Colour / Document Class
- NRIC No. / Passport No.
- Country
- Document Type
- Document Status
- Verification / Review Status

Conditional mandatory:
- Email Address OR Primary Phone Number, at least one required.
- Nationality / Country of Origin if foreign or non-Malaysian status.
- Manual title/gender override reason if override is checked.
- Unavailable Until time if Unavailable Until date is set.
- Reason for Unavailability if Unavailable Until date is set.

Validation retained:
- NRIC DOB extraction
- Minor blocking below age 18
- NRIC final digit gender check
- Title/gender match check
- Malaysian mobile number format check
- Verification flags for document/status mismatches

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO
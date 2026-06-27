# Phase EMAIL-1: Reusable Email Autocomplete Field

## Purpose

Provide a reusable frontend email input component that supports both:

- manual email entry, which must always remain allowed; and
- suggestion-assisted domain completion after `@`.

## Scope

Phase EMAIL-1 creates the reusable foundation only.

This phase does not integrate the component into live client, contact, matter, user, or firm forms.

## Created Files

- `frontend/src/data/emailSuggestions.js`
- `frontend/src/utils/emailValidation.js`
- `frontend/src/components/EmailAutocompleteInput.jsx`
- `docs/features/EMAIL_AUTOCOMPLETE_FIELD.md`

## Supported Behaviour

- User can manually type any email address.
- Suggestions appear after the user types `@`.
- Common global domains are suggested.
- Malaysia and Singapore business-domain patterns are suggested.
- Common TLDs are suggested.
- Selecting a suggestion auto-populates the email field.
- Keyboard support is included for:
  - ArrowDown
  - ArrowUp
  - Enter
  - Escape
- Click outside closes the suggestion dropdown.
- Validation warnings are soft prompts only.

## Validation Rules

The validation helper can detect:

- empty value;
- missing `@`;
- multiple `@` symbols;
- spaces;
- missing local name before `@`;
- missing domain after `@`;
- missing dot in the domain;
- incomplete domain ending.

Unknown custom domains are not hard-blocked.

## Manual Entry Rule

Manual entry is the source of truth.

Suggestions help the user, but the system must not treat the suggestion list as a whitelist.

Valid custom domains such as the following must remain manually enterable:

- `admin@lawfirm.com.my`
- `accounts@client-group.co`
- `support@company.sg`
- `user@custom-domain.legal`

## Why Every TLD Is Not Hardcoded

TLDs and public suffix rules change over time.

A static frontend list can become outdated and may incorrectly reject valid domains.

The frontend suggestion list is intentionally curated for usability, not authority.

## Future Enhancements

Future backend validation may add:

- IANA TLD validation;
- Public Suffix List validation;
- DNS MX record check;
- domain typo suggestions;
- firm-domain allowlist;
- admin override for special business domains.

## Phase EMAIL-1 Verification Checklist

- [ ] Only EMAIL-1 files are created.
- [ ] No existing pages are modified.
- [ ] No backend files are modified.
- [ ] No database files are modified.
- [ ] No package files are modified.
- [ ] Manual entry remains supported.
- [ ] Suggestions appear after `@`.
- [ ] Build passes from the frontend folder.

# Phase 8F Post-Commit Browser QA Directory Defect

Date: 2026-06-26

## Status

Post-commit browser QA identified a defect / UX gap in the Clients directory search and display path.

## Commit Under QA

49fdf0f feat(clients): enhance intake metadata and unify directory filters

## Passed Areas

- Page loads without red crash screen.
- Clients page opens.
- Add Client form opens.
- Existing client list/table appears.
- Search Clients input appears.
- Form/intake side mostly passed browser QA.

## Defect / Concern Area

The following directory/search/display controls appear unclear, overlapping, non-informative, not fully linked, or visually weak:

- Search By
- Phone / WhatsApp
- Search Clients
- Manual Client Selection
- Select existing client
- Category / Tag
- urgent / expedite tag behavior
- Show All Clients
- A-Z alphabet filters
- Client table result display

## Observed User Concern

Some results appear to overlap. Some controls appear pointless, not functioning, or not informative. The search and display path needs clearer linkage, better visual hierarchy, and more useful result feedback.

## Affected Display Columns / Area

- Title
- Given Name
- Surname
- Gender
- Age Category
- Generation
- IC Colour / Class
- Employment
- Marital Status
- IC / Passport
- Email
- Primary Phone
- Backup Phone
- WhatsApp
- Availability
- Address
- Emergency / Next of Kin
- Review Status
- Notes / Flags
- Created On
- Modified On
- Actions

## Safety Rule

Do not apply a blind patch.
Next action must be read-only inspection of the current Clients.jsx directory/filter implementation before any code change.

## Required Fix Direction

- Clarify which filter is active.
- Ensure Search By, Search Clients, Manual Client Selection, Category / Tag, A-Z, and Show All use one clear source of truth.
- Improve visual display and result feedback.
- Remove or repurpose controls that are pointless or misleading.
- Preserve committed Phase 8F work.
- Do not touch backend, database, auth, RBAC, API routes, server files, package files, or production logic.

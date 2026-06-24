# PHASE 12.0K LEGAL INTERFACE UI PROTOTYPE PACK

## Purpose

This pack provides a lab-safe UI prototype for a Legal Management System interface.

It includes:

- Left sidebar navigation
- Search button and repository search panel
- Instructions/help documentation panel
- Legal glossary panel
- Settings/configuration panel
- Scales of justice and legal branding
- Configurable firm information
- Configurable owner/managing partner details
- Malaysia/Singapore legal news links
- React component and CSS styling

## Files

- LegalManagementShell.jsx
- LegalManagementShell.css
- firmProfile.config.json
- legalNewsLinks.config.json

## Lab Integration Path

Do not overwrite your existing frontend immediately.

Recommended safe review location:

_LEOS_CONTROL\feature-exploration\ui-prototypes\legal-management-interface

## Future Frontend Integration Option

After review, the files can be copied to something like:

frontend\src\components\legal-shell\LegalManagementShell.jsx
frontend\src\components\legal-shell\LegalManagementShell.css
frontend\src\components\legal-shell\firmProfile.config.json
frontend\src\components\legal-shell\legalNewsLinks.config.json

Then imported into a route/page.

Example:

import LegalManagementShell from "./components/legal-shell/LegalManagementShell";

function App() {
  return <LegalManagementShell />;
}

## Safety

This prototype does not modify database, auth, RBAC, audit, production flags, or Phase 11 status.

## News Link Rule

The MY/SG legal news links are external links and should open in a new browser tab.
For a production-grade version, create an internal Staff Legal News page that lists approved external sources.

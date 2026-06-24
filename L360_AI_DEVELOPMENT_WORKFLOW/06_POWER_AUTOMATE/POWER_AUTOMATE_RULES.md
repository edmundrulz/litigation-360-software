# Power Automate Integration Plan

Use Power Automate for external workflow only.

Approved use cases:
- Notify Teams when GitHub issue created
- Notify admin when GitHub Actions fails
- Send Outlook email when release is approved
- Save exported reports to OneDrive or SharePoint
- Approval flow for production deployment

Do not use Power Automate for:
- RBAC
- Audit log creation
- Core matter logic
- Core billing logic
- Court deadline calculation
- Tenant isolation

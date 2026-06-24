# CRITICAL ASSET REGISTER

| Asset ID | Asset | Owner | Location | Backup Location | Recovery Method | Priority |
|---|---|---|---|---|---|---|
| CA-001 | Litigation 360 Source Code | Owner | Project Root | External/Cloud Backup | Restore repository/folder | Critical |
| CA-002 | Client Database | Owner/Lawyer | Database Server | Database Backup | Restore latest backup | Critical |
| CA-003 | Document Repository | Owner | Document Storage | Cloud/NAS Backup | Restore folder backup | Critical |
| CA-004 | Court Calendar | Lawyer/Admin | Calendar System | Export Backup | Restore calendar/export | Critical |
| CA-005 | Billing Records | Accounts | Finance Folder | Finance Backup | Restore finance files | High |
| CA-006 | Email Accounts | Owner/Admin | Gmail/Email Provider | Provider Backup | Account recovery | High |
| CA-007 | Audit Logs | System Admin | Reports/Audit | Audit Backup | Restore logs | High |

## Rule

No critical asset may exist without a backup location and recovery method.

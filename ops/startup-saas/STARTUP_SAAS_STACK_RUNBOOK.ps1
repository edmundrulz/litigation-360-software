<#
================================================================================
STARTUP SAAS STACK OPERATIONAL RUNBOOK
================================================================================

Project:
Litigation 360 / LEOS or any subscription-based SaaS application

Purpose:
This script documents and prepares the operational setup for a simple startup SaaS
system using the following stack:

- Website/app: React or Next.js
- Backend/server: Node.js / Express / NestJS
- Database: PostgreSQL
- Login: Clerk / Supabase Auth / Firebase Auth / custom auth
- Payment: Billplz / Stripe / Xendit / Curlec / ToyyibPay
- Hosting: Render / Railway / DigitalOcean / AWS Lightsail
- Email: Resend / SendGrid / Mailgun
- Admin panel: Internal owner dashboard
- Error tracking: Sentry
- Analytics: PostHog / Plausible / simple database reports

IMPORTANT SECURITY RULE:
Never paste real passwords, API keys, payment secrets, database passwords, or
private credentials directly into this script.

Use:
- environment variables
- .env files kept out of Git
- hosting provider secret manager
- vault systems
- secure CI/CD variables

This script is intended to:
1. Explain the architecture
2. Define environment settings
3. Create safe placeholder files
4. Check required tools
5. Document access controls
6. Document backup, recovery, monitoring, and rollback rules
7. Prepare a startup-ready operational foundation

This script does NOT:
1. Edit application source code
2. Run database migrations automatically
3. Deploy to production automatically
4. Store real secrets
5. Configure real payment keys
6. Create real cloud resources without your approval

================================================================================
VERSION CONTROL NOTES
================================================================================

Recommended branch:
docs/startup-saas-stack-runbook

Recommended commit message:
docs: add startup SaaS operational runbook

Change management:
- Any change to payment, login, database, or production deployment must be reviewed.
- Any production secret rotation must be logged.
- Any owner/admin permission change must be recorded.
- Any rollback must include reason, time, affected version, and recovery status.

================================================================================
#>

param(
    [ValidateSet("development", "staging", "production")]
    [string]$Environment = "development",

    [ValidateSet("Plan", "Preflight", "InitFiles", "BackupPlan", "RollbackPlan", "MonitoringPlan", "AccessMatrix")]
    [string]$Task = "Plan"
)

# ==============================================================================
# SECTION 1: GLOBAL VARIABLES
# ==============================================================================

# Root folder of your existing system.
# Type: string
# Default: current working directory
# Valid value: any valid project folder path
$ProjectRoot = Get-Location

# Application name.
# Type: string
# Change this to your actual app name.
$AppName = "Startup SaaS Subscription System"

# Default app module list.
# Type: array of strings
# These are the system components required for the minimum subscription platform.
$CoreModules = @(
    "Website / React or Next.js frontend",
    "Backend / Node.js API server",
    "PostgreSQL database",
    "Login and identity provider",
    "Payment gateway",
    "Subscription and license check",
    "Admin owner panel",
    "Email notification service",
    "Error tracking",
    "Analytics",
    "Backup and recovery",
    "Monitoring and alerts"
)

# Environment configuration.
# Replace placeholder values with real values through environment variables or vault.
# Do not store real secrets here.
$Config = @{
    development = @{
        AppUrl              = "http://localhost:3000"
        ApiUrl              = "http://localhost:5000"
        DatabaseUrl         = "USE_ENV_DATABASE_URL"
        AuthProvider        = "SupabaseAuth_OR_Clerk_OR_Firebase"
        PaymentProvider     = "Billplz_OR_Stripe_OR_Xendit_OR_Curlec_OR_ToyyibPay"
        EmailProvider       = "Resend_OR_SendGrid_OR_Mailgun"
        ErrorTracking       = "Sentry"
        Analytics           = "PostHog_OR_Plausible"
        Hosting             = "Localhost"
        ValidationInterval  = "Every login and every app start"
        BackupSchedule      = "Manual or daily local backup"
    }

    staging = @{
        AppUrl              = "https://staging.YOUR-DOMAIN.com"
        ApiUrl              = "https://api-staging.YOUR-DOMAIN.com"
        DatabaseUrl         = "USE_ENV_DATABASE_URL"
        AuthProvider        = "SupabaseAuth_OR_Clerk_OR_Firebase"
        PaymentProvider     = "PaymentProvider_TEST_MODE"
        EmailProvider       = "EmailProvider_TEST_MODE"
        ErrorTracking       = "Sentry"
        Analytics           = "PostHog_OR_Plausible"
        Hosting             = "Render_OR_Railway_OR_DigitalOcean"
        ValidationInterval  = "Every login plus every 12 hours"
        BackupSchedule      = "Daily backup"
    }

    production = @{
        AppUrl              = "https://YOUR-DOMAIN.com"
        ApiUrl              = "https://api.YOUR-DOMAIN.com"
        DatabaseUrl         = "USE_ENV_DATABASE_URL"
        AuthProvider        = "SupabaseAuth_OR_Clerk_OR_Firebase"
        PaymentProvider     = "PaymentProvider_LIVE_MODE"
        EmailProvider       = "EmailProvider_LIVE_MODE"
        ErrorTracking       = "Sentry"
        Analytics           = "PostHog_OR_Plausible"
        Hosting             = "Render_OR_Railway_OR_DigitalOcean_OR_AWS"
        ValidationInterval  = "Every login plus every 12 to 24 hours"
        BackupSchedule      = "Daily automated backup plus weekly restore test"
    }
}

# Resource allocation guide.
# These are startup values, not enterprise values.
$Resources = @{
    development = @{
        CPU     = "Local machine"
        Memory  = "4GB minimum recommended"
        Storage = "10GB local free space"
        Network = "Normal broadband"
    }

    staging = @{
        CPU     = "1 shared vCPU minimum"
        Memory  = "1GB to 2GB RAM"
        Storage = "10GB to 25GB"
        Network = "HTTPS required"
    }

    production = @{
        CPU     = "1 to 2 vCPU minimum for early launch"
        Memory  = "2GB RAM minimum"
        Storage = "25GB minimum plus backup storage"
        Network = "HTTPS, firewall, rate limiting, CDN later"
    }
}

# Monitoring thresholds.
# If exceeded, investigate or alert owner/admin.
$MonitoringThresholds = @{
    CpuWarningPercent             = 75
    CpuCriticalPercent            = 90
    MemoryWarningPercent          = 75
    MemoryCriticalPercent         = 90
    DiskWarningPercent            = 75
    DiskCriticalPercent           = 90
    ApiErrorRateWarningPercent    = 2
    ApiErrorRateCriticalPercent   = 5
    PaymentFailureWarningPercent  = 5
    LoginFailureWarningPercent    = 10
    DatabaseConnectionFailures    = 3
    BackupFailureCount            = 1
}

# ==============================================================================
# SECTION 2: LOGGING AND ERROR HANDLING
# ==============================================================================

function Write-RunbookLog {
    <#
    Purpose:
    Writes operational messages to the terminal and local log folder.

    Input:
    - Message: string
    - Level: INFO, WARN, ERROR, SUCCESS

    Output:
    - Console message
    - Log line in ops/startup-saas/logs/runbook.log

    Fallback:
    If log folder cannot be created, continue console output only.
    #>

    param(
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp][$Level] $Message"

    if ($Level -eq "ERROR") {
        Write-Host $line -ForegroundColor Red
    }
    elseif ($Level -eq "WARN") {
        Write-Host $line -ForegroundColor Yellow
    }
    elseif ($Level -eq "SUCCESS") {
        Write-Host $line -ForegroundColor Green
    }
    else {
        Write-Host $line
    }

    try {
        $logDir = Join-Path $ProjectRoot "ops/startup-saas/logs"
        New-Item -ItemType Directory -Force $logDir | Out-Null
        Add-Content -Path (Join-Path $logDir "runbook.log") -Value $line
    }
    catch {
        Write-Host "[WARN] Could not write to log file. Console logging only."
    }
}

function Stop-OnError {
    <#
    Purpose:
    Standard failure handler.

    Input:
    - Message: error explanation

    Output:
    - Error log
    - Script stops safely

    Fallback:
    User must manually check error and rerun after fixing.
    #>

    param([string]$Message)

    Write-RunbookLog -Message $Message -Level "ERROR"
    throw $Message
}

# ==============================================================================
# SECTION 3: TOOL CHECKS
# ==============================================================================

function Test-RequiredTool {
    <#
    Purpose:
    Checks whether a required command line tool exists.

    Input:
    - ToolName: command name, example git, node, npm, psql

    Output:
    - Pass/fail status

    Why necessary:
    Prevents setup from continuing when important tools are missing.

    Fallback:
    Install missing tool manually and rerun Preflight.
    #>

    param([string]$ToolName)

    $tool = Get-Command $ToolName -ErrorAction SilentlyContinue

    if ($null -eq $tool) {
        Write-RunbookLog -Message "$ToolName not found. Install it before production setup." -Level "WARN"
        return $false
    }

    Write-RunbookLog -Message "$ToolName found at $($tool.Source)" -Level "SUCCESS"
    return $true
}

function Invoke-Preflight {
    <#
    Purpose:
    Performs safe read-only checks before setup.

    Checks:
    - Git
    - Node.js
    - npm
    - PostgreSQL client if available
    - Current branch
    - Current Git status

    Input:
    None

    Output:
    Preflight report

    Trigger:
    Run before creating files, deployment, backup, rollback, or production change.
    #>

    Write-RunbookLog -Message "Starting preflight checks for $Environment"

    Test-RequiredTool "git" | Out-Null
    Test-RequiredTool "node" | Out-Null
    Test-RequiredTool "npm" | Out-Null
    Test-RequiredTool "psql" | Out-Null
    Test-RequiredTool "pg_dump" | Out-Null

    Write-RunbookLog -Message "Current project root: $ProjectRoot"

    try {
        $branch = git branch --show-current
        Write-RunbookLog -Message "Current Git branch: $branch"

        $status = git status --short
        if ([string]::IsNullOrWhiteSpace($status)) {
            Write-RunbookLog -Message "Git working tree appears clean." -Level "SUCCESS"
        }
        else {
            Write-RunbookLog -Message "Git working tree has changes:" -Level "WARN"
            Write-Host $status
        }

        $latestCommit = git log --oneline -1
        Write-RunbookLog -Message "Latest commit: $latestCommit"
    }
    catch {
        Write-RunbookLog -Message "Git information could not be read." -Level "WARN"
    }
}

# ==============================================================================
# SECTION 4: ACCESS CONTROL MATRIX
# ==============================================================================

function Show-AccessMatrix {
    <#
    Purpose:
    Documents who can access what.

    Why necessary:
    Prevents accidental exposure of payment, database, admin, or production tools.

    Roles:
    - Owner
    - Developer
    - Support
    - Finance
    - User
    - Service account

    Output:
    Access matrix displayed in terminal.
    #>

    $matrix = @(
        [PSCustomObject]@{
            Role = "Owner"
            Access = "Full admin panel, billing overview, user suspension, feature kill switch, reports"
            Restrictions = "Must use MFA. Critical actions require confirmation."
        },
        [PSCustomObject]@{
            Role = "Developer"
            Access = "Development and staging code, logs, non-production database"
            Restrictions = "No live payment secrets unless approved. No production database write access by default."
        },
        [PSCustomObject]@{
            Role = "Support"
            Access = "User lookup, subscription status, support notes"
            Restrictions = "No payment secrets. No database direct access. No mass suspension."
        },
        [PSCustomObject]@{
            Role = "Finance"
            Access = "Invoices, payments, refunds, subscription reports"
            Restrictions = "No source code. No database admin. No security settings."
        },
        [PSCustomObject]@{
            Role = "User"
            Access = "Own account, own subscription, own data"
            Restrictions = "No admin access. No other user data."
        },
        [PSCustomObject]@{
            Role = "Service Account"
            Access = "Limited API tasks such as payment webhook, email sending, backup job"
            Restrictions = "Least privilege only. Rotate secrets regularly."
        }
    )

    Write-RunbookLog -Message "Access Control Matrix"
    $matrix | Format-Table -AutoSize
}

# ==============================================================================
# SECTION 5: ENVIRONMENT FILE TEMPLATE
# ==============================================================================

function New-EnvironmentTemplate {
    <#
    Purpose:
    Creates a safe .env.example file.

    Input:
    Environment name

    Output:
    ops/startup-saas/.env.example

    Why necessary:
    Shows what secrets are needed without exposing real secrets.

    Security:
    Real .env files must not be committed to Git.
    #>

    $envExamplePath = Join-Path $ProjectRoot "ops/startup-saas/.env.example"

    $content = @"
# ==============================================================================
# ENVIRONMENT VARIABLE TEMPLATE
# ==============================================================================
# Copy this to your actual secret manager or hosting provider environment settings.
# Do not commit real .env files to Git.
# Do not paste real secrets into documentation.
# ==============================================================================

APP_ENV=$Environment
APP_NAME=Startup SaaS Subscription System

# App URLs
APP_URL=$($Config[$Environment].AppUrl)
API_URL=$($Config[$Environment].ApiUrl)

# Database
DATABASE_URL=postgresql://USERNAME:PASSWORD@HOST:PORT/DATABASE_NAME

# Auth provider
AUTH_PROVIDER=$($Config[$Environment].AuthProvider)
AUTH_SECRET_KEY=USE_SECURE_VAULT_OR_HOSTING_SECRET
AUTH_PUBLIC_KEY=USE_PROVIDER_PUBLIC_KEY

# Payment provider
PAYMENT_PROVIDER=$($Config[$Environment].PaymentProvider)
PAYMENT_SECRET_KEY=USE_SECURE_VAULT_OR_HOSTING_SECRET
PAYMENT_WEBHOOK_SECRET=USE_SECURE_VAULT_OR_HOSTING_SECRET

# Email provider
EMAIL_PROVIDER=$($Config[$Environment].EmailProvider)
EMAIL_API_KEY=USE_SECURE_VAULT_OR_HOSTING_SECRET
EMAIL_FROM=no-reply@YOUR-DOMAIN.com

# Error tracking
SENTRY_DSN=USE_SENTRY_DSN

# Analytics
ANALYTICS_PROVIDER=$($Config[$Environment].Analytics)
ANALYTICS_KEY=USE_ANALYTICS_KEY

# Licensing / subscription
LICENSE_VALIDATION_INTERVAL_HOURS=12
TRIAL_DAYS=14
GRACE_PERIOD_DAYS=3
DEFAULT_DEVICE_LIMIT=1

# Admin security
OWNER_EMAIL=owner@YOUR-DOMAIN.com
REQUIRE_ADMIN_MFA=true

# Backup
BACKUP_ENABLED=true
BACKUP_RETENTION_DAYS=30
"@

    Set-Content -Path $envExamplePath -Value $content -Encoding UTF8
    Write-RunbookLog -Message "Created environment template: $envExamplePath" -Level "SUCCESS"
}

# ==============================================================================
# SECTION 6: SYSTEM ARCHITECTURE PLAN
# ==============================================================================

function Show-SystemPlan {
    <#
    Purpose:
    Explains the full simple architecture in layman terms.

    Output:
    Terminal documentation.

    Why necessary:
    Keeps the system understandable before building or deploying.
    #>

    Write-RunbookLog -Message "System Architecture Plan"

    Write-Host ""
    Write-Host "APP FLOW"
    Write-Host "--------"
    Write-Host "1. User opens website/app."
    Write-Host "2. User logs in."
    Write-Host "3. App checks subscription status from server."
    Write-Host "4. Server checks payment and plan."
    Write-Host "5. App unlocks allowed features."
    Write-Host "6. Admin can suspend, revoke, or change access."
    Write-Host "7. Logs are kept for support, audit, and dispute handling."

    Write-Host ""
    Write-Host "CORE MODULES"
    Write-Host "------------"
    foreach ($module in $CoreModules) {
        Write-Host "- $module"
    }

    Write-Host ""
    Write-Host "SELECTED ENVIRONMENT CONFIG"
    Write-Host "---------------------------"
    $Config[$Environment].GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "$($_.Name): $($_.Value)"
    }

    Write-Host ""
    Write-Host "RESOURCE GUIDE"
    Write-Host "--------------"
    $Resources[$Environment].GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "$($_.Name): $($_.Value)"
    }
}

# ==============================================================================
# SECTION 7: INTEGRATION POINTS
# ==============================================================================

function Show-IntegrationPlan {
    <#
    Purpose:
    Documents where external systems connect.

    Integrations:
    - Auth
    - Payment
    - Email
    - Database
    - Error tracking
    - Analytics
    - Hosting

    Authentication:
    Use environment variables or secure vault.

    Output:
    Integration checklist.
    #>

    Write-RunbookLog -Message "Integration Plan"

    $integrations = @(
        [PSCustomObject]@{
            System = "Login Provider"
            ExampleTools = "Clerk, Supabase Auth, Firebase Auth"
            ConnectsTo = "Frontend and backend API"
            AuthMethod = "Provider SDK keys stored in env variables"
            RequiredWhen = "Before users can subscribe or access accounts"
        },
        [PSCustomObject]@{
            System = "Payment Gateway"
            ExampleTools = "Billplz, Stripe, Xendit, Curlec, ToyyibPay"
            ConnectsTo = "Backend webhook endpoint"
            AuthMethod = "Secret API key and webhook signing secret"
            RequiredWhen = "Before collecting subscription payments"
        },
        [PSCustomObject]@{
            System = "PostgreSQL Database"
            ExampleTools = "Supabase DB, Railway DB, Render DB, DigitalOcean DB"
            ConnectsTo = "Backend server"
            AuthMethod = "DATABASE_URL in secure env variable"
            RequiredWhen = "Before storing users, subscriptions, licenses, audit logs"
        },
        [PSCustomObject]@{
            System = "Email Provider"
            ExampleTools = "Resend, SendGrid, Mailgun"
            ConnectsTo = "Backend notification service"
            AuthMethod = "Email API key in secure env variable"
            RequiredWhen = "For login emails, invoices, reminders, alerts"
        },
        [PSCustomObject]@{
            System = "Error Tracking"
            ExampleTools = "Sentry"
            ConnectsTo = "Frontend and backend"
            AuthMethod = "Sentry DSN"
            RequiredWhen = "Before beta users start testing"
        },
        [PSCustomObject]@{
            System = "Analytics"
            ExampleTools = "PostHog, Plausible"
            ConnectsTo = "Frontend and backend events"
            AuthMethod = "Analytics project key"
            RequiredWhen = "When tracking usage, conversion, churn, referral performance"
        }
    )

    $integrations | Format-Table -AutoSize
}

# ==============================================================================
# SECTION 8: SCHEDULING AND EVENT TRIGGERS
# ==============================================================================

function Show-SchedulePlan {
    <#
    Purpose:
    Defines when each operation should run.

    Examples:
    - License check
    - Backup
    - Payment sync
    - Email reminders
    - Monitoring alerts

    Output:
    Schedule table.
    #>

    Write-RunbookLog -Message "Scheduling and Event Trigger Plan"

    $schedule = @(
        [PSCustomObject]@{
            Operation = "License / subscription validation"
            Trigger = "User login, app start, then every 12 to 24 hours"
            Reason = "Ensures unpaid or expired users do not keep premium access"
        },
        [PSCustomObject]@{
            Operation = "Payment webhook processing"
            Trigger = "Immediately when payment provider sends event"
            Reason = "Updates subscription after payment, failure, refund, or chargeback"
        },
        [PSCustomObject]@{
            Operation = "Failed payment reminder"
            Trigger = "After failed payment, then daily during grace period"
            Reason = "Improves renewal recovery"
        },
        [PSCustomObject]@{
            Operation = "Database backup"
            Trigger = "Daily for production, manual for development"
            Reason = "Protects business data"
        },
        [PSCustomObject]@{
            Operation = "Restore test"
            Trigger = "Weekly or monthly"
            Reason = "Confirms backups actually work"
        },
        [PSCustomObject]@{
            Operation = "Error report review"
            Trigger = "Daily during beta, weekly after stable"
            Reason = "Finds bugs before users complain"
        },
        [PSCustomObject]@{
            Operation = "Referral fraud review"
            Trigger = "Before referral reward is approved"
            Reason = "Prevents self-referral and fake account abuse"
        }
    )

    $schedule | Format-Table -AutoSize
}

# ==============================================================================
# SECTION 9: MONITORING AND ALERTING
# ==============================================================================

function Show-MonitoringPlan {
    <#
    Purpose:
    Documents monitoring rules and alert thresholds.

    Output:
    Monitoring threshold table and escalation plan.

    Escalation:
    - Warning: review within 24 hours
    - Critical: review immediately
    - Payment/database failure: urgent
    #>

    Write-RunbookLog -Message "Monitoring and Alerting Plan"

    Write-Host ""
    Write-Host "THRESHOLDS"
    Write-Host "----------"
    $MonitoringThresholds.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "$($_.Name): $($_.Value)"
    }

    Write-Host ""
    Write-Host "ESCALATION PLAN"
    Write-Host "---------------"
    Write-Host "Level 1: Warning - review logs within 24 hours."
    Write-Host "Level 2: Critical - owner/developer checks immediately."
    Write-Host "Level 3: Payment/database/security failure - pause affected function if needed."
    Write-Host "Level 4: Production outage - rollback to last working version."
}

# ==============================================================================
# SECTION 10: BACKUP AND RECOVERY
# ==============================================================================

function Show-BackupPlan {
    <#
    Purpose:
    Documents backup procedure.

    Important:
    This function does not run pg_dump automatically.
    It shows the correct safe plan.

    Backup targets:
    - PostgreSQL database
    - uploaded files
    - environment variable inventory
    - deployment configuration
    - audit logs

    Recovery:
    Restore backup into staging first before production.
    #>

    Write-RunbookLog -Message "Backup and Recovery Plan"

    Write-Host ""
    Write-Host "BACKUP RULES"
    Write-Host "------------"
    Write-Host "1. Production database backup: daily."
    Write-Host "2. Keep at least 30 days of backups."
    Write-Host "3. Store backups away from the main server."
    Write-Host "4. Encrypt backups."
    Write-Host "5. Test restore regularly."
    Write-Host "6. Never test restore directly on production first."

    Write-Host ""
    Write-Host "EXAMPLE POSTGRES BACKUP COMMAND"
    Write-Host "-------------------------------"
    Write-Host "Do not run until DATABASE_URL is correctly configured."
    Write-Host 'pg_dump "$env:DATABASE_URL" > ".\backups\backup_YYYYMMDD_HHMM.sql"'

    Write-Host ""
    Write-Host "RECOVERY ORDER"
    Write-Host "--------------"
    Write-Host "1. Confirm incident."
    Write-Host "2. Stop affected write operations if necessary."
    Write-Host "3. Restore latest backup into staging."
    Write-Host "4. Verify data."
    Write-Host "5. Restore production only after confirmation."
    Write-Host "6. Log recovery action."
}

# ==============================================================================
# SECTION 11: ROLLBACK PLAN
# ==============================================================================

function Show-RollbackPlan {
    <#
    Purpose:
    Documents rollback procedure.

    When to rollback:
    - Broken login
    - Broken payment
    - Broken subscription check
    - Database migration failure
    - High error rate after deployment
    - Security incident

    Output:
    Rollback checklist.
    #>

    Write-RunbookLog -Message "Rollback Plan"

    Write-Host ""
    Write-Host "ROLLBACK TRIGGERS"
    Write-Host "-----------------"
    Write-Host "1. Users cannot log in."
    Write-Host "2. Payments are not processed."
    Write-Host "3. Paid users are locked out."
    Write-Host "4. Free users gain paid features."
    Write-Host "5. API error rate exceeds threshold."
    Write-Host "6. Database migration fails."
    Write-Host "7. Security issue detected."

    Write-Host ""
    Write-Host "ROLLBACK STEPS"
    Write-Host "--------------"
    Write-Host "1. Announce internal incident."
    Write-Host "2. Stop new deployment."
    Write-Host "3. Revert app to last stable release."
    Write-Host "4. Do not rollback database blindly."
    Write-Host "5. If database changed, restore staging copy first."
    Write-Host "6. Confirm login, payment, subscription, and admin panel."
    Write-Host "7. Record incident and fix root cause."
}

# ==============================================================================
# SECTION 12: CREATE STARTUP FILES
# ==============================================================================

function Initialize-StartupFiles {
    <#
    Purpose:
    Creates safe operational folders and documentation templates.

    Files created:
    - ops/startup-saas/.env.example
    - ops/startup-saas/ACCESS_MATRIX.md
    - ops/startup-saas/DEPLOYMENT_CHECKLIST.md
    - ops/startup-saas/MONITORING_THRESHOLDS.md

    Important:
    These are documentation and placeholder files only.
    They do not deploy anything.
    #>

    Write-RunbookLog -Message "Creating startup SaaS operational files"

    $base = Join-Path $ProjectRoot "ops/startup-saas"
    New-Item -ItemType Directory -Force $base | Out-Null
    New-Item -ItemType Directory -Force (Join-Path $base "logs") | Out-Null
    New-Item -ItemType Directory -Force (Join-Path $base "backups") | Out-Null
    New-Item -ItemType Directory -Force (Join-Path $base "config") | Out-Null

    New-EnvironmentTemplate

    $accessMatrixPath = Join-Path $base "ACCESS_MATRIX.md"
    @"
# ACCESS MATRIX

## Owner
Access:
- Full admin panel
- Suspend accounts
- Revoke licenses
- View payments
- View analytics
- Trigger emergency feature disable

Security:
- MFA required
- Critical actions must be logged

## Developer
Access:
- Development code
- Staging environment
- Error logs
- Non-production database

Restrictions:
- No production database write access by default
- No live payment secrets by default

## Support
Access:
- User lookup
- Subscription status
- Support notes

Restrictions:
- No source code
- No payment secrets
- No mass suspension

## Finance
Access:
- Invoice reports
- Payment reports
- Refund status

Restrictions:
- No source code
- No database admin
- No security settings

## User
Access:
- Own account
- Own subscription
- Own data

Restrictions:
- No admin access
- No other user records

## Service Account
Access:
- Only the exact API or scheduled job needed

Rules:
- Use least privilege
- Rotate keys
- Store secrets in vault or hosting secret manager
"@ | Set-Content $accessMatrixPath -Encoding UTF8

    $deploymentPath = Join-Path $base "DEPLOYMENT_CHECKLIST.md"
    @"
# DEPLOYMENT CHECKLIST

Environment:
$Environment

## Before Deployment

- [ ] Git working tree is clean
- [ ] Latest code reviewed
- [ ] Environment variables configured
- [ ] Database backup completed
- [ ] Payment provider set to correct mode
- [ ] Auth provider keys configured
- [ ] Email provider tested
- [ ] Sentry/error tracking enabled
- [ ] Admin owner account protected with MFA

## Smoke Test After Deployment

- [ ] App opens
- [ ] User can register
- [ ] User can log in
- [ ] Trial status works
- [ ] Payment checkout opens
- [ ] Webhook updates subscription
- [ ] Paid feature unlocks
- [ ] Expired user is restricted
- [ ] Admin can suspend user
- [ ] Error tracking receives test event
- [ ] Backup schedule confirmed

## Rollback Decision

Rollback if:
- Login breaks
- Payment breaks
- Paid users are wrongly blocked
- Free users get paid access
- Error rate exceeds critical threshold
"@ | Set-Content $deploymentPath -Encoding UTF8

    $monitoringPath = Join-Path $base "MONITORING_THRESHOLDS.md"
    @"
# MONITORING THRESHOLDS

## Server

CPU warning:
$($MonitoringThresholds.CpuWarningPercent)%

CPU critical:
$($MonitoringThresholds.CpuCriticalPercent)%

Memory warning:
$($MonitoringThresholds.MemoryWarningPercent)%

Memory critical:
$($MonitoringThresholds.MemoryCriticalPercent)%

Disk warning:
$($MonitoringThresholds.DiskWarningPercent)%

Disk critical:
$($MonitoringThresholds.DiskCriticalPercent)%

## Application

API error warning:
$($MonitoringThresholds.ApiErrorRateWarningPercent)%

API error critical:
$($MonitoringThresholds.ApiErrorRateCriticalPercent)%

Payment failure warning:
$($MonitoringThresholds.PaymentFailureWarningPercent)%

Login failure warning:
$($MonitoringThresholds.LoginFailureWarningPercent)%

Database connection failures before alert:
$($MonitoringThresholds.DatabaseConnectionFailures)

Backup failure count before alert:
$($MonitoringThresholds.BackupFailureCount)

## Escalation

Warning:
Review within 24 hours.

Critical:
Review immediately.

Payment/database/security issue:
Treat as urgent.
"@ | Set-Content $monitoringPath -Encoding UTF8

    Write-RunbookLog -Message "Startup SaaS operational files created in $base" -Level "SUCCESS"
}

# ==============================================================================
# SECTION 13: MAIN EXECUTION ROUTER
# ==============================================================================

Write-RunbookLog -Message "Running $Task for $Environment environment"

switch ($Task) {
    "Plan" {
        Show-SystemPlan
        Show-IntegrationPlan
        Show-SchedulePlan
        Show-AccessMatrix
        Show-MonitoringPlan
        Show-BackupPlan
        Show-RollbackPlan
    }

    "Preflight" {
        Invoke-Preflight
    }

    "InitFiles" {
        Invoke-Preflight
        Initialize-StartupFiles
    }

    "BackupPlan" {
        Show-BackupPlan
    }

    "RollbackPlan" {
        Show-RollbackPlan
    }

    "MonitoringPlan" {
        Show-MonitoringPlan
    }

    "AccessMatrix" {
        Show-AccessMatrix
    }

    default {
        Stop-OnError "Unknown task selected."
    }
}

Write-RunbookLog -Message "Runbook task completed: $Task" -Level "SUCCESS"

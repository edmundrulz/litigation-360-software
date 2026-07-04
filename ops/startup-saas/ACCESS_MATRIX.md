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

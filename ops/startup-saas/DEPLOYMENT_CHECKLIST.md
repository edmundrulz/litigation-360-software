# DEPLOYMENT CHECKLIST

Environment:
development

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

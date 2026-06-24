# Backend Route Protection Checklist

| Check | Requirement | Status |
|---|---|---|
| Feature key exists | features.json contains feature | REQUIRED |
| Plan entitlement exists | plans.json contains feature under correct plan | REQUIRED |
| Middleware applied | requireFeature("FEATURE_KEY") used | REQUIRED |
| Ground Zero tested | Ground Zero returns 200 | REQUIRED |
| Locked user tested | Unauthorized user returns 403 | REQUIRED |
| Trial tested | Trial user returns 200 if active | REQUIRED |
| Audit log tested | access attempt written to log | REQUIRED |
| Frontend aligned | frontend featureAccess.js matches backend rule | REQUIRED |
| No direct bypass | route cannot be accessed without middleware | REQUIRED |
| Documentation updated | SOP updated | REQUIRED |

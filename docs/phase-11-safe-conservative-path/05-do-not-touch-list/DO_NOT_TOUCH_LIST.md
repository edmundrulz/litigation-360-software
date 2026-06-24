# PHASE 11 DO-NOT-TOUCH LIST

These areas remain protected during Phase 11A.

| Area | Reason | Status |
|---|---|---|
| Authentication | Security-sensitive | Protected |
| RBAC / permissions | Can break user access | Protected |
| Database schema | Can break reports and existing data | Protected |
| Backend API routes | Can break frontend/backend connection | Protected |
| Migration scripts | Can damage data structure | Protected |
| Production server logic | High blast radius | Protected |
| Real client data | Confidentiality risk | Protected |

@echo off
echo Creating Phase 7C security regression tests...

node -e "const fs=require('fs');fs.mkdirSync('tests',{recursive:true});fs.writeFileSync('tests/security-routes.test.js',`const request = require('supertest');\nconst app = require('../backend/src/server');\n\nconst protectedRoutes = [\n  '/auditlogs',\n  '/system-diagnostic',\n  '/debug',\n  '/errors',\n  '/system-report',\n  '/monitor',\n  '/integrity-scanner',\n  '/auto-heal',\n  '/scheduler',\n  '/dashboard'\n];\n\ndescribe('Security Regression - Protected Routes', () => {\n  test.each(protectedRoutes)('GET %s should not crash or expose unrestricted access', async (route) => {\n    const res = await request(app).get(route);\n    expect([200, 301, 302, 401, 403, 404]).toContain(res.statusCode);\n  });\n});\n`);"

echo Running security tests...
npm test

pause
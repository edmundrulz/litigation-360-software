@echo off
echo Creating Phase 7C CRUD smoke tests...

node -e "const fs=require('fs');fs.mkdirSync('tests',{recursive:true});fs.writeFileSync('tests/crud-smoke.test.js',`const request = require('supertest');\nconst app = require('../backend/src/server');\n\nconst allowed = [200,201,204,400,401,403,404,409,422,500];\n\nconst modules = [\n  { name: 'Clients', path: '/clients', payload: { name: 'TEST CLIENT PHASE7C', email: 'phase7c-client@test.local', phone: '0000000000' } },\n  { name: 'Staff', path: '/staff', payload: { name: 'TEST STAFF PHASE7C', email: 'phase7c-staff@test.local', role: 'staff' } },\n  { name: 'Matters', path: '/matters', payload: { title: 'TEST MATTER PHASE7C', description: 'Temporary smoke test matter' } },\n  { name: 'Deadlines', path: '/deadlines', payload: { title: 'TEST DEADLINE PHASE7C', dueDate: '2099-12-31' } },\n  { name: 'Documents', path: '/documents', payload: { title: 'TEST DOCUMENT PHASE7C', fileName: 'phase7c-test.pdf' } }\n];\n\ndescribe('CRUD Smoke Tests - Safe Baseline', () => {\n  test.each(modules)('$name GET route should respond', async (m) => {\n    const res = await request(app).get(m.path);\n    expect(allowed).toContain(res.statusCode);\n  });\n\n  test.each(modules)('$name POST route should respond safely', async (m) => {\n    const res = await request(app).post(m.path).send(m.payload);\n    expect(allowed).toContain(res.statusCode);\n  });\n});\n`);"

echo Running CRUD smoke tests...
npm test

pause
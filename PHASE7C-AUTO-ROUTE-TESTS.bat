@echo off
echo ====================================
echo Litigation 360 - Phase 7C Automation
echo ====================================

if not exist tests mkdir tests
if not exist snapshots mkdir snapshots
if not exist snapshots\phase7c-testing-started mkdir snapshots\phase7c-testing-started
if not exist snapshots\phase7c-testing-started\tests mkdir snapshots\phase7c-testing-started\tests

echo Creating snapshot...
copy package.json snapshots\phase7c-testing-started\package.json /Y
copy tests\*.js snapshots\phase7c-testing-started\tests\ /Y

echo Creating route tests...

node -e "const fs=require('fs');const mk=(f,n,p)=>fs.writeFileSync(f,`const request = require('supertest');\nconst app = require('../backend/src/server');\n\ndescribe('${n} Routes', () => {\n  test('GET ${p} should respond', async () => {\n    const res = await request(app).get('${p}');\n    expect([200,401,403,404]).toContain(res.statusCode);\n  });\n});\n`);mk('tests/staff.test.js','Staff','/staff');mk('tests/matters.test.js','Matters','/matters');mk('tests/deadlines.test.js','Deadlines','/deadlines');mk('tests/documents.test.js','Documents','/documents');"

echo Running tests...
npm test

pause
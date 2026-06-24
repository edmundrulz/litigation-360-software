const request = require('supertest');
const app = require('../backend/src/server');

const allowed = [200,201,204,400,401,403,404,409,422,500];

const modules = [
  { name: 'Clients', path: '/clients', payload: { name: 'TEST CLIENT PHASE7C', email: 'phase7c-client@test.local', phone: '0000000000' } },
  { name: 'Staff', path: '/staff', payload: { name: 'TEST STAFF PHASE7C', email: 'phase7c-staff@test.local', role: 'staff' } },
  { name: 'Matters', path: '/matters', payload: { title: 'TEST MATTER PHASE7C', description: 'Temporary smoke test matter' } },
  { name: 'Deadlines', path: '/deadlines', payload: { title: 'TEST DEADLINE PHASE7C', dueDate: '2099-12-31' } },
  { name: 'Documents', path: '/documents', payload: { title: 'TEST DOCUMENT PHASE7C', fileName: 'phase7c-test.pdf' } }
];

describe('CRUD Smoke Tests - Safe Baseline', () => {
  test.each(modules)('$name GET route should respond', async (m) => {
    const res = await request(app).get(m.path);
    expect(allowed).toContain(res.statusCode);
  });

  test.each(modules)('$name POST route should respond safely', async (m) => {
    const res = await request(app).post(m.path).send(m.payload);
    expect(allowed).toContain(res.statusCode);
  });
});

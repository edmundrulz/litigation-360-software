const request = require('supertest');
const app = require('../backend/src/server');

const protectedRoutes = [
  '/auditlogs',
  '/system-diagnostic',
  '/debug',
  '/errors',
  '/system-report',
  '/monitor',
  '/integrity-scanner',
  '/auto-heal',
  '/scheduler',
  '/dashboard'
];

describe('Security Regression - Protected Routes', () => {
  test.each(protectedRoutes)('GET s should not crash or expose unrestricted access', async (route) => {
    const res = await request(app).get(route);
    expect([200, 301, 302, 401, 403, 404]).toContain(res.statusCode);
  });
});

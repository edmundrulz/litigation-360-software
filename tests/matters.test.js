const request = require('supertest');
const app = require('../backend/src/server');

describe('Matters Routes', () => {
  test('GET /matters should respond', async () => {
    const res = await request(app).get('/matters');
    expect([200,401,403,404]).toContain(res.statusCode);
  });
});

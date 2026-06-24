const request = require('supertest');
const app = require('../backend/src/server');

describe('Staff Routes', () => {
  test('GET /staff should respond', async () => {
    const res = await request(app).get('/staff');
    expect([200,401,403,404]).toContain(res.statusCode);
  });
});

const request = require('supertest');
const app = require('../backend/src/server');

describe('Deadlines Routes', () => {
  test('GET /deadlines should respond', async () => {
    const res = await request(app).get('/deadlines');
    expect([200,401,403,404]).toContain(res.statusCode);
  });
});

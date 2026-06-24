const request = require('supertest');
const app = require('../backend/src/server');

describe('Documents Routes', () => {
  test('GET /documents should respond', async () => {
    const res = await request(app).get('/documents');
    expect([200,401,403,404]).toContain(res.statusCode);
  });
});

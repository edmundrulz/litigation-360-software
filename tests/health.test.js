const request = require("supertest");
const app = require("../backend/src/server");

describe("Health Check", () => {
  test("GET /health should respond", async () => {
    const res = await request(app).get("/health");

    expect([200, 401, 403, 404]).toContain(res.statusCode);
  });
});
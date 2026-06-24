const request = require("supertest");
const app = require("../backend/src/server");

describe("Clients Routes", () => {
  test("GET /clients should respond", async () => {
    const res = await request(app).get("/clients");

    expect([200, 401, 403, 404]).toContain(res.statusCode);
  });
});
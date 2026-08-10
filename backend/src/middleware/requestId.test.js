const requestId = require("./requestId");

function responseStub(statusCode = 200) {
  const headers = {};
  const bodies = [];
  return {
    statusCode,
    locals: {},
    headers,
    bodies,
    setHeader(name, value) { headers[name] = value; },
    json(body) { bodies.push(body); return body; },
  };
}

test("preserves a valid inbound request ID", () => {
  const req = { headers: { "x-request-id": "client-123._:abc" } };
  const res = responseStub();
  let nextCalled = false;
  requestId(req, res, () => { nextCalled = true; });
  expect(nextCalled).toBe(true);
  expect(req.requestId).toBe("client-123._:abc");
  expect(res.locals.requestId).toBe("client-123._:abc");
  expect(res.headers["X-Request-ID"]).toBe("client-123._:abc");
});

test("replaces an invalid inbound request ID with a UUID", () => {
  const req = { headers: { "x-request-id": "contains spaces" } };
  const res = responseStub();
  requestId(req, res, () => {});
  expect(req.requestId).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i);
  expect(res.headers["X-Request-ID"]).toBe(req.requestId);
});

test("adds requestId to object JSON errors", () => {
  const req = { headers: { "x-request-id": "error-correlation-1" } };
  const res = responseStub(500);
  requestId(req, res, () => {});
  res.json({ error: "failure" });
  expect(res.bodies[0]).toEqual({ error: "failure", requestId: "error-correlation-1" });
});

test("does not alter successful JSON bodies", () => {
  const req = { headers: {} };
  const res = responseStub(200);
  requestId(req, res, () => {});
  res.json({ ok: true });
  expect(res.bodies[0]).toEqual({ ok: true });
});
const express = require("express");
const request = require("supertest");

const legalControlDeskRouter = require("./legalControlDesk");

function createTestApp() {
  const app = express();

  app.use(express.json());
  app.use("/api/legal-control-desk", legalControlDeskRouter);

  return app;
}

describe("Legal Control Desk endpoint contract", () => {
  const app = createTestApp();

  test("GET /api/legal-control-desk/health returns the health contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/health")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body).toMatchObject({
      ok: true,
      module: "Legal Control Desk",
      version: "15A-F06",
      status: "online",
      mode: "read-only-executive-brief-matrix",
    });
  });

  test("GET /api/legal-control-desk/summary returns the summary contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/summary")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.module).toBe("Legal Control Desk");
    expect(response.body.mode).toBe("read-only-executive-brief-matrix");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.summary).toEqual(expect.any(Object));
    expect(response.body.workQueue).toEqual(expect.any(Array));
    expect(response.body.riskSnapshot).toEqual(expect.any(Array));
    expect(response.body.deadlineControl).toEqual(expect.any(Object));
    expect(response.body.dataQuality).toEqual(expect.any(Object));
    expect(response.body.matterControl).toEqual(expect.any(Object));
    expect(response.body.clientControl).toEqual(expect.any(Object));
    expect(response.body.actionPlan).toEqual(expect.any(Object));
    expect(response.body.readinessScore).toEqual(expect.any(Object));
    expect(response.body.priorityMatrix).toEqual(expect.any(Object));
    expect(response.body.executiveBrief).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/work-queue returns the work queue contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/work-queue")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.workQueue).toEqual(expect.any(Array));
  });

  test("GET /api/legal-control-desk/risk-snapshot returns the risk snapshot contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/risk-snapshot")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.riskSnapshot).toEqual(expect.any(Array));
  });

  test("GET /api/legal-control-desk/action-plan returns the action plan contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/action-plan")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.actionPlan).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/deadline-control returns the deadline control contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/deadline-control")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.deadlineControl).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/data-quality returns the data quality contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/data-quality")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.dataQuality).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/matter-control returns the matter control contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/matter-control")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.matterControl).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/client-control returns the client control contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/client-control")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.clientControl).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/executive-brief returns the executive brief contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/executive-brief")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.executiveBrief).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/priority-matrix returns the priority matrix contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/priority-matrix")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.priorityMatrix).toEqual(expect.any(Object));
  });

  test("GET /api/legal-control-desk/readiness-score returns the readiness score contract", async () => {
    const response = await request(app)
      .get("/api/legal-control-desk/readiness-score")
      .expect(200)
      .expect("Content-Type", /json/);

    expect(response.body.ok).toBe(true);
    expect(response.body.version).toBe("15A-F06");
    expect(response.body.generatedAt).toEqual(expect.any(String));
    expect(response.body.dataSource).toEqual(expect.any(Object));
    expect(response.body.readinessScore).toEqual(expect.any(Object));
  });
});

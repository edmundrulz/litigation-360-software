const fs = require("fs");
const path = require("path");

const legalControlDeskRouter = require("./legalControlDesk");
const legalControlDeskService = require("../services/legalControlDeskService");

const ROUTE_FILE_PATH = path.join(__dirname, "legalControlDesk.js");

const EXPECTED_ROUTE_SERVICE_MAP = [
  { path: "/health", method: "get", exportName: "getLegalControlDeskHealth" },
  { path: "/summary", method: "get", exportName: "getLegalControlDeskSummary" },
  { path: "/work-queue", method: "get", exportName: "getLegalControlDeskWorkQueue" },
  { path: "/risk-snapshot", method: "get", exportName: "getLegalControlDeskRiskSnapshot" },
  { path: "/action-plan", method: "get", exportName: "getLegalControlDeskActionPlan" },
  { path: "/deadline-control", method: "get", exportName: "getLegalControlDeskDeadlineControl" },
  { path: "/data-quality", method: "get", exportName: "getLegalControlDeskDataQuality" },
  { path: "/matter-control", method: "get", exportName: "getLegalControlDeskMatterControl" },
  { path: "/client-control", method: "get", exportName: "getLegalControlDeskClientControl" },
  { path: "/executive-brief", method: "get", exportName: "getLegalControlDeskExecutiveBrief" },
  { path: "/priority-matrix", method: "get", exportName: "getLegalControlDeskPriorityMatrix" },
  { path: "/readiness-score", method: "get", exportName: "getLegalControlDeskReadinessScore" },
];

const EXPECTED_SERVICE_EXPORTS = [
  "CONTROL_DESK_VERSION",
  ...EXPECTED_ROUTE_SERVICE_MAP.map((entry) => entry.exportName),
];

function getRouterRouteEntries(router) {
  return router.stack
    .filter((layer) => layer.route)
    .map((layer) => ({
      path: layer.route.path,
      methods: Object.keys(layer.route.methods).sort(),
    }));
}

describe("Legal Control Desk route/service parity guard", () => {
  test("router exposes only the expected public GET endpoints", () => {
    const actualRoutes = getRouterRouteEntries(legalControlDeskRouter);

    expect(actualRoutes).toEqual(
      EXPECTED_ROUTE_SERVICE_MAP.map((entry) => ({
        path: entry.path,
        methods: [entry.method],
      }))
    );
  });

  test("service exports only the expected public contract members", () => {
    expect(Object.keys(legalControlDeskService).sort()).toEqual(
      [...EXPECTED_SERVICE_EXPORTS].sort()
    );

    expect(legalControlDeskService.CONTROL_DESK_VERSION).toBe("15A-F06");

    EXPECTED_ROUTE_SERVICE_MAP.forEach((entry) => {
      expect(typeof legalControlDeskService[entry.exportName]).toBe("function");
    });
  });

  test("every expected route has a matching service export", () => {
    EXPECTED_ROUTE_SERVICE_MAP.forEach((entry) => {
      expect(legalControlDeskService).toHaveProperty(entry.exportName);
      expect(typeof legalControlDeskService[entry.exportName]).toBe("function");
    });
  });

  test("route implementation maps each endpoint to the expected service function", () => {
    const routeSource = fs.readFileSync(ROUTE_FILE_PATH, "utf8");

    EXPECTED_ROUTE_SERVICE_MAP.forEach((entry) => {
      expect(routeSource).toContain(`router.get("${entry.path}"`);
      expect(routeSource).toContain(`res.json(${entry.exportName}())`);
    });
  });
});

const fs = require("fs");
const path = require("path");

const frontend = process.env.L360_FRONTEND;
const reports = process.env.L360_REPORTS;
const buildOutput = process.env.L360_BUILD_OUTPUT;
const buildError = process.env.L360_BUILD_ERROR;
const buildExit = Number(process.env.L360_BUILD_EXIT || 0);
const preExit = Number(process.env.L360_PRE_EXIT || 0);

fs.mkdirSync(reports, { recursive: true });

const dist = path.join(frontend, "dist");
const distExists = fs.existsSync(dist);
let distFiles = [];
if (distExists) {
  function walk(dir) {
    for (const item of fs.readdirSync(dir)) {
      const p = path.join(dir, item);
      const stat = fs.statSync(p);
      if (stat.isDirectory()) walk(p);
      else distFiles.push(p);
    }
  }
  walk(dist);
}

const outputText = fs.existsSync(buildOutput) ? fs.readFileSync(buildOutput, "utf8") : "";
const errorText = fs.existsSync(buildError) ? fs.readFileSync(buildError, "utf8") : "";

const report = {
  phase: "10W",
  module: "Frontend Build Production Validation",
  timestamp: new Date().toISOString(),
  prebuildPassed: preExit === 0,
  buildExit,
  buildPassed: buildExit === 0,
  distExists,
  distFileCount: distFiles.length,
  hasIndexHtml: distFiles.some(f => path.basename(f).toLowerCase() === "index.html"),
  hasAssets: distFiles.some(f => f.includes(path.sep + "assets" + path.sep)),
  buildOutputPreview: outputText.slice(0, 4000),
  buildErrorPreview: errorText.slice(0, 4000)
};

report.status = report.prebuildPassed && report.buildPassed && report.distExists && report.hasIndexHtml ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10W-frontend-build-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10W FRONTEND BUILD REPORT",
  "===============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Prebuild Passed: " + report.prebuildPassed,
  "Build Exit: " + report.buildExit,
  "Build Passed: " + report.buildPassed,
  "Dist Exists: " + report.distExists,
  "Dist File Count: " + report.distFileCount,
  "Index HTML Exists: " + report.hasIndexHtml,
  "Assets Exist: " + report.hasAssets
].join("\n"));

if (report.status !== "PASS") process.exit(1);

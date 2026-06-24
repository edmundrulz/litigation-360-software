$file = "src\index.js"

$c = Get-Content $file -Raw

if ($c -notmatch "server\.close") {

    $c = $c -replace "app\.listen\(([\s\S]*?)\);", "const server = app.listen(`$1);"

    $shutdown = @'

// Graceful shutdown protection - prevents ghost Node process holding port 5000
function shutdownBackend(signal) {
  console.log(`${signal} received. Shutting down backend...`);

  if (typeof server !== "undefined") {
    server.close(() => {
      console.log("Backend stopped cleanly.");
      process.exit(0);
    });
  } else {
    process.exit(0);
  }
}

process.on("SIGINT", () => shutdownBackend("SIGINT"));
process.on("SIGTERM", () => shutdownBackend("SIGTERM"));
'@

    Add-Content -Path $file -Value $shutdown

    Write-Host "SUCCESS: index.js patched safely"
}
else {
    Write-Host "Already patched. No changes made."
}
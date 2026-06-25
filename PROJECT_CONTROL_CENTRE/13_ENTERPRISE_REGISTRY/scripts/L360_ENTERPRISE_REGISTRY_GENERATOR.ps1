$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software-POLLUTED-ARCHIVE-CUTOVER-V4"
$Reg = Join-Path $Root "PROJECT_CONTROL_CENTRE\13_ENTERPRISE_REGISTRY"
$Reports = Join-Path $Reg "reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null
Set-Location $Root

Get-ChildItem backend,frontend\src -Recurse -Directory -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-Object FullName,Name,LastWriteTime |
Export-Csv "$Reports\MASTER_MODULE_REGISTRY.csv" -NoTypeInformation

Get-ChildItem backend -Recurse -File -Include *.js,*.ts -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-String -Pattern "router\.|app\.get|app\.post|app\.put|app\.delete|express.Router" |
Select-Object Path,LineNumber,Line |
Export-Csv "$Reports\MASTER_API_REGISTRY.csv" -NoTypeInformation

Get-ChildItem frontend\src -Recurse -File -Include *.jsx,*.tsx,*.js,*.ts -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-Object FullName,Name,Length,LastWriteTime |
Export-Csv "$Reports\MASTER_PAGE_COMPONENT_REGISTRY.csv" -NoTypeInformation

Get-ChildItem -Recurse -File -Filter "*.db" -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules" } |
Select-Object FullName,Length,LastWriteTime |
Export-Csv "$Reports\MASTER_DATABASE_REGISTRY.csv" -NoTypeInformation

Get-ChildItem -Recurse -File -Include *.ps1,*.bat,*.cmd -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-Object FullName,Name,Length,LastWriteTime |
Export-Csv "$Reports\MASTER_SCRIPT_REGISTRY.csv" -NoTypeInformation

Get-ChildItem -Recurse -File -Include *test*.js,*test*.ts,*.spec.js,*.spec.ts -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-Object FullName,Name,Length,LastWriteTime |
Export-Csv "$Reports\MASTER_TEST_REGISTRY.csv" -NoTypeInformation

Get-ChildItem -Recurse -File -Include *.md,*.txt -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -match "PHASE|Phase|phase" -and $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-Object FullName,Name,Length,LastWriteTime |
Export-Csv "$Reports\MASTER_PHASE_REGISTRY.csv" -NoTypeInformation

Get-ChildItem backend,frontend\src -Recurse -File -Include *.js,*.jsx,*.ts,*.tsx -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-String -Pattern "TODO|FIXME|HACK|TEMP|PLACEHOLDER|not implemented|coming soon|error|fail|unsafe" |
Select-Object Path,LineNumber,Line |
Export-Csv "$Reports\MASTER_RISK_REGISTRY.csv" -NoTypeInformation

Get-ChildItem backend,frontend\src -Recurse -File -Include *.js,*.jsx,*.ts,*.tsx -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-String -Pattern "import |require\(|from " |
Select-Object Path,LineNumber,Line |
Export-Csv "$Reports\MASTER_DEPENDENCY_REGISTRY.csv" -NoTypeInformation

git log --oneline -50 |
Set-Content "$Reports\MASTER_CHANGELOG.txt" -Encoding UTF8

@"
L360 ENTERPRISE REGISTRY GENERATION COMPLETE

Generated:
- MASTER_MODULE_REGISTRY.csv
- MASTER_API_REGISTRY.csv
- MASTER_PAGE_COMPONENT_REGISTRY.csv
- MASTER_DATABASE_REGISTRY.csv
- MASTER_SCRIPT_REGISTRY.csv
- MASTER_TEST_REGISTRY.csv
- MASTER_PHASE_REGISTRY.csv
- MASTER_RISK_REGISTRY.csv
- MASTER_DEPENDENCY_REGISTRY.csv
- MASTER_CHANGELOG.txt

Next:
Review registries before Phase 13D backend coding.
"@ | Set-Content "$Reports\README_REGISTRY_SUMMARY.txt" -Encoding UTF8

Write-Host "Enterprise Registry generated."
Write-Host "Reports: $Reports"

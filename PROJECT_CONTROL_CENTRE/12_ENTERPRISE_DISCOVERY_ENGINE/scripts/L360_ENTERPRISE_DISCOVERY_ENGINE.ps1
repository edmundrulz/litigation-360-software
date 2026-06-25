$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software-POLLUTED-ARCHIVE-CUTOVER-V4"
$Out = Join-Path $Root "PROJECT_CONTROL_CENTRE\12_ENTERPRISE_DISCOVERY_ENGINE\reports"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
Set-Location $Root

git status | Out-File "$Out\00_GIT_STATUS.txt"
git remote -v | Out-File "$Out\00_GIT_STATUS.txt" -Append
git log --oneline -10 | Out-File "$Out\00_GIT_STATUS.txt" -Append

tree backend /f | Out-File "$Out\01_BACKEND_TREE.txt"
tree frontend\src /f | Out-File "$Out\02_FRONTEND_TREE.txt"

Get-ChildItem backend\src,backend\routes -Recurse -File -Include *.js,*.ts -ErrorAction SilentlyContinue |
Select-String -Pattern "router\.|app\.get|app\.post|app\.put|app\.delete|express.Router" |
Out-File "$Out\03_BACKEND_ROUTES.txt"

Get-ChildItem frontend\src -Recurse -File -Include *.js,*.jsx,*.ts,*.tsx -ErrorAction SilentlyContinue |
Select-String -Pattern "BrowserRouter|Routes|Route|createBrowserRouter|useRoutes|Outlet|react-router-dom|navigate|useNavigate" |
Out-File "$Out\04_FRONTEND_ROUTING.txt"

Get-ChildItem backend,frontend\src -Recurse -File -Include *.js,*.jsx,*.ts,*.tsx -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules|snapshots|backups|logs" } |
Select-String -Pattern "message|messages|chat|comment|comments|note|notes|feedback|notification|notifications|mention" |
Out-File "$Out\05_COMMUNICATION_DISCOVERY.txt"

Get-ChildItem -Recurse -File -Filter "*.db" -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "node_modules" } |
Select-Object FullName,Length,LastWriteTime |
Sort-Object LastWriteTime -Descending |
Out-File "$Out\06_DATABASE_DISCOVERY.txt"

"Discovery complete." | Out-File "$Out\README_DISCOVERY_SUMMARY.txt"

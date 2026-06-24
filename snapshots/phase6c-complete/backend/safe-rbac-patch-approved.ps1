$backup = "backup\rbac-approved-" + (Get-Date -Format "yyyyMMdd-HHmmss")
New-Item -ItemType Directory -Force -Path $backup | Out-Null

Copy-Item "src\routes\matters.js" "$backup\matters.js" -Force
Copy-Item "src\routes\invoices.js" "$backup\invoices.js" -Force
Copy-Item "src\routes\timeEntries.js" "$backup\timeEntries.js" -Force

$matters = Get-Content "src\routes\matters.js" -Raw
$matters = $matters.Replace(
"router.put('/:id', authMiddleware, async (req, res) => {",
"router.put(
  '/:id',
  authMiddleware,
  roleMiddleware(
    'administrator',
    'managing_partner',
    'senior_lawyer',
    'junior_lawyer'
  ),
  async (req, res) => {"
)
Set-Content "src\routes\matters.js" $matters -Encoding UTF8

$invoices = Get-Content "src\routes\invoices.js" -Raw
if ($invoices -notmatch "middleware/roles") {
  $invoices = $invoices.Replace(
"const authMiddleware = require('../middleware/auth');",
"const authMiddleware = require('../middleware/auth');
const roleMiddleware = require('../middleware/roles');"
  )
}
$invoices = $invoices.Replace(
"router.post('/', authMiddleware, async (req, res) => {",
"router.post(
  '/',
  authMiddleware,
  roleMiddleware('administrator', 'managing_partner', 'finance_admin'),
  async (req, res) => {"
)
Set-Content "src\routes\invoices.js" $invoices -Encoding UTF8

$timeEntries = Get-Content "src\routes\timeEntries.js" -Raw
if ($timeEntries -notmatch "middleware/roles") {
  $timeEntries = $timeEntries.Replace(
"const authMiddleware = require('../middleware/auth');",
"const authMiddleware = require('../middleware/auth');
const roleMiddleware = require('../middleware/roles');"
  )
}
$timeEntries = $timeEntries.Replace(
"router.post('/', authMiddleware, async (req, res) => {",
"router.post(
  '/',
  authMiddleware,
  roleMiddleware('administrator', 'managing_partner', 'senior_lawyer', 'junior_lawyer'),
  async (req, res) => {"
)
Set-Content "src\routes\timeEntries.js" $timeEntries -Encoding UTF8

Write-Host "RBAC patch complete."
Write-Host "Backup saved to: $backup"
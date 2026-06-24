$API = "http://localhost:5000/api"
$Stamp = Get-Date -Format "yyyyMMddHHmmss"

Write-Host "Creating draft..."
$draft = Invoke-RestMethod "$API/intake/draft" -Method POST
$guid = $draft.draft_guid
Write-Host "Draft:" $guid

Invoke-RestMethod "$API/intake/draft/$guid/step/1" -Method POST -ContentType "application/json" -Body (@{
  full_name = "Wizard Test Client $Stamp"
  email = "wizard$Stamp@example.com"
  phone = "0123456789"
  address = "Wizard Address"
} | ConvertTo-Json)

Invoke-RestMethod "$API/intake/draft/$guid/step/2" -Method POST -ContentType "application/json" -Body (@{
  case_number = "WIZ-$Stamp"
  title = "Wizard Test Case $Stamp"
  status = "Active"
  description = "Wizard test description"
  opened_date = "2026-06-21"
} | ConvertTo-Json)

Invoke-RestMethod "$API/intake/draft/$guid/step/3" -Method POST -ContentType "application/json" -Body (@{
  title = "Wizard Test Deadline $Stamp"
  deadline_date = "2026-07-01"
  reminder_days = 7
  notes = "Wizard deadline"
} | ConvertTo-Json)

Invoke-RestMethod "$API/intake/draft/$guid/step/4" -Method POST -ContentType "application/json" -Body (@{
  file_name = "wizard-test-$Stamp.pdf"
  file_path = "local"
  document_type = "Test"
} | ConvertTo-Json)

Write-Host "Submitting..."
Invoke-RestMethod "$API/intake/draft/$guid/submit" -Method POST

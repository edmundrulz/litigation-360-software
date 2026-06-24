# Master Verification Protocol

## Verification Commands

Run from root:

npm test

cd backend
npm test

## Inventory Commands

Get-ChildItem .\backend\src\routes -Recurse | Select-Object FullName
Get-ChildItem .\backend\src\utils -Recurse | Select-Object FullName
Get-ChildItem .\backend\src\services -Recurse | Select-Object FullName
Get-ChildItem .\tests -Recurse | Select-Object FullName

## Verification Output Folder

reports\master-system\verification

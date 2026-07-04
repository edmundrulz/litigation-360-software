$ErrorActionPreference = "Stop"

Write-Host "=== CREATE PROTECTED VERSION SNAPSHOT ==="

$branch = git branch --show-current
$shortCommit = git rev-parse --short HEAD
$date = Get-Date -Format "yyyy.MM.dd-HHmmss"

$safeBranch = $branch -replace "[/\\]", "-"
$tag = "snapshot-$date-$safeBranch-$shortCommit"
$bundleDir = "..\litigation-360-protected-snapshots"

New-Item -ItemType Directory -Force $bundleDir | Out-Null

Write-Host "Branch: $branch"
Write-Host "Commit: $shortCommit"
Write-Host "Tag: $tag"

git tag -a $tag -m "Protected snapshot $tag"

$bundlePath = Join-Path $bundleDir "$tag.bundle"
git bundle create $bundlePath --all

Write-Host "Protected snapshot created:"
Write-Host $tag
Write-Host $bundlePath

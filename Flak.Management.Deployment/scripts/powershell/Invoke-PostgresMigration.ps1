$envFile = "Flak.Management.Deployment/env/main-server.env"
if (!(Test-Path $envFile)) { throw "Missing $envFile" }
Get-Content $envFile | ForEach-Object { if ($_ -match "^") { } }
Write-Host "Run migration command for Flak.Infrastructure"

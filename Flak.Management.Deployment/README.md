# Flak.Management.Deployment

This area contains Docker Compose deployment definitions, environment templates, scripts, and operations documentation for the FLAK platform.

## Main server
- PostgreSQL
- Flak.Management.Web
- Flak.Management.Api
- Flak.Identity.Api

## RAM server
- Valkey
- Flak.Cache.Api
- Flak.Workers

## Migrations
- Linux: `bash Flak.Management.Deployment/scripts/linux/migrate-postgres.sh`
- PowerShell: `pwsh Flak.Management.Deployment/scripts/powershell/Invoke-PostgresMigration.ps1`

## Checks
- Health: `bash Flak.Management.Deployment/scripts/linux/health-check.sh all`
- Smoke: `bash Flak.Management.Deployment/scripts/linux/smoke-test.sh`

No EF tooling is used. Schema is managed by SQL files in `src/Flak.Infrastructure/Migrations`.

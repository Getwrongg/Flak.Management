namespace Flak.Infrastructure.Database;

public sealed record MigrationRecord(string Id, DateTime AppliedUtc);

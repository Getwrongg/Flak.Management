using Flak.Infrastructure.Database;

if (args.Length == 0 || args[0] != "migrate")
{
    Console.Error.WriteLine("Usage: migrate");
    return 1;
}

var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__PlatformDatabase");
if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.Error.WriteLine("ConnectionStrings__PlatformDatabase is required.");
    return 1;
}

var migrationDirectory = Path.Combine(AppContext.BaseDirectory, "Migrations");
if (!Directory.Exists(migrationDirectory))
{
    migrationDirectory = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), "src/Flak.Infrastructure/Migrations"));
}

var runner = new MigrationRunner(new DbConnectionFactory(connectionString), migrationDirectory);
await runner.RunAsync(CancellationToken.None);
Console.WriteLine("Migrations completed.");
return 0;

using Npgsql;
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("/health/live",()=>Results.Ok(new{status="live"}));
app.MapGet("/health/ready",()=>Results.Ok(new{status="ready"}));
app.MapGet("/health/dependencies", async (IConfiguration cfg, CancellationToken ct) => {
    var cs = cfg.GetConnectionString("PlatformDatabase") ?? Environment.GetEnvironmentVariable("ConnectionStrings__PlatformDatabase");
    if (string.IsNullOrWhiteSpace(cs)) return Results.Ok(new { database = "not-configured" });
    await using var conn = new NpgsqlConnection(cs); await conn.OpenAsync(ct);
    await using var cmd = new NpgsqlCommand("select 1;", conn); await cmd.ExecuteScalarAsync(ct);
    return Results.Ok(new { database = "ok" });
});
app.MapGet("/api/info",()=>Results.Ok(new{app="Flak.Management.Api", database="Npgsql"}));
app.Run();

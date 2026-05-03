using Dapper;

namespace Flak.Infrastructure.Database;

public sealed class MigrationRunner
{
    private readonly DbConnectionFactory _connectionFactory;
    private readonly string _migrationDirectory;

    public MigrationRunner(DbConnectionFactory connectionFactory, string migrationDirectory)
    {
        _connectionFactory = connectionFactory;
        _migrationDirectory = migrationDirectory;
    }

    public async Task RunAsync(CancellationToken cancellationToken)
    {
        await using var connection = await _connectionFactory.OpenConnectionAsync(cancellationToken);
        const string bootstrapSql = """
            create table if not exists schema_migrations (
                id text primary key,
                applied_utc timestamptz not null
            );
            """;
        await connection.ExecuteAsync(new CommandDefinition(bootstrapSql, cancellationToken: cancellationToken));

        var applied = (await connection.QueryAsync<string>(new CommandDefinition("select id from schema_migrations;", cancellationToken: cancellationToken))).ToHashSet();
        foreach (var file in Directory.GetFiles(_migrationDirectory, "*.sql").OrderBy(Path.GetFileName))
        {
            var id = Path.GetFileName(file);
            if (applied.Contains(id)) continue;
            var sql = await File.ReadAllTextAsync(file, cancellationToken);
            await using var tx = await connection.BeginTransactionAsync(cancellationToken);
            try
            {
                await connection.ExecuteAsync(new CommandDefinition(sql, transaction: tx, cancellationToken: cancellationToken));
                await connection.ExecuteAsync(new CommandDefinition("insert into schema_migrations (id, applied_utc) values (@Id, now());", new { Id = id }, tx, cancellationToken: cancellationToken));
                await tx.CommitAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                await tx.RollbackAsync(cancellationToken);
                throw new InvalidOperationException($"Migration failed: {id}", ex);
            }
        }
    }
}

using Dapper;
using Flak.Infrastructure.Database;

namespace Flak.Infrastructure.Repositories;

public sealed class PlatformServiceRepository
{
    private readonly DbConnectionFactory _connectionFactory;
    public PlatformServiceRepository(DbConnectionFactory connectionFactory) => _connectionFactory = connectionFactory;

    public async Task<int> CountAsync(CancellationToken cancellationToken)
    {
        const string sql = "select count(*) from platform_services;";
        await using var connection = await _connectionFactory.OpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleAsync<int>(new CommandDefinition(sql, cancellationToken: cancellationToken));
    }
}

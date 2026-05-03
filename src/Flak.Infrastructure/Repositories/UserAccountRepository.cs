using Dapper;
using Flak.Infrastructure.Database;
using Flak.Infrastructure.Models;

namespace Flak.Infrastructure.Repositories;

public sealed class UserAccountRepository
{
    private readonly DbConnectionFactory _connectionFactory;
    public UserAccountRepository(DbConnectionFactory connectionFactory) => _connectionFactory = connectionFactory;

    public async Task<UserAccount?> GetByUsernameAsync(string username, CancellationToken cancellationToken)
    {
        const string sql = """
            select id
            from user_accounts
            where username = @Username
            limit 1;
            """;

        await using var connection = await _connectionFactory.OpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<UserAccount>(new CommandDefinition(sql, new { Username = username }, cancellationToken: cancellationToken));
    }
}

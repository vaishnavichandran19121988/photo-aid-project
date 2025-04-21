import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

final _env = DotEnv()..load();

/// Determines if the application should use connection pooling.
/// Can be set via environment variable or changed programmatically.
final bool useConnectionPool =
    _env['USE_CONNECTION_POOL']?.toLowerCase() == 'true';

/// Singleton database connection for development environment.
Connection? _singletonConnection;

/// A database connection pool for production environment.
final Pool<Connection>? _connectionPool = useConnectionPool
    ? Pool<Connection>.withEndpoints(
        [
          Endpoint(
            host: _env['DB_HOST']!,
            port: int.parse(_env['DB_PORT']!),
            database: _env['DB_NAME']!,
            username: _env['DB_USER']!,
            password: _env['DB_PASSWORD']!,
          ),
        ],
        settings: const PoolSettings(
          maxConnectionCount: 10,
          sslMode: SslMode.disable,
        ),
      )
    : null;

/// Gets or creates the singleton connection.
Future<Connection> _getSingletonConnection() async {
  _singletonConnection ??= await Connection.open(
    Endpoint(
      host: _env['DB_HOST']!,
      port: int.parse(_env['DB_PORT']!),
      database: _env['DB_NAME']!,
      username: _env['DB_USER']!,
      password: _env['DB_PASSWORD']!,
    ),
    settings: const ConnectionSettings(
      sslMode: SslMode.disable,
    ),
  );
  return _singletonConnection!;
}

/// Executes a database operation using either a singleton connection or a connection from the pool,
/// depending on the environment configuration.
///
/// Takes a function [fn] that uses a connection to perform an operation and returns a value of type [T].
Future<T> withDb<T>(Future<T> Function(Session) fn) async {
  if (useConnectionPool) {
    // Production: Use connection pool
    return _connectionPool!.run(fn);
  } else {
    // Development: Use singleton connection
    final conn = await _getSingletonConnection();
    return fn(conn);
  }
}

/// Closes all database connections when the application shuts down.
Future<void> closeDbConnections() async {
  if (useConnectionPool && _connectionPool != null) {
    await _connectionPool!.close();
  } else if (_singletonConnection != null) {
    await _singletonConnection!.close();
    _singletonConnection = null;
  }
}
